-- Embedded adaptation of ForeverAuras 1.3.8; GPL-2.0. See Engine/UPSTREAM.md.
local _, host = ...
host.EmbeddedAuraEngine.Register("KUIAR_Engine", function(...)
-- Modified for ForeverAuras, 2026-09-18.
if (GAME_LOCALE or GetLocale()) ~= "deDE" then
  return
end

local L = KUIAR_Runtime.L

-- ForeverAuras
L[ [=[ Filter formats: 'Name', 'Name-Realm', '-Realm'.

Supports multiple entries, separated by commas
Can use \ to escape -.]=] ] = "Filter format:  'Name', 'Name-Realm', '-Realm'. Unterstützt mehrfacheinträge welche durch Kommas getrennt werden. Verwende \\ um - zu escapen."
L["%s Overlay Color"] = "%s Overlay Farbe"
L["* Suffix"] = "* Suffix"
L["/wa help - Show this message"] = "/wa help - Zeige diese Nachricht"
L["/wa minimap - Toggle the minimap icon"] = "/wa minimap - Anzeige des Minimap-Icons umschalten"
L["/wa pprint - Show the results from the most recent profiling"] = "/wa pprint - Zeigt das Ergebnis des aktuellsten Profilings an"
L["/wa pstart - Start profiling. Optionally include a duration in seconds after which profiling automatically stops. To profile the next combat/encounter, pass a \"combat\" or \"encounter\" argument."] = "/wa pstart - Startet das Profiling. Optional kann eine Dauer in Sekunden angegeben werden, nachdem das Profiling automatisch gestoppt wird. Um den nächsten Kampf zu loggen, füge combat oder encounter hinzu, also z.B. \"/wa pstart combat\""
L["/wa pstop - Finish profiling"] = "/wa pstop - beendet das Pofiling"
L["/wa repair - Repair tool"] = "/wa repair - Reparierwerkzeug"
L["|cffeda55fLeft-Click|r to toggle showing the main window."] = "|cffeda55fLink-Klick|r um das Anzeigen des Hauptfensters umzuschalten."
L["|cffeda55fMiddle-Click|r to toggle the minimap icon on or off."] = "|cffeda55fMittlere Maustaste|r um das Minimapsymbol an oder auszuschalten."
--[[Translation missing --]]
L["|cffeda55fRight-Click|r to toggle performance profiling window."] = "|cffeda55fRight-Click|r to toggle performance profiling window."
--[[Translation missing --]]
L["|cffeda55fShift-Click|r to pause addon execution."] = "|cffeda55fShift-Click|r to pause addon execution."
--[[Translation missing --]]
L["|cffff0000deprecated|r"] = "|cffff0000deprecated|r"
--[[Translation missing --]]
L["|cFFFF0000Not|r Item Bonus Id Equipped"] = "|cFFFF0000Not|r Item Bonus Id Equipped"
--[[Translation missing --]]
L["|cFFFF0000Not|r Item Equipped"] = "|cFFFF0000Not|r Item Equipped"
--[[Translation missing --]]
L["|cFFFF0000Not|r Player Name/Realm"] = "|cFFFF0000Not|r Player Name/Realm"
--[[Translation missing --]]
L["|cFFFF0000Not|r Spell Known"] = "|cFFFF0000Not|r Spell Known"
--[[Translation missing --]]
L[ [=[|cFFFF0000Support for unfiltered COMBAT_LOG_EVENT_UNFILTERED is deprecated|r
COMBAT_LOG_EVENT_UNFILTERED without a filter are disabled as it’s very performance costly.
Find more information:
https://github.com/WeakAuras/WeakAuras2/wiki/Custom-Triggers#events]=] ] = [=[|cFFFF0000Support for unfiltered COMBAT_LOG_EVENT_UNFILTERED is deprecated|r
COMBAT_LOG_EVENT_UNFILTERED without a filter are disabled as it’s very performance costly.
Find more information:
https://github.com/WeakAuras/WeakAuras2/wiki/Custom-Triggers#events]=]
--[[Translation missing --]]
L["|cFFffcc00Extra Options:|r %s"] = "|cFFffcc00Extra Options:|r %s"
--[[Translation missing --]]
L["|cFFffcc00Extra Options:|r None"] = "|cFFffcc00Extra Options:|r None"
--[[Translation missing --]]
L[ [=[• |cff00ff00Player|r, |cff00ff00Target|r, |cff00ff00Focus|r, and |cff00ff00Pet|r correspond directly to those individual unitIDs.
• |cff00ff00Specific Unit|r lets you provide a specific valid unitID to watch.
|cffff0000Note|r: The game will not fire events for all valid unitIDs, making some untrackable by this trigger.
• |cffffff00Party|r, |cffffff00Raid|r, |cffffff00Boss|r, |cffffff00Arena|r, and |cffffff00Nameplate|r can match multiple corresponding unitIDs.
• |cffffff00Smart Group|r adjusts to your current group type, matching just the "player" when solo, "party" units (including "player") in a party or "raid" units in a raid.

|cffffff00*|r Yellow Unit settings will create clones for each matching unit while this trigger is providing Dynamic Info to the Aura.]=] ] = [=[• |cff00ff00Player|r, |cff00ff00Target|r, |cff00ff00Focus|r, and |cff00ff00Pet|r correspond directly to those individual unitIDs.
• |cff00ff00Specific Unit|r lets you provide a specific valid unitID to watch.
|cffff0000Note|r: The game will not fire events for all valid unitIDs, making some untrackable by this trigger.
• |cffffff00Party|r, |cffffff00Raid|r, |cffffff00Boss|r, |cffffff00Arena|r, and |cffffff00Nameplate|r can match multiple corresponding unitIDs.
• |cffffff00Smart Group|r adjusts to your current group type, matching just the "player" when solo, "party" units (including "player") in a party or "raid" units in a raid.

|cffffff00*|r Yellow Unit settings will create clones for each matching unit while this trigger is providing Dynamic Info to the Aura.]=]
--[[Translation missing --]]
L["1. Profession 1. Accessory"] = "1. Profession 1. Accessory"
--[[Translation missing --]]
L["1. Profession 2. Accessory"] = "1. Profession 2. Accessory"
--[[Translation missing --]]
L["1. Professsion Tool"] = "1. Professsion Tool"
L["10 Man Raid"] = "10-Mann-Schlachtzug"
--[[Translation missing --]]
L["10 Player Raid"] = "10 Player Raid"
L["10 Player Raid (Heroic)"] = "10 Spieler Schlachtzug (Heroisch)"
L["10 Player Raid (Normal)"] = "10 Spieler Schlachtzug (Normal)"
--[[Translation missing --]]
L["2. Profession 1. Accessory"] = "2. Profession 1. Accessory"
--[[Translation missing --]]
L["2. Profession 2. Accessory"] = "2. Profession 2. Accessory"
--[[Translation missing --]]
L["2. Professsion Tool"] = "2. Professsion Tool"
L["20 Man Raid"] = "20-Mann-Schlachtzug"
--[[Translation missing --]]
L["20 Player Raid"] = "20 Player Raid"
L["25 Man Raid"] = "25-Mann-Schlachtzug"
L["25 Player Raid"] = "25 Spieler Schlachtzug"
L["25 Player Raid (Heroic)"] = "25 Spieler Schlachtzug (Heroisch)"
L["25 Player Raid (Normal)"] = "25 Spieler Schlachtzug (Normal)"
L["40 Man Raid"] = "40-Mann-Schlachtzug"
L["40 Player Raid"] = "40 Spieler Schlachtzug"
L["5 Man Dungeon"] = "5-Mann-Dungeon"
--[[Translation missing --]]
L[ [=[A detailed overview of your auras and KUIAR_Runtime systems
Copy the whole text to Weakaura's Discord if you need assistance.]=] ] = [=[A detailed overview of your auras and KUIAR_Runtime systems
Copy the whole text to Weakaura's Discord if you need assistance.]=]
--[[Translation missing --]]
L["A trigger in this aura is set up to track a soft target unit, but you don't have the CVars set up for this to work correctly. Consider either changing the unit tracked, or configuring the Soft Target CVars."] = "A trigger in this aura is set up to track a soft target unit, but you don't have the CVars set up for this to work correctly. Consider either changing the unit tracked, or configuring the Soft Target CVars."
--[[Translation missing --]]
L["Abbreviate"] = "Abbreviate"
--[[Translation missing --]]
L["AbbreviateLargeNumbers (Blizzard)"] = "AbbreviateLargeNumbers (Blizzard)"
--[[Translation missing --]]
L["AbbreviateNumbers (Blizzard)"] = "AbbreviateNumbers (Blizzard)"
L["Absorb"] = "Absorbieren"
--[[Translation missing --]]
L["Absorb and Healing"] = "Absorb and Healing"
--[[Translation missing --]]
L["Absorb Heal Overlay"] = "Absorb Heal Overlay"
--[[Translation missing --]]
L["Absorb Overlay"] = "Absorb Overlay"
L["Absorbed"] = "Absorbiert"
--[[Translation missing --]]
L["Action Button Glow"] = "Action Button Glow"
L["Actions"] = "Aktionen"
L["Active"] = "Aktiv"
--[[Translation missing --]]
L[ [=[Active boss mod addon: |cFFffcc00BigWigs|r

Note: This trigger will use BigWigs or DBM, in that order if both are installed.]=] ] = [=[Active boss mod addon: |cFFffcc00BigWigs|r

Note: This trigger will use BigWigs or DBM, in that order if both are installed.]=]
--[[Translation missing --]]
L[ [=[Active boss mod addon: |cFFffcc00DBM|r

Note: This trigger will use BigWigs or DBM, in that order if both are installed.]=] ] = [=[Active boss mod addon: |cFFffcc00DBM|r

Note: This trigger will use BigWigs or DBM, in that order if both are installed.]=]
L["Add"] = "Hinzufügen"
L["Add Missing Auras"] = "Fehlende Auren hinzufügen"
--[[Translation missing --]]
L["Advanced Caster's Target Check"] = "Advanced Caster's Target Check"
L["Affected"] = "Betroffen"
L["Affected Unit Count"] = "Anzahl betroffener Einheiten"
L["Afk"] = "Afk"
L["Aggro"] = "Aggro (Bedrohung)"
L["Agility"] = "Beweglichkeit"
L["Ahn'Qiraj"] = "Ahn'Qiraj"
L["Alert Type"] = "Warnungstyp"
L["Alive"] = "am Leben"
L["All"] = "Alle"
--[[Translation missing --]]
L["All children of this aura will also not be loaded, to minimize the chance of further corruption."] = "All children of this aura will also not be loaded, to minimize the chance of further corruption."
--[[Translation missing --]]
L["All States table contains a non table at key: '%s'."] = "All States table contains a non table at key: '%s'."
L["All Triggers"] = "Alle Auslöser (UND)"
L["Alliance"] = "Allianz"
L["Allow partial matches"] = "Teilweise Übereinstimmungen erlauben"
L["Alpha"] = "Alpha"
L["Alternate Power"] = "Alternative Energie"
L["Always"] = "Immer"
L["Always active trigger"] = "Immer aktiver Auslöser"
L["Always include realm"] = "Immer Realm einschließen"
L["Always True"] = "Immer Richtig"
L["Amount"] = "Anzahl"
--[[Translation missing --]]
L["Anchoring"] = "Anchoring"
L["And Talent"] = "Und Talent"
--[[Translation missing --]]
L["Angle and Radius"] = "Angle and Radius"
L["Animations"] = "Animationen"
L["Anticlockwise"] = "Im Gegenuhrzeigersinn"
--[[Translation missing --]]
L["Anub'Rekhan"] = "Anub'Rekhan"
--[[Translation missing --]]
L["Any"] = "Any"
L["Any Triggers"] = "Ein Auslöser (ODER)"
--[[Translation missing --]]
L["AOE"] = "AOE"
--[[Translation missing --]]
L["Arcane Resistance"] = "Arcane Resistance"
--[[Translation missing --]]
L[ [=[Are you sure you want to run the |cffff0000EXPERIMENTAL|r repair tool?
This will overwrite any changes you have made since the last database upgrade.
Last upgrade: %s]=] ] = [=[Are you sure you want to run the |cffff0000EXPERIMENTAL|r repair tool?
This will overwrite any changes you have made since the last database upgrade.
Last upgrade: %s]=]
L["Arena"] = "Arena"
L["Armor (%)"] = "Rüstung (%)"
--[[Translation missing --]]
L["Armor against Target (%)"] = "Armor against Target (%)"
--[[Translation missing --]]
L["Armor Peneration Percent"] = "Armor Peneration Percent"
--[[Translation missing --]]
L["Armor Peneration Rating"] = "Armor Peneration Rating"
--[[Translation missing --]]
L["Armor Rating"] = "Armor Rating"
--[[Translation missing --]]
L["Array"] = "Array"
L["Ascending"] = "Aufsteigend"
L["Assigned Role"] = "Zugewiesene Rolle"
--[[Translation missing --]]
L["Assigned Role Icon"] = "Assigned Role Icon"
--[[Translation missing --]]
L["Assist"] = "Assist"
--[[Translation missing --]]
L["Assisted Combat Next Cast"] = "Assisted Combat Next Cast"
L["At Least One Enemy"] = "Zumindest ein Feind"
L["At missing Value"] = "Bei fehlendem Wert"
L["At Percent"] = "Bei Prozent"
L["At Value"] = "Bei Wert"
--[[Translation missing --]]
L["At War"] = "At War"
L["Attach to End"] = "am Ende befestigen"
--[[Translation missing --]]
L["Attach to End, backwards"] = "Attach to End, backwards"
--[[Translation missing --]]
L["Attach to Point"] = "Attach to Point"
L["Attach to Start"] = "am Anfang befestigen"
L["Attack Power"] = "Angriffskraft"
L["Attackable"] = "Angreifbar"
L["Attackable Target"] = "Angreifbares Ziel"
L["Aura"] = "Aura (Buff/Debuff)"
--[[Translation missing --]]
L["Aura '%s': %s"] = "Aura '%s': %s"
L["Aura Applied"] = "Aura angewandt (AURA_APPLIED)"
L["Aura Applied Dose"] = "Aura angewandt, Stapel erhöht (AURA_APPLIED_DOSE)"
L["Aura Broken"] = "Aura gebrochen, Nahkampf (AURA_BROKEN)"
L["Aura Broken Spell"] = "Aura gebrochen, Zauber (AURA_BROKEN_SPELL)"
--[[Translation missing --]]
L["Aura is using deprecated SetDurationInfo"] = "Aura is using deprecated SetDurationInfo"
--[[Translation missing --]]
L["Aura loaded"] = "Aura loaded"
L["Aura Name"] = "Auraname oder -ID"
L["Aura Names"] = "Aura Namen"
L["Aura Refresh"] = "Aura erneuert (AURA_REFRESH)"
L["Aura Removed"] = "Aura entfernt (AURA_REMOVED)"
L["Aura Removed Dose"] = "Aura entfernt, Stack verringert (AURA_REMOVED_DOSE)"
L["Aura Stack"] = "Aurastapel"
L["Aura Type"] = "Auratyp"
--[[Translation missing --]]
L["Aura Version: %s"] = "Aura Version: %s"
L["Aura(s) Found"] = "Auren gefunden"
L["Aura(s) Missing"] = "Auren fehlend"
L["Aura:"] = "Aura:"
--[[Translation missing --]]
L["Auras"] = "Auras"
L["Auras:"] = "Auren:"
--[[Translation missing --]]
L["Author Options"] = "Author Options"
--[[Translation missing --]]
L["Auto"] = "Auto"
--[[Translation missing --]]
L["Autocast Shine"] = "Autocast Shine"
L["Automatic"] = "Automatisch"
--[[Translation missing --]]
L["Automatic Length"] = "Automatic Length"
L["Automatic Rotation"] = "Automatische Rotation"
--[[Translation missing --]]
L["Available features: %s"] = "Available features: %s"
L["Avoidance (%)"] = "Vermeidung (%)"
--[[Translation missing --]]
L["Avoidance Rating"] = "Avoidance Rating"
--[[Translation missing --]]
L["Ayamiss the Hunter"] = "Ayamiss the Hunter"
--[[Translation missing --]]
L["Azuregos"] = "Azuregos"
L["Back and Forth"] = "Vor und zurück"
L["Background"] = "Hintergrund"
L["Background Color"] = "Hintergrundfarbe"
--[[Translation missing --]]
L["Balnazzar"] = "Balnazzar"
--[[Translation missing --]]
L["Bar Color/Gradient Start"] = "Bar Color/Gradient Start"
--[[Translation missing --]]
L["Bar enabled in BigWigs settings"] = "Bar enabled in BigWigs settings"
--[[Translation missing --]]
L["Bar enabled in Boss Mod addon settings"] = "Bar enabled in Boss Mod addon settings"
--[[Translation missing --]]
L["Bar enabled in DBM settings"] = "Bar enabled in DBM settings"
--[[Translation missing --]]
L["Bar Texture"] = "Bar Texture"
--[[Translation missing --]]
L["Bar Type"] = "Bar Type"
--[[Translation missing --]]
L["Baron Geddon"] = "Baron Geddon"
--[[Translation missing --]]
L["Battle for Azeroth"] = "Battle for Azeroth"
L["Battle.net Whisper"] = "Battle.net-Flüster"
L["Battleground"] = "Schlachtfeld"
--[[Translation missing --]]
L["Battleguard Sartura"] = "Battleguard Sartura"
--[[Translation missing --]]
L["Beastmaster"] = "Beastmaster"
--[[Translation missing --]]
L["Beatrix"] = "Beatrix"
--[[Translation missing --]]
L["BG>Raid>Party>Say"] = "BG>Raid>Party>Say"
L["BG-System Alliance"] = "BG-System Allianz"
L["BG-System Horde"] = "BG-System Horde"
L["BG-System Neutral"] = "BG-System Neutral"
--[[Translation missing --]]
L["Big Number"] = "Big Number"
L["BigWigs Addon"] = "BigWigs-Addon"
L["BigWigs Message"] = "BigWigs-Nachricht"
--[[Translation missing --]]
L["BigWigs Stage"] = "BigWigs Stage"
L["BigWigs Timer"] = "BigWigs-Timer"
L["Black Wing Lair"] = "Pechschwingenhort"
--[[Translation missing --]]
L["Bleed"] = "Bleed"
L["Blizzard Combat Text"] = "Kampflog"
--[[Translation missing --]]
L["Blizzard Cooldown Reduction"] = "Blizzard Cooldown Reduction"
L["Block"] = "Blocken"
--[[Translation missing --]]
L["Block (%)"] = "Block (%)"
--[[Translation missing --]]
L["Block against Target (%)"] = "Block against Target (%)"
--[[Translation missing --]]
L["Block Value"] = "Block Value"
L["Blocked"] = "Geblockt"
--[[Translation missing --]]
L["Blood"] = "Blood"
--[[Translation missing --]]
L["Blood Rune #1"] = "Blood Rune #1"
--[[Translation missing --]]
L["Blood Rune #2"] = "Blood Rune #2"
--[[Translation missing --]]
L["Bloodlord Mandokir"] = "Bloodlord Mandokir"
--[[Translation missing --]]
L["Border"] = "Rahmen"
L["Boss"] = "Boss"
L["Boss Emote"] = "Bossemote"
--[[Translation missing --]]
L["Boss Mod Announce"] = "Boss Mod Announce"
--[[Translation missing --]]
L["Boss Mod Stage"] = "Boss Mod Stage"
--[[Translation missing --]]
L["Boss Mod Stage (Event)"] = "Boss Mod Stage (Event)"
--[[Translation missing --]]
L["Boss Mod Timer"] = "Boss Mod Timer"
L["Boss Whisper"] = "Bossflüstern"
L["Bottom"] = "Unten"
L["Bottom Left"] = "Unten Links"
L["Bottom Right"] = "Unten Rechts"
L["Bottom to Top"] = "Unten -> Oben"
L["Bounce"] = "Hüpfen"
L["Bounce with Decay"] = "Abklingendes Hüpfen"
--[[Translation missing --]]
L["Break"] = "Break"
--[[Translation missing --]]
L["BreakUpLargeNumbers (Blizzard)"] = "BreakUpLargeNumbers (Blizzard)"
--[[Translation missing --]]
L["Broodlord Lashlayer"] = "Broodlord Lashlayer"
L["Buff"] = "Buff"
L["Buff/Debuff"] = "Stärkungs-/Schwächungszauber"
L["Buffed/Debuffed"] = "Buffed/Debuffed"
L["Burning Crusade"] = "Burning Crusade"
--[[Translation missing --]]
L["Buru the Gorger"] = "Buru the Gorger"
--[[Translation missing --]]
L["Caldoran"] = "Caldoran"
--[[Translation missing --]]
L["Callback function"] = "Callback function"
L["Can be used for e.g. checking if \"boss1target\" is the same as \"player\"."] = "Kann genutzt werden um z.B zu checken ob \"Ziel\" dieselbe Einheit ist wie \"Spieler\""
L["Cancel"] = "Abbrechen"
--[[Translation missing --]]
L[ [=[Cannot change secure frame in combat lockdown. Find more information:
https://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames]=] ] = [=[Cannot change secure frame in combat lockdown. Find more information:
https://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames]=]
--[[Translation missing --]]
L["Can't schedule timer with %i, due to a World of Warcraft bug with high computer uptime. (Uptime: %i). Please restart your computer."] = "Can't schedule timer with %i, due to a World of Warcraft bug with high computer uptime. (Uptime: %i). Please restart your computer."
--[[Translation missing --]]
L["Capped"] = "Capped"
--[[Translation missing --]]
L["Capped at Season Max"] = "Capped at Season Max"
--[[Translation missing --]]
L["Capped at Weekly Max"] = "Capped at Weekly Max"
L["Cast"] = "Zauberwirken"
L["Cast Bar"] = "Zauberleiste"
L["Cast Failed"] = "Zauber fehlgeschlagen (CAST_FAILED)"
L["Cast Start"] = "Zauber gestartet (CAST_START)"
L["Cast Success"] = "Zauber gelungen (CAST_SUCCESS)"
L["Cast Type"] = "Zaubertyp"
L["Caster"] = "Zauberwirker"
--[[Translation missing --]]
L["Caster Name"] = "Caster Name"
--[[Translation missing --]]
L["Caster Realm"] = "Caster Realm"
--[[Translation missing --]]
L["Caster Unit"] = "Caster Unit"
--[[Translation missing --]]
L["Casters Name/Realm"] = "Casters Name/Realm"
--[[Translation missing --]]
L["Caster's Target"] = "Caster's Target"
--[[Translation missing --]]
L["Cataclysm"] = "Cataclysm"
--[[Translation missing --]]
L["Ceil"] = "Ceil"
L["Center"] = "Mitte"
--[[Translation missing --]]
L["Center, then alternating bottom and top"] = "Center, then alternating bottom and top"
--[[Translation missing --]]
L["Center, then alternating left and right"] = "Center, then alternating left and right"
--[[Translation missing --]]
L["Center, then alternating right and left"] = "Center, then alternating right and left"
--[[Translation missing --]]
L["Center, then alternating top and bottom"] = "Center, then alternating top and bottom"
L["Centered Horizontal"] = "Horizontal-Zentriert"
--[[Translation missing --]]
L["Centered Horizontal, then Centered Vertical"] = "Centered Horizontal, then Centered Vertical"
--[[Translation missing --]]
L["Centered Horizontal, then Down"] = "Centered Horizontal, then Down"
--[[Translation missing --]]
L["Centered Horizontal, then Up"] = "Centered Horizontal, then Up"
L["Centered Vertical"] = "Vertikal zentriert"
--[[Translation missing --]]
L["Centered Vertical, then Centered Horizontal"] = "Centered Vertical, then Centered Horizontal"
--[[Translation missing --]]
L["Centered Vertical, then Left"] = "Centered Vertical, then Left"
--[[Translation missing --]]
L["Centered Vertical, then Right"] = "Centered Vertical, then Right"
L["Changed"] = "Verändert"
L["Channel"] = "Chatkanal"
L["Channel (Spell)"] = "Kanalisieren (Zauber)"
--[[Translation missing --]]
L["Character GUID"] = "Character GUID"
--[[Translation missing --]]
L["Character Name"] = "Character Name"
L["Character Stats"] = "Charakterwerte"
--[[Translation missing --]]
L["Character Transferred Quantity"] = "Character Transferred Quantity"
L["Character Type"] = "Charaktertyp"
L["Charge gained/lost"] = "Aufladung erhalten/verloren"
--[[Translation missing --]]
L["Charged Combo Points"] = "Charged Combo Points"
L["Charges"] = "Aufladungen"
--[[Translation missing --]]
L["Charges Changed Event"] = "Charges Changed Event"
--[[Translation missing --]]
L["Charging"] = "Charging"
L["Chat Frame"] = "Chatfenster"
L["Chat Message"] = "Chatnachricht"
--[[Translation missing --]]
L["Check if a single talent match a Rank"] = "Check if a single talent match a Rank"
--[[Translation missing --]]
L["Check nameplate's target every 0.2s"] = "Check nameplate's target every 0.2s"
--[[Translation missing --]]
L["Chromaggus"] = "Chromaggus"
L["Circle"] = "Kreis"
--[[Translation missing --]]
L["Circular Texture"] = "Circular Texture"
--[[Translation missing --]]
L["Clamp"] = "Clamp"
L["Class"] = "Klasse"
L["Class and Specialization"] = "Klasse und Spezialisierung"
--[[Translation missing --]]
L["Classic"] = "Classic"
L["Classification"] = "Klassifizierung"
L["Clockwise"] = "Im Uhrzeigersinn"
--[[Translation missing --]]
L["Clone per Character"] = "Clone per Character"
L["Clone per Event"] = "Klonen pro Event"
L["Clone per Match"] = "Klonen pro Treffer"
--[[Translation missing --]]
L["Coin Precision"] = "Coin Precision"
L["Color"] = "Farbe"
--[[Translation missing --]]
L["Color Animation"] = "Color Animation"
L["Combat Log"] = "Kampflog"
--[[Translation missing --]]
L["Communities"] = "Communities"
--[[Translation missing --]]
L["Condition Custom Test"] = "Condition Custom Test"
L["Conditions"] = "Bedingungen"
L["Contains"] = "Enthält"
--[[Translation missing --]]
L["Continuously update Movement Speed"] = "Continuously update Movement Speed"
L["Cooldown"] = "Abklingzeit"
--[[Translation missing --]]
L["Cooldown bars show time before an ability is ready to be use, BigWigs prefix them with '~'"] = "Cooldown bars show time before an ability is ready to be use, BigWigs prefix them with '~'"
L["Cooldown Progress (Item)"] = "Abklingzeit (Gegenstand)"
--[[Translation missing --]]
L["Cooldown Progress (Slot)"] = "Cooldown Progress (Slot)"
--[[Translation missing --]]
L["Cooldown Ready Event"] = "Cooldown Ready Event"
--[[Translation missing --]]
L["Cooldown Ready Event (Item)"] = "Cooldown Ready Event (Item)"
--[[Translation missing --]]
L["Cooldown Ready Event (Slot)"] = "Cooldown Ready Event (Slot)"
--[[Translation missing --]]
L["Cooldown Reduction changes the duration of seconds instead of showing the real time seconds."] = "Cooldown Reduction changes the duration of seconds instead of showing the real time seconds."
--[[Translation missing --]]
L["Cooldown/Charges/Count"] = "Cooldown/Charges/Count"
--[[Translation missing --]]
L["Copper"] = "Copper"
--[[Translation missing --]]
L["Could not load KUIAR_Engine Archive, the addon is %s"] = "Could not load KUIAR_Engine Archive, the addon is %s"
L["Count"] = "Anzahl"
L["Counter Clockwise"] = "Gegen den Uhrzeigersinn"
L["Create"] = "Erstellen"
--[[Translation missing --]]
L["Creature Family"] = "Creature Family"
--[[Translation missing --]]
L["Creature Family Name"] = "Creature Family Name"
--[[Translation missing --]]
L["Creature Type"] = "Creature Type"
--[[Translation missing --]]
L["Creature Type Name"] = "Creature Type Name"
L["Critical"] = "Kritisch"
--[[Translation missing --]]
L["Critical (%)"] = "Critical (%)"
--[[Translation missing --]]
L["Critical Rating"] = "Critical Rating"
--[[Translation missing --]]
L["Crop X"] = "Crop X"
--[[Translation missing --]]
L["Crop Y"] = "Crop Y"
L["Crowd Controlled"] = "Kontrollverlust"
L["Crushing"] = "Zerschmettern"
--[[Translation missing --]]
L["C'thun"] = "C'thun"
--[[Translation missing --]]
L["Cumulated time used during profiling"] = "Cumulated time used during profiling"
--[[Translation missing --]]
L["Currency"] = "Currency"
--[[Translation missing --]]
L["Current Essence"] = "Current Essence"
--[[Translation missing --]]
L["Current Experience"] = "Current Experience"
--[[Translation missing --]]
L["Current Instance"] = "Current Instance"
--[[Translation missing --]]
L["Current Movement Speed (%)"] = "Current Movement Speed (%)"
--[[Translation missing --]]
L["Current Stage"] = "Current Stage"
--[[Translation missing --]]
L["Current Zone"] = "Current Zone"
--[[Translation missing --]]
L["Current Zone Group"] = "Current Zone Group"
L["Curse"] = "Fluch"
L["Custom"] = "Benutzerdefiniert"
--[[Translation missing --]]
L["Custom Action"] = "Custom Action"
--[[Translation missing --]]
L["Custom Anchor"] = "Custom Anchor"
--[[Translation missing --]]
L["Custom Check"] = "Custom Check"
--[[Translation missing --]]
L["Custom Color"] = "Custom Color"
--[[Translation missing --]]
L["Custom Condition Code"] = "Custom Condition Code"
--[[Translation missing --]]
L["Custom Configuration"] = "Custom Configuration"
--[[Translation missing --]]
L["Custom Fade Animation"] = "Custom Fade Animation"
L["Custom Function"] = "Benutzerdefiniert"
--[[Translation missing --]]
L["Custom Grow"] = "Custom Grow"
--[[Translation missing --]]
L["Custom Sort"] = "Custom Sort"
--[[Translation missing --]]
L["Custom Text Function"] = "Custom Text Function"
--[[Translation missing --]]
L["Custom Trigger Combination"] = "Custom Trigger Combination"
--[[Translation missing --]]
L["Custom Variables"] = "Custom Variables"
L["Damage"] = "Schaden (DAMAGE)"
L["Damage Shield"] = "Schadensschild (DAMAGE_SHIELD)"
L["Damage Shield Missed"] = "Schadensschild verfehlt (DAMAGE_SHIELD_MISSED)"
L["Damage Split"] = "Schadensteilung (DAMAGE_SPLIT)"
L["DBM Announce"] = "DBM Meldung"
--[[Translation missing --]]
L["DBM Stage"] = "DBM Stage"
L["DBM Timer"] = "DBM-Timer"
--[[Translation missing --]]
L["Dead"] = "Dead"
--[[Translation missing --]]
L["Death"] = "Death"
L["Death Knight Rune"] = "Todesritter-Rune"
L["Debuff"] = "Debuff"
L["Debuff Class"] = "Schwächungszauber Klasse"
L["Debuff Class Icon"] = "Schwächungszauber Klassensymbol"
L["Debuff Type"] = "Schwächungszaubertyp"
--[[Translation missing --]]
L["Debug Log contains more than 1000 entries"] = "Debug Log contains more than 1000 entries"
--[[Translation missing --]]
L["Debug Logging enabled"] = "Debug Logging enabled"
--[[Translation missing --]]
L["Debug Logging enabled for '%s'"] = "Debug Logging enabled for '%s'"
--[[Translation missing --]]
L["Defense"] = "Defense"
--[[Translation missing --]]
L["Defensive Stats"] = "Defensive Stats"
L["Deflect"] = "Umlenken"
--[[Translation missing --]]
L["Delve"] = "Delve"
L["Desaturate"] = "Entsättigen"
L["Desaturate Background"] = "Hintergrund entsättigen"
L["Desaturate Foreground"] = "Vordergrund entsättigen"
L["Descending"] = "Absteigend"
L["Description"] = "Beschreibung"
L["Dest Raid Mark"] = "Zielmarkierung"
--[[Translation missing --]]
L["Destination Affiliation"] = "Destination Affiliation"
--[[Translation missing --]]
L["Destination GUID"] = "Destination GUID"
--[[Translation missing --]]
L["Destination Info"] = "Destination Info"
L["Destination Name"] = "Zielname"
--[[Translation missing --]]
L["Destination NPC Id"] = "Destination NPC Id"
--[[Translation missing --]]
L["Destination Object Type"] = "Destination Object Type"
--[[Translation missing --]]
L["Destination Reaction"] = "Destination Reaction"
L["Destination Unit"] = "Zieleinheit"
--[[Translation missing --]]
L["Destination unit's raid mark index"] = "Destination unit's raid mark index"
--[[Translation missing --]]
L["Destination unit's raid mark texture"] = "Destination unit's raid mark texture"
L["Difficulty"] = "Schwierigkeit"
--[[Translation missing --]]
L["Disable Spell Known Check"] = "Disable Spell Known Check"
--[[Translation missing --]]
L["Disabled"] = "Disabled"
--[[Translation missing --]]
L["Disabled feature %q"] = "Disabled feature %q"
--[[Translation missing --]]
L["Disabled Spell Known Check"] = "Disabled Spell Known Check"
--[[Translation missing --]]
L["Discovered"] = "Discovered"
L["Disease"] = "Krankheit"
L["Dispel"] = "Bannen (DISPEL)"
L["Dispel Failed"] = "Bannen fehlgeschlagen (DISPEL_FAILED)"
L["Display"] = "Anzeige"
L["Distance"] = "Distanz"
L["Do Not Disturb"] = "Bitte nicht stören"
L["Dodge"] = "Ausweichen (DODGE)"
L["Dodge (%)"] = "Ausweichen (%)"
--[[Translation missing --]]
L["Dodge Rating"] = "Dodge Rating"
L["Down"] = "Runter"
--[[Translation missing --]]
L["Down, then Centered Horizontal"] = "Down, then Centered Horizontal"
L["Down, then Left"] = "Runter, dann links"
L["Down, then Right"] = "Runter, dann rechts"
L["Dragonflight"] = "Dragonflight"
L["Drain"] = "Saugen (DRAIN)"
L["Dropdown Menu"] = "Auswahlmenü"
--[[Translation missing --]]
L["Dumping table"] = "Dumping table"
--[[Translation missing --]]
L["Dungeon (Celestial)"] = "Dungeon (Celestial)"
L["Dungeon (Heroic)"] = "Dungeon (Heroisch)"
--[[Translation missing --]]
L["Dungeon (Mythic)"] = "Dungeon (Mythic)"
--[[Translation missing --]]
L["Dungeon (Mythic+)"] = "Dungeon (Mythic+)"
L["Dungeon (Normal)"] = "Dungeon (Normal)"
L["Dungeon (Timewalking)"] = "Dungeon (Zeitwanderung)"
L["Dungeons"] = "Instanzen"
L["Durability Damage"] = "Haltbarkeitsschaden (DURABILITY_DAMAGE)"
L["Durability Damage All"] = "Haltbarkeitsschaden, Alle (DURABILITY_DAMAGE_ALL)"
--[[Translation missing --]]
L["Duration"] = "Duration"
--[[Translation missing --]]
L["Duration Function"] = "Duration Function"
--[[Translation missing --]]
L["Duration Function (fallback state)"] = "Duration Function (fallback state)"
--[[Translation missing --]]
L["Ease In"] = "Ease In"
--[[Translation missing --]]
L["Ease In and Out"] = "Ease In and Out"
--[[Translation missing --]]
L["Ease Out"] = "Ease Out"
--[[Translation missing --]]
L["Ebonroc"] = "Ebonroc"
--[[Translation missing --]]
L["Eclipse Direction"] = "Eclipse Direction"
L["Edge"] = "Ecke"
--[[Translation missing --]]
L["Edge of Madness"] = "Edge of Madness"
--[[Translation missing --]]
L["Effective Spell Id"] = "Effective Spell Id"
--[[Translation missing --]]
L["Elide"] = "Elide"
L["Elite"] = "Elite"
L["Emote"] = "Emote"
--[[Translation missing --]]
L["Empower Cast End"] = "Empower Cast End"
--[[Translation missing --]]
L["Empower Cast Interrupt"] = "Empower Cast Interrupt"
--[[Translation missing --]]
L["Empower Cast Start"] = "Empower Cast Start"
--[[Translation missing --]]
L["Empowered"] = "Empowered"
--[[Translation missing --]]
L["Empowered 1"] = "Empowered 1"
--[[Translation missing --]]
L["Empowered 2"] = "Empowered 2"
--[[Translation missing --]]
L["Empowered 3"] = "Empowered 3"
--[[Translation missing --]]
L["Empowered 4"] = "Empowered 4"
--[[Translation missing --]]
L["Empowered 5"] = "Empowered 5"
--[[Translation missing --]]
L["Empowered Cast"] = "Empowered Cast"
--[[Translation missing --]]
L["Empowered Cast Fully Charged"] = "Empowered Cast Fully Charged"
--[[Translation missing --]]
L["Empowered Fully Charged"] = "Empowered Fully Charged"
L["Empty"] = "Leer"
--[[Translation missing --]]
L["Enabled feature %q"] = "Enabled feature %q"
--[[Translation missing --]]
L["Enables (incorrect) round down of seconds, which was the previous default behavior."] = "Enables (incorrect) round down of seconds, which was the previous default behavior."
--[[Translation missing --]]
L["Enchant Applied"] = "Enchant Applied"
--[[Translation missing --]]
L["Enchant Found"] = "Enchant Found"
--[[Translation missing --]]
L["Enchant ID"] = "Enchant ID"
--[[Translation missing --]]
L["Enchant Missing"] = "Enchant Missing"
--[[Translation missing --]]
L["Enchant Name or ID"] = "Enchant Name or ID"
--[[Translation missing --]]
L["Enchant Removed"] = "Enchant Removed"
--[[Translation missing --]]
L["Enchanted"] = "Enchanted"
--[[Translation missing --]]
L["Encounter ID(s)"] = "Encounter ID(s)"
L["Energize"] = "Aufladen (ENERGIZE)"
L["Enrage"] = "Wut"
--[[Translation missing --]]
L["Enter a name or a spellId"] = "Enter a name or a spellId"
L["Entering"] = "Betreten"
L["Entering/Leaving Combat"] = "Kampf Betreten/Verlassen"
--[[Translation missing --]]
L["Entering/Leaving Encounter"] = "Entering/Leaving Encounter"
L["Entry Order"] = "Eintragsreihenfolge"
L["Environment Type"] = "Umgebungstyp"
L["Environmental"] = "Umgebung (ENVIRONMENTAL)"
--[[Translation missing --]]
L["Equipment"] = "Equipment"
L["Equipment Set"] = "Ausrüstungsset"
L["Equipment Set Equipped"] = "Angelegtes Ausrüstungsset"
L["Equipment Slot"] = "Ausrüstungsplatz"
L["Equipped"] = "Angelegt"
L["Error"] = "Fehler"
--[[Translation missing --]]
L[ [=[Error '%s' created a secure clone. We advise deleting the aura. For more information:
https://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames]=] ] = [=[Error '%s' created a secure clone. We advise deleting the aura. For more information:
https://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames]=]
--[[Translation missing --]]
L["Error decoding."] = "Error decoding."
--[[Translation missing --]]
L["Error decompressing"] = "Error decompressing"
--[[Translation missing --]]
L["Error decompressing. This doesn't look like a KUIAR_Engine import."] = "Error decompressing. This doesn't look like a KUIAR_Engine import."
--[[Translation missing --]]
L["Error deserializing"] = "Error deserializing"
L["Error Frame"] = "Fehlerfenster"
--[[Translation missing --]]
L["ERROR in '%s' unknown or incompatible sub element type '%s'"] = "ERROR in '%s' unknown or incompatible sub element type '%s'"
--[[Translation missing --]]
L["Error in Aura '%s'"] = "Error in Aura '%s'"
--[[Translation missing --]]
L["Error not receiving display information from %s"] = "Error not receiving display information from %s"
--[[Translation missing --]]
L["Essence"] = "Essence"
--[[Translation missing --]]
L["Essence #1"] = "Essence #1"
--[[Translation missing --]]
L["Essence #2"] = "Essence #2"
--[[Translation missing --]]
L["Essence #3"] = "Essence #3"
--[[Translation missing --]]
L["Essence #4"] = "Essence #4"
--[[Translation missing --]]
L["Essence #5"] = "Essence #5"
--[[Translation missing --]]
L["Essence #6"] = "Essence #6"
L["Evade"] = "Entkommen (EVADE)"
L["Event"] = "Ereignis"
L["Event(s)"] = "Ereignis(se)"
L["Every Frame"] = "Bei jedem OnUpdate"
--[[Translation missing --]]
L["Every Frame (High CPU usage)"] = "Every Frame (High CPU usage)"
--[[Translation missing --]]
L["Evoker Essence"] = "Evoker Essence"
--[[Translation missing --]]
L["Exact Spell ID(s)"] = "Exact Spell ID(s)"
--[[Translation missing --]]
L["Execute Conditions"] = "Execute Conditions"
--[[Translation missing --]]
L["Experience (%)"] = "Experience (%)"
--[[Translation missing --]]
L["Expertise Bonus"] = "Expertise Bonus"
--[[Translation missing --]]
L["Expertise Rating"] = "Expertise Rating"
--[[Translation missing --]]
L["Extend Outside"] = "Extend Outside"
L["Extra Amount"] = "Extrabetrag"
L["Extra Attacks"] = "Extraangriffe (EXTRA_ATTACKS)"
--[[Translation missing --]]
L["Extra Spell Id"] = "Extra Spell Id"
L["Extra Spell Name"] = "Extra-Zaubername"
L["Faction"] = "Fraktion"
L["Faction Name"] = "Fraktionsname"
L["Faction Reputation"] = "Fraktionsruf"
--[[Translation missing --]]
L["Fade Animation"] = "Fade Animation"
L["Fade In"] = "Einblenden"
L["Fade Out"] = "Ausblenden"
L["Fail Alert"] = "Warnung für Fehlschlag"
L["False"] = "Nicht Zutrifft"
--[[Translation missing --]]
L["Fankriss the Unyielding"] = "Fankriss the Unyielding"
--[[Translation missing --]]
L["Feature %q is already disabled"] = "Feature %q is already disabled"
--[[Translation missing --]]
L["Feature %q is already enabled"] = "Feature %q is already enabled"
--[[Translation missing --]]
L["Fetch Absorb"] = "Fetch Absorb"
--[[Translation missing --]]
L["Fetch Heal Absorb"] = "Fetch Heal Absorb"
--[[Translation missing --]]
--[[Translation missing --]]
--[[Translation missing --]]
L["Fill Area"] = "Fill Area"
--[[Translation missing --]]
L["Filter messages with format <message>"] = "Filter messages with format <message>"
L["Fire Resistance"] = "Feuerwiderstand"
--[[Translation missing --]]
L["Firemaw"] = "Firemaw"
--[[Translation missing --]]
L["First"] = "First"
--[[Translation missing --]]
L["First Value of Tooltip Text"] = "First Value of Tooltip Text"
L["Fixed"] = "Fixiert"
--[[Translation missing --]]
L["Fixed Names"] = "Fixed Names"
L["Fixed Size"] = "Feste Größe"
--[[Translation missing --]]
L["Flamegor"] = "Flamegor"
L["Flash"] = "Aufblitzen"
L["Flex Raid"] = "Flexibler Schlachtzug"
L["Flip"] = "Umdrehen"
L["Floor"] = "Flur"
L["Focus"] = "Fokus"
--[[Translation missing --]]
L["Follower Dungeon"] = "Follower Dungeon"
--[[Translation missing --]]
L["Font"] = "Font"
L["Font Size"] = "Schriftgröße"
--[[Translation missing --]]
L["Forbidden function or table: %s"] = "Forbidden function or table: %s"
L["Foreground"] = "Vordergrund"
L["Foreground Color"] = "Vordergrundfarbe"
L["Form"] = "Form"
--[[Translation missing --]]
L["Format"] = "Format"
--[[Translation missing --]]
L["Format Gold"] = "Format Gold"
--[[Translation missing --]]
L["Formats |cFFFFCC00%unit|r"] = "Formats |cFFFFCC00%unit|r"
--[[Translation missing --]]
L["Formats Player's |cFFFFCC00%guid|r"] = "Formats Player's |cFFFFCC00%guid|r"
L["Forward"] = "Vorwärts"
--[[Translation missing --]]
L["Forward, Reverse Loop"] = "Forward, Reverse Loop"
--[[Translation missing --]]
L["Fourth Value of Tooltip Text"] = "Fourth Value of Tooltip Text"
--[[Translation missing --]]
L["Frame Selector"] = "Frame Selector"
L["Frequency"] = "Häufigkeit"
L["Friendly"] = "Freundlich"
L["Friendly Fire"] = "Eigenbeschuss"
--[[Translation missing --]]
L["Friendship Max Rank"] = "Friendship Max Rank"
--[[Translation missing --]]
L["Friendship Rank"] = "Friendship Rank"
--[[Translation missing --]]
L["Friendship Reputation"] = "Friendship Reputation"
--[[Translation missing --]]
L["Frost"] = "Frost"
L["Frost Resistance"] = "Frostwiderstand"
--[[Translation missing --]]
L["Frost Rune #1"] = "Frost Rune #1"
--[[Translation missing --]]
L["Frost Rune #2"] = "Frost Rune #2"
L["Full"] = "Voll"
--[[Translation missing --]]
L["Full Region"] = "Full Region"
L["Full/Empty"] = "Voll/Leer"
--[[Translation missing --]]
L["Gahz'ranka"] = "Gahz'ranka"
L["Gained"] = "Erhalten "
--[[Translation missing --]]
L["Garr"] = "Garr"
--[[Translation missing --]]
L["Gehennas"] = "Gehennas"
--[[Translation missing --]]
L["General"] = "General"
--[[Translation missing --]]
L["General Rajaxx"] = "General Rajaxx"
--[[Translation missing --]]
L["GetNameAndIcon Function (fallback state)"] = "GetNameAndIcon Function (fallback state)"
L["Glancing"] = "Gestreift (GLANCING)"
L["Global Cooldown"] = "Globale Abklingzeit"
L["Glow"] = "Leuchten"
--[[Translation missing --]]
L["Glow External Element"] = "Glow External Element"
--[[Translation missing --]]
L["Gluth"] = "Gluth"
--[[Translation missing --]]
L["Glyph"] = "Glyph"
--[[Translation missing --]]
L["Gold"] = "Gold"
--[[Translation missing --]]
L["Golemagg the Incinerator"] = "Golemagg the Incinerator"
--[[Translation missing --]]
L["Gothik the Harvester"] = "Gothik the Harvester"
L["Gradient"] = "Gradient"
--[[Translation missing --]]
L["Gradient Enabled"] = "Gradient Enabled"
--[[Translation missing --]]
L["Gradient End"] = "Gradient End"
--[[Translation missing --]]
L["Gradient Orientation"] = "Gradient Orientation"
L["Gradient Pulse"] = "Gradient Pulse"
--[[Translation missing --]]
L["Grand Widow Faerlina"] = "Grand Widow Faerlina"
--[[Translation missing --]]
L["Grid"] = "Grid"
--[[Translation missing --]]
L["Grobbulus"] = "Grobbulus"
L["Group"] = "Gruppe"
L["Group Arrangement"] = "Gruppenanordnung"
--[[Translation missing --]]
L["Group Leader/Assist"] = "Group Leader/Assist"
--[[Translation missing --]]
L["Group Size"] = "Group Size"
--[[Translation missing --]]
L["Group Type"] = "Group Type"
L["Grow"] = "Wachsen"
L["GTFO Alert"] = "GTFO-Warnung"
L["Guardian"] = "Wächter"
L["Guild"] = "Gilde"
--[[Translation missing --]]
L["Hakkar"] = "Hakkar"
--[[Translation missing --]]
L["Hardcore"] = "Hardcore"
L["Has Target"] = "Hat Ziel"
L["Has Vehicle UI"] = "Hat Fahrzeug-UI"
L["HasPet"] = "mit aktivem Begleiter"
L["Haste (%)"] = "Tempo (%)"
L["Haste Rating"] = "Tempowertung"
L["Heal"] = "Heilen"
--[[Translation missing --]]
L["Heal Absorb"] = "Heal Absorb"
--[[Translation missing --]]
L["Heal Absorbed"] = "Heal Absorbed"
L["Health"] = "Lebenspunkte"
L["Health (%)"] = "Lebenspunkte (%)"
--[[Translation missing --]]
L["Health Deficit"] = "Health Deficit"
--[[Translation missing --]]
L["Heigan the Unclean"] = "Heigan the Unclean"
L["Height"] = "Höhe"
--[[Translation missing --]]
L["Hero Talent"] = "Hero Talent"
--[[Translation missing --]]
L["Heroic Party"] = "Heroic Party"
L["Hide"] = "Verbergen"
--[[Translation missing --]]
L["Hide 0 cooldowns"] = "Hide 0 cooldowns"
--[[Translation missing --]]
L["Hide Timer Text"] = "Hide Timer Text"
L["High Damage"] = "Hoher Schaden"
--[[Translation missing --]]
L["High Priest Thekal"] = "High Priest Thekal"
--[[Translation missing --]]
L["High Priest Venoxis"] = "High Priest Venoxis"
--[[Translation missing --]]
L["High Priestess Arlokk"] = "High Priestess Arlokk"
--[[Translation missing --]]
L["High Priestess Jeklik"] = "High Priestess Jeklik"
--[[Translation missing --]]
L["High Priestess Mar'li"] = "High Priestess Mar'li"
L["Higher Than Tank"] = "Höher als der Tank"
--[[Translation missing --]]
L["Highest Spell Id"] = "Highest Spell Id"
--[[Translation missing --]]
L["Hit (%)"] = "Hit (%)"
--[[Translation missing --]]
L["Hit Rating"] = "Hit Rating"
L["Holy Resistance"] = "Heiligwiderstand"
L["Horde"] = "Horde"
--[[Translation missing --]]
L["Horizontal"] = "Horizontal"
L["Hostile"] = "Feindlich"
L["Hostility"] = "Gesinnung"
L["Humanoid"] = "Humanoid"
--[[Translation missing --]]
L["Hybrid"] = "Hybrid"
L["Icon"] = "Symbol"
--[[Translation missing --]]
L["Icon Function"] = "Icon Function"
--[[Translation missing --]]
L["Icon Function (fallback state)"] = "Icon Function (fallback state)"
--[[Translation missing --]]
L["Id"] = "Id"
--[[Translation missing --]]
L["ID"] = "ID"
--[[Translation missing --]]
--[[Translation missing --]]
L["Ignore Dead"] = "Ignore Dead"
--[[Translation missing --]]
L["Ignore Disconnected"] = "Ignore Disconnected"
--[[Translation missing --]]
L["Ignore out of checking range"] = "Ignore out of checking range"
L["Ignore Rune CD"] = "Runen-CD ignorieren"
--[[Translation missing --]]
L["Ignore Rune CDs"] = "Ignore Rune CDs"
--[[Translation missing --]]
L["Ignore Self"] = "Ignore Self"
--[[Translation missing --]]
L["Ignore Spell Cooldown/Charges"] = "Ignore Spell Cooldown/Charges"
--[[Translation missing --]]
L["Ignore Spell Override"] = "Ignore Spell Override"
L["Immune"] = "Immun (IMMUNE)"
L["Important"] = "Wichtig"
--[[Translation missing --]]
L["Importing will start after combat ends."] = "Importing will start after combat ends."
L["In Combat"] = "im Kampf"
L["In Encounter"] = "im Bosskampf"
L["In Group"] = "In Gruppe"
--[[Translation missing --]]
L["In Party"] = "In Party"
L["In Pet Battle"] = "im Haustierkampf"
L["In Raid"] = "Im Schlachtzug"
--[[Translation missing --]]
L["In Range"] = "In Range"
L["In Vehicle"] = "im Fahrzeug"
--[[Translation missing --]]
L["In War Mode"] = "In War Mode"
L["Include Bank"] = "Bank einbeziehen"
L["Include Charges"] = "Aufladungen einbeziehen"
--[[Translation missing --]]
L["Include Death Runes"] = "Include Death Runes"
--[[Translation missing --]]
L["Include Pets"] = "Include Pets"
--[[Translation missing --]]
L["Include War Band Bank"] = "Include War Band Bank"
L["Incoming Heal"] = "Eingehende Heilung"
--[[Translation missing --]]
L["Increase Precision Below"] = "Increase Precision Below"
--[[Translation missing --]]
L["Increases by one per stage or intermission."] = "Increases by one per stage or intermission."
--[[Translation missing --]]
L["Information"] = "Information"
L["Inherited"] = "Vererbt"
L["Instakill"] = "Sofortiger Tod (INSTAKILL)"
--[[Translation missing --]]
L["Install the addons BugSack and BugGrabber for detailed error logs."] = "Install the addons BugSack and BugGrabber for detailed error logs."
L["Instance"] = "Instanz"
L["Instance Difficulty"] = "Instanzschwierigkeit"
--[[Translation missing --]]
L["Instance Id"] = "Instance Id"
--[[Translation missing --]]
L["Instance ID"] = "Instance ID"
--[[Translation missing --]]
L["Instance Info"] = "Instance Info"
--[[Translation missing --]]
L["Instance Name"] = "Instance Name"
--[[Translation missing --]]
L["Instance Size Type"] = "Instance Size Type"
L["Instance Type"] = "Instanztyp"
--[[Translation missing --]]
L["Instructor Razuvious"] = "Instructor Razuvious"
--[[Translation missing --]]
L["Insufficient Resources"] = "Insufficient Resources"
L["Intellect"] = "Intelligenz"
L["Interrupt"] = "Unterbrechen (INTERRUPT)"
--[[Translation missing --]]
L["Interrupt School"] = "Interrupt School"
--[[Translation missing --]]
L["Interrupted School Text"] = "Interrupted School Text"
L["Interruptible"] = "Unterbrechbar"
L["Inverse"] = "Invertieren"
--[[Translation missing --]]
L["Inverse Pet Behavior"] = "Inverse Pet Behavior"
--[[Translation missing --]]
L["Is Away from Keyboard"] = "Is Away from Keyboard"
--[[Translation missing --]]
--[[Translation missing --]]
L["Is Death Rune"] = "Is Death Rune"
L["Is Exactly"] = "Strikter Vergleich"
L["Is Moving"] = "am Bewegen"
L["Is Off Hand"] = "Ist Schildhand"
--[[Translation missing --]]
--[[Translation missing --]]
L["Is Paused"] = "Is Paused"
L["is useable"] = "benutzbar"
--[[Translation missing --]]
L["Is Weekly Renown Capped"] = "Is Weekly Renown Capped"
--[[Translation missing --]]
L["Island Expedition (Heroic)"] = "Island Expedition (Heroic)"
--[[Translation missing --]]
L["Island Expedition (Mythic)"] = "Island Expedition (Mythic)"
--[[Translation missing --]]
L["Island Expedition (Normal)"] = "Island Expedition (Normal)"
--[[Translation missing --]]
L["Island Expeditions (PvP)"] = "Island Expeditions (PvP)"
L["Item"] = "Gegenstand"
--[[Translation missing --]]
L["Item Bonus Id"] = "Item Bonus Id"
--[[Translation missing --]]
L["Item Bonus Id Equipped"] = "Item Bonus Id Equipped"
L["Item Count"] = "Gegenstandsanzahl"
L["Item Equipped"] = "Gegenstand angelegt"
--[[Translation missing --]]
L["Item Id"] = "Item Id"
--[[Translation missing --]]
L["Item in Range"] = "Item in Range"
--[[Translation missing --]]
L["Item Name"] = "Item Name"
L["Item Set Equipped"] = "Gegenstandsset angelegt"
--[[Translation missing --]]
L["Item Set Id"] = "Item Set Id"
--[[Translation missing --]]
L["Item Slot"] = "Item Slot"
--[[Translation missing --]]
L["Item Slot String"] = "Item Slot String"
--[[Translation missing --]]
L["Item Type"] = "Item Type"
--[[Translation missing --]]
L["Item Type Equipped"] = "Item Type Equipped"
--[[Translation missing --]]
L["ItemId"] = "ItemId"
--[[Translation missing --]]
L["Jin'do the Hexxer"] = "Jin'do the Hexxer"
--[[Translation missing --]]
L["Journal Stage"] = "Journal Stage"
--[[Translation missing --]]
L["Kazzak"] = "Kazzak"
--[[Translation missing --]]
L["Keep Inside"] = "Keep Inside"
--[[Translation missing --]]
L["Kel'Thuzad"] = "Kel'Thuzad"
--[[Translation missing --]]
L["Kurinnaxx"] = "Kurinnaxx"
--[[Translation missing --]]
L["Large"] = "Large"
--[[Translation missing --]]
L["Latency"] = "Latency"
--[[Translation missing --]]
L["Leader"] = "Leader"
--[[Translation missing --]]
L["Least remaining time"] = "Least remaining time"
L["Leaving"] = "Verlassen"
L["Leech"] = "Saugen (LEECH)"
L["Leech (%)"] = "Lebensraub (%)"
L["Leech Rating"] = "Lebensraubswertung"
L["Left"] = "Links"
L["Left to Right"] = "Links -> Rechts"
--[[Translation missing --]]
L["Left, then Centered Vertical"] = "Left, then Centered Vertical"
L["Left, then Down"] = "Links, dann runter"
L["Left, then Up"] = "Links, dann hoch"
--[[Translation missing --]]
L["Legacy Looking for Raid"] = "Legacy Looking for Raid"
--[[Translation missing --]]
L["Legacy RGB Gradient"] = "Legacy RGB Gradient"
--[[Translation missing --]]
L["Legacy RGB Gradient Pulse"] = "Legacy RGB Gradient Pulse"
--[[Translation missing --]]
L["Legion"] = "Legion"
L["Length"] = "Länge"
L["Level"] = "Stufe"
--[[Translation missing --]]
L["LibSharedMedia"] = "LibSharedMedia"
--[[Translation missing --]]
L["Lillian Voss"] = "Lillian Voss"
--[[Translation missing --]]
L["Limited"] = "Limited"
--[[Translation missing --]]
L["Linear Texture"] = "Linear Texture"
--[[Translation missing --]]
L["Lines & Particles"] = "Lines & Particles"
L["Load Conditions"] = "Ladebedingungen"
--[[Translation missing --]]
L["Loatheb"] = "Loatheb"
--[[Translation missing --]]
L["Location"] = "Location"
--[[Translation missing --]]
L["Looking for Raid"] = "Looking for Raid"
L["Loop"] = "Schleife"
--[[Translation missing --]]
L["Loot"] = "Loot"
--[[Translation missing --]]
--[[Translation missing --]]
--[[Translation missing --]]
--[[Translation missing --]]
L["Lord Kazzak"] = "Lord Kazzak"
--[[Translation missing --]]
L["Lorewalking"] = "Lorewalking"
L["Lost"] = "Verloren"
L["Low Damage"] = "Niedriger Schaden"
L["Lower Than Tank"] = "Niedriger als der Tank"
--[[Translation missing --]]
L["Lowest Spell Id"] = "Lowest Spell Id"
--[[Translation missing --]]
L["Lua error"] = "Lua error"
--[[Translation missing --]]
L["Lua error in Aura '%s': %s"] = "Lua error in Aura '%s': %s"
--[[Translation missing --]]
L["Lucifron"] = "Lucifron"
--[[Translation missing --]]
L["Maexxna"] = "Maexxna"
L["Magic"] = "Magie"
--[[Translation missing --]]
L["Magmadar"] = "Magmadar"
--[[Translation missing --]]
L["Main Character"] = "Main Character"
--[[Translation missing --]]
L["Main Stat"] = "Main Stat"
--[[Translation missing --]]
L["Majordomo Executus"] = "Majordomo Executus"
--[[Translation missing --]]
L["Malformed KUIAR_Engine link"] = "Malformed KUIAR_Engine link"
--[[Translation missing --]]
L["Manual"] = "Manual"
--[[Translation missing --]]
L["Manual Icon"] = "Manual Icon"
L["Manual Rotation"] = "Manuelle Rotation"
L["Marked First"] = "Zuerst markiert"
L["Marked Last"] = "Zuletzt markiert"
--[[Translation missing --]]
L["Mason"] = "Mason"
L["Master"] = "Master"
L["Mastery (%)"] = "Meisterschaft (%)"
L["Mastery Rating"] = "Meisterschaftswertung"
--[[Translation missing --]]
L["Match Count"] = "Match Count"
--[[Translation missing --]]
L["Match Count per Unit"] = "Match Count per Unit"
L["Matches (Pattern)"] = "Abgleichen (Muster)"
--[[Translation missing --]]
L[ [=[Matches stage number of encounter journal.
Intermissions are .5
E.g. 1;2;1;2;2.5;3]=] ] = [=[Matches stage number of encounter journal.
Intermissions are .5
E.g. 1;2;1;2;2.5;3]=]
--[[Translation missing --]]
L["Max Char "] = "Max Char "
--[[Translation missing --]]
L["Max Char"] = "Max Char"
--[[Translation missing --]]
L["Max Charges"] = "Max Charges"
--[[Translation missing --]]
L["Max Health"] = "Max Health"
--[[Translation missing --]]
L["Max Power"] = "Max Power"
--[[Translation missing --]]
L["Max Quantity"] = "Max Quantity"
--[[Translation missing --]]
L["Maximum Estimate"] = "Maximum Estimate"
--[[Translation missing --]]
L["Maximum Progress"] = "Maximum Progress"
--[[Translation missing --]]
L["Maximum time used on a single frame"] = "Maximum time used on a single frame"
--[[Translation missing --]]
L["Media"] = "Media"
--[[Translation missing --]]
L["Medium"] = "Medium"
--[[Translation missing --]]
L["Melee"] = "Melee"
--[[Translation missing --]]
L["Melee Haste (%)"] = "Melee Haste (%)"
L["Message"] = "Nachricht"
L["Message Type"] = "Nachrichtentyp"
L["Message type:"] = "Nachrichtentyp:"
--[[Translation missing --]]
L["Meta Data"] = "Meta Data"
--[[Translation missing --]]
L["Mine"] = "Mine"
--[[Translation missing --]]
L["Minimum Estimate"] = "Minimum Estimate"
--[[Translation missing --]]
L["Minimum Progress"] = "Minimum Progress"
--[[Translation missing --]]
L["Minus (Small Nameplate)"] = "Minus (Small Nameplate)"
L["Mirror"] = "Spiegel"
--[[Translation missing --]]
L["Miscellaneous"] = "Miscellaneous"
L["Miss"] = "Verfehlen"
L["Miss Type"] = "Verfehlengrund"
L["Missed"] = "Verfehlt (MISSED)"
L["Missing"] = "Fehlend"
--[[Translation missing --]]
L["Mists of Pandaria"] = "Mists of Pandaria"
--[[Translation missing --]]
L["Moam"] = "Moam"
--[[Translation missing --]]
L["Model"] = "Model"
--[[Translation missing --]]
L["Modern Blizzard (1h 3m | 3m 7s | 10s | 2.4)"] = "Modern Blizzard (1h 3m | 3m 7s | 10s | 2.4)"
--[[Translation missing --]]
L["Modernize"] = "Modernize"
L["Molten Core"] = "Geschmolzener Kern"
--[[Translation missing --]]
L["Money"] = "Money"
L["Monochrome"] = "Einfarbig"
L["Monochrome Outline"] = "Graustufenkontur"
L["Monochrome Thick Outline"] = "Einfarbige dicke Kontur"
L["Monster Emote"] = "Monster-Emote"
--[[Translation missing --]]
L["Monster Party"] = "Monster Party"
L["Monster Say"] = "Monster Sagen"
L["Monster Whisper"] = "Monster Flüstern"
L["Monster Yell"] = "NPC-Schrei"
--[[Translation missing --]]
L["Moon"] = "Moon"
--[[Translation missing --]]
L["Most remaining time"] = "Most remaining time"
L["Mounted"] = "am Reiten"
L["Mouse Cursor"] = "Mauszeiger"
--[[Translation missing --]]
L["Movement Speed Rating"] = "Movement Speed Rating"
L["Multi-target"] = "Mehrfachziel"
--[[Translation missing --]]
L["Mythic Keystone"] = "Mythic Keystone"
--[[Translation missing --]]
L["Mythic+ Affix"] = "Mythic+ Affix"
L["Name"] = "Name"
--[[Translation missing --]]
L["Name Function"] = "Name Function"
--[[Translation missing --]]
L["Name Function (fallback state)"] = "Name Function (fallback state)"
--[[Translation missing --]]
L["Name of Caster's Target"] = "Name of Caster's Target"
--[[Translation missing --]]
L["Name of the (sub-)zone currently shown above the minimap."] = "Name of the (sub-)zone currently shown above the minimap."
--[[Translation missing --]]
L["Name(s)"] = "Name(s)"
--[[Translation missing --]]
L["Name/Realm of Caster's Target"] = "Name/Realm of Caster's Target"
--[[Translation missing --]]
L["Nameplate"] = "Nameplate"
--[[Translation missing --]]
L["Nameplates"] = "Nameplates"
--[[Translation missing --]]
L["Names of affected Players"] = "Names of affected Players"
--[[Translation missing --]]
L["Names of unaffected Players"] = "Names of unaffected Players"
L["Nature Resistance"] = "Naturwiderstand"
--[[Translation missing --]]
L["Naxxramas"] = "Naxxramas"
--[[Translation missing --]]
L["Nefarian"] = "Nefarian"
L["Neutral"] = "Neutral"
L["Never"] = "Nie"
L["Next Combat"] = "Nächster Kampf"
L["Next Encounter"] = "Nächstes Gefecht"
--[[Translation missing --]]
L[ [=[No active boss mod addon detected.

Note: This trigger will use BigWigs or DBM, in that order if both are installed.]=] ] = [=[No active boss mod addon detected.

Note: This trigger will use BigWigs or DBM, in that order if both are installed.]=]
--[[Translation missing --]]
L["No Extend"] = "No Extend"
L["No Instance"] = "Keine Instanz"
--[[Translation missing --]]
L["No Profiling information saved."] = "No Profiling information saved."
--[[Translation missing --]]
L["No Progress Information available."] = "No Progress Information available."
L["None"] = "Keine(r)"
L["Non-player Character"] = "Nicht-Spieler-Charakter (NPC)"
L["Normal"] = "Normal"
--[[Translation missing --]]
L["Normal Party"] = "Normal Party"
L["Not in Group"] = "In keiner Gruppe"
--[[Translation missing --]]
L["Not in Smart Group"] = "Not in Smart Group"
L["Not on Cooldown"] = "Nicht auf Abklingzeit"
L["Not On Threat Table"] = "Nicht bedroht"
--[[Translation missing --]]
L["Note: Due to how complicated the swing timer behavior is and the lack of APIs from Blizzard, results are inaccurate in edge cases."] = "Note: Due to how complicated the swing timer behavior is and the lack of APIs from Blizzard, results are inaccurate in edge cases."
--[[Translation missing --]]
L["Note: 'Hide Alone' is not available in the new aura tracking system. A load option can be used instead."] = "Note: 'Hide Alone' is not available in the new aura tracking system. A load option can be used instead."
--[[Translation missing --]]
L["Note: The available text replacements for multi triggers match the normal triggers now."] = "Note: The available text replacements for multi triggers match the normal triggers now."
--[[Translation missing --]]
L["Note: This trigger internally stores the shapeshift position, and thus is incompatible with learning stances on the fly, like e.g. the Gladiator Rune."] = "Note: This trigger internally stores the shapeshift position, and thus is incompatible with learning stances on the fly, like e.g. the Gladiator Rune."
--[[Translation missing --]]
L["Note: This trigger relies on the WoW API, which returns incorrect information in some cases."] = "Note: This trigger relies on the WoW API, which returns incorrect information in some cases."
L["Uses UnitIsVisible() to check if game client has loaded a object for this unit. This distance is around 100 yards. This is polled every second."] = "Uses UnitIsVisible() to check if game client has loaded a object for this unit. This distance is around 100 yards. This is polled every second."
--[[Translation missing --]]
L["Note: This trigger type estimates the range to the hitbox of a unit. The actual range of friendly players is usually 3 yards more than the estimate. Range checking capabilities depend on your current class and known abilities as well as the type of unit being checked. Some of the ranges may also not work with certain NPCs.|n|n|cFFAAFFAAFriendly Units:|r %s|n|cFFFFAAAAHarmful Units:|r %s|n|cFFAAAAFFMiscellanous Units:|r %s"] = "Note: This trigger type estimates the range to the hitbox of a unit. The actual range of friendly players is usually 3 yards more than the estimate. Range checking capabilities depend on your current class and known abilities as well as the type of unit being checked. Some of the ranges may also not work with certain NPCs.|n|n|cFFAAFFAAFriendly Units:|r %s|n|cFFFFAAAAHarmful Units:|r %s|n|cFFAAAAFFMiscellanous Units:|r %s"
--[[Translation missing --]]
L["Noth the Plaguebringer"] = "Noth the Plaguebringer"
L["NPC"] = "NSC"
L["Npc ID"] = "Nsc ID"
L["Number"] = "Nummer"
L["Number Affected"] = "Betroffene Anzahl"
L["Object"] = "Objekt"
--[[Translation missing --]]
L[ [=[Occurrence of the event
Can be a range of values
Can have multiple values separated by a comma or a space

Examples:
2nd 5th and 6th events: 2, 5, 6
2nd to 6th: 2-6
every 2 events: /2
every 3 events starting from 2nd: 2/3
every 3 events starting from 2nd and ending at 11th: 2-11/3

Works only if Boss Mod addon show counter]=] ] = [=[Occurrence of the event
Can be a range of values
Can have multiple values separated by a comma or a space

Examples:
2nd 5th and 6th events: 2, 5, 6
2nd to 6th: 2-6
every 2 events: /2
every 3 events starting from 2nd: 2/3
every 3 events starting from 2nd and ending at 11th: 2-11/3

Works only if Boss Mod addon show counter]=]
--[[Translation missing --]]
L[ [=[Occurrence of the event, reset when aura is unloaded
Can be a range of values
Can have multiple values separated by a comma or a space

Examples:
2nd 5th and 6th events: 2, 5, 6
2nd to 6th: 2-6
every 2 events: /2
every 3 events starting from 2nd: 2/3
every 3 events starting from 2nd and ending at 11th: 2-11/3

Only if BigWigs shows it on it's bar]=] ] = [=[Occurrence of the event, reset when aura is unloaded
Can be a range of values
Can have multiple values separated by a comma or a space

Examples:
2nd 5th and 6th events: 2, 5, 6
2nd to 6th: 2-6
every 2 events: /2
every 3 events starting from 2nd: 2/3
every 3 events starting from 2nd and ending at 11th: 2-11/3

Only if BigWigs shows it on it's bar]=]
--[[Translation missing --]]
L[ [=[Occurrence of the event, reset when aura is unloaded
Can be a range of values
Can have multiple values separated by a comma or a space

Examples:
2nd 5th and 6th events: 2, 5, 6
2nd to 6th: 2-6
every 2 events: /2
every 3 events starting from 2nd: 2/3
every 3 events starting from 2nd and ending at 11th: 2-11/3

Only if DBM shows it on it's bar]=] ] = [=[Occurrence of the event, reset when aura is unloaded
Can be a range of values
Can have multiple values separated by a comma or a space

Examples:
2nd 5th and 6th events: 2, 5, 6
2nd to 6th: 2-6
every 2 events: /2
every 3 events starting from 2nd: 2/3
every 3 events starting from 2nd and ending at 11th: 2-11/3

Only if DBM shows it on it's bar]=]
L["Officer"] = "Offizier"
--[[Translation missing --]]
L["Offset from progress"] = "Offset from progress"
--[[Translation missing --]]
L["Offset Timer"] = "Offset Timer"
--[[Translation missing --]]
L["Old Blizzard (2h | 3m | 10s | 2.4)"] = "Old Blizzard (2h | 3m | 10s | 2.4)"
L["On Cooldown"] = "Auf Abklingzeit"
--[[Translation missing --]]
L["On Taxi"] = "On Taxi"
--[[Translation missing --]]
L["Only if on a different realm"] = "Only if on a different realm"
L["Only if Primary"] = "Nur falls Primär"
L["Onyxia"] = "Onyxia"
L["Opaque"] = "Deckend"
--[[Translation missing --]]
L["Option Group"] = "Option Group"
--[[Translation missing --]]
L["Options could not be loaded, the addon is %s"] = "Options could not be loaded, the addon is %s"
--[[Translation missing --]]
L["Options will finish loading after combat ends."] = "Options will finish loading after combat ends."
--[[Translation missing --]]
L["Options will open after the login process has completed."] = "Options will open after the login process has completed."
--[[Translation missing --]]
L["Or Talent"] = "Or Talent"
L["Orbit"] = "Orbit"
L["Orientation"] = "Ausrichtung"
--[[Translation missing --]]
L["Ossirian the Unscarred"] = "Ossirian the Unscarred"
--[[Translation missing --]]
L["Other"] = "Other"
--[[Translation missing --]]
L["Other Addons"] = "Other Addons"
--[[Translation missing --]]
L["Other Events"] = "Other Events"
--[[Translation missing --]]
L["Ouro"] = "Ouro"
L["Outline"] = "Kontur"
--[[Translation missing --]]
L["Over Energize"] = "Over Energize"
L["Overhealing"] = "Überheilung"
L["Overkill"] = "Overkill"
--[[Translation missing --]]
L["Overlay %s"] = "Overlay %s"
--[[Translation missing --]]
L["Overlay Charged Combo Points"] = "Overlay Charged Combo Points"
--[[Translation missing --]]
L["Overlay Cost of Casts"] = "Overlay Cost of Casts"
--[[Translation missing --]]
L["Overlay Latency"] = "Overlay Latency"
--[[Translation missing --]]
L["Pad"] = "Pad"
--[[Translation missing --]]
L["Pad Mode"] = "Pad Mode"
--[[Translation missing --]]
L["Pad to"] = "Pad to"
--[[Translation missing --]]
--[[Translation missing --]]
--[[Translation missing --]]
L["Parent Frame"] = "Parent Frame"
--[[Translation missing --]]
L["Parent Zone"] = "Parent Zone"
L["Parry"] = "Parieren"
L["Parry (%)"] = "Parieren (%)"
L["Parry Rating"] = "Parierwertung"
L["Party"] = "Gruppe"
L["Party Kill"] = "Gruppen Tod (PARTY_KILL)"
--[[Translation missing --]]
L["Patchwerk"] = "Patchwerk"
--[[Translation missing --]]
L["Path of Ascension: Courage"] = "Path of Ascension: Courage"
--[[Translation missing --]]
L["Path of Ascension: Humility"] = "Path of Ascension: Humility"
--[[Translation missing --]]
L["Path of Ascension: Loyalty"] = "Path of Ascension: Loyalty"
--[[Translation missing --]]
L["Path of Ascension: Wisdom"] = "Path of Ascension: Wisdom"
L["Paused"] = "Pausiert"
L["Periodic Spell"] = "Periodischer Zauber (PERIODIC_SPELL)"
L["Personal Resource Display"] = "Persönliche Ressourcenanzeige"
L["Pet"] = "Begleiter"
L["Pet Behavior"] = "Begleiterverhalten"
--[[Translation missing --]]
L["Pet Specialization"] = "Pet Specialization"
L["Pet Spell"] = "Begleiterzauber"
--[[Translation missing --]]
L["Pets only"] = "Pets only"
L["Phase"] = "Phase"
--[[Translation missing --]]
L["Pixel Glow"] = "Pixel Glow"
--[[Translation missing --]]
L["Placement"] = "Placement"
--[[Translation missing --]]
L["Placement %i"] = "Placement %i"
--[[Translation missing --]]
L["Placement Mode"] = "Placement Mode"
L["Play"] = "Abspielen"
L["Player"] = "Spieler (Selbst)"
L["Player Character"] = "Spieler-Charakter (PC)"
L["Player Class"] = "Spielerklasse"
--[[Translation missing --]]
L["Player Effective Level"] = "Player Effective Level"
--[[Translation missing --]]
L["Player Experience"] = "Player Experience"
L["Player Faction"] = "Spielerfraktion"
L["Player Level"] = "Spielerstufe"
--[[Translation missing --]]
L["Player Location ID(s)"] = "Player Location ID(s)"
--[[Translation missing --]]
L["Player Money"] = "Player Money"
--[[Translation missing --]]
L["Player Name/Realm"] = "Player Name/Realm"
L["Player Race"] = "Spielervolk"
L["Player(s) Affected"] = "Betroffene Spieler"
L["Player(s) Not Affected"] = "Nicht betroffene Spieler"
--[[Translation missing --]]
L["Player/Unit Info"] = "Player/Unit Info"
--[[Translation missing --]]
L["Players and Pets"] = "Players and Pets"
L["Poison"] = "Gift"
L["Power"] = "Ressource"
L["Power (%)"] = "Ressource (%)"
--[[Translation missing --]]
L["Power Deficit"] = "Power Deficit"
L["Power Type"] = "Ressourcentyp"
--[[Translation missing --]]
L["Precision"] = "Precision"
L["Preset"] = "Standard"
--[[Translation missing --]]
L["Primary Stats"] = "Primary Stats"
--[[Translation missing --]]
L["Princess Huhuran"] = "Princess Huhuran"
--[[Translation missing --]]
L["Print Profiling Results"] = "Print Profiling Results"
--[[Translation missing --]]
L["Proc Glow"] = "Proc Glow"
--[[Translation missing --]]
L["Profiling already started."] = "Profiling already started."
--[[Translation missing --]]
L["Profiling automatically started."] = "Profiling automatically started."
--[[Translation missing --]]
L["Profiling not running."] = "Profiling not running."
--[[Translation missing --]]
L["Profiling started."] = "Profiling started."
--[[Translation missing --]]
L["Profiling started. It will end automatically in %d seconds"] = "Profiling started. It will end automatically in %d seconds"
--[[Translation missing --]]
L["Profiling still running, stop before trying to print."] = "Profiling still running, stop before trying to print."
--[[Translation missing --]]
L["Profiling stopped."] = "Profiling stopped."
--[[Translation missing --]]
L["Progress"] = "Progress"
--[[Translation missing --]]
L["Progress Source"] = "Progress Source"
L["Progress Total"] = "Totaler Fortschritt"
L["Progress Value"] = "Fortschrittswert"
--[[Translation missing --]]
L["Pull"] = "Pull"
L["Pulse"] = "Pulsieren"
L["PvP Flagged"] = "PvP aktiv"
--[[Translation missing --]]
L["PvP Mode Active"] = "PvP Mode Active"
L["PvP Talent selected"] = "Gewähltes PvP-Talent"
--[[Translation missing --]]
L["PvP Talent Selected"] = "PvP Talent Selected"
--[[Translation missing --]]
L["Quality Id"] = "Quality Id"
--[[Translation missing --]]
L["Quantity"] = "Quantity"
--[[Translation missing --]]
L["Quantity earned this week"] = "Quantity earned this week"
--[[Translation missing --]]
L["Quest Party"] = "Quest Party"
--[[Translation missing --]]
L["Queued Action"] = "Queued Action"
L["Radius"] = "Radius"
L["Ragnaros"] = "Ragnaros"
L["Raid"] = "Schlachtzug"
--[[Translation missing --]]
L["Raid (Heroic)"] = "Raid (Heroic)"
--[[Translation missing --]]
L["Raid (Mythic)"] = "Raid (Mythic)"
--[[Translation missing --]]
L["Raid (Normal)"] = "Raid (Normal)"
--[[Translation missing --]]
L["Raid (Timewalking)"] = "Raid (Timewalking)"
--[[Translation missing --]]
L["Raid Mark"] = "Raid Mark"
--[[Translation missing --]]
L["Raid Mark Icon"] = "Raid Mark Icon"
--[[Translation missing --]]
L["Raid Role"] = "Raid Role"
L["Raid Warning"] = "Schlachtzugswarnung"
L["Raids"] = "Schlachtzüge"
L["Range"] = "Reichweite"
L["Range Check"] = "Reichweitencheck"
--[[Translation missing --]]
L["Ranged"] = "Ranged"
--[[Translation missing --]]
L["Rank"] = "Rank"
--[[Translation missing --]]
L["Rare"] = "Rare"
--[[Translation missing --]]
L["Rare Elite"] = "Rare Elite"
--[[Translation missing --]]
L["Rated Arena"] = "Rated Arena"
--[[Translation missing --]]
L["Rated Battleground"] = "Rated Battleground"
--[[Translation missing --]]
L["Raw Threat Percent"] = "Raw Threat Percent"
--[[Translation missing --]]
L["Razorgore the Untamed"] = "Razorgore the Untamed"
L["Ready Check"] = "Bereitschaftscheck"
--[[Translation missing --]]
L["Reagent Quality"] = "Reagent Quality"
--[[Translation missing --]]
L["Reagent Quality Texture"] = "Reagent Quality Texture"
L["Realm"] = "Realm"
--[[Translation missing --]]
L["Realm Name"] = "Realm Name"
--[[Translation missing --]]
L["Realm of Caster's Target"] = "Realm of Caster's Target"
--[[Translation missing --]]
L["Reborn Council"] = "Reborn Council"
--[[Translation missing --]]
L["Receiving %s Bytes"] = "Receiving %s Bytes"
L["Receiving display information"] = "Erhalte Anzeigeinformationen von %s"
L["Reflect"] = "Reflektieren (REFLECT)"
L["Region type %s not supported"] = "Regiontyp %s wird nicht unterstützt"
L["Relative"] = "Relativ"
--[[Translation missing --]]
L["Relative X-Offset"] = "Relative X-Offset"
--[[Translation missing --]]
L["Relative Y-Offset"] = "Relative Y-Offset"
L["Remaining Duration"] = "Verbleibende Dauer"
L["Remaining Time"] = "Verbleibende Zeit"
--[[Translation missing --]]
L["Remove Obsolete Auras"] = "Remove Obsolete Auras"
--[[Translation missing --]]
L["Renown Level"] = "Renown Level"
--[[Translation missing --]]
L["Renown Max Level"] = "Renown Max Level"
--[[Translation missing --]]
L["Renown Reputation"] = "Renown Reputation"
L["Repair"] = "Reparieren"
L["Repeat"] = "Wiederhole"
--[[Translation missing --]]
L["Report Summary"] = "Report Summary"
--[[Translation missing --]]
L["Reputation"] = "Reputation"
--[[Translation missing --]]
L["Reputation (%)"] = "Reputation (%)"
L["Requested display does not exist"] = "Angeforderte Anzeige existiert nicht"
L["Requested display not authorized"] = "Angeforderte Anzeige ist nicht autorisiert"
--[[Translation missing --]]
L["Requesting display information from %s ..."] = "Requesting display information from %s ..."
L["Require Valid Target"] = "Erfordert gültiges Ziel"
--[[Translation missing --]]
L["Requires syncing the specialization via LibSpecialization."] = "Requires syncing the specialization via LibSpecialization."
--[[Translation missing --]]
L["Resilience (%)"] = "Resilience (%)"
--[[Translation missing --]]
L["Resilience Rating"] = "Resilience Rating"
L["Resist"] = "Widerstehen"
--[[Translation missing --]]
L["Resistances"] = "Resistances"
L["Resisted"] = "Widerstanden (RESISTED)"
--[[Translation missing --]]
L["Rested"] = "Rested"
--[[Translation missing --]]
L["Rested Experience"] = "Rested Experience"
--[[Translation missing --]]
L["Rested Experience (%)"] = "Rested Experience (%)"
L["Resting"] = "am Erholen"
L["Resurrect"] = "Wiederbeleben"
--[[Translation missing --]]
L["Resurrect Pending"] = "Resurrect Pending"
L["Right"] = "Rechts"
L["Right to Left"] = "Rechts -> Links"
--[[Translation missing --]]
L["Right, then Centered Vertical"] = "Right, then Centered Vertical"
L["Right, then Down"] = "Rechts, dann runter"
L["Right, then Up"] = "Rechts, dann hoch"
L["Role"] = "Rolle"
--[[Translation missing --]]
L["Rollback snapshot is complete. Thank you for your patience!"] = "Rollback snapshot is complete. Thank you for your patience!"
--[[Translation missing --]]
L["Rotate Animation"] = "Rotate Animation"
L["Rotate Left"] = "Nach links rotieren"
L["Rotate Right"] = "Nach rechts rotieren"
--[[Translation missing --]]
L["Rotation"] = "Rotation"
--[[Translation missing --]]
L["Round"] = "Round"
--[[Translation missing --]]
L["Round Mode"] = "Round Mode"
L["Ruins of Ahn'Qiraj"] = "Ruinen von Ahn'Qiraj"
L["Run Custom Code"] = "Code ausführen"
--[[Translation missing --]]
L["Run Speed (%)"] = "Run Speed (%)"
L["Rune"] = "Rune"
L["Rune #1"] = "Rune #1"
L["Rune #2"] = "Rune #2"
L["Rune #3"] = "Rune #3"
L["Rune #4"] = "Rune #4"
L["Rune #5"] = "Rune #5"
L["Rune #6"] = "Rune #6"
--[[Translation missing --]]
L["Rune Count"] = "Rune Count"
--[[Translation missing --]]
L["Rune Count - Blood"] = "Rune Count - Blood"
--[[Translation missing --]]
L["Rune Count - Frost"] = "Rune Count - Frost"
--[[Translation missing --]]
L["Rune Count - Unholy"] = "Rune Count - Unholy"
--[[Translation missing --]]
L["Sapphiron"] = "Sapphiron"
L["Say"] = "Sagen"
--[[Translation missing --]]
L["Scale"] = "Scale"
--[[Translation missing --]]
L["Scarlet Enclave"] = "Scarlet Enclave"
L["Scenario"] = "Szenario"
--[[Translation missing --]]
L["Scenario (Heroic)"] = "Scenario (Heroic)"
--[[Translation missing --]]
L["Scenario (Normal)"] = "Scenario (Normal)"
--[[Translation missing --]]
L["Screen"] = "Screen"
L["Screen/Parent Group"] = "Bildschirm/Elterngruppe"
--[[Translation missing --]]
L["Season of Discovery"] = "Season of Discovery"
--[[Translation missing --]]
L["Second"] = "Second"
--[[Translation missing --]]
L["Second Value of Tooltip Text"] = "Second Value of Tooltip Text"
--[[Translation missing --]]
L["Secondary Stats"] = "Secondary Stats"
L["Seconds"] = "Sekunden"
--[[Translation missing --]]
L[ [=[Secure frame detected. Find more information:
https://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames]=] ] = [=[Secure frame detected. Find more information:
https://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames]=]
L["Select Frame"] = "Frame auswählen"
--[[Translation missing --]]
L["Select the type of timer to filter"] = "Select the type of timer to filter"
--[[Translation missing --]]
L["Selection Mode"] = "Selection Mode"
--[[Translation missing --]]
L["Separator"] = "Separator"
--[[Translation missing --]]
L["Set IDs can be found on websites such as wowhead.com/cata/item-sets"] = "Set IDs can be found on websites such as wowhead.com/cata/item-sets"
--[[Translation missing --]]
L["Set IDs can be found on websites such as wowhead.com/classic/item-sets"] = "Set IDs can be found on websites such as wowhead.com/classic/item-sets"
--[[Translation missing --]]
L["Set IDs can be found on websites such as wowhead.com/item-sets"] = "Set IDs can be found on websites such as wowhead.com/item-sets"
--[[Translation missing --]]
L["Set IDs can be found on websites such as wowhead.com/mop-classic/item-sets"] = "Set IDs can be found on websites such as wowhead.com/mop-classic/item-sets"
L["Shadow Resistance"] = "Schattenwiderstand"
--[[Translation missing --]]
L["Shadowlands"] = "Shadowlands"
L["Shake"] = "Beben"
--[[Translation missing --]]
L["Shazzrah"] = "Shazzrah"
--[[Translation missing --]]
L["Shift-Click to resume addon execution."] = "Shift-Click to resume addon execution."
L["Show"] = "Zeigen"
--[[Translation missing --]]
L["Show CD of Charge"] = "Show CD of Charge"
--[[Translation missing --]]
L["Show charged duration for empowered casts"] = "Show charged duration for empowered casts"
L["Show GCD"] = "GCD anzeigen"
L["Show Global Cooldown"] = "Globale Abklingzeit anzeigen"
L["Show Incoming Heal"] = "Eingehende Heilung zeigen"
--[[Translation missing --]]
L["Show Loss of Control"] = "Show Loss of Control"
--[[Translation missing --]]
L["Show On"] = "Show On"
--[[Translation missing --]]
L["Show Rested Overlay"] = "Show Rested Overlay"
L["Shrink"] = "Schrumpfen"
--[[Translation missing --]]
L["Silithid Royalty"] = "Silithid Royalty"
--[[Translation missing --]]
L["Silver"] = "Silver"
L["Simple"] = "Einfach"
--[[Translation missing --]]
L["Since Active"] = "Since Active"
--[[Translation missing --]]
L["Since Apply"] = "Since Apply"
--[[Translation missing --]]
L["Since Apply/Refresh"] = "Since Apply/Refresh"
--[[Translation missing --]]
L["Since Charge Gain"] = "Since Charge Gain"
--[[Translation missing --]]
L["Since Charge Lost"] = "Since Charge Lost"
--[[Translation missing --]]
L["Since Ready"] = "Since Ready"
--[[Translation missing --]]
L["Since Stack Gain"] = "Since Stack Gain"
--[[Translation missing --]]
L["Since Stack Lost"] = "Since Stack Lost"
L["Size & Position"] = "Größe & Position"
--[[Translation missing --]]
L["Skyriding"] = "Skyriding"
--[[Translation missing --]]
L["Slide Animation"] = "Slide Animation"
L["Slide from Bottom"] = "Von unten eingleiten"
L["Slide from Left"] = "Von links eingleiten"
L["Slide from Right"] = "Von rechts eingleiten"
L["Slide from Top"] = "Von oben eingleiten"
L["Slide to Bottom"] = "Nach unten entgleiten"
L["Slide to Left"] = "Nach links entgleiten"
L["Slide to Right"] = "Nach rechts entgleiten"
L["Slide to Top"] = "Nach oben entgleiten"
--[[Translation missing --]]
L["Slider"] = "Slider"
L["Small"] = "Klein"
--[[Translation missing --]]
L["Smart Group"] = "Smart Group"
--[[Translation missing --]]
L["Soft Enemy"] = "Soft Enemy"
--[[Translation missing --]]
L["Soft Friend"] = "Soft Friend"
--[[Translation missing --]]
L["Solistrasza"] = "Solistrasza"
L["Sound"] = "Ton"
--[[Translation missing --]]
L["Sound by Kit ID"] = "Sound by Kit ID"
--[[Translation missing --]]
L["Source"] = "Source"
--[[Translation missing --]]
L["Source Affiliation"] = "Source Affiliation"
--[[Translation missing --]]
L["Source GUID"] = "Source GUID"
--[[Translation missing --]]
L["Source Info"] = "Source Info"
L["Source Name"] = "Quellname"
--[[Translation missing --]]
L["Source NPC Id"] = "Source NPC Id"
--[[Translation missing --]]
L["Source Object Type"] = "Source Object Type"
L["Source Raid Mark"] = "Quellmarkierung"
--[[Translation missing --]]
L["Source Reaction"] = "Source Reaction"
L["Source Unit"] = "Quelleinheit"
--[[Translation missing --]]
L["Source Unit Name/Realm"] = "Source Unit Name/Realm"
--[[Translation missing --]]
L["Source unit's raid mark index"] = "Source unit's raid mark index"
--[[Translation missing --]]
L["Source unit's raid mark texture"] = "Source unit's raid mark texture"
--[[Translation missing --]]
L["Space"] = "Space"
L["Spacing"] = "Abstand"
--[[Translation missing --]]
L["Spark"] = "Spark"
--[[Translation missing --]]
L["Spec Position"] = "Spec Position"
--[[Translation missing --]]
L["Spec Role"] = "Spec Role"
--[[Translation missing --]]
L["Specialization"] = "Specialization"
--[[Translation missing --]]
L["Specific Currency"] = "Specific Currency"
--[[Translation missing --]]
L["Specific Type"] = "Specific Type"
L["Specific Unit"] = "Konkrete Einheit"
L["Spell"] = "Zauber"
L["Spell (Building)"] = "Zauber, Gebäude (SPELL_BUILDING)"
--[[Translation missing --]]
L["Spell Activation Overlay Glow"] = "Spell Activation Overlay Glow"
--[[Translation missing --]]
L["Spell Cast Succeeded"] = "Spell Cast Succeeded"
L["Spell Cost"] = "Zauberkosten"
--[[Translation missing --]]
L["Spell Count"] = "Spell Count"
L["Spell ID"] = "Zauber-ID"
L["Spell Id"] = "Zauber-ID"
L["Spell ID:"] = "Zauber ID:"
L["Spell IDs:"] = "Zauber IDs:"
--[[Translation missing --]]
L["Spell in Range"] = "Spell in Range"
L["Spell Known"] = "Zauber erlernt"
L["Spell Name"] = "Zaubername"
--[[Translation missing --]]
L["Spell Peneration Percent"] = "Spell Peneration Percent"
--[[Translation missing --]]
L["Spell Power"] = "Spell Power"
--[[Translation missing --]]
L["Spell School"] = "Spell School"
L["Spell Usable"] = "Zauber benutzbar"
--[[Translation missing --]]
L["Spellname"] = "Spellname"
--[[Translation missing --]]
L["Spike"] = "Spike"
L["Spin"] = "Drehen"
L["Spiral"] = "Winden"
L["Spiral In And Out"] = "Ein- und Auswinden"
--[[Translation missing --]]
L["Spirit"] = "Spirit"
--[[Translation missing --]]
L["Stack Count"] = "Stack Count"
--[[Translation missing --]]
L["Stack trace:"] = "Stack trace:"
L["Stacks"] = "Stapel"
--[[Translation missing --]]
L["Stacks Function"] = "Stacks Function"
--[[Translation missing --]]
L["Stacks Function (fallback state)"] = "Stacks Function (fallback state)"
--[[Translation missing --]]
L["Stage"] = "Stage"
--[[Translation missing --]]
L["Stage Counter"] = "Stage Counter"
--[[Translation missing --]]
L["Stagger"] = "Stagger"
--[[Translation missing --]]
L["Stagger (%)"] = "Stagger (%)"
--[[Translation missing --]]
L["Stagger against Target (%)"] = "Stagger against Target (%)"
--[[Translation missing --]]
L["Stagger Scale"] = "Stagger Scale"
L["Stamina"] = "Ausdauer"
L["Stance/Form/Aura"] = "Haltung/Form/Aura"
--[[Translation missing --]]
L["Standing"] = "Standing"
--[[Translation missing --]]
L["Star Shake"] = "Star Shake"
--[[Translation missing --]]
L["Start Animation"] = "Start Animation"
--[[Translation missing --]]
L["Start Now"] = "Start Now"
--[[Translation missing --]]
L["Start Profiling"] = "Start Profiling"
L["Status"] = "Status"
--[[Translation missing --]]
L["Status Bar"] = "Status Bar"
L["Stolen"] = "Gestohlen (STOLEN)"
L["Stop"] = "Stopp"
--[[Translation missing --]]
L["Stop Motion"] = "Stop Motion"
--[[Translation missing --]]
L["Story Raid"] = "Story Raid"
L["Strength"] = "Stärke"
--[[Translation missing --]]
L["String"] = "String"
--[[Translation missing --]]
L["Subevent Info"] = "Subevent Info"
--[[Translation missing --]]
L["Subtract Cast"] = "Subtract Cast"
--[[Translation missing --]]
L["Subtract Channel"] = "Subtract Channel"
--[[Translation missing --]]
L["Subtract GCD"] = "Subtract GCD"
--[[Translation missing --]]
L["Subzone Name"] = "Subzone Name"
--[[Translation missing --]]
L["Success"] = "Success"
--[[Translation missing --]]
L["Sulfuron Harbinger"] = "Sulfuron Harbinger"
L["Summon"] = "Herbeirufen (SUMMON)"
--[[Translation missing --]]
L["Summon Pending"] = "Summon Pending"
--[[Translation missing --]]
L["Sun"] = "Sun"
--[[Translation missing --]]
L["Supports multiple entries, separated by commas"] = "Supports multiple entries, separated by commas"
--[[Translation missing --]]
L[ [=[Supports multiple entries, separated by commas
]=] ] = [=[Supports multiple entries, separated by commas
]=]
--[[Translation missing --]]
L["Supports multiple entries, separated by commas. Escape ',' with \\. Prefix with '-' for negation."] = "Supports multiple entries, separated by commas. Escape ',' with \\. Prefix with '-' for negation."
--[[Translation missing --]]
L["Supports multiple entries, separated by commas. Escape with \\. Prefix with '-' for negation."] = "Supports multiple entries, separated by commas. Escape with \\. Prefix with '-' for negation."
--[[Translation missing --]]
L["Supports multiple entries, separated by commas. Prefix with '-' for negation."] = "Supports multiple entries, separated by commas. Prefix with '-' for negation."
--[[Translation missing --]]
L[ [=[Supports multiple entries, separated by commas. To include child zone ids, prefix with 'c', e.g. 'c2022'.
Group Zone IDs must be prefixed with 'g', e.g. 'g277'.
Supports Area IDs from https://wago.tools/db2/AreaTable prefixed with 'a'.
Supports Instance IDs prefixed with 'i'.
Entries can be prefixed with '-' to negate.]=] ] = [=[Supports multiple entries, separated by commas. To include child zone ids, prefix with 'c', e.g. 'c2022'.
Group Zone IDs must be prefixed with 'g', e.g. 'g277'.
Supports Area IDs from https://wago.tools/db2/AreaTable prefixed with 'a'.
Supports Instance IDs prefixed with 'i'.
Entries can be prefixed with '-' to negate.]=]
L["Swing"] = "Schwingen (SWING)"
L["Swing Timer"] = "Schlagtimer"
--[[Translation missing --]]
L["Swipe"] = "Swipe"
--[[Translation missing --]]
L["Syntax /wa feature <toggle|on|enable|disable|off> <feature>"] = "Syntax /wa feature <toggle|on|enable|disable|off> <feature>"
L["System"] = "System"
--[[Translation missing --]]
L["Systems"] = "Systems"
--[[Translation missing --]]
L["Tab "] = "Tab "
--[[Translation missing --]]
L["Talent"] = "Talent"
--[[Translation missing --]]
L["Talent |cFFFF0000Not|r Known"] = "Talent |cFFFF0000Not|r Known"
--[[Translation missing --]]
L["Talent |cFFFF0000Not|r Selected"] = "Talent |cFFFF0000Not|r Selected"
--[[Translation missing --]]
L["Talent Known"] = "Talent Known"
L["Talent Selected"] = "Talent gewählt"
L["Talent selected"] = "Gewähltes Talent"
L["Talent Specialization"] = "Talentspezialisierung"
L["Tanking And Highest"] = "Höchster und Aggro"
L["Tanking But Not Highest"] = "Aggro aber nicht höchste"
L["Target"] = "Ziel"
L["Targeted"] = "Anvisiert"
--[[Translation missing --]]
L["Tertiary Stats"] = "Tertiary Stats"
--[[Translation missing --]]
L["Test if bar is enabled in BigWigs settings"] = "Test if bar is enabled in BigWigs settings"
--[[Translation missing --]]
L["Test if bar is enabled in Boss Mod addon settings"] = "Test if bar is enabled in Boss Mod addon settings"
--[[Translation missing --]]
L["Test if bar is enabled in DBM settings"] = "Test if bar is enabled in DBM settings"
L["Text"] = "Text"
--[[Translation missing --]]
L["Text To Speech"] = "Text To Speech"
--[[Translation missing --]]
L["Text-to-speech"] = "Text-to-speech"
--[[Translation missing --]]
L["Texture"] = "Texture"
--[[Translation missing --]]
L["Texture Function"] = "Texture Function"
--[[Translation missing --]]
L["Texture Function (fallback state)"] = "Texture Function (fallback state)"
--[[Translation missing --]]
L["Texture Picker"] = "Texture Picker"
--[[Translation missing --]]
L["Texture Rotation"] = "Texture Rotation"
--[[Translation missing --]]
L["Thaddius"] = "Thaddius"
--[[Translation missing --]]
L["The aura has overwritten the global '%s', this might affect other auras."] = "The aura has overwritten the global '%s', this might affect other auras."
--[[Translation missing --]]
L["The aura tried to overwrite the aura_env global, which is not allowed."] = "The aura tried to overwrite the aura_env global, which is not allowed."
--[[Translation missing --]]
L["The effective level differs from the level in e.g. Time Walking dungeons."] = "The effective level differs from the level in e.g. Time Walking dungeons."
--[[Translation missing --]]
L["The Four Horsemen"] = "The Four Horsemen"
--[[Translation missing --]]
L["The 'ID' value can be found in the BigWigs options of a specific spell"] = "The 'ID' value can be found in the BigWigs options of a specific spell"
--[[Translation missing --]]
L["The Prophet Skeram"] = "The Prophet Skeram"
--[[Translation missing --]]
L["The total quantity a warband character can transfer after paying the transfer cost"] = "The total quantity a warband character can transfer after paying the transfer cost"
--[[Translation missing --]]
L["The total quantity after transferring everything to your current character and paying the transfer cost"] = "The total quantity after transferring everything to your current character and paying the transfer cost"
--[[Translation missing --]]
L["The War Within"] = "The War Within"
--[[Translation missing --]]
L["There are %i updates to your auras ready to be installed!"] = "There are %i updates to your auras ready to be installed!"
L["Thick Outline"] = "Dicke Kontur"
--[[Translation missing --]]
L["Thickness"] = "Thickness"
--[[Translation missing --]]
L["Third"] = "Third"
--[[Translation missing --]]
L["Third Value of Tooltip Text"] = "Third Value of Tooltip Text"
--[[Translation missing --]]
L["This aura calls GetData a lot, which is a slow function."] = "This aura calls GetData a lot, which is a slow function."
--[[Translation missing --]]
L["This aura has caused a Lua error."] = "This aura has caused a Lua error."
--[[Translation missing --]]
L["This aura is saving %s KB of data"] = "This aura is saving %s KB of data"
--[[Translation missing --]]
L["This aura plays a sound via a condition."] = "This aura plays a sound via a condition."
--[[Translation missing --]]
L["This aura plays a sound via an action."] = "This aura plays a sound via an action."
--[[Translation missing --]]
L["This aura plays a Text To Speech via a condition."] = "This aura plays a Text To Speech via a condition."
--[[Translation missing --]]
L["This aura plays a Text To Speech via an action."] = "This aura plays a Text To Speech via an action."
--[[Translation missing --]]
L["This filter has been moved to the Location trigger. Change your aura to use the new Location trigger or join the KUIAR_Engine Discord server for help."] = "This filter has been moved to the Location trigger. Change your aura to use the new Location trigger or join the KUIAR_Engine Discord server for help."
--[[Translation missing --]]
L["Threat Percent"] = "Threat Percent"
L["Threat Situation"] = "Bedrohungssituation"
--[[Translation missing --]]
L["Threat Value"] = "Threat Value"
--[[Translation missing --]]
L["Tick"] = "Tick"
--[[Translation missing --]]
L["Time"] = "Time"
--[[Translation missing --]]
L["Time Format"] = "Time Format"
--[[Translation missing --]]
L["Time in GCDs"] = "Time in GCDs"
--[[Translation missing --]]
L["Time since initial application"] = "Time since initial application"
--[[Translation missing --]]
L["Time since last refresh"] = "Time since last refresh"
--[[Translation missing --]]
L["Time since stack gain"] = "Time since stack gain"
--[[Translation missing --]]
L["Time since stack lost"] = "Time since stack lost"
L["Timed"] = "Zeitgesteuert"
--[[Translation missing --]]
L["Timed Progress"] = "Timed Progress"
--[[Translation missing --]]
L["Timer"] = "Timer"
--[[Translation missing --]]
L["Timer Id"] = "Timer Id"
L["Toggle"] = "Umschalten"
--[[Translation missing --]]
L["Toggle List"] = "Toggle List"
--[[Translation missing --]]
L["Toggle Options Window"] = "Toggle Options Window"
--[[Translation missing --]]
L["Toggle Performance Profiling Window"] = "Toggle Performance Profiling Window"
L["Tooltip"] = "Tooltip"
--[[Translation missing --]]
L["Tooltip 1"] = "Tooltip 1"
--[[Translation missing --]]
L["Tooltip 2"] = "Tooltip 2"
--[[Translation missing --]]
L["Tooltip 3"] = "Tooltip 3"
L["Tooltip Value 1"] = "Tooltip Wert 1"
L["Tooltip Value 2"] = "Tooltip Wert 2"
L["Tooltip Value 3"] = "Tooltip Wert 3"
--[[Translation missing --]]
L["Tooltip Value 4"] = "Tooltip Value 4"
L["Top"] = "Oben"
L["Top Left"] = "Oben Links"
L["Top Right"] = "Oben Rechts"
L["Top to Bottom"] = "Oben -> Unten"
--[[Translation missing --]]
L["Torghast"] = "Torghast"
L["Total Duration"] = "Gesamtdauer"
--[[Translation missing --]]
L["Total Earned in this Season"] = "Total Earned in this Season"
--[[Translation missing --]]
L["Total Essence"] = "Total Essence"
--[[Translation missing --]]
L["Total Experience"] = "Total Experience"
--[[Translation missing --]]
L["Total Match Count"] = "Total Match Count"
--[[Translation missing --]]
L["Total Reputation"] = "Total Reputation"
--[[Translation missing --]]
L["Total Stacks"] = "Total Stacks"
--[[Translation missing --]]
L["Total stacks over all matches"] = "Total stacks over all matches"
--[[Translation missing --]]
L["Total Stages"] = "Total Stages"
--[[Translation missing --]]
L["Total Unit Count"] = "Total Unit Count"
--[[Translation missing --]]
L["Total Units"] = "Total Units"
L["Totem"] = "Totem"
L["Totem #%i"] = "Totem #%i"
--[[Translation missing --]]
L["Totem Icon"] = "Totem Icon"
L["Totem Name"] = "Totemname"
--[[Translation missing --]]
L["Totem Name Pattern Match"] = "Totem Name Pattern Match"
L["Totem Number"] = "Totemnummer"
--[[Translation missing --]]
L["Track Cooldowns"] = "Track Cooldowns"
--[[Translation missing --]]
L["Tracking Charge %i"] = "Tracking Charge %i"
--[[Translation missing --]]
L["Tracking Charge CDs"] = "Tracking Charge CDs"
--[[Translation missing --]]
L["Tracking Only Cooldown"] = "Tracking Only Cooldown"
L["Transmission error"] = "Übertragungsfehler"
L["Trigger"] = "Auslöser"
--[[Translation missing --]]
L["Trigger %i"] = "Trigger %i"
--[[Translation missing --]]
L["Trigger %s"] = "Trigger %s"
L["Trigger 1"] = "Auslöser 1"
--[[Translation missing --]]
L["Trigger State Updater (Advanced)"] = "Trigger State Updater (Advanced)"
L["Trigger Update"] = "Auslöseraktualisierung"
L["Trigger:"] = "Auslöser:"
--[[Translation missing --]]
L["Trivial (Low Level)"] = "Trivial (Low Level)"
L["True"] = "Zutrifft"
--[[Translation missing --]]
L["Trying to repair broken conditions in %s likely caused by a KUIAR_Engine bug."] = "Trying to repair broken conditions in %s likely caused by a KUIAR_Engine bug."
L["Twin Emperors"] = "Zwillingsimperatoren"
L["Type"] = "Typ"
--[[Translation missing --]]
L["Unable to modernize aura '%s'. This is probably due to corrupt data or a bad migration."] = "Unable to modernize aura '%s'. This is probably due to corrupt data or a bad migration."
--[[Translation missing --]]
L["Unaffected"] = "Unaffected"
L["Undefined"] = "Undefiniert"
--[[Translation missing --]]
L["Unholy"] = "Unholy"
--[[Translation missing --]]
L["Unholy Rune #1"] = "Unholy Rune #1"
--[[Translation missing --]]
L["Unholy Rune #2"] = "Unholy Rune #2"
L["Unit"] = "Einheit"
L["Unit Characteristics"] = "Einheitencharakterisierung"
L["Unit Destroyed"] = "Einheit zerstört"
L["Unit Died"] = "Einheit gestorben"
--[[Translation missing --]]
L["Unit Dissipates"] = "Unit Dissipates"
--[[Translation missing --]]
L["Unit Frame"] = "Unit Frame"
--[[Translation missing --]]
L["Unit Frames"] = "Unit Frames"
L["Unit is Unit"] = "Vergleicht Einheit mit"
--[[Translation missing --]]
L["Unit Name"] = "Unit Name"
--[[Translation missing --]]
L["Unit Name/Realm"] = "Unit Name/Realm"
--[[Translation missing --]]
L["Units Affected"] = "Units Affected"
--[[Translation missing --]]
L["Units of affected Players in a table format"] = "Units of affected Players in a table format"
--[[Translation missing --]]
L["Units of unaffected Players in a table format"] = "Units of unaffected Players in a table format"
--[[Translation missing --]]
L["Unknown action %q"] = "Unknown action %q"
--[[Translation missing --]]
L["Unknown feature %q"] = "Unknown feature %q"
--[[Translation missing --]]
L["unknown location"] = "unknown location"
L["Unlimited"] = "Unbegrenzt"
--[[Translation missing --]]
L["Untrigger %s"] = "Untrigger %s"
L["Up"] = "Hoch"
--[[Translation missing --]]
L["Up, then Centered Horizontal"] = "Up, then Centered Horizontal"
L["Up, then Left"] = "Hoch, dann links"
L["Up, then Right"] = "Hoch, dann rechts"
--[[Translation missing --]]
L["Update Position"] = "Update Position"
L["Usage:"] = "Benutzung:"
--[[Translation missing --]]
L["Use /wa minimap to show the minimap icon again."] = "Use /wa minimap to show the minimap icon again."
L["Use Custom Color"] = "Benutzerdefinierte Farbe benutzen"
--[[Translation missing --]]
L["Use Legacy floor rounding"] = "Use Legacy floor rounding"
--[[Translation missing --]]
L["Use Texture"] = "Use Texture"
--[[Translation missing --]]
L["Use Watched Faction"] = "Use Watched Faction"
--[[Translation missing --]]
L["Uses UnitInRange() to check if in range. Matches default raid frames out of range behavior, which is between 25 to 40 yards depending on your class and spec."] = "Uses UnitInRange() to check if in range. Matches default raid frames out of range behavior, which is between 25 to 40 yards depending on your class and spec."
--[[Translation missing --]]
L["Using KUIAR_Runtime.clones is deprecated. Use KUIAR_Runtime.GetRegion(id, cloneId) instead."] = "Using KUIAR_Runtime.clones is deprecated. Use KUIAR_Runtime.GetRegion(id, cloneId) instead."
--[[Translation missing --]]
L["Using KUIAR_Runtime.regions is deprecated. Use KUIAR_Runtime.GetRegion(id) instead."] = "Using KUIAR_Runtime.regions is deprecated. Use KUIAR_Runtime.GetRegion(id) instead."
--[[Translation missing --]]
L["Vaelastrasz the Corrupt"] = "Vaelastrasz the Corrupt"
L["Versatility (%)"] = "Vielseitigkeit (%)"
L["Versatility Rating"] = "Vielseitigkeitswertung"
--[[Translation missing --]]
L["Vertical"] = "Vertical"
--[[Translation missing --]]
L["Viscidus"] = "Viscidus"
L["Visibility"] = "Sichtbarkeit"
--[[Translation missing --]]
L["Visions of N'Zoth"] = "Visions of N'Zoth"
--[[Translation missing --]]
L["Warband Quantity Total"] = "Warband Quantity Total"
--[[Translation missing --]]
L["Warband Transfer Percentage"] = "Warband Transfer Percentage"
--[[Translation missing --]]
L["Warband Transferred Quantity"] = "Warband Transferred Quantity"
--[[Translation missing --]]
L["Warfront (Heroic)"] = "Warfront (Heroic)"
--[[Translation missing --]]
L["Warfront (Normal)"] = "Warfront (Normal)"
--[[Translation missing --]]
L["Warlords of Draenor"] = "Warlords of Draenor"
--[[Translation missing --]]
L["Warning"] = "Warning"
--[[Translation missing --]]
L["Warning for unknown aura:"] = "Warning for unknown aura:"
--[[Translation missing --]]
L["Warning: Anchoring in aura '%s' is imposssible, due to an anchoring cycle"] = "Warning: Anchoring in aura '%s' is imposssible, due to an anchoring cycle"
--[[Translation missing --]]
L["Warning: Full Scan auras checking for both name and spell id can't be converted."] = "Warning: Full Scan auras checking for both name and spell id can't be converted."
--[[Translation missing --]]
L["Warning: Name info is now available via %affected, %unaffected. Number of affected group members via %unitCount. Some options behave differently now. This is not automatically adjusted."] = "Warning: Name info is now available via %affected, %unaffected. Number of affected group members via %unitCount. Some options behave differently now. This is not automatically adjusted."
--[[Translation missing --]]
L["Warning: Tooltip values are now available via %tooltip1, %tooltip2, %tooltip3 instead of %s. This is not automatically adjusted."] = "Warning: Tooltip values are now available via %tooltip1, %tooltip2, %tooltip3 instead of %s. This is not automatically adjusted."
--[[Translation missing --]]
L["KUIAR_Engine Built-In (63:42 | 3:07 | 10 | 2.4)"] = "KUIAR_Engine Built-In (63:42 | 3:07 | 10 | 2.4)"
--[[Translation missing --]]
--[[Translation missing --]]
L[ [=[KUIAR_Runtime has detected that it has been downgraded.
Your saved auras may no longer work properly.
Would you like to run the |cffff0000EXPERIMENTAL|r repair tool? This will overwrite any changes you have made since the last database upgrade.
Last upgrade: %s

|cffff0000You should BACKUP your WTF folder BEFORE pressing this button.|r]=] ] = [=[KUIAR_Runtime has detected that it has been downgraded.
Your saved auras may no longer work properly.
Would you like to run the |cffff0000EXPERIMENTAL|r repair tool? This will overwrite any changes you have made since the last database upgrade.
Last upgrade: %s

|cffff0000You should BACKUP your WTF folder BEFORE pressing this button.|r]=]
--[[Translation missing --]]
L["KUIAR_Engine is creating a rollback snapshot of your auras. This snapshot will allow you to revert to the current state of your auras if something goes wrong. This process may cause your framerate to drop until it is complete."] = "KUIAR_Engine is creating a rollback snapshot of your auras. This snapshot will allow you to revert to the current state of your auras if something goes wrong. This process may cause your framerate to drop until it is complete."
--[[Translation missing --]]
L["KUIAR_Engine Profiling"] = "KUIAR_Engine Profiling"
--[[Translation missing --]]
L["KUIAR_Engine Profiling Report"] = "KUIAR_Engine Profiling Report"
--[[Translation missing --]]
L["KUIAR_Engine Version: %s"] = "KUIAR_Engine Version: %s"
L["Weapon"] = "Waffen"
L["Weapon Enchant"] = "Waffenverzauberung"
L["Weapon Enchant / Fishing Lure"] = "Waffenverzauberung / Angelrute"
L["Whisper"] = "Flüstern"
L["Width"] = "Breite"
L["Wobble"] = "Wackeln"
L["World Boss"] = "Weltboss"
--[[Translation missing --]]
L["World Bosses"] = "World Bosses"
--[[Translation missing --]]
L["Wrap"] = "Wrap"
--[[Translation missing --]]
L["Wrath of the Lich King"] = "Wrath of the Lich King"
--[[Translation missing --]]
L["Writing to the KUIAR_Engine table is not allowed."] = "Writing to the KUIAR_Engine table is not allowed."
L["X-Offset"] = "X-Versatz"
L["Yell"] = "Schreien"
L["Y-Offset"] = "Y-Versatz"
--[[Translation missing --]]
L["You have new auras ready to be installed!"] = "You have new auras ready to be installed!"
--[[Translation missing --]]
L["Your next encounter will automatically be profiled."] = "Your next encounter will automatically be profiled."
--[[Translation missing --]]
L["Your next instance of combat will automatically be profiled."] = "Your next instance of combat will automatically be profiled."
--[[Translation missing --]]
L["Your scheduled automatic profile has been cancelled."] = "Your scheduled automatic profile has been cancelled."
--[[Translation missing --]]
L["Your threat as a percentage of the tank's current threat."] = "Your threat as a percentage of the tank's current threat."
L["Your threat on the mob as a percentage of the amount required to pull aggro. Will pull aggro at 100."] = "Ihre Bedrohung für den Mob als Prozentsatz der Menge, der zum Ziehen von Aggro erforderlich ist. Wird bei 100 Aggro ziehen."
L["Your total threat on the mob."] = "Ihre gesamte Bedrohung für den Mob."
--[[Translation missing --]]
L["Zone Group ID"] = "Zone Group ID"
--[[Translation missing --]]
L["Zone ID"] = "Zone ID"
L["Zone Name"] = "Gebietsname"
L["Zoom"] = "Zoom"
--[[Translation missing --]]
L["Zoom Animation"] = "Zoom Animation"
L["Zul'Gurub"] = "Zul'Gurub"

-- KUI: translations added for strings upstream leaves in English (2026-11-12).
L["|cffeda55fRight-Click|r to toggle performance profiling window."] = "|cffeda55fRechtsklick|r, um das Profiling-Fenster für die Leistung umzuschalten."
L["|cffeda55fShift-Click|r to pause addon execution."] = "|cffeda55fUmschalt+Klick|r, um die Ausführung des Addons zu pausieren."
L["|cffff0000deprecated|r"] = "|cffff0000veraltet|r"
L["|cFFFF0000Not|r Item Bonus Id Equipped"] = "Gegenstandsbonus-ID |cFFFF0000nicht|r angelegt"
L["|cFFFF0000Not|r Item Equipped"] = "Gegenstand |cFFFF0000nicht|r angelegt"
L["|cFFFF0000Not|r Player Name/Realm"] = "Spielername/Realm |cFFFF0000nicht|r"
L["|cFFFF0000Not|r Spell Known"] = "Zauber |cFFFF0000nicht|r bekannt"
L["|cFFFF0000Support for unfiltered COMBAT_LOG_EVENT_UNFILTERED is deprecated|r\nCOMBAT_LOG_EVENT_UNFILTERED without a filter are disabled as it’s very performance costly.\nFind more information:\nhttps://github.com/WeakAuras/WeakAuras2/wiki/Custom-Triggers#events"] = "|cFFFF0000Die Unterstützung für ungefiltertes COMBAT_LOG_EVENT_UNFILTERED ist veraltet|r\nCOMBAT_LOG_EVENT_UNFILTERED ohne Filter ist deaktiviert, da es sehr leistungsintensiv ist.\nWeitere Informationen:\nhttps://github.com/WeakAuras/WeakAuras2/wiki/Custom-Triggers#events"
L["|cFFffcc00Extra Options:|r %s"] = "|cFFffcc00Zusatzoptionen:|r %s"
L["|cFFffcc00Extra Options:|r None"] = "|cFFffcc00Zusatzoptionen:|r Keine"
L["• |cff00ff00Player|r, |cff00ff00Target|r, |cff00ff00Focus|r, and |cff00ff00Pet|r correspond directly to those individual unitIDs.\n• |cff00ff00Specific Unit|r lets you provide a specific valid unitID to watch.\n|cffff0000Note|r: The game will not fire events for all valid unitIDs, making some untrackable by this trigger.\n• |cffffff00Party|r, |cffffff00Raid|r, |cffffff00Boss|r, |cffffff00Arena|r, and |cffffff00Nameplate|r can match multiple corresponding unitIDs.\n• |cffffff00Smart Group|r adjusts to your current group type, matching just the \"player\" when solo, \"party\" units (including \"player\") in a party or \"raid\" units in a raid.\n\n|cffffff00*|r Yellow Unit settings will create clones for each matching unit while this trigger is providing Dynamic Info to the Aura."] = "• |cff00ff00Spieler|r, |cff00ff00Ziel|r, |cff00ff00Fokus|r und |cff00ff00Begleiter|r entsprechen direkt diesen einzelnen Einheiten-IDs.\n• |cff00ff00Bestimmte Einheit|r lässt dich eine bestimmte gültige Einheiten-ID zur Beobachtung angeben.\n|cffff0000Hinweis|r: Das Spiel löst nicht für alle gültigen Einheiten-IDs Ereignisse aus, sodass manche von diesem Auslöser nicht verfolgt werden können.\n• |cffffff00Gruppe|r, |cffffff00Schlachtzug|r, |cffffff00Boss|r, |cffffff00Arena|r und |cffffff00Namensplakette|r können mehrere entsprechende Einheiten-IDs treffen.\n• |cffffff00Intelligente Gruppe|r passt sich deinem aktuellen Gruppentyp an: allein nur \"player\", in einer Gruppe die \"party\"-Einheiten (inklusive \"player\"), in einem Schlachtzug die \"raid\"-Einheiten.\n\n|cffffff00*|r Gelbe Einheiteneinstellungen erzeugen Klone für jede passende Einheit, solange dieser Auslöser dynamische Informationen an die Aura liefert."
L["1. Profession 1. Accessory"] = "1. Beruf 1. Zubehör"
L["1. Profession 2. Accessory"] = "1. Beruf 2. Zubehör"
L["1. Professsion Tool"] = "1. Berufswerkzeug"
L["10 Player Raid"] = "10-Spieler-Schlachtzug"
L["2. Profession 1. Accessory"] = "2. Beruf 1. Zubehör"
L["2. Profession 2. Accessory"] = "2. Beruf 2. Zubehör"
L["2. Professsion Tool"] = "2. Berufswerkzeug"
L["20 Player Raid"] = "20-Spieler-Schlachtzug"
L["A detailed overview of your auras and KUIAR_Runtime systems\nCopy the whole text to Weakaura's Discord if you need assistance."] = "Eine detaillierte Übersicht deiner Auren und KUIAR_Runtime-Systeme\nKopiere den gesamten Text in den Discord von WeakAuras, wenn du Hilfe brauchst."
L["A trigger in this aura is set up to track a soft target unit, but you don't have the CVars set up for this to work correctly. Consider either changing the unit tracked, or configuring the Soft Target CVars."] = "Ein Auslöser in dieser Aura verfolgt eine Einheit mit weichem Ziel, aber die CVars dafür sind nicht richtig eingerichtet. Ändere entweder die verfolgte Einheit oder konfiguriere die CVars für weiche Ziele."
L["Abbreviate"] = "Abkürzen"
L["Absorb and Healing"] = "Absorption und Heilung"
L["Absorb Heal Overlay"] = "Absorptions-Heilungs-Überlagerung"
L["Absorb Overlay"] = "Absorptions-Überlagerung"
L["Action Button Glow"] = "Aktionstasten-Leuchten"
L["Active boss mod addon: |cFFffcc00BigWigs|r\n\nNote: This trigger will use BigWigs or DBM, in that order if both are installed."] = "Aktives Boss-Mod-Addon: |cFFffcc00BigWigs|r\n\nHinweis: Dieser Auslöser verwendet BigWigs oder DBM, in dieser Reihenfolge, wenn beide installiert sind."
L["Active boss mod addon: |cFFffcc00DBM|r\n\nNote: This trigger will use BigWigs or DBM, in that order if both are installed."] = "Aktives Boss-Mod-Addon: |cFFffcc00DBM|r\n\nHinweis: Dieser Auslöser verwendet BigWigs oder DBM, in dieser Reihenfolge, wenn beide installiert sind."
L["Advanced Caster's Target Check"] = "Erweiterte Zielprüfung des Zaubernden"
L["Afk"] = "AFK"
L["All children of this aura will also not be loaded, to minimize the chance of further corruption."] = "Alle Kinder dieser Aura werden ebenfalls nicht geladen, um die Gefahr weiterer Beschädigungen zu verringern."
L["All States table contains a non table at key: '%s'."] = "Die Tabelle All States enthält unter dem Schlüssel '%s' einen Nicht-Tabellenwert."
L["Anchoring"] = "Verankerung"
L["Angle and Radius"] = "Winkel und Radius"
L["Any"] = "Beliebig"
L["AOE"] = "Flächenschaden"
L["Arcane Resistance"] = "Arkanwiderstand"
L["Are you sure you want to run the |cffff0000EXPERIMENTAL|r repair tool?\nThis will overwrite any changes you have made since the last database upgrade.\nLast upgrade: %s"] = "Bist du sicher, dass du das |cffff0000EXPERIMENTELLE|r Reparaturwerkzeug ausführen möchtest?\nDadurch werden alle Änderungen überschrieben, die du seit dem letzten Datenbank-Upgrade vorgenommen hast.\nLetztes Upgrade: %s"
L["Armor against Target (%)"] = "Rüstung gegen Ziel (%)"
L["Armor Peneration Percent"] = "Rüstungsdurchschlag in Prozent"
L["Armor Peneration Rating"] = "Rüstungsdurchschlagswertung"
L["Armor Rating"] = "Rüstungswertung"
L["Assigned Role Icon"] = "Symbol der zugewiesenen Rolle"
L["Assist"] = "Unterstützen"
L["Assisted Combat Next Cast"] = "Nächster Zauber der Kampfassistenz"
L["At War"] = "Im Krieg"
L["Attach to End, backwards"] = "Am Ende anheften, rückwärts"
L["Attach to Point"] = "An Punkt anheften"
L["Aura is using deprecated SetDurationInfo"] = "Aura verwendet das veraltete SetDurationInfo"
L["Aura loaded"] = "Aura geladen"
L["Aura Version: %s"] = "Aura-Version: %s"
L["Auras"] = "Auren"
L["Author Options"] = "Autor-Optionen"
L["Auto"] = "Automatisch"
L["Autocast Shine"] = "Autocast-Schimmern"
L["Automatic Length"] = "Automatische Länge"
L["Available features: %s"] = "Verfügbare Funktionen: %s"
L["Avoidance Rating"] = "Ausweichwertung"
L["Ayamiss the Hunter"] = "Ayamiss der Jäger"
L["Bar Color/Gradient Start"] = "Leistenfarbe/Farbverlauf-Start"
L["Bar enabled in BigWigs settings"] = "Leiste in den BigWigs-Einstellungen aktiviert"
L["Bar enabled in Boss Mod addon settings"] = "Leiste in den Boss-Mod-Addon-Einstellungen aktiviert"
L["Bar enabled in DBM settings"] = "Leiste in den DBM-Einstellungen aktiviert"
L["Bar Texture"] = "Leistentextur"
L["Bar Type"] = "Leistentyp"
L["Battleguard Sartura"] = "Schlachtwächter Sartura"
L["Beastmaster"] = "Tierherrschaft"
L["BG>Raid>Party>Say"] = "SF>Schlachtzug>Gruppe>Sagen"
L["BG-System Horde"] = "Schlachtfeld-System Horde"
L["BG-System Neutral"] = "Schlachtfeld-System Neutral"
L["Big Number"] = "Große Zahl"
L["BigWigs Stage"] = "BigWigs-Phase"
L["Bleed"] = "Blutung"
L["Blizzard Cooldown Reduction"] = "Blizzard-Abklingzeitverringerung"
L["Block (%)"] = "Blocken (%)"
L["Block against Target (%)"] = "Blocken gegen Ziel (%)"
L["Block Value"] = "Blockwert"
L["Blood"] = "Blut"
L["Blood Rune #1"] = "Blutrune Nr. 1"
L["Blood Rune #2"] = "Blutrune Nr. 2"
L["Bloodlord Mandokir"] = "Blutfürst Mandokir"
L["Boss Mod Announce"] = "Boss-Mod-Ankündigung"
L["Boss Mod Stage"] = "Boss-Mod-Phase"
L["Boss Mod Stage (Event)"] = "Boss-Mod-Phase (Ereignis)"
L["Boss Mod Timer"] = "Boss-Mod-Timer"
L["Break"] = "Pause"
L["Broodlord Lashlayer"] = "Brutlord Lashlayer"
L["Buff"] = "Stärkungszauber"
L["Buffed/Debuffed"] = "Mit Stärkungs-/Schwächungszauber"
L["Buru the Gorger"] = "Buru der Verschlinger"
L["Callback function"] = "Callback-Funktion"
L["Cannot change secure frame in combat lockdown. Find more information:\nhttps://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames"] = "Gesicherter Rahmen kann im Kampf nicht geändert werden. Weitere Informationen:\nhttps://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames"
L["Can't schedule timer with %i, due to a World of Warcraft bug with high computer uptime. (Uptime: %i). Please restart your computer."] = "Timer mit %i kann nicht geplant werden, aufgrund eines World-of-Warcraft-Fehlers bei langer Rechnerlaufzeit. (Laufzeit: %i). Bitte starte deinen Computer neu."
L["Capped"] = "Begrenzt"
L["Capped at Season Max"] = "Auf Saisonmaximum begrenzt"
L["Capped at Weekly Max"] = "Auf Wochenmaximum begrenzt"
L["Caster Name"] = "Name des Zaubernden"
L["Caster Realm"] = "Realm des Zaubernden"
L["Caster Unit"] = "Zaubernde Einheit"
L["Casters Name/Realm"] = "Name/Realm des Zaubernden"
L["Caster's Target"] = "Ziel des Zaubernden"
L["Ceil"] = "Aufrunden"
L["Center, then alternating bottom and top"] = "Mitte, dann abwechselnd unten und oben"
L["Center, then alternating left and right"] = "Mitte, dann abwechselnd links und rechts"
L["Center, then alternating right and left"] = "Mitte, dann abwechselnd rechts und links"
L["Center, then alternating top and bottom"] = "Mitte, dann abwechselnd oben und unten"
L["Centered Horizontal, then Centered Vertical"] = "Horizontal zentriert, dann vertikal zentriert"
L["Centered Horizontal, then Down"] = "Horizontal zentriert, dann nach unten"
L["Centered Horizontal, then Up"] = "Horizontal zentriert, dann nach oben"
L["Centered Vertical, then Centered Horizontal"] = "Vertikal zentriert, dann horizontal zentriert"
L["Centered Vertical, then Left"] = "Vertikal zentriert, dann links"
L["Centered Vertical, then Right"] = "Vertikal zentriert, dann rechts"
L["Character GUID"] = "Charakter-GUID"
L["Character Name"] = "Charaktername"
L["Character Transferred Quantity"] = "Vom Charakter übertragene Menge"
L["Charged Combo Points"] = "Aufgeladene Combopunkte"
L["Charges Changed Event"] = "Ereignis Aufladungen geändert"
L["Charging"] = "Wird aufgeladen"
L["Check if a single talent match a Rank"] = "Prüft, ob ein einzelnes Talent einem Rang entspricht"
L["Check nameplate's target every 0.2s"] = "Ziel der Namensplakette alle 0,2 s prüfen"
L["Circular Texture"] = "Kreisförmige Textur"
L["Clamp"] = "Begrenzen"
L["Classic"] = "Klassisch"
L["Clone per Character"] = "Pro Charakter klonen"
L["Coin Precision"] = "Münzgenauigkeit"
L["Color Animation"] = "Farbanimation"
L["Communities"] = "Gemeinschaften"
L["Condition Custom Test"] = "Benutzerdefinierter Test der Bedingung"
L["Continuously update Movement Speed"] = "Bewegungsgeschwindigkeit laufend aktualisieren"
L["Cooldown bars show time before an ability is ready to be use, BigWigs prefix them with '~'"] = "Abklingzeitleisten zeigen die Zeit, bis eine Fähigkeit bereit ist; BigWigs stellt ihnen '~' voran"
L["Cooldown Progress (Slot)"] = "Abklingzeitfortschritt (Slot)"
L["Cooldown Ready Event"] = "Ereignis Abklingzeit bereit"
L["Cooldown Ready Event (Item)"] = "Ereignis Abklingzeit bereit (Gegenstand)"
L["Cooldown Ready Event (Slot)"] = "Ereignis Abklingzeit bereit (Slot)"
L["Cooldown Reduction changes the duration of seconds instead of showing the real time seconds."] = "Abklingzeitverringerung ändert die Dauer in Sekunden, anstatt die echten Sekunden anzuzeigen."
L["Cooldown/Charges/Count"] = "Abklingzeit/Aufladungen/Anzahl"
L["Copper"] = "Kupfer"
L["Could not load KUIAR_Engine Archive, the addon is %s"] = "KUIAR_Engine-Archiv konnte nicht geladen werden, das Addon ist %s"
L["Creature Family"] = "Kreaturenfamilie"
L["Creature Family Name"] = "Name der Kreaturenfamilie"
L["Creature Type"] = "Kreaturentyp"
L["Creature Type Name"] = "Name des Kreaturentyps"
L["Critical (%)"] = "Kritisch (%)"
L["Critical Rating"] = "Kritische Trefferwertung"
L["Crop X"] = "Zuschneiden X"
L["Crop Y"] = "Zuschneiden Y"
L["C'thun"] = "C'Thun"
L["Cumulated time used during profiling"] = "Während der Profilerstellung angesammelte Zeit"
L["Currency"] = "Währung"
L["Current Essence"] = "Aktuelle Essenz"
L["Current Experience"] = "Aktuelle Erfahrung"
L["Current Instance"] = "Aktuelle Instanz"
L["Current Movement Speed (%)"] = "Aktuelle Bewegungsgeschwindigkeit (%)"
L["Current Stage"] = "Aktuelle Phase"
L["Current Zone"] = "Aktuelles Gebiet"
L["Current Zone Group"] = "Aktuelle Gebietsgruppe"
L["Custom Action"] = "Benutzerdefinierte Aktion"
L["Custom Anchor"] = "Benutzerdefinierter Anker"
L["Custom Check"] = "Benutzerdefinierte Prüfung"
L["Custom Color"] = "Benutzerdefinierte Farbe"
L["Custom Condition Code"] = "Code der benutzerdefinierten Bedingung"
L["Custom Configuration"] = "Benutzerdefinierte Konfiguration"
L["Custom Fade Animation"] = "Benutzerdefinierte Ausblendanimation"
L["Custom Grow"] = "Benutzerdefiniertes Wachstum"
L["Custom Sort"] = "Benutzerdefinierte Sortierung"
L["Custom Text Function"] = "Benutzerdefinierte Textfunktion"
L["Custom Trigger Combination"] = "Benutzerdefinierte Auslöser-Kombination"
L["Custom Variables"] = "Benutzerdefinierte Variablen"
L["DBM Stage"] = "DBM-Phase"
L["Dead"] = "Tot"
L["Death"] = "Tod"
L["Debuff"] = "Schwächungszauber"
L["Debug Log contains more than 1000 entries"] = "Das Debug-Protokoll enthält mehr als 1000 Einträge"
L["Debug Logging enabled"] = "Debug-Protokollierung aktiviert"
L["Debug Logging enabled for '%s'"] = "Debug-Protokollierung für '%s' aktiviert"
L["Defense"] = "Verteidigung"
L["Defensive Stats"] = "Defensivwerte"
L["Delve"] = "Tiefen"
L["Destination Affiliation"] = "Zielzugehörigkeit"
L["Destination GUID"] = "Ziel-GUID"
L["Destination Info"] = "Zielinfo"
L["Destination NPC Id"] = "Ziel-NPC-ID"
L["Destination Object Type"] = "Zielobjekttyp"
L["Destination Reaction"] = "Zielreaktion"
L["Destination unit's raid mark index"] = "Schlachtzugsmarkierungsindex der Zieleinheit"
L["Destination unit's raid mark texture"] = "Schlachtzugsmarkierungstextur der Zieleinheit"
L["Disable Spell Known Check"] = "Prüfung auf bekannten Zauber deaktivieren"
L["Disabled"] = "Deaktiviert"
L["Disabled feature %q"] = "Funktion %q deaktiviert"
L["Disabled Spell Known Check"] = "Prüfung auf bekannten Zauber deaktiviert"
L["Discovered"] = "Entdeckt"
L["Dodge Rating"] = "Ausweichwertung"
L["Down, then Centered Horizontal"] = "Nach unten, dann horizontal zentriert"
L["Dumping table"] = "Tabelle wird ausgegeben"
L["Dungeon (Celestial)"] = "Dungeon (Himmlisch)"
L["Dungeon (Mythic)"] = "Dungeon (Mythisch)"
L["Dungeon (Mythic+)"] = "Dungeon (Mythisch+)"
L["Duration"] = "Dauer"
L["Duration Function"] = "Dauerfunktion"
L["Duration Function (fallback state)"] = "Dauerfunktion (Ersatzzustand)"
L["Ease In"] = "Sanft einblenden"
L["Ease In and Out"] = "Sanft ein- und ausblenden"
L["Ease Out"] = "Sanft ausblenden"
L["Eclipse Direction"] = "Eklipse-Richtung"
L["Edge of Madness"] = "Rand des Wahnsinns"
L["Effective Spell Id"] = "Tatsächliche Zauber-ID"
L["Elide"] = "Auslassen"
L["Empower Cast End"] = "Ende des Machtzaubers"
L["Empower Cast Interrupt"] = "Unterbrechung des Machtzaubers"
L["Empower Cast Start"] = "Beginn des Machtzaubers"
L["Empowered"] = "Machtzauber"
L["Empowered 1"] = "Macht 1"
L["Empowered 2"] = "Macht 2"
L["Empowered 3"] = "Macht 3"
L["Empowered 4"] = "Macht 4"
L["Empowered 5"] = "Macht 5"
L["Empowered Cast"] = "Machtzauber"
L["Empowered Cast Fully Charged"] = "Machtzauber voll aufgeladen"
L["Empowered Fully Charged"] = "Machtzauber voll aufgeladen"
L["Enabled feature %q"] = "Funktion %q aktiviert"
L["Enables (incorrect) round down of seconds, which was the previous default behavior."] = "Aktiviert das (fehlerhafte) Abrunden von Sekunden, das früher das Standardverhalten war."
L["Enchant Applied"] = "Verzauberung angewendet"
L["Enchant Found"] = "Verzauberung gefunden"
L["Enchant ID"] = "Verzauberungs-ID"
L["Enchant Missing"] = "Verzauberung fehlt"
L["Enchant Name or ID"] = "Verzauberungsname oder -ID"
L["Enchant Removed"] = "Verzauberung entfernt"
L["Enchanted"] = "Verzaubert"
L["Encounter ID(s)"] = "Begegnungs-ID(s)"
L["Enter a name or a spellId"] = "Gib einen Namen oder eine Zauber-ID ein"
L["Entering/Leaving Encounter"] = "Begegnung betreten/verlassen"
L["Equipment"] = "Ausrüstung"
L["Error '%s' created a secure clone. We advise deleting the aura. For more information:\nhttps://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames"] = "Fehler '%s' hat einen gesicherten Klon erstellt. Wir empfehlen, die Aura zu löschen. Weitere Informationen:\nhttps://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames"
L["Error decoding."] = "Fehler beim Dekodieren."
L["Error decompressing"] = "Fehler beim Dekomprimieren"
L["Error decompressing. This doesn't look like a KUIAR_Engine import."] = "Fehler beim Dekomprimieren. Das sieht nicht nach einem KUIAR_Engine-Import aus."
L["Error deserializing"] = "Fehler beim Deserialisieren"
L["ERROR in '%s' unknown or incompatible sub element type '%s'"] = "FEHLER in '%s': unbekannter oder inkompatibler Unterelementtyp '%s'"
L["Error in Aura '%s'"] = "Fehler in Aura '%s'"
L["Error not receiving display information from %s"] = "Fehler: Keine Anzeigeinformationen von %s erhalten"
L["Essence"] = "Essenz"
L["Essence #1"] = "Essenz Nr. 1"
L["Essence #2"] = "Essenz Nr. 2"
L["Essence #3"] = "Essenz Nr. 3"
L["Essence #4"] = "Essenz Nr. 4"
L["Essence #5"] = "Essenz Nr. 5"
L["Essence #6"] = "Essenz Nr. 6"
L["Every Frame (High CPU usage)"] = "Jeden Frame (hohe CPU-Last)"
L["Evoker Essence"] = "Essenz des Rufers"
L["Exact Spell ID(s)"] = "Exakte Zauber-ID(s)"
L["Spell ID(s)"] = "Zauber-ID(s)"
L["Execute Conditions"] = "Bedingungen ausführen"
L["Experience (%)"] = "Erfahrung (%)"
L["Expertise Bonus"] = "Waffenkundebonus"
L["Expertise Rating"] = "Waffenkundewertung"
L["Extend Outside"] = "Nach außen erweitern"
L["Extra Spell Id"] = "Zusätzliche Zauber-ID"
L["Fade Animation"] = "Ausblendanimation"
L["Fankriss the Unyielding"] = "Fankriss der Unnachgiebige"
L["Feature %q is already disabled"] = "Funktion %q ist bereits deaktiviert"
L["Feature %q is already enabled"] = "Funktion %q ist bereits aktiviert"
L["Fetch Absorb"] = "Absorption abrufen"
L["Fetch Heal Absorb"] = "Heilungsabsorption abrufen"
L["Fill Area"] = "Fläche füllen"
L["Filter messages with format <message>"] = "Nachrichten mit dem Format <message> filtern"
L["Firemaw"] = "Feuerschwinge"
L["First"] = "Erste"
L["First Value of Tooltip Text"] = "Erster Wert des Tooltip-Textes"
L["Fixed Names"] = "Feste Namen"
L["Flamegor"] = "Flammenmaul"
L["Follower Dungeon"] = "Gefolgsdungeon"
L["Font"] = "Schriftart"
L["Forbidden function or table: %s"] = "Verbotene Funktion oder Tabelle: %s"
L["Form"] = "Gestalt"
L["Format Gold"] = "Gold formatieren"
L["Formats |cFFFFCC00%unit|r"] = "Formatiert |cFFFFCC00%unit|r"
L["Formats Player's |cFFFFCC00%guid|r"] = "Formatiert die |cFFFFCC00%guid|r des Spielers"
L["Forward, Reverse Loop"] = "Vorwärts, rückwärts in Schleife"
L["Fourth Value of Tooltip Text"] = "Vierter Wert des Tooltip-Textes"
L["Frame Selector"] = "Frame-Auswahl"
L["Friendship Max Rank"] = "Maximaler Freundschaftsrang"
L["Friendship Rank"] = "Freundschaftsrang"
L["Friendship Reputation"] = "Freundschaftsruf"
L["Frost Rune #1"] = "Frostrune Nr. 1"
L["Frost Rune #2"] = "Frostrune Nr. 2"
L["Full Region"] = "Volle Region"
L["General"] = "Allgemein"
L["GetNameAndIcon Function (fallback state)"] = "GetNameAndIcon-Funktion (Ersatzzustand)"
L["Glow External Element"] = "Externes Leuchten-Element"
L["Glyph"] = "Glyphe"
L["Golemagg the Incinerator"] = "Golemagg der Verbrenner"
L["Gothik the Harvester"] = "Gothik der Ernter"
L["Gradient"] = "Farbverlauf"
L["Gradient Enabled"] = "Farbverlauf aktiviert"
L["Gradient End"] = "Farbverlauf-Ende"
L["Gradient Orientation"] = "Farbverlauf-Ausrichtung"
L["Gradient Pulse"] = "Farbverlauf-Pulsieren"
L["Grand Widow Faerlina"] = "Großwitwe Faerlina"
L["Grid"] = "Raster"
L["Group Leader/Assist"] = "Gruppenleiter/Assistent"
L["Group Size"] = "Gruppengröße"
L["Group Type"] = "Gruppentyp"
L["Heal Absorb"] = "Heilungsabsorption"
L["Heal Absorbed"] = "Heilung absorbiert"
L["Health Deficit"] = "Gesundheitsdefizit"
L["Heigan the Unclean"] = "Heigan der Unreine"
L["Hero Talent"] = "Heldentalent"
L["Heroic Party"] = "Heroische Gruppe"
L["Hide 0 cooldowns"] = "Abklingzeiten von 0 ausblenden"
L["Hide Timer Text"] = "Timer-Text ausblenden"
L["High Priest Thekal"] = "Hohepriester Thekal"
L["High Priest Venoxis"] = "Hohepriester Venoxis"
L["High Priestess Arlokk"] = "Hohepriesterin Arlokk"
L["High Priestess Jeklik"] = "Hohepriesterin Jeklik"
L["High Priestess Mar'li"] = "Hohepriesterin Mar'li"
L["Highest Spell Id"] = "Höchste Zauber-ID"
L["Hit (%)"] = "Trefferchance (%)"
L["Hit Rating"] = "Trefferwertung"
L["Icon Function"] = "Symbolfunktion"
L["Icon Function (fallback state)"] = "Symbolfunktion (Ersatzzustand)"
L["Id"] = "ID"
L["Ignore Dead"] = "Tote ignorieren"
L["Ignore Disconnected"] = "Getrennte ignorieren"
L["Ignore out of checking range"] = "Außerhalb der Prüfreichweite ignorieren"
L["Ignore Rune CDs"] = "Runen-Abklingzeiten ignorieren"
L["Ignore Self"] = "Selbst ignorieren"
L["Ignore Spell Cooldown/Charges"] = "Zauber-Abklingzeit/Aufladungen ignorieren"
L["Ignore Spell Override"] = "Zauberersetzung ignorieren"
L["Importing will start after combat ends."] = "Der Import beginnt, sobald der Kampf endet."
L["In Party"] = "In der Gruppe"
L["In Range"] = "In Reichweite"
L["In War Mode"] = "Im Kriegsmodus"
L["Include Death Runes"] = "Todesrunen einbeziehen"
L["Include Pets"] = "Begleiter einbeziehen"
L["Include War Band Bank"] = "Kriegsmeute-Bank einbeziehen"
L["Increase Precision Below"] = "Genauigkeit erhöhen unter"
L["Increases by one per stage or intermission."] = "Steigt pro Phase oder Zwischenphase um eins."
L["Install the addons BugSack and BugGrabber for detailed error logs."] = "Installiere die Addons BugSack und BugGrabber für detaillierte Fehlerprotokolle."
L["Instance Id"] = "Instanz-ID"
L["Instance ID"] = "Instanz-ID"
L["Instance Info"] = "Instanzinfo"
L["Instance Name"] = "Instanzname"
L["Instance Size Type"] = "Instanzgrößentyp"
L["Instructor Razuvious"] = "Ausbilder Razuvious"
L["Insufficient Resources"] = "Unzureichende Ressourcen"
L["Interrupt School"] = "Unterbrechungsschule"
L["Interrupted School Text"] = "Text der unterbrochenen Schule"
L["Inverse Pet Behavior"] = "Begleiterverhalten umkehren"
L["Is Away from Keyboard"] = "Ist abwesend (AFK)"
L["Is Death Rune"] = "Ist Todesrune"
L["Is Paused"] = "Ist pausiert"
L["Is Weekly Renown Capped"] = "Wöchentliches Ruhmlimit erreicht"
L["Island Expedition (Heroic)"] = "Inselexpedition (Heroisch)"
L["Island Expedition (Mythic)"] = "Inselexpedition (Mythisch)"
L["Island Expedition (Normal)"] = "Inselexpedition (Normal)"
L["Island Expeditions (PvP)"] = "Inselexpeditionen (PvP)"
L["Item Bonus Id"] = "Gegenstandsbonus-ID"
L["Item Bonus Id Equipped"] = "Gegenstandsbonus-ID angelegt"
L["Item Id"] = "Gegenstands-ID"
L["Item in Range"] = "Gegenstand in Reichweite"
L["Item Name"] = "Gegenstandsname"
L["Item Set Id"] = "Gegenstandssatz-ID"
L["Item Slot"] = "Gegenstandsplatz"
L["Item Slot String"] = "Gegenstandsplatz-Zeichenfolge"
L["Item Type"] = "Gegenstandstyp"
L["Item Type Equipped"] = "Gegenstandstyp angelegt"
L["Jin'do the Hexxer"] = "Jin'do der Verhexer"
L["Journal Stage"] = "Journal-Phase"
L["Keep Inside"] = "Innen halten"
L["Large"] = "Groß"
L["Latency"] = "Latenz"
L["Leader"] = "Anführer"
L["Least remaining time"] = "Geringste Restzeit"
L["Left, then Centered Vertical"] = "Links, dann vertikal zentriert"
L["Legacy Looking for Raid"] = "Altes Schlachtzugsportal"
L["Legacy RGB Gradient"] = "Alter RGB-Farbverlauf"
L["Legacy RGB Gradient Pulse"] = "Alter RGB-Farbverlauf-Puls"
L["Limited"] = "Begrenzt"
L["Linear Texture"] = "Lineare Textur"
L["Lines & Particles"] = "Linien & Partikel"
L["Load Flag"] = "Ladeflag"
L["Loads while an aura has set this flag with KUIAR_Engine.SetLoadFlag(name, true), for example a group's backend choosing which children to load from its custom options."] = "Wird geladen, solange eine Aura dieses Flag mit KUIAR_Engine.SetLoadFlag(name, true) gesetzt hat, zum Beispiel wenn das Backend einer Gruppe anhand ihrer benutzerdefinierten Optionen wählt, welche Kinder geladen werden."
L["Location"] = "Standort"
L["Looking for Raid"] = "Schlachtzugsportal"
L["Loot"] = "Beute"
L["Lowest Spell Id"] = "Niedrigste Zauber-ID"
L["Lua error"] = "Lua-Fehler"
L["Lua error in Aura '%s': %s"] = "Lua-Fehler in Aura '%s': %s"
L["Main Character"] = "Hauptcharakter"
L["Main Stat"] = "Hauptwert"
L["Majordomo Executus"] = "Majordomus Exekutus"
L["Malformed KUIAR_Engine link"] = "Fehlerhafter KUIAR_Engine-Link"
L["Manual"] = "Manuell"
L["Manual Icon"] = "Manuelles Symbol"
L["Master"] = "Gesamt"
L["Match Count"] = "Trefferanzahl"
L["Match Count per Unit"] = "Trefferanzahl pro Einheit"
L["Matches stage number of encounter journal.\nIntermissions are .5\nE.g. 1;2;1;2;2.5;3"] = "Entspricht der Phasennummer des Dungeonjournals.\nZwischenphasen sind .5\nz. B. 1;2;1;2;2.5;3"
L["Max Char "] = "Max. Zeichen"
L["Max Char"] = "Max. Zeichen"
L["Max Charges"] = "Max. Aufladungen"
L["Max Health"] = "Maximale Gesundheit"
L["Max Power"] = "Maximale Energie"
L["Max Quantity"] = "Maximale Menge"
L["Maximum Estimate"] = "Maximale Schätzung"
L["Maximum Progress"] = "Maximaler Fortschritt"
L["Maximum time used on a single frame"] = "Maximal auf einem einzelnen Frame verbrauchte Zeit"
L["Media"] = "Medien"
L["Medium"] = "Mittel"
L["Melee"] = "Nahkampf"
L["Melee Haste (%)"] = "Nahkampftempo (%)"
L["Meta Data"] = "Metadaten"
L["Mine"] = "Meine"
L["Minimum Estimate"] = "Minimale Schätzung"
L["Minimum Progress"] = "Minimaler Fortschritt"
L["Minus (Small Nameplate)"] = "Minus (kleine Namensplakette)"
L["Miscellaneous"] = "Verschiedenes"
L["Model"] = "Modell"
L["Modern Blizzard (1h 3m | 3m 7s | 10s | 2.4)"] = "Modernes Blizzard (1h 3m | 3m 7s | 10s | 2.4)"
L["Modernize"] = "Modernisieren"
L["Money"] = "Geld"
L["Monster Party"] = "Monstergruppe"
L["Moon"] = "Mond"
L["Most remaining time"] = "Höchste Restzeit"
L["Movement Speed Rating"] = "Bewegungsgeschwindigkeitswertung"
L["Mythic Keystone"] = "Mythischer Schlüsselstein"
L["Mythic+ Affix"] = "Mythisch+-Affix"
L["Name Function"] = "Namensfunktion"
L["Name Function (fallback state)"] = "Namensfunktion (Ersatzzustand)"
L["Name of Caster's Target"] = "Name des Ziels des Zaubernden"
L["Name of the (sub-)zone currently shown above the minimap."] = "Name des (Unter-)Gebiets, das aktuell über der Minikarte angezeigt wird."
L["Name(s)"] = "Name(n)"
L["Name/Realm of Caster's Target"] = "Name/Realm des Ziels des Zaubernden"
L["Nameplate"] = "Namensplakette"
L["Nameplates"] = "Namensplaketten"
L["Names of affected Players"] = "Namen betroffener Spieler"
L["Names of unaffected Players"] = "Namen nicht betroffener Spieler"
L["No active boss mod addon detected.\n\nNote: This trigger will use BigWigs or DBM, in that order if both are installed."] = "Kein aktives Boss-Mod-Addon erkannt.\n\nHinweis: Dieser Auslöser verwendet BigWigs oder DBM, in dieser Reihenfolge, wenn beide installiert sind."
L["No Extend"] = "Nicht erweitern"
L["No Profiling information saved."] = "Keine Profilinformationen gespeichert."
L["No Progress Information available."] = "Keine Fortschrittsinformationen verfügbar."
L["Normal Party"] = "Normale Gruppe"
L["Not in Smart Group"] = "Nicht in intelligenter Gruppe"
L["Note: Due to how complicated the swing timer behavior is and the lack of APIs from Blizzard, results are inaccurate in edge cases."] = "Hinweis: Da das Verhalten des Schwungtimers so kompliziert ist und Blizzard keine APIs bereitstellt, sind die Ergebnisse in Grenzfällen ungenau."
L["Note: 'Hide Alone' is not available in the new aura tracking system. A load option can be used instead."] = "Hinweis: 'Allein ausblenden' ist im neuen Aurenverfolgungssystem nicht verfügbar. Stattdessen kann eine Ladeoption verwendet werden."
L["Note: The available text replacements for multi triggers match the normal triggers now."] = "Hinweis: Die verfügbaren Textersetzungen für Mehrfach-Auslöser entsprechen jetzt denen der normalen Auslöser."
L["Note: This trigger internally stores the shapeshift position, and thus is incompatible with learning stances on the fly, like e.g. the Gladiator Rune."] = "Hinweis: Dieser Auslöser speichert intern die Gestaltposition und ist daher nicht mit dem spontanen Erlernen von Haltungen kompatibel, wie z. B. mit der Gladiatorrune."
L["Note: This trigger relies on the WoW API, which returns incorrect information in some cases."] = "Hinweis: Dieser Auslöser stützt sich auf die WoW-API, die in einigen Fällen falsche Informationen zurückgibt."
L["Uses UnitIsVisible() to check if game client has loaded a object for this unit. This distance is around 100 yards. This is polled every second."] = "Verwendet UnitIsVisible(), um zu prüfen, ob der Spielclient ein Objekt für diese Einheit geladen hat. Diese Entfernung beträgt etwa 100 Meter. Wird jede Sekunde abgefragt."
L["Note: This trigger type estimates the range to the hitbox of a unit. The actual range of friendly players is usually 3 yards more than the estimate. Range checking capabilities depend on your current class and known abilities as well as the type of unit being checked. Some of the ranges may also not work with certain NPCs.|n|n|cFFAAFFAAFriendly Units:|r %s|n|cFFFFAAAAHarmful Units:|r %s|n|cFFAAAAFFMiscellanous Units:|r %s"] = "Hinweis: Dieser Auslösertyp schätzt die Reichweite zur Hitbox einer Einheit. Die tatsächliche Reichweite zu freundlichen Spielern ist meist 3 Meter größer als die Schätzung. Die Möglichkeiten der Reichweitenprüfung hängen von deiner aktuellen Klasse und den bekannten Fähigkeiten sowie vom Typ der geprüften Einheit ab. Manche Reichweiten funktionieren bei bestimmten NPCs möglicherweise auch nicht.|n|n|cFFAAFFAAFreundliche Einheiten:|r %s|n|cFFFFAAAASchädliche Einheiten:|r %s|n|cFFAAAAFFSonstige Einheiten:|r %s"
L["Noth the Plaguebringer"] = "Noth der Seuchenfürst"
L["Occurrence of the event\nCan be a range of values\nCan have multiple values separated by a comma or a space\n\nExamples:\n2nd 5th and 6th events: 2, 5, 6\n2nd to 6th: 2-6\nevery 2 events: /2\nevery 3 events starting from 2nd: 2/3\nevery 3 events starting from 2nd and ending at 11th: 2-11/3\n\nWorks only if Boss Mod addon show counter"] = "Auftreten des Ereignisses\nKann ein Wertebereich sein\nKann mehrere Werte enthalten, getrennt durch Komma oder Leerzeichen\n\nBeispiele:\n2., 5. und 6. Ereignis: 2, 5, 6\n2. bis 6.: 2-6\njedes 2. Ereignis: /2\njedes 3. Ereignis ab dem 2.: 2/3\njedes 3. Ereignis ab dem 2. bis zum 11.: 2-11/3\n\nFunktioniert nur, wenn das Boss-Mod-Addon einen Zähler anzeigt"
L["Occurrence of the event, reset when aura is unloaded\nCan be a range of values\nCan have multiple values separated by a comma or a space\n\nExamples:\n2nd 5th and 6th events: 2, 5, 6\n2nd to 6th: 2-6\nevery 2 events: /2\nevery 3 events starting from 2nd: 2/3\nevery 3 events starting from 2nd and ending at 11th: 2-11/3\n\nOnly if BigWigs shows it on it's bar"] = "Auftreten des Ereignisses, wird beim Entladen der Aura zurückgesetzt\nKann ein Wertebereich sein\nKann mehrere Werte enthalten, getrennt durch Komma oder Leerzeichen\n\nBeispiele:\n2., 5. und 6. Ereignis: 2, 5, 6\n2. bis 6.: 2-6\njedes 2. Ereignis: /2\njedes 3. Ereignis ab dem 2.: 2/3\njedes 3. Ereignis ab dem 2. bis zum 11.: 2-11/3\n\nNur wenn BigWigs es auf seiner Leiste anzeigt"
L["Occurrence of the event, reset when aura is unloaded\nCan be a range of values\nCan have multiple values separated by a comma or a space\n\nExamples:\n2nd 5th and 6th events: 2, 5, 6\n2nd to 6th: 2-6\nevery 2 events: /2\nevery 3 events starting from 2nd: 2/3\nevery 3 events starting from 2nd and ending at 11th: 2-11/3\n\nOnly if DBM shows it on it's bar"] = "Auftreten des Ereignisses, wird beim Entladen der Aura zurückgesetzt\nKann ein Wertebereich sein\nKann mehrere Werte enthalten, getrennt durch Komma oder Leerzeichen\n\nBeispiele:\n2., 5. und 6. Ereignis: 2, 5, 6\n2. bis 6.: 2-6\njedes 2. Ereignis: /2\njedes 3. Ereignis ab dem 2.: 2/3\njedes 3. Ereignis ab dem 2. bis zum 11.: 2-11/3\n\nNur wenn DBM es auf seiner Leiste anzeigt"
L["Offset from progress"] = "Versatz vom Fortschritt"
L["Offset Timer"] = "Timer-Versatz"
L["Old Blizzard (2h | 3m | 10s | 2.4)"] = "Altes Blizzard (2h | 3m | 10s | 2.4)"
L["On Taxi"] = "Auf Flugroute"
L["Only if on a different realm"] = "Nur auf einem anderen Realm"
L["Option Group"] = "Optionsgruppe"
L["Options could not be loaded, the addon is %s"] = "Optionen konnten nicht geladen werden, das Addon ist %s"
L["Options will finish loading after combat ends."] = "Die Optionen werden nach Ende des Kampfes fertig geladen."
L["Options will open after the login process has completed."] = "Die Optionen werden geöffnet, sobald die Anmeldung abgeschlossen ist."
L["Or Talent"] = "Oder Talent"
L["Orbit"] = "Umlaufbahn"
L["Ossirian the Unscarred"] = "Ossirian der Narbenlose"
L["Other"] = "Sonstiges"
L["Other Addons"] = "Andere Addons"
L["Other Events"] = "Andere Ereignisse"
L["Over Energize"] = "Überschüssige Energie"
L["Overkill"] = "Überschüssiger Schaden"
L["Overlay %s"] = "Überlagerung %s"
L["Overlay Charged Combo Points"] = "Aufgeladene Combopunkte überlagern"
L["Overlay Cost of Casts"] = "Zauberkosten überlagern"
L["Overlay Latency"] = "Latenz überlagern"
L["Pad"] = "Auffüllen"
L["Pad Mode"] = "Auffüllmodus"
L["Pad to"] = "Auffüllen auf"
L["Parent Frame"] = "Übergeordneter Rahmen"
L["Parent Zone"] = "Übergeordnete Zone"
L["Path of Ascension: Courage"] = "Pfad des Aufstiegs: Mut"
L["Path of Ascension: Humility"] = "Pfad des Aufstiegs: Demut"
L["Path of Ascension: Loyalty"] = "Pfad des Aufstiegs: Loyalität"
L["Path of Ascension: Wisdom"] = "Pfad des Aufstiegs: Weisheit"
L["Pet Specialization"] = "Begleiterspezialisierung"
L["Pets only"] = "Nur Begleiter"
L["Pixel Glow"] = "Pixel-Leuchten"
L["Placement"] = "Platzierung"
L["Placement %i"] = "Platzierung %i"
L["Placement Mode"] = "Platzierungsmodus"
L["Player Effective Level"] = "Effektive Spielerstufe"
L["Player Experience"] = "Spielererfahrung"
L["Player Location ID(s)"] = "Spieler-Ortskennung(en)"
L["Player Money"] = "Spielergold"
L["Player Name/Realm"] = "Spielername/Realm"
L["Player/Unit Info"] = "Spieler-/Einheiteninfo"
L["Players and Pets"] = "Spieler und Begleiter"
L["Power Deficit"] = "Ressourcendefizit"
L["Precision"] = "Genauigkeit"
L["Primary Stats"] = "Primärattribute"
L["Princess Huhuran"] = "Prinzessin Huhuran"
L["Print Profiling Results"] = "Profiling-Ergebnisse ausgeben"
L["Proc Glow"] = "Prozessleuchten"
L["Profiling already started."] = "Das Profiling läuft bereits."
L["Profiling automatically started."] = "Das Profiling wurde automatisch gestartet."
L["Profiling not running."] = "Das Profiling läuft nicht."
L["Profiling started."] = "Das Profiling wurde gestartet."
L["Profiling started. It will end automatically in %d seconds"] = "Das Profiling wurde gestartet. Es endet automatisch in %d Sekunden"
L["Profiling still running, stop before trying to print."] = "Das Profiling läuft noch, beende es vor der Ausgabe."
L["Profiling stopped."] = "Das Profiling wurde beendet."
L["Progress"] = "Fortschritt"
L["Progress Source"] = "Fortschrittsquelle"
L["PvP Mode Active"] = "PvP-Modus aktiv"
L["PvP Talent Selected"] = "PvP-Talent ausgewählt"
L["Quality Id"] = "Qualitäts-ID"
L["Quantity"] = "Menge"
L["Quantity earned this week"] = "In dieser Woche erhaltene Menge"
L["Quest Party"] = "Quest-Gruppe"
L["Queued Action"] = "Aktion in Warteschlange"
L["Raid (Heroic)"] = "Schlachtzug (Heroisch)"
L["Raid (Mythic)"] = "Schlachtzug (Mythisch)"
L["Raid (Normal)"] = "Schlachtzug (Normal)"
L["Raid (Timewalking)"] = "Schlachtzug (Zeitwanderung)"
L["Raid Mark"] = "Schlachtzugsmarkierung"
L["Raid Mark Icon"] = "Symbol der Schlachtzugsmarkierung"
L["Raid Role"] = "Schlachtzugsrolle"
L["Ranged"] = "Fernkampf"
L["Rank"] = "Rang"
L["Rare"] = "Selten"
L["Rare Elite"] = "Seltener Elite"
L["Rated Arena"] = "Gewertete Arena"
L["Rated Battleground"] = "Gewertetes Schlachtfeld"
L["Raw Threat Percent"] = "Rohe Bedrohung in Prozent"
L["Razorgore the Untamed"] = "Razorgore der Ungezähmte"
L["Reagent Quality"] = "Reagenzqualität"
L["Reagent Quality Texture"] = "Reagenzqualitätstextur"
L["Realm Name"] = "Realmname"
L["Realm of Caster's Target"] = "Realm des Ziels des Zaubernden"
L["Reborn Council"] = "Rat der Wiedergeborenen"
L["Receiving %s Bytes"] = "%s Bytes werden empfangen"
L["Relative X-Offset"] = "Relativer X-Versatz"
L["Relative Y-Offset"] = "Relativer Y-Versatz"
L["Remove Obsolete Auras"] = "Veraltete Auren entfernen"
L["Renown Level"] = "Ruhmstufe"
L["Renown Max Level"] = "Maximale Ruhmstufe"
L["Renown Reputation"] = "Ruhm-Ruf"
L["Report Summary"] = "Berichtszusammenfassung"
L["Reputation"] = "Ruf"
L["Reputation (%)"] = "Ruf (%)"
L["Requesting display information from %s ..."] = "Anzeigeinformationen werden von %s angefordert ..."
L["Requires syncing the specialization via LibSpecialization."] = "Erfordert die Synchronisierung der Spezialisierung über LibSpecialization."
L["Resilience (%)"] = "Abhärtung (%)"
L["Resilience Rating"] = "Abhärtungswertung"
L["Resistances"] = "Widerstände"
L["Rested"] = "Ausgeruht"
L["Rested Experience"] = "Erfahrung durch Erholung"
L["Rested Experience (%)"] = "Ausgeruhte Erfahrung (%)"
L["Resurrect Pending"] = "Wiederbelebung ausstehend"
L["Right, then Centered Vertical"] = "Rechts, dann vertikal zentriert"
L["Rollback snapshot is complete. Thank you for your patience!"] = "Der Rollback-Snapshot ist vollständig. Danke für deine Geduld!"
L["Rotate Animation"] = "Animation drehen"
L["Rotation"] = "Drehung"
L["Round"] = "Rund"
L["Round Mode"] = "Rundungsmodus"
L["Run Speed (%)"] = "Laufgeschwindigkeit (%)"
L["Rune #1"] = "Rune Nr. 1"
L["Rune #2"] = "Rune Nr. 2"
L["Rune #3"] = "Rune Nr. 3"
L["Rune #4"] = "Rune Nr. 4"
L["Rune #5"] = "Rune Nr. 5"
L["Rune #6"] = "Rune Nr. 6"
L["Rune Count"] = "Runenanzahl"
L["Rune Count - Blood"] = "Runenanzahl – Blut"
L["Rune Count - Frost"] = "Runenanzahl – Frost"
L["Rune Count - Unholy"] = "Runenanzahl – Unheilig"
L["Sapphiron"] = "Saphiron"
L["Scale"] = "Skalierung"
L["Scarlet Enclave"] = "Scharlachrote Enklave"
L["Scenario (Heroic)"] = "Szenario (Heroisch)"
L["Scenario (Normal)"] = "Szenario (Normal)"
L["Screen"] = "Bildschirm"
L["Season of Discovery"] = "Saison der Entdeckungen"
L["Second"] = "Sekunde"
L["Second Value of Tooltip Text"] = "Zweiter Wert des Tooltip-Textes"
L["Secondary Stats"] = "Sekundärattribute"
L["Secure frame detected. Find more information:\nhttps://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames"] = "Gesicherter Rahmen erkannt. Weitere Informationen:\nhttps://github.com/WeakAuras/WeakAuras2/wiki/Protected-Frames"
L["Select the type of timer to filter"] = "Wähle den Timertyp, nach dem gefiltert wird"
L["Selection Mode"] = "Auswahlmodus"
L["Separator"] = "Trennzeichen"
L["Set IDs can be found on websites such as wowhead.com/cata/item-sets"] = "Set-IDs findest du auf Websites wie wowhead.com/cata/item-sets"
L["Set IDs can be found on websites such as wowhead.com/classic/item-sets"] = "Set-IDs findest du auf Websites wie wowhead.com/classic/item-sets"
L["Set IDs can be found on websites such as wowhead.com/item-sets"] = "Set-IDs findest du auf Websites wie wowhead.com/item-sets"
L["Set IDs can be found on websites such as wowhead.com/mop-classic/item-sets"] = "Set-IDs findest du auf Websites wie wowhead.com/mop-classic/item-sets"
L["Shadowlands"] = "Schattenlande"
L["Shift-Click to resume addon execution."] = "Umschalt+Klick, um die Ausführung des Addons fortzusetzen."
L["Show CD of Charge"] = "Abklingzeit der Aufladung anzeigen"
L["Show charged duration for empowered casts"] = "Aufgeladene Dauer bei verstärkten Zaubern anzeigen"
L["Show Loss of Control"] = "Kontrollverlust anzeigen"
L["Show On"] = "Anzeigen bei"
L["Show Rested Overlay"] = "Ausgeruht-Überlagerung anzeigen"
L["Silithid Royalty"] = "Silithidenadel"
L["Silver"] = "Silber"
L["Since Active"] = "Seit Aktivierung"
L["Since Apply"] = "Seit Anwendung"
L["Since Apply/Refresh"] = "Seit Anwendung/Erneuerung"
L["Since Charge Gain"] = "Seit Aufladungsgewinn"
L["Since Charge Lost"] = "Seit Aufladungsverlust"
L["Since Ready"] = "Seit Bereitschaft"
L["Since Stack Gain"] = "Seit Stapelgewinn"
L["Since Stack Lost"] = "Seit Stapelverlust"
L["Skyriding"] = "Himmelsreiten"
L["Slide Animation"] = "Gleitanimation"
L["Slider"] = "Schieberegler"
L["Smart Group"] = "Intelligente Gruppe"
L["Soft Enemy"] = "Weicher Feind"
L["Soft Friend"] = "Weicher Freund"
L["Sound by Kit ID"] = "Sound nach Kit-ID"
L["Source"] = "Quelle"
L["Source Affiliation"] = "Quellenzugehörigkeit"
L["Source GUID"] = "Quell-GUID"
L["Source Info"] = "Quelleninfo"
L["Source NPC Id"] = "Quell-NPC-ID"
L["Source Object Type"] = "Quellobjekttyp"
L["Source Reaction"] = "Quellreaktion"
L["Source Unit Name/Realm"] = "Name/Realm der Quelleinheit"
L["Source unit's raid mark index"] = "Index der Schlachtzugsmarkierung der Quelleinheit"
L["Source unit's raid mark texture"] = "Textur der Schlachtzugsmarkierung der Quelleinheit"
L["Space"] = "Leertaste"
L["Spark"] = "Funke"
L["Spec Position"] = "Spezialisierungsposition"
L["Spec Role"] = "Spezialisierungsrolle"
L["Specialization"] = "Spezialisierung"
L["Specific Currency"] = "Bestimmte Währung"
L["Specific Type"] = "Bestimmter Typ"
L["Spell Activation Overlay Glow"] = "Leuchten der Zauberaktivierungsüberlagerung"
L["Spell Cast Succeeded"] = "Zauber erfolgreich gewirkt"
L["Spell Count"] = "Zauberanzahl"
L["Spell in Range"] = "Zauber in Reichweite"
L["Spell Peneration Percent"] = "Zauberdurchschlagskraft in Prozent"
L["Spell Power"] = "Zaubermacht"
L["Spell School"] = "Zauberschule"
L["Spellname"] = "Zaubername"
L["Spike"] = "Stachel"
L["Spirit"] = "Willenskraft"
L["Stack Count"] = "Stapelanzahl"
L["Stack trace:"] = "Stapelüberwachung:"
L["Stacks Function"] = "Stapelfunktion"
L["Stacks Function (fallback state)"] = "Stapelfunktion (Ausweichstatus)"
L["Stage"] = "Phase"
L["Stage Counter"] = "Phasenzähler"
L["Stagger"] = "Staffeln"
L["Stagger (%)"] = "Staffeln (%)"
L["Stagger against Target (%)"] = "Staffeln gegen Ziel (%)"
L["Stagger Scale"] = "Staffelskalierung"
L["Standing"] = "Ruf"
L["Star Shake"] = "Sternenzittern"
L["Start Animation"] = "Startanimation"
L["Start Now"] = "Jetzt starten"
L["Start Profiling"] = "Profiling starten"
L["Status Bar"] = "Statusleiste"
L["Stop Motion"] = "Stop-Motion"
L["Story Raid"] = "Story-Schlachtzug"
L["String"] = "Zeichenkette"
L["Subevent Info"] = "Unterereignisinfo"
L["Subtract Cast"] = "Zauberzeit abziehen"
L["Subtract Channel"] = "Kanalisierung abziehen"
L["Subtract GCD"] = "Globale Abklingzeit abziehen"
L["Subzone Name"] = "Name der Unterzone"
L["Success"] = "Erfolg"
L["Sulfuron Harbinger"] = "Sulfuronherold"
L["Summon Pending"] = "Beschwörung ausstehend"
L["Sun"] = "Sonne"
L["Supports multiple entries, separated by commas"] = "Unterstützt mehrere Einträge, durch Kommas getrennt"
L["Supports multiple entries, separated by commas\n"] = "Unterstützt mehrere Einträge, durch Kommas getrennt\n"
L["Supports multiple entries, separated by commas. Escape ',' with \\. Prefix with '-' for negation."] = "Unterstützt mehrere Einträge, durch Kommas getrennt. ',' mit \\ maskieren. Mit '-' voranstellen für Negation."
L["Supports multiple entries, separated by commas. Escape with \\. Prefix with '-' for negation."] = "Unterstützt mehrere Einträge, durch Kommas getrennt. Mit \\ maskieren. Mit '-' voranstellen für Negation."
L["Supports multiple entries, separated by commas. Prefix with '-' for negation."] = "Unterstützt mehrere Einträge, durch Kommas getrennt. Mit '-' voranstellen für Negation."
L["Supports multiple entries, separated by commas. To include child zone ids, prefix with 'c', e.g. 'c2022'.\nGroup Zone IDs must be prefixed with 'g', e.g. 'g277'.\nSupports Area IDs from https://wago.tools/db2/AreaTable prefixed with 'a'.\nSupports Instance IDs prefixed with 'i'.\nEntries can be prefixed with '-' to negate."] = "Unterstützt mehrere Einträge, durch Kommas getrennt. Um Zonen-IDs untergeordneter Zonen einzuschließen, 'c' voranstellen, z. B. 'c2022'.\nGruppenzonen-IDs müssen mit 'g' beginnen, z. B. 'g277'.\nUnterstützt Gebiets-IDs von https://wago.tools/db2/AreaTable mit vorangestelltem 'a'.\nUnterstützt Instanz-IDs mit vorangestelltem 'i'.\nEinträge können mit '-' beginnen, um sie zu negieren."
L["Swipe"] = "Abklinganimation"
L["Systems"] = "Systeme"
L["Tab "] = "Reiter "
L["Talent |cFFFF0000Not|r Known"] = "Talent |cFFFF0000nicht|r bekannt"
L["Talent |cFFFF0000Not|r Selected"] = "Talent |cFFFF0000nicht|r ausgewählt"
L["Talent Known"] = "Talent bekannt"
L["Tertiary Stats"] = "Tertiärattribute"
L["Test if bar is enabled in BigWigs settings"] = "Prüfen, ob die Leiste in den BigWigs-Einstellungen aktiviert ist"
L["Test if bar is enabled in Boss Mod addon settings"] = "Prüfen, ob die Leiste in den Einstellungen des Boss-Mod-Addons aktiviert ist"
L["Test if bar is enabled in DBM settings"] = "Prüfen, ob die Leiste in den DBM-Einstellungen aktiviert ist"
L["Text To Speech"] = "Text-zu-Sprache"
L["Text-to-speech"] = "Text-zu-Sprache"
L["Texture"] = "Textur"
L["Texture Function"] = "Texturfunktion"
L["Texture Function (fallback state)"] = "Texturfunktion (Ausweichstatus)"
L["Texture Picker"] = "Texturauswahl"
L["Texture Rotation"] = "Texturdrehung"
L["The aura has overwritten the global '%s', this might affect other auras."] = "Die Aura hat das globale '%s' überschrieben, das könnte andere Auren beeinflussen."
L["The aura tried to overwrite the aura_env global, which is not allowed."] = "Die Aura hat versucht, das globale aura_env zu überschreiben, was nicht erlaubt ist."
L["The effective level differs from the level in e.g. Time Walking dungeons."] = "Die effektive Stufe weicht von der Stufe z. B. in Zeitwanderungs-Dungeons ab."
L["The Four Horsemen"] = "Die vier Reiter"
L["The 'ID' value can be found in the BigWigs options of a specific spell"] = "Den Wert 'ID' findest du in den BigWigs-Optionen eines bestimmten Zaubers"
L["The Prophet Skeram"] = "Der Propheten Skeram"
L["The total quantity a warband character can transfer after paying the transfer cost"] = "Die Gesamtmenge, die ein Kriegsmeute-Charakter nach Zahlung der Transferkosten übertragen kann"
L["The total quantity after transferring everything to your current character and paying the transfer cost"] = "Die Gesamtmenge, nachdem alles auf deinen aktuellen Charakter übertragen und die Transferkosten bezahlt wurden"
L["There are %i updates to your auras ready to be installed!"] = "Es sind %i Aktualisierungen für deine Auren zur Installation bereit!"
L["Thickness"] = "Dicke"
L["Third"] = "Dritter"
L["Third Value of Tooltip Text"] = "Dritter Wert des Tooltip-Textes"
L["This aura calls GetData a lot, which is a slow function."] = "Diese Aura ruft GetData sehr oft auf, was eine langsame Funktion ist."
L["This aura has caused a Lua error."] = "Diese Aura hat einen Lua-Fehler verursacht."
L["This aura is saving %s KB of data"] = "Diese Aura speichert %s KB an Daten"
L["This aura plays a sound via a condition."] = "Diese Aura spielt per Bedingung einen Sound ab."
L["This aura plays a sound via an action."] = "Diese Aura spielt per Aktion einen Sound ab."
L["This aura plays a Text To Speech via a condition."] = "Diese Aura spielt per Bedingung eine Text-zu-Sprache ab."
L["This aura plays a Text To Speech via an action."] = "Diese Aura spielt per Aktion eine Text-zu-Sprache ab."
L["This filter has been moved to the Location trigger. Change your aura to use the new Location trigger or join the KUIAR_Engine Discord server for help."] = "Dieser Filter wurde in den Ortsauslöser verschoben. Ändere deine Aura so, dass sie den neuen Ortsauslöser verwendet, oder tritt dem KUIAR_Engine-Discord-Server bei, um Hilfe zu erhalten."
L["Threat Percent"] = "Bedrohung in Prozent"
L["Threat Value"] = "Bedrohungswert"
L["Time"] = "Zeit"
L["Time Format"] = "Zeitformat"
L["Time in GCDs"] = "Zeit in GCDs"
L["Time since initial application"] = "Zeit seit der ersten Anwendung"
L["Time since last refresh"] = "Zeit seit der letzten Erneuerung"
L["Time since stack gain"] = "Zeit seit Stapelgewinn"
L["Time since stack lost"] = "Zeit seit Stapelverlust"
L["Timed Progress"] = "Zeitgesteuerter Fortschritt"
L["Timer Id"] = "Timer-ID"
L["Toggle List"] = "Liste umschalten"
L["Toggle Options Window"] = "Optionsfenster umschalten"
L["Toggle Performance Profiling Window"] = "Leistungs-Profiling-Fenster umschalten"
L["Tooltip Value 4"] = "Tooltip-Wert 4"
L["Total Earned in this Season"] = "In dieser Saison insgesamt verdient"
L["Total Essence"] = "Essenz gesamt"
L["Total Experience"] = "Erfahrung gesamt"
L["Total Match Count"] = "Gesamtzahl der Treffer"
L["Total Reputation"] = "Ruf gesamt"
L["Total Stacks"] = "Stapel gesamt"
L["Total stacks over all matches"] = "Stapel gesamt über alle Treffer"
L["Total Stages"] = "Phasen gesamt"
L["Total Unit Count"] = "Gesamtzahl der Einheiten"
L["Total Units"] = "Einheiten gesamt"
L["Totem Icon"] = "Totemsymbol"
L["Totem Name Pattern Match"] = "Totemnamen-Musterabgleich"
L["Track Cooldowns"] = "Abklingzeiten verfolgen"
L["Tracking Charge %i"] = "Aufladung %i wird verfolgt"
L["Tracking Charge CDs"] = "Abklingzeiten der Aufladungen verfolgen"
L["Tracking Only Cooldown"] = "Nur Abklingzeit wird verfolgt"
L["Trigger %i"] = "Auslöser %i"
L["Trigger %s"] = "Auslöser %s"
L["Trigger State Updater (Advanced)"] = "Auslöser-Statusaktualisierer (Fortgeschritten)"
L["Trivial (Low Level)"] = "Trivial (niedrige Stufe)"
L["Trying to repair broken conditions in %s likely caused by a KUIAR_Engine bug."] = "Es wird versucht, defekte Bedingungen in %s zu reparieren, vermutlich verursacht durch einen KUIAR_Engine-Fehler."
L["Unable to modernize aura '%s'. This is probably due to corrupt data or a bad migration."] = "Die Aura '%s' konnte nicht modernisiert werden. Das liegt wahrscheinlich an beschädigten Daten oder einer fehlerhaften Migration."
L["Unaffected"] = "Nicht betroffen"
L["Unholy"] = "Unheilig"
L["Unholy Rune #1"] = "Unheilige Rune Nr. 1"
L["Unholy Rune #2"] = "Unheilige Rune Nr. 2"
L["Unit Dissipates"] = "Einheit verschwindet"
L["Unit Frame"] = "Einheitenrahmen"
L["Unit Frames"] = "Einheitenfenster"
L["Unit Name"] = "Einheitenname"
L["Unit Name/Realm"] = "Einheitenname/Realm"
L["Units Affected"] = "Betroffene Einheiten"
L["Units of affected Players in a table format"] = "Einheiten betroffener Spieler in Tabellenform"
L["Units of unaffected Players in a table format"] = "Einheiten nicht betroffener Spieler in Tabellenform"
L["Unknown action %q"] = "Unbekannte Aktion %q"
L["Unknown feature %q"] = "Unbekannte Funktion %q"
L["unknown location"] = "unbekannter Ort"
L["Untrigger %s"] = "Auslöser %s beenden"
L["Up, then Centered Horizontal"] = "Nach oben, dann horizontal zentriert"
L["Update Position"] = "Position aktualisieren"
L["Use /wa minimap to show the minimap icon again."] = "Nutze /wa minimap, um das Minimap-Symbol wieder anzuzeigen."
L["Use Legacy floor rounding"] = "Altes Abrunden verwenden"
L["Use Texture"] = "Textur verwenden"
L["Use Watched Faction"] = "Beobachtete Fraktion verwenden"
L["Uses UnitInRange() to check if in range. Matches default raid frames out of range behavior, which is between 25 to 40 yards depending on your class and spec."] = "Verwendet UnitInRange(), um die Reichweite zu prüfen. Entspricht dem Reichweitenverhalten der Standard-Schlachtzugsrahmen, das je nach Klasse und Spezialisierung zwischen 25 und 40 Metern liegt."
L["Using KUIAR_Runtime.clones is deprecated. Use KUIAR_Runtime.GetRegion(id, cloneId) instead."] = "Die Verwendung von KUIAR_Runtime.clones ist veraltet. Verwende stattdessen KUIAR_Runtime.GetRegion(id, cloneId)."
L["Using KUIAR_Runtime.regions is deprecated. Use KUIAR_Runtime.GetRegion(id) instead."] = "Die Verwendung von KUIAR_Runtime.regions ist veraltet. Verwende stattdessen KUIAR_Runtime.GetRegion(id)."
L["Vaelastrasz the Corrupt"] = "Vaelastrasz der Verdorbene"
L["Vertical"] = "Vertikal"
L["Visions of N'Zoth"] = "Visionen von N'Zoth"
L["Warband Quantity Total"] = "Kriegsmeute-Gesamtmenge"
L["Warband Transfer Percentage"] = "Kriegsmeute-Transferanteil"
L["Warband Transferred Quantity"] = "Von der Kriegsmeute übertragene Menge"
L["Warfront (Heroic)"] = "Kriegsfront (Heroisch)"
L["Warfront (Normal)"] = "Kriegsfront (Normal)"
L["Warning"] = "Warnung"
L["Warning for unknown aura:"] = "Warnung für unbekannte Aura:"
L["Warning: Anchoring in aura '%s' is imposssible, due to an anchoring cycle"] = "Warnung: Das Verankern in der Aura '%s' ist wegen eines Verankerungszyklus unmöglich"
L["Warning: Full Scan auras checking for both name and spell id can't be converted."] = "Warnung: Full-Scan-Auren, die sowohl Name als auch Zauber-ID prüfen, können nicht umgewandelt werden."
L["Warning: Name info is now available via %affected, %unaffected. Number of affected group members via %unitCount. Some options behave differently now. This is not automatically adjusted."] = "Warnung: Namensinformationen sind jetzt über %affected, %unaffected verfügbar. Die Anzahl betroffener Gruppenmitglieder über %unitCount. Einige Optionen verhalten sich jetzt anders. Dies wird nicht automatisch angepasst."
L["Warning: Tooltip values are now available via %tooltip1, %tooltip2, %tooltip3 instead of %s. This is not automatically adjusted."] = "Warnung: Tooltip-Werte sind jetzt über %tooltip1, %tooltip2, %tooltip3 statt %s verfügbar. Dies wird nicht automatisch angepasst."
L["KUIAR_Engine Built-In (63:42 | 3:07 | 10 | 2.4)"] = "KUIAR_Engine integriert (63:42 | 3:07 | 10 | 2.4)"
L["KUIAR_Runtime has detected that it has been downgraded.\nYour saved auras may no longer work properly.\nWould you like to run the |cffff0000EXPERIMENTAL|r repair tool? This will overwrite any changes you have made since the last database upgrade.\nLast upgrade: %s\n\n|cffff0000You should BACKUP your WTF folder BEFORE pressing this button.|r"] = "KUIAR_Runtime hat festgestellt, dass es auf eine ältere Version zurückgesetzt wurde.\nDeine gespeicherten Auren funktionieren möglicherweise nicht mehr richtig.\nMöchtest du das |cffff0000EXPERIMENTELLE|r Reparaturwerkzeug ausführen? Dadurch werden alle Änderungen überschrieben, die du seit dem letzten Datenbank-Upgrade vorgenommen hast.\nLetztes Upgrade: %s\n\n|cffff0000Du solltest VOR dem Drücken dieser Schaltfläche deinen WTF-Ordner SICHERN.|r"
L["KUIAR_Engine is creating a rollback snapshot of your auras. This snapshot will allow you to revert to the current state of your auras if something goes wrong. This process may cause your framerate to drop until it is complete."] = "KUIAR_Engine erstellt einen Wiederherstellungs-Snapshot deiner Auren. Mit diesem Snapshot kannst du den aktuellen Stand deiner Auren wiederherstellen, falls etwas schiefgeht. Dieser Vorgang kann deine Bildrate senken, bis er abgeschlossen ist."
L["KUIAR_Engine Profiling"] = "KUIAR_Engine-Profilerstellung"
L["KUIAR_Engine Profiling Report"] = "KUIAR_Engine-Profilbericht"
L["KUIAR_Engine Version: %s"] = "KUIAR_Engine-Version: %s"
L["Enchant Type"] = "Verzauberungstyp"
L["Imbue (Firestones, Mage Scrolls, Shaman Imbues)"] = "Imbue (Feuersteine, Magierschriftrollen, Schamanen-Imbues)"
L["Oil, Stone or Poison"] = "Öl, Stein oder Gift"
L["World Bosses"] = "Weltbosse"
L["Wrap"] = "Umbruch"
L["Writing to the KUIAR_Engine table is not allowed."] = "Das Schreiben in die KUIAR_Engine-Tabelle ist nicht erlaubt."
L["You have new auras ready to be installed!"] = "Du hast neue Auren, die installiert werden können!"
L["Your next encounter will automatically be profiled."] = "Dein nächster Begegnungskampf wird automatisch profiliert."
L["Your next instance of combat will automatically be profiled."] = "Dein nächster Kampf wird automatisch profiliert."
L["Your scheduled automatic profile has been cancelled."] = "Dein geplantes automatisches Profil wurde abgebrochen."
L["Your threat as a percentage of the tank's current threat."] = "Deine Bedrohung als Prozentsatz der aktuellen Bedrohung des Tanks."
L["Zone Group ID"] = "Zonengruppen-ID"
L["Zone ID"] = "Zonen-ID"
L["Zoom Animation"] = "Zoomanimation"
L["Raid Leader"] = "Schlachtzugsleiter"
L["Blizzard refused the Remaining Time countdown: %s"] = "Blizzard hat den Restzeit-Countdown abgelehnt: %s"
L["Blizzard refused the Remaining Time %s: %s"] = "Blizzard hat Restzeit %s abgelehnt: %s"
L["Row cells: %s. The next display is laid out from this display's carrier, which is the wrong place."] = "Zeilenzellen: %s. Die nächste Anzeige wird vom Träger dieser Anzeige aus angeordnet, was der falsche Ort ist."
L["Row cells: a button's artwork could not be placed on the row: %s"] = "Zeilenzellen: Die Grafik einer Schaltfläche konnte nicht in der Zeile platziert werden: %s"
L["Row cells: a Total Duration filter and a Remaining Time glow condition share one measurement; this display keeps one spot in the row."] = "Zeilenzellen: Ein Gesamtdauer-Filter und eine Leuchtbedingung für verbleibende Zeit teilen sich eine Messung; diese Anzeige behält einen Platz in der Zeile."
L["Row cells: a list of several units keeps one spot in the row; only single-unit lists lay out side by side."] = "Zeilenzellen: Eine Liste mehrerer Einheiten behält einen Platz in der Zeile; nur Listen mit einer Einheit werden nebeneinander angeordnet."
L["Row cells: this display's elements reach further than 8 row steps around the icon; the display keeps one spot in the row. Move the elements closer or make the spacing larger."] = "Zeilenzellen: Die Elemente dieser Anzeige reichen weiter als 8 Zeilenschritte um das Symbol; die Anzeige behält einen Platz in der Zeile. Rücke die Elemente näher heran oder vergrößere den Abstand."
L["Row cells: a Centered row keeps one spot for this display."] = "Zeilenzellen: Eine zentrierte Zeile behält einen Platz für diese Anzeige."
L["Row cells: a row on unit frames or nameplates keeps one spot for this display."] = "Zeilenzellen: Eine Zeile an Einheitenrahmen oder Namensplaketten behält einen Platz für diese Anzeige."
L["Row cells: a wrapped list keeps one spot in the row."] = "Zeilenzellen: Eine umbrochene Liste behält einen Platz in der Zeile."
L["on"] = "an"
L["Row cells: built as one spot during combat (the client allows no packed construction under aura restrictions); laid out side by side when the restrictions end."] = "Zeilenzellen: Im Kampf als ein Platz aufgebaut (der Client erlaubt bei Aura-Einschränkungen keinen gepackten Aufbau); nach Ende der Einschränkungen nebeneinander angeordnet."
L["Row cells combat fallback (one spot while restricted, chained when restrictions end) is %s (/fa cells fallback on|off; applies to the next build)."] = "Der Kampf-Fallback der Zeilenzellen (ein Platz während der Einschränkung, verkettet nach deren Ende) ist %s (/fa cells fallback on|off; gilt für den nächsten Aufbau)."
L["bound: record %d beyond the spine, ignored."] = "gebunden: Datensatz %d jenseits des Rückgrats, ignoriert."
L["text"] = "Text"
L["binding"] = "Bindung"
L["button to the holder and its text"] = "Schaltfläche zum Halter und dessen Text"
L["artwork"] = "Grafik"
L["span from the button"] = "Spanne von der Schaltfläche"
L["bound record %d: %s"] = "gebundener Datensatz %d: %s"
L["FA build:"] = "FA-Build:"
L["Row cells build reports are %s (/fa cells debug on|off)."] = "Berichte zum Aufbau der Zeilenzellen sind %s (/fa cells debug on|off)."
L["Row cells: Stack Count >= n and <= n use the display's one stack-count binding, so a display with a %s stack text keeps one spot in the row; remove the stack text to lay it out side by side (= n keeps it: the count is known)."] = "Zeilenzellen: Stapelanzahl >= n und <= n nutzen die einzelne Stapelanzahl-Bindung der Anzeige, daher behält eine Anzeige mit %s-Stapeltext einen Platz in der Zeile; entferne den Stapeltext, um sie nebeneinander anzuordnen (= n behält ihn: die Anzahl ist bekannt)."
L["  record %d: complete %s; elements %s; P %s; text [%s, %s]; count [%s, %s]; clip [%s, %s]"] = "  Eintrag %d: vollständig %s; Elemente %s; P %s; Text [%s, %s]; Anzahl [%s, %s]; Clip [%s, %s]"
L["  content %s; end %s"] = "  Inhalt %s; Ende %s"
L["REFERENCE: red, green, blue groups, all 30x30, 2 buttons each, 3 cells per line"] = "REFERENZ: rote, grüne, blaue Gruppen, alle 30x30, je 2 Schaltflächen, 3 Zellen pro Zeile"
L["Row cells: a Stack Count filter together with a Total Duration = / >= or Remaining Time filter is not supported yet (its side-by-side construction was withdrawn); the display is not shown. Each filter alone lays out side by side."] = "Zeilenzellen: Ein Stapelanzahl-Filter zusammen mit einem Filter für Gesamtdauer = / >= oder verbleibende Zeit wird noch nicht unterstützt (der Aufbau nebeneinander wurde zurückgezogen); die Anzeige wird nicht dargestellt. Jeder Filter allein ordnet nebeneinander an."
L["UNRESOLVED (an anchor read nil)"] = "UNAUFGELÖST (ein Anker las nil)"
L["NOT CLOSED (the empty text is not the baseline)"] = "NICHT GESCHLOSSEN (der leere Text ist nicht die Basislinie)"
L["NOT OPEN (the markup did not render)"] = "NICHT GEÖFFNET (das Markup wurde nicht dargestellt)"
L["OFF by %.2f px"] = "Um %.2f px daneben"
L["cell %d/%d %s: text [%s, %s] (extent %s for a %d px markup); spans [%s, %s] [%s, %s]; next holder -> %s, expected P + extent/4 = %s -> %s"] = "Zelle %d/%d %s: Text [%s, %s] (Ausdehnung %s für ein %d-px-Markup); Spannen [%s, %s] [%s, %s]; nächster Halter -> %s, erwartet P + Ausdehnung/4 = %s -> %s"
L["cell check done: %d of %d states OK."] = "Zellenprüfung abgeschlossen: %d von %d Zuständen in Ordnung."
L["cell check: one text cell (markup %d px, L = %d px, q = 4: two spans) and its follower; %d states, each set in one frame and read in the next; the verdict compares the follower with P + extent/4 within %.2f px."] = "Zellenprüfung: eine Textzelle (Markup %d px, L = %d px, q = 4: zwei Spannen) und ihr Nachfolger; %d Zustände, jeweils in einem Frame gesetzt und im nächsten gelesen; das Urteil vergleicht den Nachfolger mit P + Ausdehnung/4 innerhalb von %.2f px."
L["cell %d/%d %s: holder near edge P = %s; empty text [%s, %s] -> baseline b = %s"] = "Zelle %d/%d %s: Halter nahe Rand P = %s; leerer Text [%s, %s] -> Grundlinie b = %s"
L["DIFFERENT near edge"] = "ANDERS nahe am Rand"
L["INCONCLUSIVE (unreadable)"] = "UNKLAR (nicht lesbar)"
L["NOT REACHED (the fill is not the requested length)"] = "NICHT ERREICHT (die Füllung hat nicht die angeforderte Länge)"
L["SAME near edge"] = "GLEICHER nahe Rand"
L["fill %d/%d %s %s %s: bar [%s, %s], fill [%s, %s] -> %s"] = "Füllung %d/%d %s %s %s: Leiste [%s, %s], Füllung [%s, %s] -> %s"
L["reading"] = "Lesen"
L["setup"] = "Einrichtung"
L["Row cells: Remaining Time on an Icon draws one aura and keeps one spot in the row (the row closes up while no aura is in the window); on bars, textures and texts the list lays out side by side."] = "Zeilenzellen: Die verbleibende Zeit auf einem Symbol zeichnet eine Aura und behält einen Platz in der Zeile (die Zeile schließt sich, solange keine Aura im Fenster ist); bei Leisten, Texturen und Texten wird die Liste nebeneinander angeordnet."
L["Row cells: a Stack Count filter that can never match keeps one spot in the row."] = "Zeilenzellen: Ein Stapelanzahl-Filter, der nie passen kann, behält einen Platz in der Zeile."
L[" (root dirty)"] = " (Wurzel unsauber)"
L[" (the root among them)"] = " (darunter die Wurzel)"
L["already cleaning."] = "wird bereits geleert."
L["anchoring"] = "Verankerung"
L["cleared."] = "geleert."
L["clearing."] = "wird geleert."
L["creation"] = "Erstellung"
L["moving the root"] = "Verschieben der Wurzel"
L["not measuring (%s)."] = "keine Messung (%s)."
L["nothing to clear."] = "nichts zu leeren."
L["resolution"] = "Auflösung"
L["reverse"] = "umgekehrt"
L["stopped."] = "angehalten."
L["off"] = "aus"
L["Row cells: Blizzard refused %s %d times. This display keeps one spot in the row and shows nothing until its settings change or the interface is reloaded."] = "Zeilenzellen: Blizzard hat %s %d Mal abgelehnt. Diese Anzeige behält einen Platz in der Zeile und zeigt nichts, bis ihre Einstellungen geändert werden oder die Benutzeroberfläche neu geladen wird."
L["Row cells: Blizzard refused %s. This display keeps one spot in the row and shows nothing until it is laid out again."] = "Zeilenzellen: Blizzard hat %s abgelehnt. Diese Anzeige behält einen Platz in der Zeile und zeigt nichts, bis sie neu angeordnet wird."
L["Row cells: the game made %d more aura record(s) than the 10 this row lays out; they are hidden."] = "Zeilenzellen: Das Spiel hat %d Aura-Datensatz/-sätze mehr erzeugt als die 10, die diese Zeile anordnet; sie sind ausgeblendet."
L["the member's end (%s)"] = "das Ende des Mitglieds (%s)"
L["a row cell (%s)"] = "eine Zeilenzelle (%s)"
L["this display's place in the row (%s)"] = "der Platz dieser Anzeige in der Zeile (%s)"
L["the next member's place (%s)"] = "der Platz des nächsten Mitglieds (%s)"
L["Row cells: this display is laid out; Blizzard refused it %d times for these settings, so no further automatic repair is made until its settings change or the interface is reloaded."] = "Zeilenzellen: Diese Anzeige ist angeordnet; Blizzard hat sie für diese Einstellungen %d Mal abgelehnt, daher erfolgt keine weitere automatische Reparatur, bis ihre Einstellungen geändert werden oder die Benutzeroberfläche neu geladen wird."
L["%d cell(s) could not be hidden, so the display reserves its full length meanwhile."] = "%d Zelle(n) konnten nicht ausgeblendet werden, daher reserviert die Anzeige solange ihre volle Länge."
L["  %s: not built"] = "  %s: nicht erstellt"
L["%d button(s): %s"] = "%d Button(s): %s"
L["FA carriers: %s is not a Modern Aura Group."] = "FA-Träger: %s ist keine Moderne Aura-Gruppe."
L["FA carriers: %s: setting %s"] = "FA-Träger: %s: Einstellung %s"
L["    container %d: %d buttons; callbacks with the container: %d attempted, %d constructed (styled afterwards), %d failed (%d refused operations); later: %d attempted, %d built, %d failed (%d refused operations); of the later ones under restrictions: %d attempted, %d built, %d failed; boxes now: %d placed, %d failed%s"] = "    Container %d: %d Buttons; Callbacks mit dem Container: %d versucht, %d erstellt (danach gestaltet), %d fehlgeschlagen (%d abgelehnte Operationen); später: %d versucht, %d erstellt, %d fehlgeschlagen (%d abgelehnte Operationen); von den späteren unter Einschränkungen: %d versucht, %d erstellt, %d fehlgeschlagen; Boxen jetzt: %d platziert, %d fehlgeschlagen%s"
L["    history since login (all containers of this display, not the current state): later callbacks %d attempted, %d built, %d failed; under restrictions %d attempted, %d built, %d failed"] = "    Verlauf seit Login (alle Container dieser Anzeige, nicht der aktuelle Zustand): spätere Callbacks %d versucht, %d erstellt, %d fehlgeschlagen; unter Einschränkungen %d versucht, %d erstellt, %d fehlgeschlagen"
L["FA carriermarks: %s is not a Modern Aura Group."] = "FA-Trägermarkierungen: %s ist keine Moderne Aura-Gruppe."
L["FA carriermarks: %d mark(s) could not be removed yet; they will be tried again next time."] = "FA-Trägermarkierungen: %d Markierung(en) konnten noch nicht entfernt werden; es wird beim nächsten Mal erneut versucht."
L["FA carriers: %s: setting %s, growth %s, independent group %s, editor open now %s, combat now %s"] = "FA-Träger: %s: Einstellung %s, Wachstum %s, unabhängige Gruppe %s, Editor jetzt offen %s, Kampf jetzt %s"
L["  pin (group frame): %s"] = "  Anheften (Gruppenrahmen): %s"
L["  %s: independent %s, pinned %s, end %s, boxes %s; configured: growth %s, size %sx%s, spacing %s, capacity %s, padding %s, own offset %s,%s"] = "  %s: unabhängig %s, angeheftet %s, Ende %s, Boxen %s; konfiguriert: Wachstum %s, Größe %sx%s, Abstand %s, Kapazität %s, Innenabstand %s, eigener Versatz %s,%s"
L["    start: %s"] = "    Start: %s"
L["    content: %s"] = "    Inhalt: %s"
L["    end in use: %s at %s %s,%s; translated end %s"] = "    Ende in Verwendung: %s bei %s %s,%s; verschobenes Ende %s"
L["    endH: %s"] = "    EndeH: %s"
L["    endP: %s"] = "    EndeP: %s"
L["    endOut: %s"] = "    EndeOut: %s"
L["    container%d: %s"] = "    Container%d: %s"
L["    #%d record %s%s; button %s; H %s; P %s; box %s"] = "    #%d Eintrag %s%s; Button %s; H %s; P %s; Box %s"
L["      art: icon %s; base %s; elements %s; clip %s"] = "      Grafik: Symbol %s; Basis %s; Elemente %s; Clip %s"
L["    #%d no box (not an independent-carrier button); button %s"] = "    #%d keine Box (kein unabhängiger Träger-Button); Button %s"
L["    events (epoch:event@time, flags at that moment): %s"] = "    Ereignisse (Epoche:Ereignis@Zeit, Flags in diesem Moment): %s"
L["FA carriermarks: %s: red pin, cyan member starts, white rings content corners, yellow/orange container TOPLEFT/BOTTOMRIGHT (%d containers), blue native button corners (index below), green box corners (index above; dim = no complete record; %d boxes), magenta translated list ends. %d marker operations failed. Type /fa carriermarks off to remove."] = "FA-Trägermarkierungen: %s: roter Pin, cyanfarbene Mitgliedsanfänge, weiße Ringe Inhaltsecken, gelb/orange Container OBENLINKS/UNTENRECHTS (%d Container), blaue native Button-Ecken (Index unten), grüne Box-Ecken (Index oben; gedimmt = kein vollständiger Eintrag; %d Boxen), magentafarbene verschobene Listenenden. %d Markierungsoperationen fehlgeschlagen. Gib /fa carriermarks off ein, um sie zu entfernen."
L["nothing"] = "nichts"
L["This aura's time or stack filter may leave it blank during combat in a Centered row.\n\nChoose another Grow setting, or move this aura out of the group."] = "Der Zeit- oder Stapelfilter dieser Aura kann sie im Kampf in einer zentrierten Zeile leer lassen.\n\nWähle eine andere Wachstumseinstellung oder verschiebe diese Aura aus der Gruppe."
L["Another aura in this row also uses a time or stack filter. This aura may appear blank or in the wrong place during combat.\n\nMove it to a separate row or group."] = "Eine weitere Aura in dieser Zeile verwendet ebenfalls einen Zeit- oder Stapelfilter. Diese Aura kann im Kampf leer oder an der falschen Stelle erscheinen.\n\nVerschiebe sie in eine eigene Zeile oder Gruppe."
L["Remaining Time shows one aura: the first that matches the trigger, and the time window applies to that one only. Select the spell(s) in the trigger so the window applies to the aura you mean."] = "Die verbleibende Zeit zeigt eine Aura: die erste, die zum Auslöser passt; das Zeitfenster gilt nur für sie. Wähle die Zauber im Auslöser aus, damit das Zeitfenster für die gemeinte Aura gilt."
L["This display will be built when aura restrictions end."] = "Diese Anzeige wird aufgebaut, sobald die Aura-Einschränkungen enden."
L["Blizzard refused the extra units of this display %d times (%s). They are left out until the display's settings change or the interface is reloaded."] = "Blizzard hat die zusätzlichen Einheiten dieser Anzeige %d Mal abgelehnt (%s). Sie werden ausgelassen, bis sich die Einstellungen der Anzeige ändern oder das Interface neu geladen wird."
L["Use old row layout (before 1.1.0)"] = "Altes Zeilenlayout verwenden (vor 1.1.0)"
L["Groups made before 1.1.0 have this ticked so they keep looking the same. Untick it to move this group to the current layout, where the row starts where you place the group, like a Dynamic Group; then place the group where the row should start. This box goes away once unticked."] = "Vor Version 1.1.0 erstellte Gruppen haben dies angehakt, damit sie gleich aussehen. Entferne den Haken, um diese Gruppe auf das aktuelle Layout umzustellen, bei dem die Zeile dort beginnt, wo du die Gruppe platzierst, wie bei einer Dynamischen Gruppe; platziere die Gruppe dann dort, wo die Zeile beginnen soll. Dieses Kästchen verschwindet, sobald der Haken entfernt ist."
L["Won't match:"] = "Passt nicht:"
L["Another unit's spell is secret on this server, in and out of combat; only your own casts can be filtered by spell."] = "Der Zauber einer anderen Einheit ist auf diesem Server geheim, innerhalb und außerhalb des Kampfes; nur deine eigenen Zauber können nach Zauber gefiltert werden."
L["Another unit's casts are secret on this server, in and out of combat: they show with their bar and timer, but cannot be filtered by spell."] = "Zauber anderer Einheiten sind auf diesem Server geheim, innerhalb und außerhalb des Kampfes: Sie werden mit Leiste und Timer angezeigt, können aber nicht nach Zauber gefiltert werden."
L["Money (total copper)"] = "Geld (Kupfer gesamt)"
L["Set up Blizzard's Cooldown Manager for KUIAR_Engine? This changes your CDM settings (backed up) and works on a copy of your Edit Mode layout named \"<layout>-FA\"; your own layout is left as it is. Needs a reload."] = "Blizzards Abklingzeit-Manager für KUIAR_Engine einrichten? Dies ändert deine CDM-Einstellungen (gesichert) und arbeitet mit einer Kopie deines Bearbeitungsmodus-Layouts namens „<layout>-FA“; dein eigenes Layout bleibt unverändert. Erfordert ein Neuladen."
L["A KUIAR_Engine class pack can set up Blizzard's Cooldown Manager for its auras (%d buffs, %d spell cooldowns). This changes your CDM settings and makes a copy of your Edit Mode layout named \"<layout>-FA\" with the viewers always visible; your own layout is left as it is. Needs a reload."] = "Ein KUIAR_Engine-Klassenpaket kann den Cooldown-Manager von Blizzard für seine Auren einrichten (%d Stärkungszauber, %d Zauber-Abklingzeiten). Dadurch ändern sich deine CDM-Einstellungen, und es wird eine Kopie deines Bearbeitungsmodus-Layouts namens \"<Layout>-FA\" mit immer sichtbaren Anzeigen erstellt; dein eigenes Layout bleibt unverändert. Erfordert ein Neuladen."
L["Is Ready"] = "Ist bereit"
L["Elapsed Time"] = "Verstrichene Zeit"
L[" (+%d more)"] = " (+%d weitere)"
L[", remaining %s %s s"] = ", verbleibend %s %s s"
L["A Glow can follow Remaining Time or the pandemic window, not both."] = "Ein Leuchten kann der Restzeit oder dem Pandemie-Fenster folgen, nicht beidem."
L["A Remaining Time glow condition must use < and turn the glow on."] = "Eine Leuchten-Bedingung für die Restzeit muss < verwenden und das Leuchten einschalten."
L["An In Pandemic Window glow condition must turn the glow on."] = "Eine Leuchten-Bedingung für das Pandemie-Fenster muss das Leuchten einschalten."
L["Anchored to a unit frame, nameplate, the mouse or a custom anchor, this display keeps its own position."] = "An einem Einheitenrahmen, einer Namensplakette, der Maus oder einem eigenen Anker verankert, behält diese Anzeige ihre eigene Position."
L["Any (no classification)"] = "Beliebig (keine Klassifizierung)"
L["A condition with an Aura (Modern) check (Aura Active, Remaining Time, In Pandemic Window, Stack Count, dispel type...) cannot use Else If."] = "Eine Bedingung mit einer Aura-(Modern)-Prüfung (Aura aktiv, Restzeit, Im Pandemie-Fenster, Stapelanzahl, Bannart ...) kann kein Sonst-Wenn verwenden."
L["Aura (Modern) in a Dynamic Group: It keeps its position even when no aura is shown. Use a Modern Aura Group to keep dynamic behaviour."] = "Aura (Modern) in einer dynamischen Gruppe: Sie behält ihre Position, auch wenn keine Aura angezeigt wird. Verwende eine Moderne Aura-Gruppe, um das dynamische Verhalten zu behalten."
L["Aura (Modern) time conditions support < and >=."] = "Aura-(Modern)-Zeitbedingungen unterstützen < und >=."
L["Aura (Modern) type conditions support = and !=."] = "Aura-(Modern)-Typbedingungen unterstützen = und !=."
L["Aura (Modern) works on Icon, Progress Bar, Progress Texture, Texture and Text displays."] = "Aura (Modern) funktioniert bei Symbol-, Fortschrittsleisten-, Fortschrittstextur-, Textur- und Textanzeigen."
L["Aura Active"] = "Aura aktiv"
L["Aura Highlight Border Thickness"] = "Randstärke der Aurenhervorhebung"
L["Aura Highlight Color"] = "Farbe der Aurenhervorhebung"
L["Aura Highlight Padding"] = "Innenabstand der Aurenhervorhebung"
L["Aura Highlight Pulse Duration"] = "Pulsdauer der Aurenhervorhebung"
L["Aura Highlight Style"] = "Stil der Aurenhervorhebung"
L["Aura Highlight Texture"] = "Textur der Aurenhervorhebung"
L["Aura Highlight Thickness / Padding"] = "Stärke / Innenabstand der Aurenhervorhebung"
L["Aura(s) Gained, shown %s s"] = "Aura(en) erhalten, angezeigt %s s"
L["Auras Blizzard classifies as big defensives."] = "Auren, die Blizzard als große Defensivfähigkeiten einstuft."
L["Auras Blizzard classifies as external defensives."] = "Auren, die Blizzard als externe Defensivfähigkeiten einstuft."
L["Auras Blizzard identifies as boss auras or marks as relevant to your role."] = "Auren, die Blizzard als Boss-Auren erkennt oder als relevant für deine Rolle markiert."
L["Auras Blizzard identifies as boss auras."] = "Auren, die Blizzard als Boss-Auren erkennt."
L["Auras Blizzard marks as relevant to your role."] = "Auren, die Blizzard als relevant für deine Rolle markiert."
L["Auras Blizzard marks for display on all nameplates."] = "Auren, die Blizzard zur Anzeige auf allen Namensplaketten markiert."
L["Auras Blizzard marks for its personal-debuff display on nameplates."] = "Auren, die Blizzard für seine Anzeige persönlicher Schwächungszauber auf Namensplaketten markiert."
L["Auras Blizzard says your character can apply."] = "Auren, die laut Blizzard dein Charakter wirken kann."
L["Auras cast by any player or player pet, not only yours. For your own auras, use Own Only."] = "Auren, die von einem beliebigen Spieler oder Spielerhaustier gewirkt wurden, nicht nur von dir. Für deine eigenen Auren verwende Nur eigene."
L["Auras cast by you, your pet or your vehicle."] = "Auren, die von dir, deinem Begleiter oder deinem Fahrzeug gewirkt wurden."
L["Auras flagged by Blizzard for raid-frame display in combat."] = "Auren, die Blizzard für die Schlachtzugsrahmen-Anzeige im Kampf markiert."
L["Auras that the player can cancel."] = "Auren, die der Spieler abbrechen kann."
L["Auras with a crowd-control effect, such as a stun or fear."] = "Auren mit einem Massenkontrolleffekt, etwa Betäubung oder Furcht."
L["Big defensive"] = "Große Defensivfähigkeit"
L["Big defensives"] = "Große Defensivfähigkeiten"
L["Blizzard could not create the Aura(s) Missing display: %s"] = "Blizzard konnte die Anzeige Aura(en) fehlen nicht erstellen: %s"
L["Blizzard could not create the Modern Aura Group spacing: %s"] = "Blizzard konnte den Abstand der Modernen Aura-Gruppe nicht erstellen: %s"
L["Blizzard could not create the Remaining Time display: %s"] = "Blizzard konnte die Restzeit-Anzeige nicht erstellen: %s"
L["Blizzard could not register the %s sound for spell %s."] = "Blizzard konnte den Sound %s für Zauber %s nicht registrieren."
L["Blizzard debuff order"] = "Blizzard-Reihenfolge der Schwächungszauber"
L["Blizzard default"] = "Blizzard-Standard"
L["Blizzard hides %s on %s from spell ID filters in combat."] = "Blizzard blendet %s auf %s im Kampf bei Zauber-ID-Filtern aus."
L["Blizzard hides debuffs on %s from spell ID filters in combat: filter by Total Duration =, dispel type and flags instead."] = "Blizzard blendet Schwächungszauber auf %s im Kampf bei Zauber-ID-Filtern aus: Filtere stattdessen nach Gesamtdauer =, Bannart und Flags."
L["Blizzard refused the %s check: %s"] = "Blizzard hat die Prüfung %s abgelehnt: %s"
L["Blizzard refused the Modern Aura Group spacing; this display keeps a fixed space."] = "Blizzard hat den Abstand der Modernen Aura-Gruppe abgelehnt; diese Anzeige behält einen festen Abstand."
L["Blizzard's important-aura flag, including non-stealable enemy buffs shown on nameplates."] = "Blizzards Flag für wichtige Auren, einschließlich nicht stehlbarer Feind-Stärkungszauber, die auf Namensplaketten angezeigt werden."
L["Border (Pulsing)"] = "Rand (pulsierend)"
L["Border thickness in UI units, limited to one quarter of the aura's smaller dimension so the center stays visible. Set style and color in this same condition."] = "Randstärke in UI-Einheiten, begrenzt auf ein Viertel der kleineren Abmessung der Aura, damit die Mitte sichtbar bleibt. Stil und Farbe in derselben Bedingung festlegen."
L["Boss or role aura"] = "Boss- oder Rollenaura"
L["Bounce In"] = "Hereinhüpfen"
L["Buff Is Not Stealable"] = "Stärkungszauber ist nicht stehlbar"
L["Buff Is Stealable"] = "Stärkungszauber ist stehlbar"
L["Buffs that can be stolen with abilities such as Spellsteal."] = "Stärkungszauber, die mit Fähigkeiten wie Zauberraub gestohlen werden können."
L["Buffs you can apply, or debuffs you can dispel."] = "Stärkungszauber, die du wirken kannst, oder Schwächungszauber, die du bannen kannst."
L["CDM Category"] = "CDM-Kategorie"
L["Can Apply Aura"] = "Kann Aura wirken"
L["Can apply / dispel"] = "Kann wirken / bannen"
L["Cancelable"] = "Abbrechbar"
L["Cannot load Blizzard_AuraContainer: %s"] = "Blizzard_AuraContainer kann nicht geladen werden: %s"
L["Cast by a Player"] = "Von einem Spieler gewirkt"
L["Choose Action Button Glow, Pixel Glow, Autocast Shine or Proc Glow."] = "Wähle Aktionstasten-Leuchten, Pixel-Leuchten, Autocast-Schimmern oder Proc-Leuchten."
L["Choose a sound file in Actions."] = "Wähle eine Sounddatei unter Aktionen."
L["Choose a supported Blizzard classification."] = "Wähle eine unterstützte Blizzard-Klassifizierung."
L["Choose a supported sort order."] = "Wähle eine unterstützte Sortierreihenfolge."
L["Choose a supported unit and Buff or Debuff."] = "Wähle eine unterstützte Einheit und Stärkungs- oder Schwächungszauber."
L["Choose supported Blizzard aura filters."] = "Wähle unterstützte Blizzard-Aurenfilter."
L["Choose supported dispel types."] = "Wähle unterstützte Bannarten."
L["Cooldown Manager entries"] = "Cooldown-Manager-Einträge"
L["Crowd control"] = "Massenkontrolle"
L["Custom Texture"] = "Benutzerdefinierte Textur"
L["Debuffs Blizzard marks as high priority."] = "Schwächungszauber, die Blizzard als hochpriorisiert markiert."
L["Debuffs on you or your pet can't be found by spell ID in combat: filter by Total Duration =, dispel type and flags instead."] = "Schwächungszauber auf dir oder deinem Begleiter können im Kampf nicht per Zauber-ID gefunden werden: Filtere stattdessen nach Gesamtdauer =, Bannart und Flags."
L["Detached Text uses hardcoded text. Use other triggers and Conditions to control when it appears."] = "Abgetrennter Text verwendet fest codierten Text. Verwende andere Auslöser und Bedingungen, um zu steuern, wann er erscheint."
L["Dispel Type"] = "Bannart"
L["Dispellable"] = "Bannbar"
L["Dispellable by someone in your raid"] = "Von jemandem in deinem Schlachtzug bannbar"
L["Dispellable raid debuff"] = "Bannbarer Schlachtzugs-Schwächungszauber"
L["Dispellable regardless of your or your raid's current abilities."] = "Bannbar, unabhängig von den aktuellen Fähigkeiten von dir oder deinem Schlachtzug."
L["Display changes will apply when aura restrictions end."] = "Anzeigeänderungen werden angewendet, wenn die Aurenbeschränkungen enden."
L["Displayed in CDM"] = "Im CDM angezeigt"
L["Each aura spell ID must be a positive whole number."] = "Jede Aura-Zauber-ID muss eine positive ganze Zahl sein."
L["Elapsed Time (%)"] = "Verstrichene Zeit (%)"
L["Enable Name(s) or Exact Spell ID(s) in the Trigger and enter a spell that is not ignored to use aura sounds."] = "Aktiviere Name(n) oder Exakte Zauber-ID(s) im Auslöser und gib einen Zauber ein, der nicht ignoriert wird, um Aurasounds zu verwenden."
L["End Time (game clock)"] = "Endzeit (Spieluhr)"
L["Enter a Specific Unit such as party1, raid5, boss1 or arena2."] = "Gib eine bestimmte Einheit wie party1, raid5, boss1 oder arena2 ein."
L["Enter an aura name or spell ID, or untick Name(s)."] = "Gib einen Aura-Namen oder eine Zauber-ID ein, oder deaktiviere Name(n)."
L["Enter an exact spell ID, or untick Exact Spell IDs to show all matching auras."] = "Gib eine exakte Zauber-ID ein, oder deaktiviere Exakte Zauber-IDs, um alle passenden Auren anzuzeigen."
L["Enter an ignored spell ID, or untick Ignored Exact Spell IDs."] = "Gib eine ignorierte Zauber-ID ein, oder deaktiviere Ignorierte exakte Zauber-IDs."
L["Exact Spell IDs"] = "Exakte Zauber-IDs"
L["External defensive"] = "Externe Defensivfähigkeit"
L["Extra space around a glow or custom texture, in UI units. Overlay always fills the aura and ignores padding. Set style and color in this same condition."] = "Zusätzlicher Platz um ein Leuchten oder eine benutzerdefinierte Textur, in UI-Einheiten. Die Überlagerung füllt die Aura immer aus und ignoriert den Innenabstand. Stil und Farbe in derselben Bedingung festlegen."
L["KUIAR_Engine has changed CDM settings. Reload to apply them."] = "KUIAR_Engine hat CDM-Einstellungen geändert. Lade neu, um sie anzuwenden."
L["Friendly units only."] = "Nur freundliche Einheiten."
L["Glow (Pulsing)"] = "Leuchten (pulsierend)"
L["Glow (Static)"] = "Leuchten (statisch)"
L["Glow starts once the aura's duration is known."] = "Das Leuchten beginnt, sobald die Dauer der Aura bekannt ist."
L["Grouped by nameplate, choose the Nameplate unit."] = "Nach Namensplakette gruppiert, wähle die Namensplaketten-Einheit."
L["Grouped by unit frame or nameplate, use Show On: Aura(s) Found."] = "Nach Einheitenrahmen oder Namensplakette gruppiert, verwende Anzeigen bei: Aura(en) gefunden."
L["Grouped by unit frame, choose a unit other than Nameplate."] = "Nach Einheitenrahmen gruppiert, wähle eine andere Einheit als Namensplakette."
L["Groups inside a Modern Aura Group keep their own position."] = "Gruppen innerhalb einer Modernen Aura-Gruppe behalten ihre eigene Position."
L["Hostile units only."] = "Nur feindliche Einheiten."
L["Ignore buff classification"] = "Stärkungszauber-Klassifizierung ignorieren"
L["Ignore debuff classification"] = "Schwächungszauber-Klassifizierung ignorieren"
L["Ignore dispel classification"] = "Bannarten-Klassifizierung ignorieren"
L["Importance only"] = "Nur Wichtigkeit"
L["Important aura"] = "Wichtige Aura"
L["In Pandemic Window"] = "Im Pandemie-Fenster"
L["In a Dynamic Group it keeps a fixed position; a Modern Aura Group is recommended."] = "In einer Dynamischen Gruppe behält sie eine feste Position; eine Moderne Aura-Gruppe wird empfohlen."
L["In a Grid layout, Remaining Time, Total Duration and Stack Count filters are not available. This aura is shown at its own position."] = "In einem Raster-Layout sind die Filter für Restzeit, Gesamtdauer und Stapelanzahl nicht verfügbar. Diese Aura wird an ihrer eigenen Position angezeigt."
L["In a Grid layout, choose one unit (Player, Target, Focus, Pet...). This aura is shown at its own position."] = "Wähle in einem Raster-Layout eine Einheit (Spieler, Ziel, Fokus, Begleiter ...). Diese Aura wird an ihrer eigenen Position angezeigt."
L["In a Grid layout, every aura watches the same unit as the first one. This aura is shown at its own position."] = "In einem Raster-Layout beobachtet jede Aura dieselbe Einheit wie die erste. Diese Aura wird an ihrer eigenen Position angezeigt."
L["In a Grid layout, use Show On: Aura(s) Found. This aura is shown at its own position."] = "Verwende in einem Raster-Layout Anzeigen bei: Aura(en) gefunden. Diese Aura wird an ihrer eigenen Position angezeigt."
L["In a Grid, Remaining Time is not available."] = "In einem Raster ist die Restzeit nicht verfügbar."
L["In a Modern Aura Group, use an Icon, Progress Bar, Progress Texture, Texture or Text display."] = "Verwende in einer Modernen Aura-Gruppe eine Symbol-, Fortschrittsleisten-, Fortschrittstextur-, Textur- oder Textanzeige."
L["Include global cooldown"] = "Globale Abklingzeit einbeziehen"
L["Includes helpful enrages on enemies."] = "Enthält hilfreiche Wutanfälle bei Feinden."
L["Incompatible condition."] = "Inkompatible Bedingung."
L["Invalid aura filter: %s"] = "Ungültiger Aurenfilter: %s"
L["Invalid classification option: %s"] = "Ungültige Klassifizierungsoption: %s"
L["Is Boss Aura"] = "Ist Boss-Aura"
L["Is Stealable"] = "Ist stehlbar"
L["Item ID"] = "Gegenstands-ID"
L["Marked for all nameplates"] = "Für alle Namensplaketten markiert"
L["Marked for personal debuff display"] = "Für die Anzeige persönlicher Schwächungszauber markiert"
L["Maximum total duration must be a positive number."] = "Die maximale Gesamtdauer muss eine positive Zahl sein."
L["Mouseover"] = "Bei Mouseover"
L["Name (Blizzard priority)"] = "Name (Blizzard-Priorität)"
L["No recording for '%s' in the selected FojjiCore voice pack."] = "Keine Aufnahme für '%s' im gewählten FojjiCore-Sprachpaket."
L["On the screen, Aura(s) Missing, Always and Remaining Time watch one unit: choose Player, Target, Focus, Pet, Target of Target, Target of Focus, Pet Target or a Specific Unit. Anchored to unit frames or nameplates, Missing and Always work for every unit."] = "Auf dem Bildschirm beobachten Aura(en) fehlen, Immer und Restzeit eine Einheit: Wähle Spieler, Ziel, Fokus, Begleiter, Ziel des Ziels, Ziel des Fokus, Begleiterziel oder eine bestimmte Einheit. An Einheitenrahmen oder Namensplaketten verankert funktionieren Fehlt und Immer für jede Einheit."
L["On this display type, Remaining Time can't be combined with Total Duration = or >=."] = "Bei diesem Anzeigetyp kann die Restzeit nicht mit Gesamtdauer = oder >= kombiniert werden."
L["Only Aura Active can be combined with All of / Any of, once, with ordinary checks."] = "Nur „Aura aktiv“ kann mit „Alle von“ / „Eine von“ kombiniert werden, einmalig, mit normalen Prüfungen."
L["Order applied"] = "Reihenfolge angewendet"
L["Overlay"] = "Überlagerung"
L["Own Only"] = "Nur eigene"
L["PLAYER"] = "SPIELER"
L["Pet Target"] = "Ziel des Begleiters"
L["Preview only: these auras will not display in combat with spell ID filters.\nConfigured sounds in Actions can still play."] = "Nur Vorschau: Diese Auren werden im Kampf mit Zauber-ID-Filtern nicht angezeigt.\nKonfigurierte Sounds unter Aktionen können trotzdem abgespielt werden."
L["Priority debuff"] = "Priorisierter Schwächungszauber"
L["RAID"] = "SCHLACHTZUG"
L["Ready"] = "Bereit"
L["Recharging"] = "Lädt auf"
L["Remaining Time (%)"] = "Verbleibende Zeit (%)"
L["Remaining Time can't anchor to unit frames or nameplates."] = "Die verbleibende Zeit kann nicht an Einheitenrahmen oder Namensplaketten verankert werden."
L["Remaining Time needs a comparison and a number of seconds of 0 or more."] = "Die verbleibende Zeit braucht einen Vergleich und eine Sekundenzahl von 0 oder mehr."
L["Remaining time"] = "Verbleibende Zeit"
L["Remaining time (Blizzard priority)"] = "Verbleibende Zeit (Blizzard-Priorität)"
L["Role aura"] = "Rollenaura"
L["With an Aura (Modern) trigger, On Show/On Hide support Play Sound and Hide Glows only. Custom Init is available."] = "Bei einem Aura-(Modern)-Auslöser unterstützen „Beim Anzeigen“/„Beim Ausblenden“ nur „Sound abspielen“ und „Leuchten ausblenden“. Eigene Initialisierung ist verfügbar."
L["With an Aura (Modern) trigger, the display's own Start/Main/Finish animations do not play; use the aura animations on the Animations tab."] = "Bei einem Aura-(Modern)-Auslöser werden die Start-/Haupt-/Ende-Animationen der Anzeige nicht abgespielt; nutze die Aura-Animationen im Reiter „Animationen“."
L["Secret Auras"] = "Geheime Auren"
L["Secret aura sounds support sound files, not Sound Kit IDs or Stop Sound."] = "Sounds geheimer Auren unterstützen Sounddateien, keine Sound-Kit-IDs oder „Sound stoppen“."
L["Secret auras support one text element for each of %p, %s and %n. Remove the duplicate or turn off Show Text."] = "Geheime Auren unterstützen je ein Textelement für %p, %s und %n. Entferne das Duplikat oder schalte „Text anzeigen“ aus."
L["Select one recorded voice pack in FojjiCore. Recorded sounds cannot use synthesized TTS or random favorites."] = "Wähle ein aufgenommenes Sprachpaket in FojjiCore. Aufgenommene Sounds können keine synthetische TTS oder zufälligen Favoriten verwenden."
L["Set Dynamic Information to this trigger."] = "Dynamische Informationen auf diesen Auslöser setzen."
L["Shown on raid frames in combat"] = "Im Kampf an Schlachtzugsrahmen angezeigt"
L["Sounds in Actions still play."] = "Sounds unter Aktionen werden weiterhin abgespielt."
L["Speech is disabled in FojjiCore."] = "Sprachausgabe ist in FojjiCore deaktiviert."
L["Spell IDs (All Ranks)"] = "Zauber-IDs (alle Ränge)"
L["Spell In Range"] = "Zauber in Reichweite"
L["Spin In"] = "Hineindrehen"
L["Stack Count < 0 never matches."] = "Stapelanzahl < 0 passt nie."
L["Stack Count can't anchor to unit frames or nameplates."] = "Die Stapelanzahl kann nicht an Einheitenrahmen oder Namensplaketten verankert werden."
L["Stack Count can't be combined with Total Duration = or >=."] = "Die Stapelanzahl kann nicht mit Gesamtdauer = oder >= kombiniert werden."
L["Stack Count needs a whole number from 0 to %d."] = "Die Stapelanzahl braucht eine ganze Zahl von 0 bis %d."
L["Stack Count only works with Show On: Aura(s) Found, without Remaining Time."] = "Die Stapelanzahl funktioniert nur mit „Anzeigen bei: Gefundene Aura(en)“, ohne verbleibende Zeit."
L["Start Time (game clock)"] = "Startzeit (Spieluhr)"
L["Target of Focus"] = "Ziel des Fokus"
L["Target of Target"] = "Ziel des Ziels"
L["The Remaining Time glow could not be measured; it stays off."] = "Das Leuchten für die verbleibende Zeit konnte nicht gemessen werden; es bleibt aus."
L["This client can't check Remaining Time on this display type."] = "Dieser Client kann die verbleibende Zeit bei diesem Anzeigetyp nicht prüfen."
L["This client can't check Stack Count."] = "Dieser Client kann die Stapelanzahl nicht prüfen."
L["This client can't check Total Duration = or >=."] = "Dieser Client kann Gesamtdauer = oder >= nicht prüfen."
L["This client cannot limit auras by Remaining Time."] = "Dieser Client kann Auren nicht nach verbleibender Zeit begrenzen."
L["This client does not expose nameplate frames."] = "Dieser Client stellt keine Namensplaketten-Rahmen bereit."
L["This client does not provide native aura sound registration."] = "Dieser Client bietet keine native Registrierung von Aura-Sounds."
L["This client does not support native circular Progress Textures."] = "Dieser Client unterstützt keine nativen kreisförmigen Fortschrittstexturen."
L["This client does not support the selected Blizzard aura filters."] = "Dieser Client unterstützt die gewählten Blizzard-Aurafilter nicht."
L["This sub element is not supported by Secret Auras. Use Text, Texture or Glow."] = "Dieses Unterelement wird von geheimen Auren nicht unterstützt. Nutze Text, Textur oder Leuchten."
L["Timer Available"] = "Timer verfügbar"
L["Total Duration = and >= can't anchor to unit frames or nameplates."] = "Gesamtdauer = und >= können nicht an Einheitenrahmen oder Namensplaketten verankert werden."
L["Total Duration = and >= only work with Show On: Aura(s) Found, without Remaining Time."] = "Gesamtdauer = und >= funktionieren nur mit „Anzeigen bei: Gefundene Aura(en)“, ohne verbleibende Zeit."
L["Trigger Combination: the trigger chosen for when Aura (Modern) filters are not met no longer exists or is an Aura (Modern) trigger."] = "Auslöserkombination: Der Auslöser, der gewählt wurde, wenn die Aura-(Modern)-Filter nicht erfüllt sind, existiert nicht mehr oder ist ein Aura-(Modern)-Auslöser."
L["Unavailable in this specialization"] = "In dieser Spezialisierung nicht verfügbar"
L["Unit-frame debuff sorting requires the Debuff or Dispellable raid debuff classification."] = "Die Sortierung von Schwächungszaubern an Einheitenrahmen erfordert die Klassifizierung Schwächungszauber oder Bannbarer Schlachtzugs-Schwächungszauber."
L["Use dispellable-debuff classification"] = "Klassifizierung bannbarer Schwächungszauber verwenden"
L["Use one time basis per countdown text: seconds, percentage, elapsed, total, start, or end."] = "Verwende pro Countdown-Text eine Zeitbasis: Sekunden, Prozent, verstrichen, gesamt, Start oder Ende."
L["With Centered growth this display keeps its own position: only icons and texts join a centred row (with the old row layout off, also textures, bars and progress textures)."] = "Bei zentriertem Wachstum behält diese Anzeige ihre eigene Position: Nur Symbole und Texte schließen sich einer zentrierten Zeile an (bei ausgeschaltetem altem Zeilenlayout auch Texturen, Leisten und Fortschrittstexturen)."
L["With Grid or Group by Frame, only Aura (Modern) displays line up. This display keeps its own position."] = "Bei Raster oder Gruppierung nach Rahmen werden nur Aura-(Modern)-Anzeigen ausgerichtet. Diese Anzeige behält ihre eigene Position."
L["With Remaining Time, countdown conditions must use Remaining Time in seconds."] = "Bei verbleibender Zeit müssen Countdown-Bedingungen die verbleibende Zeit in Sekunden verwenden."
L["Won't work:"] = "Funktioniert nicht:"
L["Works in combat."] = "Funktioniert im Kampf."
L["You can only use %p, %s, %n, %l or hardcoded text. Put each code in its own text element. Custom text (%c) is not supported."] = "Du kannst nur %p, %s, %n, %l oder festen Text verwenden. Setze jeden Code in ein eigenes Textelement. Eigener Text (%c) wird nicht unterstützt."
L["Zoom In"] = "Einzoomen"
L["Apply"] = "Anwenden"
L["Not now"] = "Nicht jetzt"
L["Don't ask again"] = "Nicht mehr fragen"
L["Hitch capture armed for the next reload: frames slower than %dms are reported from addon load until %d s after entering the world."] = "Ruckler-Aufzeichnung für das nächste Neuladen scharfgestellt: Frames, die langsamer als %dms sind, werden vom Laden des Addons bis %d s nach dem Betreten der Welt gemeldet."
L["Entered the world; hitch capture continues for %d s."] = "Die Welt betreten; die Ruckler-Aufzeichnung läuft noch %d s weiter."
L["/wa phitch login [ms] [seconds] - Run the hitch capture through the next reload and login, then print the load time and profile"] = "/wa phitch login [ms] [Sekunden] - Die Ruckler-Aufzeichnung über das nächste Neuladen und den Login ausführen, dann Ladezeit und Profil ausgeben"

end)
