-- Modules/FlightMaster/FlightMaster_Sync.lua
-- Shares measured flight times with guild and group members running
-- KullThranUI, so routes nobody in your account has flown still get real
-- durations. Messages use taxi node IDs, which do not depend on the locale.
local _, ns = ...
local Mod = ns.Mod
local FM = ns.FM
if not Mod then return end

local PREFIX = "KTFM"
local VERSION = "1"
local SEND_GAP = 0.3       -- seconds between queued messages
local SHARE_ALL_LIMIT = 200

local queue = {}
local sending = false
local prefixRegistered = false

local function SendAddonMessageCompat(msg, channel)
    if C_ChatInfo and C_ChatInfo.SendAddonMessage then
        return C_ChatInfo.SendAddonMessage(PREFIX, msg, channel)
    elseif type(SendAddonMessage) == "function" then
        return SendAddonMessage(PREFIX, msg, channel)
    end
end

local function Channels()
    local list = {}
    if IsInGuild and IsInGuild() then list[#list + 1] = "GUILD" end
    if IsInRaid and IsInRaid() then
        list[#list + 1] = "RAID"
    elseif IsInGroup and IsInGroup() then
        list[#list + 1] = "PARTY"
    end
    return list
end

local function Pump()
    local item = table.remove(queue, 1)
    if not item then
        sending = false
        return
    end
    pcall(SendAddonMessageCompat, item.msg, item.channel)
    C_Timer.After(SEND_GAP, Pump)
end

local function Enqueue(msg)
    for _, channel in ipairs(Channels()) do
        queue[#queue + 1] = { msg = msg, channel = channel }
    end
    if not sending and #queue > 0 then
        sending = true
        Pump()
    end
end

local function Encode(originID, destID, seconds)
    return string.format("T:%s:%d:%d:%d", VERSION, originID, destID, seconds)
end

function Mod:IsSharingEnabled()
    return self:GetDB().shareTimes ~= false
end

function Mod:InitSync()
    if prefixRegistered then return end
    if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
        C_ChatInfo.RegisterAddonMessagePrefix(PREFIX)
    elseif type(RegisterAddonMessagePrefix) == "function" then
        RegisterAddonMessagePrefix(PREFIX)
    end
    prefixRegistered = true
    self:RegisterEvent("CHAT_MSG_ADDON")
end

-- Broadcast one route right after landing.
function Mod:ShareFlight(flight, seconds)
    if not (self:IsSharingEnabled() and flight and seconds) then return end
    FM.BuildCatalog()
    local o = FM.nodesByKey[FM.Key(flight.origin) or ""]
    local d = FM.nodesByKey[FM.Key(flight.dest) or ""]
    if o and d and o.nodeID and d.nodeID then
        Enqueue(Encode(o.nodeID, d.nodeID, math.floor(seconds + 0.5)))
    end
end

-- Options button: send every route you have measured. Returns the count.
function Mod:ShareAllTimings()
    if #Channels() == 0 then return 0 end
    local list = FM.GetShareableTimings()
    local n = math.min(#list, SHARE_ALL_LIMIT)
    for i = 1, n do
        Enqueue(Encode(list[i][1], list[i][2], list[i][3]))
    end
    return n
end

local function IsSelf(sender)
    local me = UnitName and UnitName("player")
    if not sender or not me then return false end
    local short = Ambiguate and Ambiguate(sender, "none") or sender:match("^[^-]+")
    return short == me
end

function Mod:CHAT_MSG_ADDON(_, prefix, msg, _, sender)
    if prefix ~= PREFIX or type(msg) ~= "string" or not self:IsSharingEnabled() then return end
    if IsSelf(sender) then return end
    local version, o, d, secs = msg:match("^T:(%d+):(%d+):(%d+):(%d+)$")
    if version ~= VERSION then return end
    if FM.RecordShared(o, d, secs) then
        FM.sharedReceived = (FM.sharedReceived or 0) + 1
    end
end

Mod.SYNC_PREFIX = PREFIX
