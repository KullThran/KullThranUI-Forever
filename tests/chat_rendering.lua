-- Run from the workspace root: lua tests/chat_rendering.lua
local Mod = {}
local KT = { db = { profile = { chat = { classColorNames = true } } } }
function KT:NewModule() return Mod end
function KT:IsForever() return true end
LibStub = function(name)
    if name == 'AceAddon-3.0' then
        return { GetAddon = function() return KT end }
    end
end
strtrim = function(s) return s:match('^%s*(.-)%s*$') end
strlower, strupper = string.lower, string.upper
wipe = function(t) for k in pairs(t) do t[k] = nil end end
date = function() return '05:11' end
Ambiguate = function(name) return name:match('^[^-]+') end
GetBuildInfo = function() return '', '', '', 16001 end
GetPlayerInfoByGUID = function() return 'Rogue', 'ROGUE' end
RAID_CLASS_COLORS = { ROGUE = { r = 1, g = 1, b = 0 } }
ChatTypeInfo = { SYSTEM = { r = 1, g = 1, b = 0 }, SAY = { r = 1, g = 1, b = 1 } }
issecretvalue = function(value) return value == '<secret>' end
canaccessvalue = function(value) return value ~= '<secret>' end
hasanysecretvalues = function() return false end
assert(loadfile('KullThranUI_Chat/Modules/Chat.lua'))()
Mod.db = KT.db.profile.chat

local function event(kind, message, sender, channel, lineID)
    return Mod:BuildEntryFromEvent('CHAT_MSG_' .. kind, message, sender, '', channel or '', '', '', 0, 2, channel or '', '', lineID or 1, 'Player-1-123')
end

local function contains(text, expected)
    assert(text:find(expected, 1, true), 'Missing ' .. expected .. ' in ' .. text)
end

for _, kind in ipairs({ 'SAY', 'YELL', 'GUILD', 'OFFICER', 'PARTY', 'RAID', 'CHANNEL', 'WHISPER', 'WHISPER_INFORM' }) do
    local body = 'Mensaje completo |cffff0000|Hitem:123|h[Objeto]|h|r final'
    local entry = assert(event(kind, body, 'Depicaros-Realm', '2. Trade'))
    contains(Mod:GetEntryMessage(entry), body)
    contains(Mod:GetEntryMessage(entry), 'Depicaros')
    local stored = assert(Mod:SanitizeHistoryEntry(entry))
    contains(Mod:GetEntryMessage(stored), body)
    contains(Mod:GetEntryMessage(stored), 'Depicaros')
end
contains(Mod:GetEntryMessage(event('SAY', '.', 'Depicaros')), '.')
assert(event('SAY', '<secret>', 'Depicaros') == nil)
assert(event('SAY', '', 'Depicaros') == nil)
local say = event('SAY', '.', 'Depicaros-Realm')
contains(Mod:GetEntryMessage(say), '|Hplayer:Depicaros-Realm:1:SAY:')
contains(Mod:GetEntryMessage(say), '|cffffff00Depicaros|r')
assert(Mod:GetEntryMessage(say):sub(-1) == '.')
Mod.db.classColorNames = false
assert(not Mod:GetEntryMessage(say):find('|cff', 1, true))
Mod.db.classColorNames = true
contains(Mod:GetEntryMessage(event('CHANNEL', 'LFM', 'Kyirp', '2. Trade')), '[2. Trade]')
assert(Mod:GetEntryMessage(event('SYSTEM', 'You are no longer Away.', ''), false) == 'You are no longer Away.')
contains(Mod:GetEntryMessage({ rawMessage = '', message = 'Recovered body' }), 'Recovered body')

-- Monitor callers retain their original argument layout and formatting.
local nativeLine = '[Depicaros]: native message'
local monitor = Mod:BuildPreformattedEntryFromMonitor('CHAT_MSG_SAY', nativeLine, 1, 1, 1,
    'native message', 'Depicaros', '', '', '', '', 0, 0, '', '', 3, 'Player-1-123')
assert(Mod:GetEntryMessage(monitor) == nativeLine)
C_BattleNet = { GetAccountInfoByID = function() return { accountName = 'Friend' } end }
local bn = Mod:BuildEntryFromEvent('CHAT_MSG_BN_WHISPER', 'BN body', 'Friend', '', '', '', '', 0, 0, '', '', 0, '', 0, 42)
contains(Mod:GetEntryMessage(bn), '|HBNplayer:Friend:42|h')
contains(Mod:GetEntryMessage(bn), 'BN body')

-- Exercise live display, stored history, reload and full redraw.
local displayed = {}
local frame = {
    AddMessage = function(_, text) displayed[#displayed + 1] = text end,
    Clear = function() wipe(displayed) end,
}
Mod.messageFrames = { frame }
Mod.runtimeInitialized, Mod.chatEventsRegistered = true, true
for _, method in ipairs({ 'RecordChatActivity', 'ShowWindowForActivity', 'ScheduleWindowFade', 'UpdateScrollButtonVisibility' }) do
    Mod[method] = function() end
end
Mod:OnChatEvent('CHAT_MSG_SAY', 'Full live message', 'Depicaros-Realm', '', '', '', '', 0, 0, '', '', 50, 'Player-1-123')
assert(#displayed == 1)
contains(displayed[1], 'Full live message')
contains(displayed[1], '|Hplayer:Depicaros-Realm:50:SAY:')
local live = displayed[1]
Mod:LoadPersistedHistory()
Mod:RenderFrame(frame)
assert(#displayed == 1 and displayed[1] == live)
GetPlayerInfoByGUID = function() error('GUID unavailable') end
contains(Mod:GetEntryMessage(say), 'Depicaros')
print('PASS: message and author survive event construction, history and rendering')
print('PASS: player links, class colors, channels, system, Battle.net, monitor and reload')
