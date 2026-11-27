# KullThranUI Changelog

Current addon version: **2.0.4**

Primary source: https://addons.wago.io/addons/kullthranui-forever/versions
Secondary source: https://www.curseforge.com/wow/addons/kullthranui-forever/files/all?page=1&pageSize=20&showAlphaFiles=show

## 2.0.4 (2026-11-27)
- Action Bars: both end caps of the main bar always show. The right one no longer goes missing when the bags bar is moved, hidden or on another row.
- Resource Bars: on Forever the class resource is combo points only (Rogue, Cat Form). A Warlock or any other class no longer gets a row of empty yellow pips.
- Resource Bars: new Pip Style option under Resource 1: follow the visual style, flat pips, KUI points, Retail or Forever. Combo points draw with their own socket and gem.
- Resource Bars and Unit Frames: health, power and mana numbers count to their new value together with the bar instead of jumping in steps. The Smooth option turns it off.
- Aura Reminders: a class buff (Battle Shout, Fortitude, Mark of the Wild, Arcane Intellect) that runs out or is removed during combat is reminded again right away, not only after combat.
- World Map: the window portrait (such as OpenMap's icon) draws above the KUI window border instead of under it.

## 2.0.3 (2026-11-25)
- Unit Frames: health, power and alternate mana bars glide to their new values in every visual style. Changing resource (a druid form) jumps at once instead of sliding from the old one.
- Bags: rarity frames are easier to read. Blue, purple and the other coloured qualities use their full colour with a soft glow, and grey items get a darker frame so they no longer look like white ones.
- Bags: items an active quest asks for (Un'Goro Soil, Dark Iron Residue...) get a turquoise border of their own; yellow stays for quest items and items that start a quest. Quest borders update when you accept or finish a quest. Only items the game ties to one of your quests are marked, as in the default bags, and items that start a quest show the game's ! mark. Quest items no quest needs any more leave the Quest category. Common (white) items now take a white tint too.
- Bags: white crafting reagents get a coral frame. Bags > Item Slots > Highlight Reagents turns it off.
- Bank: item slots show the same rarity frames as the bags and follow the same options.
- Gold input popups (such as the guild bank deposit): the amount you type no longer sits under the coin icon.
- Chat: whispers play the game's whisper sound, like the default chat. Chat > Whisper Sound turns it off.
- Gossip: dialogue options no longer overlap; their rows are measured with the same font they are drawn with.
- /loot: opening the window shows the current state of every roll instead of the state when the loot dropped.
- Aura Reminders: missing group buffs show again in combat for the buffs the game lets addons read in combat, and clear when the buff is cast.
- Aura Reminders: Mark of the Wild, Fortitude, Arcane Intellect, Battle Shout and Devotion Aura no longer show as missing when the buff is already on you, cast by you or by a group member under any rank. This includes combat and instances, where the game hides auras from addons. A buff you cast during combat clears its icon at once.
- Profiles: switching profile (also from a layout import) keeps the specialization assignment and the nameplate and Aura Reminders settings in step, so a reload no longer brings the old profile back. Teleport Menu, Cursor, Buffs, Flight Master and Party Frames follow a profile switch or reset at once.
- Profiles: the full KUI reset from the options runs again (a duplicate popup replaced it), and resets and imports keep the character's identity data.
- Translations: the Enhancements card title is no longer in capitals in German, French, Italian, Portuguese and Russian; several wrong or broken texts were fixed and about 35 texts that showed in English are translated.

## 2.0.2 (2026-11-23)
- Armory: the stats panel shows the stats of Forever's own character sheet, with the same sections, order, names and values, and the resistances of the five schools. Rows the game's sheet hides are left out.
- Armory: while you have a pet with a character page, a Pet tab shows it: its model, experience and happiness, and its stats in the list of the Armory.
- Armory: the Progress page is made for Forever. It shows your level, experience and rested experience, the dungeons you completed with their runs and best time, raid lockouts, your PvP rank with this week's cap, and the skill of your professions.
- Armory and Inspect Armory: the specialization icon no longer repeats the class icon beside it. On the inspect window the header icons keep one order: background, specialization, class.
- Dungeon Tracker: the tracker offers once, when you enter a dungeon and before the first fight, to save the run by reloading the UI. After a crash or a closed game a saved run goes on with its time, XP and gold instead of starting again.
- Dungeon Tracker: gold has its own row and shows gold and silver; it counts all the money earned in the run, quests included.
- Dungeon Tracker: walking back in after a wipe no longer restarts the run, and outside the dungeon the tracker only shows during the corpse run of a death in it.
- Dungeon Tracker: finished dungeons are remembered for each character with their best time. A run joined with bosses already dead does not count for the best time, and Finish Dungeon Run with bosses left only stops the clock.
- Profiles: a profile or Dungeon Tracker export no longer carries the dungeon run in progress, and importing one keeps yours.
- Skins: the Professions window is skinned as a whole: the overview page with its entries and rank bars, and the profession tabs on the right, with the open one in the accent colour. Profession cards are no longer turned black.
- Skins: hovering an item in the loot rolls window no longer causes errors, and the window no longer rebuilds itself on every frame in some cases.
- Cooldown Manager: spells saved on the Cooldowns or Utility bar keep showing after you train a new rank. Before, the options preview showed them but the bar in game left them out until the spell was added again.
- Minimap: on the square map the zone name sits in a title bar joined to the map's frame, in the look of your Visual Style; a name too long for the bar is cut at its ends. The Forever style wears the bronze frame of that client's windows, and the buttons around the map move out to clear it. The options preview and the installer show the same.
- Bags: hover your gold to see the gold of every character, the one you play first and then the richest, with the total. Gold waiting in their mailboxes is listed apart, and gold you mail to one of your own characters counts there at once. Log in to each character once to add it.
- Bags: the search box has a button to clear the search.
- Bags: slot borders no longer lose an edge at some window scales; the grid lines up with the pixels of your screen.
- Chat: the whisper buttons are squares with the name of the person on their bubble, pink for whispers and blue for Battle.net, in the art of your chat style. They sit in a column right beside the chat, with a second column when the first one is full, and the close button of each shows while the mouse is over it.
- Chat: whisper conversations keep their place instead of jumping to the front; a new one goes last, or takes the place of the one unused for longest when there is no room.
- Unit Frames: new Portrait Mode card in the options to set 2D, 3D or class portraits, with the zoom, rotation and offsets of 3D, for every frame at once or one by one.
- Unit Frames: a unit whose level is hidden because it is far above yours shows Blizzard's skull in place of a red "??", as on Blizzard's target frame. In combat the combat icon takes that spot, as before.
- Unit Frames: the PvP badge sits on the outer side of the portrait, whichever side the portrait is on, instead of over the name.
- Unit Frames: Aura Spacing only changes the gap between icons; it no longer moves the auras away from the frame. Turning the player's buffs on or off or changing how many show applies at once, and their icons match the target's.
- Unit Frames: aura icons no longer overlap or move when the icon size or frame layout changes in combat; the change applies when the combat ends. Stack and time texts are drawn above the icon border.
- Party Frames: leaving a raid or battleground back into your party no longer leaves a player from that raid drawn on a party member's frame.
- Party Frames: some raid sizes no longer leave a member's frame undrawn, or showing the previous player, when the group fills.
- Resource Bars: a bar or the stack being moved in Unlock Mode stays where you put it when the bars are rebuilt (a shapeshift, for example), and the movers follow the bars. The stack keeps its bottom edge where you drop it, so showing, hiding or detaching a bar no longer moves the others. Reset puts the stack back over the Cooldown Manager.
- Settings: the one-time reset window has a goblin miner on the right of its sign in place of the mechanostrider rider.

## 2.0.1 (2026-11-19)
- Dungeon Tracker: each boss has a small round portrait next to its name, greyed once the boss is dead. Classic dungeon bosses have theirs built in, and other bosses get theirs the first time you see them. The test run and the installer preview show the portraits too.
- Party Frames: the missing-buff reminder hides in combat and comes back after it. It no longer shows on members who have the buff from any rank or from a Forever-only version of the spell, it now also shows on members out of spell range, members too far away to be seen keep their last known state, and dead or offline members never get it.
- Party Frames: power bars take the colour of each member's resource (red for rage, yellow for energy and so on) instead of always mana blue; mana keeps KUI's blue.
- Unit Frames: Rage and Runic Power texts show the real value (34, not 341) on the unit frames, party frames and Resource Bars.
- World Map: zones you collapse in the quest log stay collapsed for the session when the map changes zone or you hover a quest on the map; expanding a zone on the list opens it again. When another addon, such as a quest guide, expands every zone, KUI leaves it alone.
- Unit Frames: the options page is laid out as cards on the left: General, Name & Level, Portrait, one card per frame (Player, Pet, Target, Focus, Target of Target, Boss) and Portrait Auras. A frame's card has its size, bars and text on the left and its portrait, castbar and auras on the right. Search results, Unlock Mode's Open Configuration and clicks on the preview open the right card.
- Party Frames: the options page is laid out as cards on the left: General, Layout, Appearance, Indicators, Auras, Dispel & Missing Buffs, Spell Visibility, Portrait Auras and Profiles. The group cards edit the group picked in the bar above them, the level and PvP icon settings are under Indicators, and search results open the right card.
- Bags: a more compact window. The header, toolbar and footer are thinner, the gaps and item spacing are smaller, and the footer fits on one line, with the selected item's name cut before the gold and currencies. The Options, Compact and Close buttons and the toolbar buttons are now small icon buttons with KUI's own icons and tooltips; the compact view button is lit while that view is on.
- Bags: the watched items button shows an eye and how many items you watch. Click it to show only the watched items and again to show everything; its tooltip reminds you that Alt-click watches an item.
- Bags: newly looted items get a pink border. The bag slot icons are smaller by default (the old default size moves to the new one, a size you chose is kept) and can go down to 16; the toolbar grows when you set them larger.
- Bags: opening a vendor, bank or mailbox with the bags already open no longer closes them, and closing that window only closes the bags if it was the one that opened them.
- Unlock Mode: dragging a unit frame moves only that frame. The frames laid out around it (Pet, Focus, Target of Target, Focus Target, Combat Timer and Combat Res) stay where they are; hold Ctrl while dragging or nudging with the arrow keys to bring them along. Typing coordinates or centring a frame also leaves them in place, and the help panel explains it.
- Unlock Mode: opening Blizzard's Edit Mode pauses Unlock Mode and keeps your unsaved changes, and closing Edit Mode brings it back, instead of closing Unlock Mode.
- Unlock Mode: the Focus mover sits on the Focus frame in its default place under the Player frame, instead of in the middle of the screen, when you have no focus.
- Cooldown Manager: a character with no specialization yet, and the Buffs bar, follow Blizzard's Cooldown Manager as it is, so spells learned later and buffs not active at the time of the import are no longer left out. Spell lists saved for another specialization (a profile shared with another class or spec) no longer filter this character's bars.
- Cooldown Manager: turning the bars on (installer, options or a profile change) also turns on Blizzard's Cooldown Manager, which fills them. Importing the Blizzard layout can read it before Blizzard's bars have been shown, says why when Blizzard's Cooldown Manager is not available yet (a level requirement, for example), and the installer's button only says Layout Imported when something was imported.
- Aura Reminders: group buff reminders (Mark of the Wild, Power Word: Fortitude, Arcane Intellect and the rest) hide when combat starts and come back when it ends.
- Aura Reminders: Hide Blizzard's CDM no longer hides KUI's Cooldown Manager bars, which show Blizzard's icons, and while KUI's Cooldown Manager is on, the class pack setup leaves the cooldown bars to it.
- Cast Bar: applying a different style asks for a reload, as on the Experience Bar page; applying the style you already use does not.
- Profiles: a profile name that runs past 50 characters with the KullThranUI Forever prefix (a long character and realm name, for example) is saved shortened, so it no longer causes an error when another addon loads the same profile library. Profile lists still show the full name, and existing long profiles are renamed once.
- Settings: the one-time reset window for players coming from an earlier version is now an Under construction! sign, with a gnome in a hard hat hammering on one side and a goblin on a mechanostrider on the other. It says the fresh start is required since 2.0.0; the reset itself works as before.
- Options: the section cards beside the Unit Frames, Party Frames and Nameplates options scroll the page with the mouse wheel, and shrink to fit the window when it is short.
- Party Frames: the Spell Visibility list scrolls with the mouse wheel again.
- Loot Rolls: while a roll is up, left and right clicks on the world above the rolls work again; the empty space the game keeps for the rolls no longer catches them.
- Resource Bars: each bar (class resource, power, extra mana, health and the autoattack bars) can be detached from the stack in its options and moved on its own in Unlock Mode. Until you move it, it keeps its place in the stack.
- Resource Bars: the autoattack bars have style cards (KUI Style, Forever, Retail, Classic), like the Cast Bar.

## 2.0.0 (2026-11-19)
- Settings: 2.0.0 starts clean. If you played an earlier version, a one-time window resets KullThranUI: all its saved settings and profiles are deleted, the UI reloads and the installer opens. The reset is required to use 2.0.0; a new install does not see the window.
- Bags: new Category List options. Hide the whole category list (the arrow beside the size button narrows the window to the item grid, and the arrow left of the grid title brings it back), turn the category icons off, or switch between KUI's own category icons and the game's item icons.
- Bags: new Item Slots options. Rarity Frame gives each slot the Armory slot frame of your Visual Style tinted by quality, a coloured edge or nothing; Rarity Colour From sets the lowest quality that gets a colour. Grey Out Junk, Highlight New Items and Highlight Quest Items join the item level options here.
- Bags: new Accessibility options. Text Size enlarges the category list, category titles, item counts and item levels; Window Scale sizes the whole window (the same value as the scale in Unlock Mode) and is kept after a reload.
- Bags: smart search. Type a name, a type (weapon, enchant, gem, potion), a slot (ring, head), a quality (epic) or an item level (ilvl>200, 200-250). Words combine, || means or and ! means not; English and Spanish words work in any client language. The empty search box shows what it understands.
- Bags: new Equipped Bags options to show your bag slots and set their icon size. The toolbar button for them has its own icon and is lit while they are shown.
- Dungeon Tracker: shows how long the run has taken (from the first fight to the last boss, corpse runs included), the XP and gold the mobs gave (quest rewards, vendors and trades left out) and the time each boss died.
- Dungeon Tracker: rares seen in the dungeon are listed under their own heading. A living rare pulses and plays an alert sound until you click it or it dies.
- Dungeon Tracker: click a boss or rare on the tracker to target it; a rare also gets a skull. Right-click the dungeon name for the tracker options, and hover it for buttons that hide the tracker for this run or restart the run. /ktdungeon show and /ktdungeon hide do the same from chat.
- Dungeon Tracker: new options Show Time, Show Mobs XP, Show Gold, Show Bosses, Show Rares, Rare Alert Sound and Show When Solo, plus Time Font Size, Time Color and Completed Time Color. The options preview shows them all.
- Dungeon Tracker: the tracker stays up during a corpse run, and a boss killed again after you left and came back starts a new run (a dungeon reset by the group leader).
- Compatibility: the addon list has tabs for Conflicts, Installed/Disabled, Ignored and Recognized Addons (every addon KUI knows, installed ones in green), and a search by addon name, category or KUI module.
- Compatibility: new Ignore button. An ignored addon keeps running and is left out of the login warning and of Disable All; Stop Ignoring All clears the list.
- Compatibility: new Warn At Login For setting: all conflicts, medium and high risk, or high risk only. The installer's conflict page follows it.
- Compatibility: each category shows whether it is a conflict or an overlap, its risk and the KUI modules it affects, and each addon shows its own description.
- Compatibility: many more addons are recognised, among them AzeriteUI, RealUI, LUI, KkthnxUI, DuffedUI, ShestakUI, LiteBag, DJBags, Bagshui, Skada, Recount, TinyDPS, XPerl, Luna Unit Frames, TinyTooltip, TipTop, Narcissus and IceHUD, with new categories for Resource Bars, Buffs & Debuffs and Experience Bar.
- Inspect Armory: new Inspect Style picker with the slot frames, class icon frame and glyphs of each Visual Style, and new Slot Borders options: Show Slot Borders, Tint Border by Quality and Tint Strength.
- Unit Frames: new First Name Only (Hide Surname) option and Player / Target Name Y Offset slider under Global.
- Unit Frames: the Player and Target PvP badges can be moved in Unlock Mode and keep following their frame.
- Cast Bar: new Show Text Plate option for the Retail and Forever styles. Without the plate, the spell name shows inside the bar.
- Options: search ranks results with modules first, then their sections, then options, and shows where each result lives (Module > Section). Accents and spaces do not matter ("castbar" finds Cast Bar), every Enhancements category, Nameplates card and Aura Reminders page is searched, and a result opens the right tab. Profile and frame lists filter the same way.
- Unlock Mode: Open Configuration (right-click or the cog) opens the element's own options at the right tab or section: unit frame, party frame mode, Cooldown Manager bar, tracker or buff bar, Damage Meter, Aura Reminders and more. The button is hidden when an element has no options.
- Unlock Mode: a click that only selects an element no longer moves it, so docks and anchors stay and no unsaved-changes prompt appears.
- Unlock Mode: elements attached to a moved frame (a PvP badge, a docked window, a bar anchored to another element) keep their movers on them while you drag, nudge or center.
- Unlock Mode: empty Cooldown Manager trackers show their placeholder slots as soon as Unlock Mode opens, so they can be moved at their real size.
- Escape Menu: with the Game Menu skin or Style Blizzard Frames turned off, the menu keeps Blizzard's own layout, and the KullThranUI buttons take Blizzard's button style at the position you chose.
- Installer: the addon conflict page shows each category with its risk, the modules it affects and each addon's icon. The login conflict popup no longer opens on top of it.
- Aura Reminders: Mark of the Wild, Power Word: Fortitude, Arcane Intellect, Battle Shout, Devotion Aura and Concentration Aura accept every rank and the group version as the buff, and the icon casts your highest known rank.
- Aura Reminders: a paladin with another aura up (Retribution or a resistance aura) no longer gets an aura reminder.
- Aura Reminders: the pet reminder only shows when you can summon a pet.
- Aura Reminders: reminders update when buffs change on group members and when you change stance or form. Group members out of range or in another phase no longer count as missing a buff.
- Cooldown Manager: on a slow login the bars wait for your saved settings instead of building early, so docks and positions are no longer lost.
- Cooldown Manager: Player and Target docked beside the Cooldowns bar move with it when it grows or shrinks (a spell learned on level-up, a talent swap). In combat the bar keeps placing its icons.
- Cooldown Manager: a spell you lose and learn again goes back to its old spot, and learning a new rank brings parked spells back.
- Cooldown Manager: turning off a bar in a docked stack closes the gap. Deleting a bar moves the bars docked to it into its place, or leaves them free where they are.
- Cooldown Manager: bars docked to the party frames follow you joining or leaving a group.
- Cooldown Manager: the gap between stacked bars matches the gap between their icons, icon edges stay sharp, and the bars rebuild after a UI scale or screen size change.
- Cooldown Manager: Reset and Reset All in Unlock Mode put the bars back where a new profile places them: Utility under Cooldowns, Buffs on the cast bar and KUI Trackers on the player frame.
- Cooldown Manager: a docked bar with no Anchor Position chosen uses the side the options show: the cast bar on top, the others on the left.
- Cast Bar: follows the KUI Cooldowns row whenever the Cooldown Manager shows it, instead of jumping to Blizzard's viewer spot while the row is still empty.
- Cast Bar: turning Auto Width off brings back the width you had before, and a width you set by hand is kept.
- Cast Bar: the fill glides smoothly again on computers that have been running for days.
- Cast Bar: the options preview fits the bar, icon and text plate inside the preview area.
- Nameplates: the nameplate distance follows the client's own limit, and is set again when another addon or a settings reset changes it.
- Inspect Armory: new header. The class and spec icons and the background selector sit beside the Talents button, and the average item level is on the right of the header instead of covering the upgrade and enchant texts by the trinkets. Item level and enchant texts sit above the slot border.
- Inspect Armory: the Ranged slot gets its texts and border, and the off-hand upgrade and enchant texts sit above that slot instead of running over Ranged. The Raider.IO button is gone.
- Damage Meter: discarding a drag in Unlock Mode keeps the window in its dock.
- Unlock Mode: Revert also puts back elements that were hidden when Unlock Mode opened and moved afterwards, and restoring defaults no longer saves the screen centre as the position of elements without one. During a group drag, frames no longer snap to the frames being dragged with them.
- Unit Frames: Shift+left-click on a unit frame no longer opens the KUI options.
- Aura Reminders: middle-clicking an icon to dismiss it no longer also casts the spell or uses the item.
- Aura Reminders: the reminder icons hide when combat starts instead of staying as invisible buttons that catch clicks, and the pet menu closes at the pull without an error.
- Compatibility: addons disabled for your character are no longer reported as enabled, and addons that cannot load (a missing dependency, out of date) no longer count as conflicts. Old "reload required" marks clear after a reload.
- Skins: status bars such as achievement progress no longer draw empty, and close buttons fit their box.
- Skins: popups keep their alert icon, progress bar, spinner, dropdown and item button, and a popup reused for another dialog is styled again. Windows with their own skin, such as the guild invite, are no longer restyled as popups, and the role check icon no longer floats over the role buttons.
- Skins: gossip options keep their height, so a click near the edge of an option picks that option. Book and letter text keeps its scrollbar track.
- Skins: quest objectives are coloured on the right line when a quest has a waypoint, and the title reward icon shows.
- Skins: World Map breadcrumbs fit in the bar, and quest text keeps its meaningful colours (green objectives, red money) while dark text is lightened.
- Skins: guild bank tabs dim correctly while searching, the guild invite shows the reputation warning, the guild bank log scrollbars sit in place, Guild Control has a proper close button and the Communities member list scrollbar is styled.
- Skins: the mail inbox tells read and unread mail apart correctly.
- Skins: group finder class bars no longer show through windows dragged over them, the group finder panels no longer show the eye portrait over the KUI header, and the role poll has a proper close button.
- Skins: the profession overview page gets KUI fonts and rank bars, the crossmark shows correctly and the recipe checkboxes are styled.
- Skins: Collections side tab icons no longer stretch when clicked, and appearance models no longer show the Favorite and hidden icons on every appearance.
- Skins: with the KUI Armory off, the character window's icon strip and level line are no longer covered.
- Skins: the Settings tabs keep the KUI font centred and highlight the right tab after a search.
- Skins: Encounter Journal loot rows no longer run the slot and armour text into the item name.
- Skins: the AddOn list's dropdown, search box and performance controls show above its header.

## 1.2.7 (2026-11-17)
- Skins: new Loot History skin. The loot rolls window takes the KUI style, and each item lists the rolls under it: every Need, Greed and Transmog roll with its number, then who passed and who is still deciding.
- Nameplates: names of friendly players in name-only mode sit above the head again instead of on the character's chest. Name Only Distance now defaults to 0, and profiles still on the old -20 move to 0. Friendly NPCs and their quest markers are unchanged.
- Cooldown Manager: Player and Target dock right beside the cooldown bar, level with it. With the Forever and Classic styles they no longer keep a wide gap from the bar.
- Experience Bar: with a single bar it rests just above Action Bar 1 instead of floating in the middle of the free row, also after turning off the second bar. The Classic style runs the whole length of Action Bar 1 and sits on its border, like the original Classic bar.

## 1.2.6 (2026-11-16)
- Profiles: loading or importing the Cooldown Manager from another profile keeps the spells of every specialization in your current profile.
- Profiles: Nameplate and Aura Reminder settings no longer carry over to a character that uses a different profile.
- Profiles: Save As no longer overwrites a profile that already exists.
- Profiles: a profile assigned to your specialization is applied when you change spec, log in or reload, not on every loading screen. Switching profiles by hand updates the assignment of your current spec.
- Profiles: imported or copied settings get their default values right away. A full import keeps your own Progress Bars, Danders integration and interrupt slots, and exports no longer carry the installer state.
- Profiles: a failed import keeps the import window open with the error, and a string with no usable module data says so.
- Profiles: Import Modules refuses a full profile, Import Party Frames applies only the Party Frames settings, and a failed import from the Party Frames page or Unlock Mode keeps the window open with the error.
- Profiles: loading modules from another profile also resets the settings that profile keeps at their defaults, and asks for a reload like an import.
- Profiles: the Cooldown Manager's tracked buff bars and their positions are saved with each specialization and travel with CDM exports.
- Fonts & Colors: colours you pick by hand (tooltip text, chat panel, Armory separator and the rest) are no longer replaced by the style after a refresh or reload. Applying a style preset sets them again.
- Unlock Mode: Reset All also restores the Damage Meter, Aura Reminders and the other elements that keep their own position. Closing Unlock Mode waits until combat ends.
- Minimap button bag: with the bag turned off, hovering the minimap no longer hides addon buttons, and released buttons get their size and position back.
- Options: Resolution Preset applies the preset you choose, and search finds every General sub-tab and opens the right one.
- Visual Style: applying a style keeps your health colour choice (Health or Class) for its unit frames.
- Manage Modules: turning Resource Bars back on no longer turns on the health bar.
- Resource Bars: fixed an error on every power update with custom markers. Hide Out of Combat shows the bars as soon as combat starts, and turning the module off and on keeps the choice of each bar.
- Resource Bars: new Extra Mana Bar option. It shows your mana on its own bar above the power bar while your resource is another one, such as Energy or Rage in a druid form.
- Experience Bar: new second bar for reputation or honor, above or below the main bar, with room kept for it next to the action bars.
- Buffs and Debuffs: the options preview shows the style, shape, fonts and offsets. Switching to a profile with the module on or off applies without a reload, and the Shape menu follows the Style.
- Aura Reminders: custom auras follow Enable Module, a preferred consumable that no longer exists falls back to Last Used, and the Source of Magic reminder keeps the setting you saved.
- Action Bars: the key press highlight respects Shift, Ctrl and Alt and follows new key bindings, and Hide Hotkeys keeps the hotkeys hidden.
- Unit Frames: the KUI style shows the group leader crown on your own frame.
- Party Frames: Boss mode frames show in encounters that start in combat. Raid movers in Unlock Mode follow the module and mode switches, and buff reminders recognise the spell names of every language.
- Armory: hovering a stat in combat no longer causes a Lua error.
- Inspect: quality highlights, upgrade hints and enchants update on every slot, and the enchant text hides when Show Enchants is off. Background Type lists the real backgrounds, and four options that had no effect are gone.
- Armory and Inspect: each enchant shows once, beside its slot, without a second copy inside the slot.
- Installer: a Visual Style picked in the installer is applied with every Reload UI button.
- Installer: the question to use an existing profile shows again until you answer it, closing the installer keeps your own profile, and each profile in the list shows the characters that use it.
- Tooltip: hovering players no longer disturbs an open Inspect window.
- Tooltip: the item or spell icon no longer covers text on the right, such as a spell's range, when the tooltip first opens.
- Teleport Menu: Hide Minimap Button hides the button.
- Bags: the toolbar shows the reagent bag slot and the key ring, and every bag slot swaps bags as on the bag bar. Keys dropped on the key ring go into it.
- Skins: role check and ready popups show the right role icon, without a duplicate. Turning Enable Skins off also stops the Bank, Trade and timer bar skins, and the Loot Roll switch shows its real state.
- Skins: the Report and Battle.net windows are skinned, Armory and Inspect slots keep their gem and flyout art, the World Map no longer draws a flat line over the gradient border, and the guild bank icon picker is skinned.
- Skins: the accent colour updates at once in Collections, Transmog and the Adventure Guide.
- Friend List: Battle.net group assignments are no longer lost when Battle.net is offline, Battle.net notes stay with the right friend, the raid panel is not moved in combat, and a disabled list no longer shows tabs Blizzard had hidden.
- Spell History no longer grows while it is hidden, and Damage Meter Reset All stops a history capture in progress.
- External Addons and Compatibility: addons that are enabled but not loaded yet are detected.
- Translations: corrected texts in several languages, among them Fade on Mouseover in Spanish, Portuguese and Russian, which said the opposite.
- Profiles: the profile you pick stays after a reload, and Unlock Mode positions and the language no longer go back to old values after an import, a reset or a deleted profile. Profile names show without the internal prefix.
- Profiles: each character keeps its own profile when other addons are loaded, so a profile picked or imported on one character no longer moves to another, and the installer asks again whether to use an existing profile.
- Unlock Mode: the Damage Meter keeps its dock after a loading screen.
- Tooltip: player names no longer show as Name-Surname, and item tooltips no longer add Retail-only lines.
- Installer: Show Installer On Login undoes Don't show again, and going back from tooltip cards turns the Tooltip module off again if it was off.
- Party Frames: buff reminders recognise Prayer of Fortitude, Gift of the Wild and higher Battle Shout ranks. Turning the module on or off works without a reload and waits for combat to end.
- Action Bars: no duplicate page selector, and less work on every page change.
- Resource Bars: combo points follow your new target, and combo colours work with the KUI style.
- Aura Reminders: Beacon reminders show as soon as you enter the instance.
- Cast Bar: a new profile keeps the height you set.
- Dungeon Tracker and Minimap: less work during combat.
- Skins: Collections can be turned off, and the Achievement window no longer adds hooks each time it opens.
- Friend List: the Who tab is gone, since the client has no Who window.
- Spell History: casts of a lower rank of the same spell are no longer dropped.
- Changelog: the Don't show again box starts unticked.

## 1.2.5 (2026-11-15)
- Nameplates: when a friendly plate leaves the screen, KUI no longer shows again the Blizzard plate frame it had hidden. Blizzard reuses those frames, so a released one could stay drawn until a reload. A new /knpdebug stray command lists any frame still drawn without its unit.
- Nameplates: a plate that appears for your current target or focus now gets the target or focus look, and the glow and arrows leave it when you pick someone else. The class resource pips on the target are no longer hidden every time the target is refreshed.
- Nameplates: Restore Defaults really resets the nameplate settings instead of bringing back the ones saved at login.
- Nameplates: enemies near you keep their plates after a loading screen, the mouseover highlight no longer stays on a plate after it is rebuilt (at the start of a duel, for example), and the cast bar interrupt colour updates when your interrupt becomes available during a cast (a pet summoned mid-fight).
- Nameplates: the DoT tracker no longer forgets a resist or dodge on a mob when you or your group take a hit, and DoTs no longer show on another mob that reuses the plate after the overlay was turned off.
- Nameplates: with the module off, or with another nameplate addon such as Plater in charge, KUI leaves friendly plates alone. The raid marker on friendly bars shows in the Bottom position.
- Nameplates: recycled friendly health bars keep the unit's name, and a type switched from name-only to bars no longer shows its name twice.
- Unit Frames: Target of Target and Focus Target follow a target switch at once (name, health, level, status) instead of up to half a second later, and their heal prediction follows too.
- Unit Frames: health and power bars jump to the new unit's values when the frame shows someone else instead of sliding from the previous unit's, and a hit number shown on the previous target or focus is cleared.
- Unit Frames: class and power colours of the text bar and the power value text follow the unit when the target changes or a druid changes form.
- Unit Frames: a text slot set to none or covered by a centre text no longer shows an old value, and the AFK, Dead or Offline icon no longer brings back a text the layout had hidden.
- Unit Frames: a reload no longer flashes the previous unit on Target, Focus or Boss frames, and a frame switched off no longer comes back with the next target. Leader, assistant, resurrect, summon and raid marker icons come back when a group frame is shown again, and roster changes made in combat are applied when it ends.
- Unit Frames: the class resource row is rebuilt for the new spec after a spec change (after combat if it happens in a fight), and the Tip of the Spear pips go out when the stacks end.
- Unit Frames: in a vehicle the Player frame no longer keeps your dispel border, and after a scale change the cast bar fill and spell text no longer run under the spell icon.
- Unit Frames: scaling the Boss mover in Unlock Mode scales all five boss frames and uses the boss settings, scaling the cast bar or class power mover no longer changes the Player frame's scale, and the boss frames keep their position and spacing after a refresh.
- Unit Frames: Player and Target docked beside the Cooldown Manager bar stay level when the bar changes height.
- Unit Frames: a target picked up in combat gets the bronze ring around its level badge, and the combat icon stays above the ring.
- Experience Bar: the reputation bar reads the watched faction like Blizzard's bar: its standing, paragon, renown and friendship progress, a full bar with the name for a faction at its last step, and Reputation: None when no faction is watched. In Auto mode at the level cap, honor and the watched reputation come first.
- Experience Bar: XP per hour counts from login or reload instead of starting again at every loading screen. The Disable At Max Level box shows its real state, the Mode list shows Reputation when it is chosen, the width goes up to 1200 and the rested colour updates the preview.
- Experience Bar: until it is moved in Unlock Mode the bar sits in Forever's status bar row between Action Bar 1 and Bars 2 and 3, sized to that row, with its text inside the bar.
- KUI Move: a moved window is pinned by its top-left corner, so the loot window no longer grows upwards or jumps between openings. A plain click (on the gap a looted item leaves, for example) no longer moves or saves the window: the move starts once the cursor travels a few pixels. The loot window takes its saved place when it opens in combat.
- Nameplates: Blizzard reuses its plate frames from one unit to the next. A frame KUI had turned into an enemy plate now gets its health bar, cast bar, name, auras and widgets back when that plate goes away, so the next friendly or NPC plate that receives it no longer misses parts or shows widgets in the wrong place.
- Nameplates: the level number of a friendly player stays on that player's plate instead of turning up beside another unit once plates are reused.
- Nameplates: the soft-target interact icon shows above the name on name-only friendly plates.
- Nameplates: when KUI stops hiding friendly buffs and debuffs, you get your own setting back even in a later session.
- Nameplates: a buff, debuff or crowd control slot switched on or off in the options applies to the plates on screen right away.
- Nameplates: the DoT damage marker no longer flashes on a plate reused for another mob.
- Nameplates: class icons pick up a respec within 30 seconds instead of keeping the old spec until the next loading screen.
- Nameplates: plate colours and aura filters no longer rely on unit values the game can hide (level, classification, reaction), and one failing plate no longer stops the refresh of the others.

## 1.2.4 (2026-11-14)
- Skins: group loot rolls (Need, Greed, Pass) get a KUI skin: a compact dark panel, the item icon in a border of its quality colour, the roll buttons in a row and a thin timer bar underneath. It has its own switch under Skins > Skinned Windows.
- Group loot rolls: the roll frames stay at Blizzard's spot above the action bars instead of jumping when an alert or another frame at the bottom of the screen appears, and a roll you have already answered no longer flashes back. The spot can be moved in unlock mode (Group Loot Rolls).
- KUI Move: a new Reset All Positions button in the side panel puts every element and every moved window back in its default place and scale, saves the change and reloads the interface.
- Aura Reminders: Custom Auras work again in the downloaded addon. Packaging broke one of the aura engine's library files, which kept the whole engine off and showed a Profiling.xml warning.
- Tooltip: the item or spell icon sits inside the tooltip's top-right corner instead of above it, and the lines beside it keep clear of it. The options preview shows it the same way.
- Tooltip: the panels of the options preview show their border on every side again.
- Skins: opening the Collections window in combat, from a chat link for example, no longer causes a blocked action error. The summon buttons are moved into place once combat ends.
- Buffs and Debuffs: a second row of buffs or debuffs leaves room for the duration text of the row above instead of covering it.
- Buffs and Debuffs: buffs longer than an hour show hours and minutes (1h26m, 1d3h) instead of a rounded-down hour. Weapon enchants too.
- Dungeon Tracker: Scarlet Monastery, Blackrock Spire and Dire Maul list their bosses under wing headings. The wing is recognised from the first boss you see or fight, and only its bosses count toward the total. In Scarlet Monastery, entering another wing starts a new run, and side encounters such as Lord Hel'nurath or Tsu'zee appear once killed.
- Cooldown Manager: new tracked buff bars show their icon on the left by default. Existing bars keep their icon setting.
- Cooldown Manager: a buff bar empties when its buff ends instead of keeping its last fill and timer, and a buff that Blizzard's Cooldown Manager does not track follows its own duration.
- Cooldown Manager: the buff bar options show a live preview of the selected bar, and the Group Grow Direction list shows its choices again.
- Cooldown Manager: a deleted buff bar, or one added to the group, no longer keeps its own entry in unlock mode.

## 1.2.3 (2026-11-13)
- Skins: the loss of control alert gets a KUI skin: a dark band with thin lines above and below in the colour of the effect (red for stuns, purple for fears, blue for silences, green for roots, amber for disarms, or the colour of the locked spell school), the spell's own icon in a KUI border and the KUI font. It has its own switch under Skins > Skinned Windows.
- Window moving: Blizzard windows can be dragged by their title or any empty area, without holding SHIFT, as with KUI Move on Retail. A plain click no longer saves the window's position.
- Party Frames: health and power bars now ease into each new value instead of jumping. A new Smooth Health/Power Bars option, on by default, turns it off per layout.
- Resource Bars: drops in your resource, when you spend it or take damage, now ease too, not only gains.
- Resource Bars: the swing timer moves smoothly at any frame rate.
- Cooldown Manager: the spell lists of each specialisation are no longer lost when you log out.
- Cooldown Manager: spells added from the spellbook stay on their bar after you learn a new rank, and no longer drop off the bars at login.
- Aura Reminders: pasting a string of the full aura editor (!WA or !FA) into Import Auras now switches to the Full Aura Editor and imports it there. The button of the editor you are in is highlighted.
- Aura Reminders: auras shown while missing no longer cut off the last letters of a text placed beside the icon.
- Unit Frames: with the Forever and Retail styles, the target's elite, rare and world boss art sits where Blizzard's target frame puts it, with Blizzard's own rare art.
- Minimap: the minimap cluster no longer stretches to the bottom of the screen, which could shrink the right action bars.
- Professions: opening the professions window while dead now shows the overview page instead of an empty crafting page spilling out of the window.
- External Addons: BugSack's window can now be closed in combat.
- Configuration change: Require SHIFT to move frames (KUI Interface > Move Windows) is turned off once in existing profiles. Turn it back on there if you prefer it.

## 1.2.2 (2026-11-11)
- Aura Reminders: auras from Wago saved with a newer ForeverAuras version can now be imported. The import window shows a warning instead of refusing them; any setting added in that version is kept but has no effect.
- Aura Reminders: imported auras that use textures, sounds or fonts from the standalone ForeverAuras, WeakAuras or M33kAuras folders now use the copies bundled with KUI, so they no longer stay invisible or silent. Auras that use media from other addons (SharedMedia packs, Details and so on) still need those addons installed.
- Buffs and Debuffs: weapon enchants and poisons now come first in the buff row, as on Blizzard's buff frame: they start at the row's anchored edge (the right one when buffs grow to the left), main hand first, and your buffs follow them. They no longer run off the right edge of the screen.
- Armory: hovering a stat now shows the game's own stat tooltip, as on Blizzard's character panel: the total, the base value plus what your gear and buffs add, and what the stat gives you. Critical strike and haste break down melee, ranged and spell.
- Tooltip: with Card Style on, talents (passive and active) now show as cards too, with their icon, cost, range, cast time and description.
- Aura Reminders: the aura engine now loads its own copies of the libraries it uses, so other addons' copies of them can no longer break the editor. If the engine still fails to start, a chat message says so and Custom Auras stay off.
- Aura Reminders: the aura editor texts that were still in English are now translated into every language KUI supports.
- Tooltip: new optional lines, each with its own switch and off by default. Items: icon ID, item level, required level, quality, equip slot, binding, vendor price, item count, use effect spell, item set ID, and enchant and bonus IDs. Spells: icon ID, rank, range, cooldown, cost, known and passive. Buff and debuff tooltips can show the aura's spell ID and who cast it.
- Tooltip: the options preview now shows the player tooltip, one of your equipped items and one of your spells side by side, and follows every switch on the page, Card Style included. Click it for another item and spell.
- Armory: the Armory tabs no longer stay on screen on the Reputation, Skills, PvP, Currency or Statistics tabs.
- Armory: while you apply an enchant or poison, the slots it can't go on are shaded again, along with their border and item level.
- Unit Frames: with the Forever style, the target frame shows Blizzard's rare and elite art by default, as the Retail style does.
- Flight Master: searching the options no longer leaves the flight guide's 3D portraits drawn on screen.

## 1.2.1 (2026-11-11)
- Aura Reminders: Custom Auras now includes the full ForeverAuras 1.3.8 aura editor (based on WeakAuras, GPL v2), styled to match KUI and shown inside KUI's options. You don't need a separate ForeverAuras or WeakAuras addon. Its auras are saved separately, and auras from a standalone ForeverAuras or WeakAuras install are not brought over automatically: use the editor's import and export to move them.
- Aura Reminders: auras from the full editor that sit on the screen can be moved in KUI's Unlock Mode along with everything else. They follow the module's Enable Module setting, and the Custom Auras card counts them. The engine also has its own chat commands: /kuiae, /kuiaengine and /kuiforeverauras.
- Aura Reminders: your existing KUI auras keep working in their original editor, found under Existing KUI Auras on the Custom Auras page.
- Aura Reminders: the KUI aura editor gains up to four triggers per aura, which can all be required or any one. New trigger types: Spell Charges, Spell Usable (optionally also in range of the target), Item (ready, on cooldown or number owned), Health, Power, Casting and Player State. Aura triggers can be limited to your own casts.
- Aura Reminders: KUI auras can now show text with values (name, stacks, time left, value, maximum, percentage, count), a cooldown swipe and a bar filled by time, stacks or value. An aura whose trigger is off can stay on screen greyed out or faded, and you can pick the icon it shows.
- Aura Reminders: KUI auras gain rules that change colour, glow, grey or opacity while a condition holds, plus appear, loop and disappear animations in a new Animations tab. They also gain load options for class, specialisation, role, group, minimum level and hiding while mounted.
- Aura Reminders: KUI auras can be anchored to another frame by name. Dynamic groups can wrap onto new lines and sort by remaining time. New templates: Cooldown Tracker, Low Health, Resource Bar and Enemy Cast.
- Aura Reminders: the preferred flask and potion dropdowns show your saved choice again instead of a blank box. The zone dialog, the talent tooltip and the "Disabled: requires" notes are now translated.
- Textures: new bar textures drawn for KUI (KUI Satin, Brushed, Rough, Split, Glass, Fade Right, Fade Left, Fade Up, Fade Down, Matte and Sheer) replace the old unnamed bar textures in Unit Frames and in the Cooldown Manager buff bars. They are also offered in every status bar texture picker.
- Cooldown Manager: the Bar Texture dropdown shows a preview of each texture, and the glow preview button has new eye icons.
- Tooltip: new optional Card Style draws item and spell tooltips as cards, with icon, item level, chips, a weapon summary or spell grid, and sell price. It is off by default, has a live preview, and the installer has a new step to choose it.
- Tooltip: every extra line now has its own switch, grouped into player, item and spell sections: icon, targeting players, guild rank, item level, item ID, max stack size, AH category, bag and slot, spell ID and cast time.
- Tooltip: the Mythic+ score and raid progress lines are removed, since Forever has neither. Score Type now offers None or PvP (Max Rating).
- Flight Master: the flight point guide has a new look, with round flight master portraits and accent-coloured cards and window. Clicking a card again clears its waypoint.
- Nameplates: the nameplate distance is now set to 45 yards, the distance at which the client actually shows plates, for player plates too. Units in plain sight no longer fade to 40%.
- Nameplates: the DoT damage tracker now also works while hit amounts are hidden in combat, and after combat it learns real tick sizes from the damage meter. Casts on your focus, mouseover or soft target are followed, and dead mobs no longer show a marker or kill icon.
- Nameplates: the range text sits just past the end of the health bar, so it no longer overlaps the name.
- Dungeon Tracker: bosses killed while you were outside the instance (released after dying, disconnected or stepped out) are now counted when you return. Seeing a boss's corpse also counts the kill.
- Unit Frames: the target's level colour now updates when you change target in combat, instead of keeping the previous target's difficulty colour.
- Unit Frames: the Active Stance bar no longer drifts away from the player frame after loading screens.
- Unit Frames: the alternate mana bar now sits neatly inside its frame.
- Buffs and Debuffs: weapon enchant icons now sit outside the buff row, so your buffs no longer shift when an enchant appears or runs out.
- Loot Rolls: roll frames no longer jump between two spots when rolls are added or removed, and a roll no longer opens on top of another roll.
- Chat: the combat log's default filter buttons now show in your client language and fit their text. They keep the KUI style after you click a filter.
- Options: the window size slider now ends at the largest size that fits your screen, and the window resizes around the slider. Releasing the slider without moving it no longer changes anything, and the slider keeps working if the window was closed mid-drag.
- Options: slider values snap cleanly (0.7 rather than 0.69999), and a Default value appears only when a slider has a real default. Opening the action bar, experience bar, quest tracker and aura editors no longer saves their values back.
- Options: texture and background dropdowns preview each entry in every language.
- Profiles: the module grid shows an icon for every module and uses the Forever module names, for example Dungeon Tracker.
- Enhanced Friend List: the search icon shows again, and its chat messages are translated.
- Spell History: icon backdrops, frames and shape borders show again.
- Experience Bar: the Text Position choice now sits under the style cards.
- Translations: texts that were still in English on many pages are now translated, including Cast Bar, Chat, Minimap, Nameplates, Cooldown Manager, Window Layout and Compatibility. Portuguese (Portugal) and Mexican Spanish no longer fall back to English in Aura Reminders and the installer.

Configuration changes after updating: Unit Frames and Cooldown Manager buff bars that used the old bar textures switch automatically to the matching KUI textures, including in profiles you switch to, copy or import. A Tooltip Score Type set to Mythic+ is reset to None. Auras from a standalone ForeverAuras or WeakAuras install are not imported (use import and export).

## 1.2.0 (2026-11-09)
- Aura Reminders: Custom Auras is now a full aura creator. Its editor has Trigger, Display, Conditions, Load and Sound tabs, a live preview that draws the aura as in game, and a badge on each section that tells you whether it works in combat, only out of combat or not on this client.
- Aura Reminders: new stack options for custom auras. Show the aura only at, above or below a number of stacks, fill a bar by stacks up to a maximum you choose, and change its colour and glow from a set number of stacks. New Stacking Buff template.
- Aura Reminders: custom auras and their groups can be moved in Unlock Mode, and the Move on Screen button opens it straight away.
- Aura Reminders: the Custom Auras page is easier to use, with a New Aura, Import and Move on Screen bar, large rows with on/off and delete buttons, a search by name, group or spell ID, Undo Delete, and a template gallery that includes major cooldowns of your class.
- Aura Reminders: new icons for the section cards and the Custom Auras templates, tinted in your accent colour. Class Upkeep and Consumable Loadout no longer show question marks.
- Aura Reminders: sliders in the custom aura options can be dragged smoothly instead of stopping after each step.
- Aura Reminders: the options preview shows a sharpening stone and the Flask of the Titans for Weapon and Flask instead of red question marks.
- Experience Bar: new style cards for KUI, Forever, Retail and Classic, each with its own art, and the bar follows your Visual Style. Changing the style asks for a reload.
- Experience Bar: new Text Position option (above, below or inside the bar) and Bar Animation switch. Rested experience shows in purple in the Forever and Retail styles.
- Experience Bar: by default it sits just above Action Bars 2 and 3, and it can still be moved in Unlock Mode.
- Nameplates: the distance text is a larger number above the right end of the bar, in the Russo One font. Pick another font with the new Distance Font option. By default the distance shows up to 100 yards.
- Nameplates: in the Forever and Retail styles, the target highlight on plates that just appeared shows the style's own frame glow instead of a blue border.
- Nameplates: in the Forever and Retail styles, the edge of the frame is no longer covered by the health fill at some interface scales.
- Bags: the search works in combat. Items that do not match are dimmed until combat ends, and then the bag is filtered.
- Bags: the loot window, the stack splitter and confirmation dialogs open on top of the bags instead of behind them, so items you right-click open as expected.
- Bags: new items keep their highlight until you hover them or close the bags, the Recent category shows only the new stack, and quest starters are sorted with quest items.
- Bags: Alt+click pins an item again, the keyring and the bag slot buttons open their bags, and a locked item is greyed out without redrawing the bag.
- Bags: the bag keeps updating in combat when you loot, and dropping an item on the empty space always goes to the first free slot.
- Damage Meter: it no longer covers the bags. While Blizzard's bags or the KUI bags are open, the meters sit below them.
- Group loot: the Need, Greed and Pass window no longer blinks or briefly vanishes when another roll or alert appears.
- Armory: the settings and close buttons in the top-right corner use new KUI icons and sit inside the window.
- Damage Meter: the Forever style is darker.
- Unit Frames: the class portrait is used only for players. NPCs keep their normal portrait.
- Options: live previews sit on the dark background instead of a greyish one.
- Guild window: the close and minimize buttons sit inside the header as KUI boxes.
- Party Frames: in the Forever, Retail and Classic styles, the raid marker sits on top of the portrait ring.
- Fixed: an error when opening the Custom Auras page.

Configuration changes after updating: the Experience Bar text moves above the bar once. Other saved settings are kept.

## 1.0.10 (2026-11-08)
- Nameplates: the Forever, Retail and Classic styles use Blizzard's own nameplate art from the game. Forever has its metal frame, the level box on the right and the yellow target glow around both. Retail has its frame and selection glow. Classic has its gold border with the level in the pill on the right.
- Nameplates: the frames stretch the way the game's do, so the metal edge, rounded corners and glow keep their shape at any bar width or height.
- Nameplates: in the Forever and Retail styles, plates that are not your target are darkened, as in the game.
- Nameplates: the Forever, Retail and Classic styles show Blizzard's gold elite dragon on the left of the bar. KUI Style keeps its own dragon.
- Nameplates: the Retail style uses the game's own bar colours, and the empty part of the bar shows the dark inside of the frame instead of a red-brown fill. The white level stays at the start of the bar.
- Nameplates: in the Classic style the level is centred in the border's pill.
- Nameplates: Combo Point Shape has four choices: Retail, Forever, KUI and Pips. Retail and Forever use the game's own combo points (silver socket or bronze socket with a red gem), and KUI has a new look whose gem takes your combo point colour. The Forever and Retail styles use their own by default, and KUI Style keeps Pips.
- Nameplates and Unit Frames: the level of enemies takes its difficulty colour (grey, green, yellow, orange or red) in every Visual Style, and it is on by default. Friendly units keep the style's level colour. Turn it off with Color Enemy Level by Difficulty, now in the nameplate level options too. The Unit Frames option is no longer limited to KUI Style.
- Unit Frames: the combo points under the player frame offer Retail and Forever as separate choices, next to Classic, using the game's own sockets. The Retail style now shows them under the player frame by default, as Forever and Classic already did, and the Resource Bars stop showing combo points while they are there.
- Skins: the Collections window's side tabs (Mounts, Pets, Toys, Heirlooms and Appearances) show their icons again.
- Skins: purchase dialogs with a price, such as buying a bank slot, show the amount with its gold, silver and copper coins instead of an empty box.

## 1.0.9 (2026-11-07)
- Nameplates: new Color Enemies by Level option in the Colors card. Enemies you can attack take the colour of their level compared to yours, like the level on the unit frames: grey far below you, then green, yellow, orange and red. It is off by default.
- Flight Master: routes you have never flown get their time from the length of the game's own flight paths, and retired or placeholder flight points no longer show.
- Armory: in combat the stats panel keeps every stat. Stats the game hides during combat show their last value from out of combat, health, mana and resistances stay live, and everything refreshes when combat ends.
- Armory: the Stamina label lines up with the other stats instead of sitting in the middle.
- Auction House: the Buy, Buyout, Bid and Post buttons and the purchase dialog buttons show their full skin instead of only their text.
- Unit Frames: the raid marker stays on top of the portrait rings, combo points and aggro glow.
- Unit Frames: in KUI Style the level number of enemies takes its difficulty colour (grey, green, yellow, orange or red), as on the Blizzard frames. Turn it off with Color Enemy Level by Difficulty in the Unit Frames options.
- Translations: texts that showed in the wrong language are fixed, such as Chinese text in German, Spanish and English options, Portuguese text in the Cooldown Manager buff bar options and Health shown in Chinese. Bag sections, Hide offline and Macros are now translated.

## 1.0.8 (2026-11-07)
- Stance Bar: new optional bar on the player frame, turned on in Unit Frames. Each stance, form, aura, hunter aspect or paladin aura is a button: click it to switch, also in combat. The active one is lit in your accent colour and cooldowns show on the buttons. Choose its size, spacing and position or move it in Unlock Mode; the Active Stance Only style shows just the current one.
- Friend List: new look in the Skins material, with a class colour bar, the class icon with your friend's status, the faction crest, larger game icons, flat cards and a sunken tab bar.
- Friend List: the tabs stay on the bottom bar in combat, the close button works in combat, and the Filter button keeps its bottom edge.
- Friend List: friends playing WoW Forever show the Forever icon.
- Skins: every skinned window shares the same darkness. Spellbook, Professions, Achievements, Adventure Guide and Group Finder are no longer lighter than the rest, and skinned windows are darker overall.
- Options window: keeps its intended darkness when the game's Gamma setting is raised.
- Nameplates: the raid marker sits centred above the name, and debuffs move up to make room for it.
- Nameplates: raid markers show on allied NPCs, and on friendly players shown by name only they sit just above the name.
- Nameplates: in a group, the quest sign shows again on mobs you need for your own quests.
- Nameplates: plates show at the farthest distance the game allows.
- Cooldown Manager: the Buffs bar no longer gets wide gaps between icons after taking the Blizzard layout.
- Target frame: the rare and elite ring follows a target change in combat, and the raid marker is drawn above it.
- Mail: attachment borders show each item's own quality instead of colours left over from other mails.

Configuration changes after updating:

- Nameplates: a raid marker set to the top-right corner moves to the centre above the name once.
- Cooldown Manager: icon gaps wider than half an icon that came from the Blizzard layout go back to 2 px once.

## 1.0.7 (2026-11-06)
- Dungeon Tracker: lists the bosses of every Forever dungeon, read from the game's own encounter data, and marks each one as it dies. Dungeons with several wings count the bosses you kill without a total.
- Dungeon Tracker: on by default, and at 1440p its default spot is beside the Objective Tracker.
- Raid Check: new look, with a status badge, icon columns that show each consumable's own icon, and flat report buttons. On Forever it checks food and flask only.
- Nameplates: friendly plates that show only the name now show raid markers up close too.
- Party Frames: party members' mana, rage and energy show again in every style.
- Guild window: the chat input box no longer covers the member list.
- World Map: the close and maximize buttons sit inside the window.
- Fixed: an error on the target of target portrait when shapeshifting.
- Fixed: an error when targeting some enemy NPCs.

Configuration changes after updating:

- Dungeon Tracker: turned on once for every profile.
- Dungeon Tracker: at 1440p, a tracker still on the old default spot moves to the new one.

## 1.0.6 (2026-11-05)
- Nameplates: the quest sign over friendly characters sits above their name instead of covering it.
- Nameplates: in the Forever style, crowd control and other side auras sit beside the level box instead of under it.
- Combo points: they belong to your current target, so they clear when you change target on the unit frames, nameplates and resource bars.
- Cooldown Manager: Utility no longer leaves a gap under Cooldowns when it shows a single spell.
- Cooldown Manager: more racial abilities for Undead, Orc, Troll, Night Elf and Human characters can be tracked.
- Party Frames: party members show their mana bar by default.
- Portraits: druid forms face inward on the player, target and party portraits.
- Unit Frames: the druid mana bar shown in forms fits the frame straight away instead of after a reload.
- World Map: KUI no longer moves the world map, which stopped a blocked action error when opening it.
- Achievements: comparing achievements with another player no longer causes an error.
- Merchant: the page arrows show again.
- Fixed: green squares on profession reagent slots and green buttons in the Compatibility Check dialog.
- Target frame: in KUI Style the cast bar sits right under the frame and the debuffs under the cast bar, so a cast no longer covers them.

Configuration changes after updating:

- Party Frames: the party mana bar is turned on once for every profile.

## 1.0.5 (2026-11-04)
- Dungeon Tracker: the Dungeon Timer becomes the Dungeon Tracker. Forever dungeons have no timer, so it shows the dungeon, party deaths and bosses without a clock, and its preview matches.
- Dungeon Tracker: walking back in after a corpse run or a trip to a vendor continues the same run. A finished run, or one left for more than an hour, starts fresh.
- Kick Tracker: a new way to tell who interrupted. It only marks a kick when it is sure who made it, and crowd control on a whole pack no longer counts as a kick. It runs in every dungeon, knows each class's interrupt at every rank, follows a second interrupt such as Shield Bash or Skull Bash once you cast it, and its text is larger by default.
- Chat: system messages, slash command replies, friend notices and other game text now show in the General tab, each channel keeps its own colour, and achievement lines link the player.
- Chat: changing an option no longer reloads the history and drops unsaved lines, and the General tab no longer keeps a whisper or guild target.
- Chat: whispers from your own realm are matched correctly, repeated messages are no longer hidden as duplicates, the window keeps its position at any scale, and with fading off it stays fully visible. Closing a tab keeps the right tab selected.
- Armory: the header shows your title next to your name and updates when you change it, and the background selector sits in the header with a tooltip.
- Translations: button and option labels fit in every language. Long labels shrink slightly or are shortened with the full text in the tooltip, switch labels can use two lines, and buttons widen for longer languages.
- Translations: Korean, Chinese and Russian nameplates use a font that can draw their script, and Chat, Party Frames group headers, new custom Aura Reminders and chat messages are now translated.
- Cooldown Manager: on a new profile, Utility docks under Cooldowns and Buffs above the cast bar. The installer's Import button puts every bar back in its layout position, and the spell search works with any character.
- Installer: the Cooldown Manager preview shows sample spells for low-level characters, and its cast bar fill shows correctly.
- Objective Tracker: in Edit Mode its selection box fits the visible tracker instead of its full height.
- Minimap: in its default corner it moves down just enough to keep the zone name on screen.
- Skins: tabs get a new border lit in your accent colour, and bottom tabs are no longer cut by the window border.
- Skins: Spellbook, Professions and Adventure Guide pages are darker with readable text, empty scrollbars in the Adventure Guide are hidden, Group Finder categories lose their blue halo and the group leader keeps a single icon.
- Cursor: turning the custom cursor on or off no longer needs a reload.
- Layout: new default Buffs and Debuffs positions at 1080p, 1440p and 4K.
- Fixed: debug lines no longer show in chat at login.
- Fixed: the character title no longer shows again over the Armory.
- Fixed: class resource bars no longer cause errors in the buff frame.
- Fixed: changing the Armory colour updates its style straight away.

Configuration changes after updating:

- Kick Tracker: text sizes saved in your profile are raised by 2 once, to match the new default.
- Durability: a frame still at the old default spot moves to the new default position.

## 1.0.4 (2026-11-02)
- Large restructuring and refactor: Unit Frames, Nameplates, Aura Reminders, Cooldown Manager, Skins, Profiles and the shared aura code were reorganised and rewritten module by module, with cleaner code and many old leftovers removed.
- Nameplates options: new layout. Visual cards with their own icons replace the tabs, the live preview sits above every section at a larger size, and each card shows only its own options, with the duplicates gone.
- Nameplates: the preview and the plates show each class resource with the game's own art, centred under the plate. Pips default to the colour of each resource.
- Nameplates: in the Friendly card the preview dims the health bar when it is off or set to show names only.
- Aura Reminders options: new layout with section cards, a preview column and a settings column, plus a new zone dialog and error flash.
- Resource Bars: the anchor block was redesigned, and a resource the unit frame already draws is no longer repeated.
- Resource Bars: Tip of the Spear for Survival and Whirlwind for Fury.
- Skins: new surface material across windows, and buttons no longer keep their default red look in the Group Finder, AddOn List, Auction House and other windows.
- Game Menu: new frame styles, crests and button styles, with position, order and visibility options for the KUI buttons and a live preview.
- Enhancements: new Battleground History, recording each battleground with filters and a summary.
- Layout: Focus, Pet, Target of Target and the combat timers follow their unit frames, and frames around Player and Target keep their gaps when the scale changes. Default positions now depend on client and resolution.
- Art: new portrait, nameplate, bar, cursor and category icons, plus lighter packaging with unused fonts and textures removed.
- Fixed: Enhancement Shaman nameplates no longer raise an error, and Maelstrom Weapon shows its stacks.
- Client detection: KUI now recognises the Forever client properly, so its own group finder skin, default layout and bar look apply, and Aura Reminders settings are kept between sessions. Existing profiles move to the Forever name automatically.
- Forever Visual Style: Action Bars default to the Blizzard button style.
- Fixed: a damaged profile string can no longer freeze the game on import. It now shows a clear message.
- Fixed: nameplates follow a specialization change without a reload, and the resource of the previous spec no longer stays.
- Fixed: nameplate settings for Friendly text now show the real values instead of blanks.
- Fixed: Blizzard plates come back correctly when a unit stops being hostile.
- Fixed: pips reappear when a resource returns to its higher maximum, and the Stagger bar handles missing values.
- Fixed: Aura Reminders no longer hides your reminder because of the same buff from another player, repeated talents now give feedback, and dragging icons during a refresh no longer breaks their order.
- Fixed: debug messages in chat are gone, and the Group Finder leader role icon shows again.
- Translations: new option labels and messages translated into every language, and garbled characters in the changelog window repaired.

Configuration changes after updating:

- Aura Reminders: a preferred flask saved by an older version returns to Last Used. Choose it again if you want a fixed one.
- Cooldown Manager: a bar anchored with an older saved value returns to its saved position.

If you update from 1.0.3 or lower, restoring defaults from the installer is recommended.

## 1.0.3 (2026-10-28)
- Action Bars: new Glows tab. Pick the style, colour and opacity of proc glows, of spells that glow while usable (such as Execute or Overpower) and of spells coming off cooldown, and give any spell its own look.
- Teleport Menu: new Atlas look, a map table in your accent colour with every teleport as a waypoint.
- Objective Tracker: a small arrow above the tracker hides or shows it entirely, background included.
- Profiles: right-click a profile card for a menu (load, assign to spec, change icon, export, save as, delete), and the new profile card creates a clean profile with the KUI defaults.
- Installer: the Unit Frames, Party Frames and Damage Meter previews show the Visual Style you pick and always fit their box. Party Frames gets the same style row as Unit Frames.
- Test buttons: new animated look in your accent colour, the same in every language.
- Options: section cards no longer touch or overlap, and the pinned live preview no longer shows the options scrolling behind it.
- Cooldown Manager: the KUI Tracker docks to the player frame as it is drawn, keeping room for the cast bar, the druid mana bar and combo points. Bars docked together keep their anchor when dragged in Unlock Mode.
- Translations: installer texts reviewed in every language, more option labels translated, and line breaks show correctly.

## 1.0.2 (2026-10-25)
- Installer: redesigned in the KUI look, with a painted window, an animated progress bar, cut-corner buttons and holographic language switches with country flags. Its colours follow your KUI accent, also when you change it while it is open.
- Installer: the Enhanced Friend List, Bags and Damage Meter previews show the real windows, the Cooldown Manager preview stacks your bars as they sit on screen, and the welcome page shows your character with an accent glow.
- Installer: new "Opening KullThranUI" step that explains how to open the KUI options, KUI Unlock Mode and the installer, and a "How do I move frames?" guide on the scale step.
- Unlock Mode: redesigned side panel with its own art, Grid, Snap, Dark and Coords tiles, a filter for the element list, an icon for every element and a Guide that explains each control.
- Armory: its own look for each Visual Style (slot borders, stats panel, item level and PvP badge, tabs and header) with new icons, and a redesigned Progress page with your rating, dungeon tiles, the Great Vault and your raids.
- Style pickers: Armory, Bags, Chat and Party Frames share new style cards, and the Nameplates style cards show a live plate of each style.
- Enhancements: new Kick Tracker (your group's interrupts on the enemy nameplates, with cooldown bars, in Mythic, Mythic+ and arenas) and Spell History (the spells you cast as a row of icons).
- Enhanced Friend List: shows the exact WoW game each friend is playing.
- Cooldown Manager: KUI Tracker icons can be clicked to cast or use them.
- Minimap: style cards per Visual Style, a more faithful live preview, and KUI module options in the minimap button drawer.
- Bags: the options page shows a live preview of the window with your own items.
- Skins: gradient window borders and a cleaner group finder popup.
- Chat: messages stay left-aligned with the per-script font.
- Translations completed for every language, Bulk Buy included.
- System Tuning: new Ground Effects options to set the ground clutter density, fade distance and draw distance.

## 1.0.1 (2026-10-22)
- Options window: redesigned, with its own look for each Visual Style (KUI, Forever, Retail, Classic). The Window Scale percentage can be typed in, and scrollbars have a soft glow.
- Profiles: new page with animated profile cards in your accent colour. Pick any game icon for each profile, and choose modules and Cooldown Manager specs from clear grids to export or import.
- Cooldown Manager: five new glow styles (Pixel Glow, Action Button Glow, GCD, Classic WoW Glow and Blackout). On icons with a custom shape, the glows follow the shape's outline.
- Cooldown Manager: glows on action buttons now sit exactly on the spell icon, and active cooldowns that buff you glow even without a target or when a talent replaces the spell.
- Nameplates: pending DoT damage marker on enemy plates, with an optional kill icon when your DoTs are enough to finish the target, and class icons over friendly players.
- Damage Meter: new toolbar on every window (new window, reset, data type, segment and options). The mode menu and the breakdown window use the KUI surface texture.
- Bags: a frame for each Visual Style, with a style picker on the Bags page that applies at once.
- Chat: messages fade one by one after a while, as in the default chat, while the window frame fades when idle. Private chat buttons follow the chat style, and Chinese, Korean and Cyrillic names keep the chat text size.
- Minimap: the Calendar, Mail and Tracking buttons follow the Visual Style, the zone name sits on its plate on the round minimap too, and the zone no longer shows twice.
- Visual Styles: the level on the style cards is shown in full again.
- Fixed a Lua error when switching the Cooldown Manager glow to Pixel Border or Shape Glow.
- Fixed the Cooldown Manager buff bar overlapping the Forever and Retail cast bars, and the Cooldown Manager tabs overlapping their header.

## 1.0.0 (2026-10-18)

- Forever leaves beta: this is the first stable release.
- Chat: four chat styles (KUI Style, Forever, Retail and Classic), each with its own frame, tabs, buttons and input bar. Every Visual Style remembers its own choice and whispers keep their colours.
- Chat: the Combat tab shows only the combat log (no pet, loot or system messages) and its My actions / What happened to me? buttons follow the chat style.
- Raid Check (Enhancements): after a ready check it lists who is missing food, flask, augment rune or pre-pot and lets you report it to the group. Open it with /ktraidcheck.
- Bulk Buy (Enhancements): Shift-click a stackable vendor item to buy a whole quantity in one go.
- Nameplates: optional distance over enemy nameplates, shown as range brackets, with format, colour and scope options.
- Unit Frames: new Portrait Auras tab. The most important aura of Player, Target, Focus, Pet, Target of Target and Focus Target shows on its portrait (crowd control, disarms, defensives, important spells), with a live preview. A CC Catalog lists the crowd control spells of your game with search and a switch per spell, and raid and arena frames can show the same auras.
- Unit Frames: Druid alternate mana bar under the Player frame while in cat, bear or moonkin form (off by default on the Retail client). The cast bar sits below it and no longer overlaps the power bar.
- Unit Frames: Forever Portrait Frame option (bronze ornament or plain ring), Forever combo points, and the style cards can be folded away.
- Cast Bar: Retail and Forever use Blizzard-style art with the spell name on a plate, identical on both clients.
- Portraits: Druid forms are framed correctly (cat, bear, moonkin, travel and flight).
- Damage Meter: native styles keep their panel and header, and the meter drops below the maximized world map.
- Unlock Mode: the right-click menu has a Scale slider for each element.
- Skins: the Auction House marks the selected category again.
- Minimap: the zone name shows even when it loads late.

## 0.1.6 (2026-10-17) - Beta

- Forever style reworked for the new Forever art: Player, Target, Focus, Target of Target, Pet, Focus Target and Party Frames fit the new three-band plate (bars, names, icons and portraits) and keep the round portrait ring. It looks the same on the Retail and Forever clients.
- Retail and Forever styles use Blizzard's own bar fill on Unit Frames, Raid Frames and Resource Bars, without the baked edge or the diagonal end that left gaps.
- Resource Bars: smoother fill and no stale value after a change of resource or talents.
- Portraits face the right way in every Druid form and for class icons.
- Damage Meter: the Classic style uses the real Recount bar texture in the live preview, the options and the installer, and Retail and Forever use Blizzard-style bars.
- Action Bars: end caps span the whole bar group up to the bags, with a new End Cap Width option (Bar Group or Bar 1). Action buttons and Cooldown Manager icons glow following their shape instead of a plain swipe.
- Cooldown Manager: the KUI Tracker shows again in the outdoor world.
- Chat: print and debug output shows in the chat frame again, not only in the copy window.
- Unit Frames: in KUI Style the target buffs clear the health bar and the combo points circle the portrait. Aura timers use the KUI global font and sit on the icon, stack counts are smaller and buff rows keep their distance.
- Combo points under the Player frame use Forever's bronze rings in the Forever style, on any client.

## 0.1.5 (2026-10-14) - Beta

- Teleport Menu rebuilt for Forever: a working catalog of the teleports that exist here (Hearthstone, mage teleports and portals with rune count, Moonglade, Astral Recall, Everlook and Gadgetzan items). Click to cast or use; unusable ones are dimmed.
- Flight Master: clicking a flight point in the guide puts a TomTom arrow on it. Without TomTom it uses the map waypoint.
- AFK Screen: new page in Enhancements. When you go AFK the interface hides, the camera turns slowly and a bottom bar shows your character, guild, time away and your model, with whispers and guild chat. Any key, combat, or a group finder or battleground invite closes it.
- Performance: Party Frames do less work in raids (health, power and shield updates are separate, power events only while a power bar is shown), Nameplates stop re-laying out friendly plates every tick, and the Cooldown Manager skips icons without visibility rules.
- New /kperf window with CPU and memory per module, with snapshots to compare before and after a change.
- Unlock Mode: Focus and Focus Target no longer drift away from their mover while the unit is hidden, and Reset Position works after a drag.
- Unit Frames: Text Size now scales the text of the Blizzard-style looks. In Classic the name window takes the class color when health is not class colored, and the raid marker sits on top of the portrait in the Blizzard-style looks.
- Skins: popups use the Settings artwork, breath and fatigue bars get striped bars in Blizzard's colors, and the Professions rank bar no longer shows a floating flare over an empty bar.
- Cooldown Manager: a potion quality saved from a Retail profile no longer hides every potion; Forever only offers Highest and Most.
- Cooldown Manager: buff icons appear as soon as you gain the buff (they could wait until combat), and no longer stay hidden for seconds when combat starts.

## 0.1.4 (2026-10-12) - Beta

- New Debuff Tracker tab in Enhancements: shows which important raid debuffs your target is missing (Sunder Armor, Expose Armor, Faerie Fire, the Curses of Recklessness and of the Elements, Hunter's Mark, the Judgements, Fire Vulnerability, demoralizing effects and rogue poisons), whoever applies them. Missing ones are dimmed and glow, active ones show their timer and stacks, and you can add your own. In combat, where the client hides enemy auras, debuffs seen before the pull keep updating and the rest show a question mark.
- Minimap: choose the side (left, right, top or bottom) for the Teleport Menu, Guild, Friends and KUI options icons and show or hide each one. The live preview now draws the real map of your zone inside the chosen shape, with the icons in place, and the shape picker no longer errors with the Retail ring.
- Party Frames: in the Classic, Retail and Forever styles the portrait fills its ring, the Dead, Offline and AFK icon sits on the portrait, debuffs get their own strip below the frame instead of covering the next one, and the live preview and Party Test show portraits again. These styles keep the portrait on, as their art needs it.
- Unlock Mode: dragging the X or Y slider no longer sends the element away or makes it flicker, and editing X no longer makes Y sink.
- Nameplates: a friendly player who challenges you to a duel no longer shows two plates at once.
- Chat: Battle.net toasts (friend online, invites) are visible again.
- Profiles: the Debuff Tracker and the Dungeon Timer export, import and reset as their own module profiles, and the General profile carries the window move settings.

## 0.1.3 (2026-10-11) - Beta

- New Flight Master module, replacing Dragon Riding. A flight bar shows origin and destination, remaining time or arrival time, and whether the duration is measured or estimated. Routes with stops get a button to land at the next stop, and an optional sound plays on landing.
- Flight Master guide: every flight point with its distance from you, flight master portrait, flight time and known or undiscovered state, with search, filters and pages, sorted by distance by default. It appears in the options page, next to the flight map when you talk to a flight master, and with /kfm.
- Flight times are measured on every flight, shared by all your characters and, optionally, with guild and group members using KullThranUI.
- New Dungeon Tracker in Enhancements: elapsed time, bosses defeated, party deaths and dungeon history, with live preview and appearance options.
- Friends list enhancements work with the new Social window of the Forever client.
- Chat: each whisper window shows only its own conversation.
- Character names with surnames show correctly on nameplates and Unit Frames.
- Unlock Mode: right-clicking an element opens a complete Element Options menu. Width, height, X and Y have sliders and number boxes, and you can anchor the element to another one with its own offsets and extra width, pick the screen point positions are measured from, fade it on mouseover, center it, or reset its position and size.
- Unlock Mode: Unit Frames, Cast Bar and Party Frames resize with the same width and height settings used on their option pages.
- Unlock Mode: the unsaved changes dialog is back, with Exit Without Saving and Save & Exit. Esc or clicking outside returns you to editing.
- Unlock Mode: movers are more opaque, the element list uses flat rows, and hovering a row highlights its element on screen while clicking it makes it flash. Elements also have new hover, click and selection animations.
- Leaving Unlock Mode without saving no longer changes Unit Frame scale. The Player frame is restored once to 132% in the Classic, Forever and Retail styles.
- Resource Bars: new Autoattack Bars that replace Blizzard's autoattack bars while enabled, with fill or empty direction, color, a test button and artwork that follows the selected visual style.
- Damage Meter: new Visual Style selector (KUI, Retail, Forever, Classic). Only the look changes; every window keeps its own mode, session, size and position.
- Classic style: Holy Power, Soul Shards, Runes, Essence, Chi and Arcane Charges use a classic gem tray under the Player frame, aligned like the combo points.
- Retail and Forever styles keep Blizzard's own class resource art and animations under the Player frame.
- Target of Target and Focus Target use the small Blizzard frame with power bar and portrait in the Classic, Forever and Retail styles, and their previews match.
- Druid combo points are only shown in Cat Form, in every combo style.
- Party Frames: in the Classic, Retail and Forever styles, debuffs sit centered below the frame instead of over the health bar when the debuff anchor is Center.
- Cooldown Manager: the KUI Tracker no longer shows another class's interrupt or defensive (for example Kick on a Warlock) when characters share a profile.
- Cooldown Manager: bars keep their exact position after being dragged in Unlock Mode and when arena layouts reset.
- Unit Frames: AFK, Dead, Ghost and Offline badges update correctly when you switch target or focus.
- Unit Frames: names written in Korean, Chinese or Japanese characters display correctly instead of empty boxes.
- Target auras refresh reliably after target changes.
- Bags: using an item from the bags in combat no longer triggers a blocked-action warning. The bag updates as soon as combat ends.
- Bags: item categories (Equipment, Consumables, Reagents, Junk and the rest) are now built into KullThranUI and work on their own.
- Nameplates: KUI style bars no longer keep the fill texture left by a previously applied style, and group threat colors stay readable.
- Teleport Menu shows destination names in your client's language.
- Minimap layout refreshes with your current settings after combat.
- Tooltip, Installer previews, Inspect, Minimap and Aura Reminders texts are now translated in every supported language.
- Unit Frames: the PvP icon of the previous target no longer stays on the frame when you switch targets in combat.
- Cast Bar: chaining fast casts no longer hides the first cast halfway through.

## 0.1.2 (2026-10-06) - Beta

- Party Frames now offer KUI, Forever, Retail and Classic style cards with independent class-color or health-color selections.
- Reworked Party Test and live previews to match the selected style, with randomized classes appropriate to the client.
- Fixed KUI party portrait layering and aura placement; sample dispel overlays are limited to one frame.
- Forever, Retail and Classic party frames are 25% larger by default. KUI frame sizing remains unchanged.
- Debuff overlays default to disabled for Forever, Retail and Classic party styles.
- Raid group movers are available in Unlock Mode outside an active raid.
- Elite and Rare nameplate indicators fit the upper-right corner without reducing their size and support manual X/Y offsets.
- Focus, Target of Target and Focus Target frames and previews use matching frame artwork for the selected style.
- Cast Bar style controls have clearer icons and an Apply Style button matching the options interface.
- Refined the Profiles page layout and module export/import controls, with accent-colored borders and clearer text.
- Visual Style cards use rounded surfaces and a subtle hover effect, with no card tooltips.
- Refined the options search bar to fit the header; performance readings are now in Enhancements > System Tuning.
- Test buttons use transparent backgrounds, clean white text and outlined borders. Options text follows the global font.
- Restored the KUI Move configuration for Forever and improved movable-window registration.

## 0.1.1 (2026-10-05)

- Cast Bar now offers KUI, Classic, Forever and Retail preview tabs with Apply controls; native styles use Blizzard casting art and colors. Classic has no icon, outlined text and a properly layered frame.

**New**
- Nameplates mark enemies you still need for a quest with a yellow "!" in every style.
- Party Frames: Portrait Mode (2D, 3D or Class Theme) with 3D Portrait Zoom, Rotation and X/Y Offset sliders.
- Chat: new "Click Channel to Chat" option; left-click a channel tag to start typing in that channel.
- General: new "KUI controls the UI scale" option.
- Unit Frames: Blizzard-style name and level text, combat and resting icons, and a combo point ring on the Target frame.

**Improved**
- Forever nameplates redesigned: taller bars with the Retail texture, the name above the bar, a bronze border with softly rounded corners, and the level in a yellow box beside the bar.
- Classic nameplates show the level as a gold number on a gold pill at the end of the bar and are larger by default.
- The nameplate live preview shows the selected visual style.
- Better 3D party portraits, and 3D portraits in circular Unit Frame portraits.
- The Classic style shows the original Blizzard text on health and power bars, and its Rare/Elite ring hugs the portrait.
- Combo points use a look that matches each visual style by default.
- Redesigned Mail skin.
- The Installer returns to the Visual Style page after a style change reloads the interface, and no longer reopens by itself if you closed it.

**Fixed**
- KUI no longer changes your UI scale or moves Edit Mode frames unless you choose to, and module on/off toggles apply correctly.
- Fixed KUI Tracker icons briefly showing a green swipe.
- Profile import notices, nameplate style prompts and visual style messages are now available in every supported language.
- KUI Style target combo points now form a separate row above the portrait.
- Classic Rare/Elite overlays fit KUI circular portraits without the stock level socket.
- Classic player health and power percentages appear inside their bars.
- Blue quest-objective nameplates use a darker shade in Classic.
- Aggro glow illuminates the complete Classic Rare/Elite decoration.
- Target arrows respect the frame and level badges in every nameplate style.
- Unit Frames live previews show the complete Rare/Elite artwork beneath the level.
- Cast Bar styles use Avant Garde text, with style icons in the tabs and preview.
- Fixed Hide Alerts suppressing loot-roll windows; pending rolls remain visible and selectable.
- Unit Frame combo displays can be toggled independently and combined; Target defaults to the portrait ring, with correctly aligned optional rows.
- Retail-style nameplates keep stable atlas geometry as camera scale changes.
- Fixed Nameplate Tip of the Spear and Whirlwind tracking on player lifecycle and spellcast events.
- Applying KUI Style on Retail keeps Unit Frame portraits disabled, including previously saved style settings.

## 0.1.0 (2026-10-03)

Beta focused on making every visual style consistent across Unit Frames, Nameplates, Minimap and Skins.

**New**
- Nameplate style presets (KUI, Classic, Retail, Forever) in Nameplates > General, with a compact preview of each; choosing one resets sizes and offers a reload.
- Minimap frame rings per style (Forever, Retail, Classic) with a visual selector and Live Preview; choosing a visual style applies its ring and removes the decorative gold circle.
- Combat text on the portrait (Dodge, Miss, damage) in every style, with an off toggle and a white-numbers option.
- Incoming heal prediction bar on all unit frames and styles.
- Aggro glow on/off toggle; it now also lights the Target frame portrait overlays when you hold aggro on the target.
- Modern PvP icon is the default in Retail and Forever; the PvP circle turns dark grey with the Rare border.

**Improved**
- Classic nameplates now match the original: bronze rounded border, gold-ringed oval level plate with the difficulty-colored number, the original matte bar texture and saturated red/green fills.
- Retail and Forever nameplates now use Blizzard's own nameplate atlases (bar fill, rounded border, cast bar), with red enemies, the level inside the bar in white, and an extra bronze ring in Forever. Existing blue or orange enemy colors are migrated automatically.
- Retail and Forever nameplates are taller; enemy target and focus frames use class or reaction colors instead of the theme green.
- Rare/Elite portraits keep the atlas frame around the health and power bars.
- Combo points placed above the frame adapt to the Classic tray (mirrored) and to the loose pips, also in the Live Preview.
- Resource bars show their resource/power text by default in every theme.
- Selecting a theme now also resets the nameplate style and sizes.
- Party frames no longer draw above other windows.
- Action bars: cooldown swipes now fill the whole icon on KUI and Simplicity buttons and follow the button shape (circle and others) on Blizzard bars.
- Objective Tracker: the "All Objectives" header is shown again and every module header gets an accent-colored gradient bar.
- Cooldown Manager: shaped icons no longer show the square background behind them.

**Fixed**
- Forever clients were detected as Retail, mislabeling profiles; existing misnamed profiles are renamed.
- The target class portrait kept the previous class after changing target, and flipped did not apply.
- Chat: clicking a player name opens a whisper again and /played shows its result.
- Skins: guild invite emblem, Auction House and popup money fields, and the Send Mail layout with attachment feedback.

## 0.0.9 (2026-10-02)

Beta centered on a full visual-style refresh: Forever, Classic and Retail now look like their originals while staying customizable.

**New**
- Forever, Classic and Retail styles with authentic player, target and pet frame art, plus matching action bars, cast bars, resource bars, nameplates, minimap, damage meter and objective tracker.
- Pet frame follows the selected style and appears in the Unit Frames live preview.
- Combo points under the Player and Target frames, chosen separately: Off, Modern or Classic (Target also has a portrait Ring), placed below or above the frame with X/Y offsets and a live preview. Classic is on by default in the Classic style.
- PvP icon styles for Player and Target: Modern or Classic banner, Classic by default in the Classic style.
- Action Bar Art selector with live previews.
- Circles and Pips options for combo points.
- Per-ability cooldown display rules: always visible, only while usable, hidden while ready or on cooldown, reduced opacity, and charge controls.
- The new race's racial is detected by default in the KUI Tracker.

**Improved**
- Redesigned player, target and pet frames: portraits, level and rare/elite indicators, names, buffs and a new frame-size option.
- KUI Tracker adapts to every style, with buffs placed correctly and an accurate live preview.
- KUI Tracker catalogs are exclusive to Forever, and each item appears only in its proper tracker.
- Party portraits on by default; dispel overlay changes apply instantly, even in combat.
- Profile imports warn when a profile comes from a different game version.
- Chat uses Avant Garde as its fixed font.

**Fixed**
- KUI Tracker elements move and keep their position in Unlock Mode.
- Rare/Elite portrait borders and loot-roll alerts display correctly.

## 0.0.8 (2026-09-27)

Forever beta maintenance release carrying the latest tested addon state and refreshed package metadata.

- Updated all Forever addon TOCs to version 0.0.8.
- Prepared the release workflow and package for explicit GitHub, CurseForge, and Wago beta publication.

- Restored Blizzard's special-NPC state so friendly quest givers retain their native overhead question-mark indicator.
- Prevented friendly nameplate FontStrings from calling `SetText()` before a font is initialized during level updates and frame recycling.
- Split Friendly Name Only into independent Player and NPC controls and moved them higher in the Friendly display page.

## 0.0.7 (2026-09-26)

Forever beta release focused on the latest Nameplates, Unit Frames, and Bags visual and compatibility improvements.

- Added protected-value-safe dynamic Nameplate level placement that keeps the level beside the rendered name and repositions classification and aura icons consistently.
- Added configurable Dynamic Level Layout support and refreshed Nameplate classification artwork and anchoring for enemy, NPC, and friendly plates.
- Added custom Rare and Elite classification icons to Unit Frames, including portrait-ring rendering, no-portrait placement, side-aware mirroring, and delayed metadata refreshes.
- Added a beige highlight frame for newly collected items in Bags, synchronized with Blizzard new-item state and cleared when the item is viewed.

## 0.0.6 (2026-09-26)

Forever maintenance release focused on Bags, Nameplates, dungeon tracking, protected-value safety, and party frames.

- Added a visible gold highlight border to quest-item icons in Bags, including recycled slots and Forever item-classification fallbacks.
- Fixed a Nameplates protected-value error by removing comparisons against secret text geometry while anchoring level text.
- Added a dungeon Objective Tracker fallback that lists every detected boss and marks defeated bosses with [X], including delayed refreshes while entering or updating an instance.
- Fixed the dungeon tracker fallback detection for Forever by supporting both IsInInstance() and GetInstanceInfo() and avoiding false suppression by an empty native scenario block.
- Fixed an oUF portrait taint error caused by comparing secret GUID strings; unit identity now uses UnitIsUnit() and protected GUID changes are ignored safely.
- Fixed distorted dead/offline icons in Party Frames after AFK status geometry changed the shared icon dimensions.

## 0.0.5 (2026-09-25)

Forever maintenance release focused on Nameplates, Aura Reminders, texture opacity, and chat sync.

- Reverted a scaling regression that caused Enemy Nameplates to stay excessively large at long distances instead of scaling normally.
- Decreased the default size of Enemy Nameplate debuffs and upper/lower aura slots by 25%.
- Implemented fully dynamic positioning for Nameplate level text; the level indicator now perfectly hugs the left edge of the unit's name, preventing overlap regardless of name length.
- Refactored Aura Reminders: Removed group-wide logic (such as checking if party members are missing a buff). The module now operates on a strict personal basis, solely reminding you if your own character is missing the buff.
- Fixed an issue in Chat where clicking a channel or whisper link in the chat frame would immediately revert to the default channel instead of keeping the manually selected one.
- Finetuned the darkening opacity (wash alpha) of the KUI background textures on the Bags, World Map, and Objective Tracker interfaces. The opacity has been set to 0.38, matching the Armory module for better visual consistency.
- Audited all module toggle options (Enable Module). Fixed an issue where toggling the Enhancements and Cursor modules would not prompt for a UI reload, ensuring complete and clean activation/deactivation across all modules.
## 0.0.4 BETA (2026-09-24)

Forever beta maintenance release focused on chat, minimap, Armory, Collections, Appearances, and Bags.

- Restored chat sender names, class colors and clickable player links with Blizzard right-click interaction; preserved message text, item links and whisper history through reloads.
- Fixed chat payload handling so empty or protected messages cannot be replaced with the sender name.
- Applied the Retail minimap positioning and launcher restoration fixes to the Forever layout.
- Improved Armory surfaces, stats/progress panels, and texture treatment so character and inspection views remain readable.
- Reworked Collections and Appearances skinning with safe Forever OnClick hooks, restored native slot and right-hand icons, and balanced textured surfaces.
- Set Bags texture darkening to 62% across the window panels.
- Removed the syntax-broken popup recovery fragment; the active popup skin remains in Popups.lua.
- Hardened Aura Reminders, Unit Frames, Party Frames, Nameplates, Cooldown Manager, and Objective Tracker paths for Forever API and protected-value differences.
- Published explicitly as BETA with matching release notes on GitHub, CurseForge and Wago.

## 0.0.3 (2026-09-20)

Forever beta follow-up focused on the Forever-native layout, options, installer, and release flow.

- Reworked KUI Move as KUI Move Forever with a curated Forever frame catalogue, Forever-specific naming, aliases, frame toggles, position and scale controls, and safe Settings fallback handling.
- Fixed the General > KUI Move page so it exposes real configuration controls instead of only a dead external button.
- Corrected Forever default layout handling for Unlock Mode elements, including Equipment Durability, Focus, Focus Target, Pet, and Target of Target while accommodating Forever SavedVariables limitations.
- Improved KUI Tracker and Aura handling so Forever icons and positions are rebuilt reliably after Unlock Mode edits instead of retaining Retail-only or stale copies.
- Adjusted Armory layout and stat presentation to keep the character, equipment slots, original Blizzard stats, and KUI stats visible without panel overlap.
- Made Cast Bar and Resource Bars use the intended Forever defaults, including fixed width behavior, matching resource-bar dimensions, and mana on the pet bar.
- Removed or filtered Retail-only Enhancements, Damage Meter class data, profile choices, and Skins paths that do not apply to Forever.
- Limited External Addons quick access to addons installed and enabled in the current Forever client, showing their available configuration commands and resolving registered command aliases.
- Updated the Forever installer branding with the blue square KUI logo, the Forever logo, a blue Feral Shape, and an explicit Retail-to-Forever adaptation description.
- Validated the beta package against Interface 16001 and refreshed the GitHub, CurseForge, Wago, and Discord release workflow for Forever beta publication.

## 0.0.2 (2026-09-19)

Cumulative WoW Forever beta release notes from the 0.0.1 baseline. This branch is versioned independently from Retail 5.0.7.

- Updated the package, core addon, module TOCs, release tooling, and in-game version sources to 0.0.2.
- Added Forever/Camelot detection and compatibility guards for the reduced API surface, specialization data, item information, range checks, protected values, and secret values.
- Hardened startup, AceDB/profile ownership, saved-variable migration, Installer state, changelog suppression, language selection, reload continuation, and Unlock Mode persistence.
- Fixed the Installer Don't show again state so it remains selected after reload and no longer reopens on every login; preserved the changelog suppression migration from 5.0.7.
- Connected Experience Bar to the current Unlock Mode registry, restored its visibility, position saving, and a safe default above the Blizzard action bars while Forever saved variables are incomplete.
- Removed Dragon Riding from the Forever-facing module flow and removed Mythic+ Timer from the Forever TOC, Installer, previews, and startup; retained Mythic+ History as normal Dungeon History.
- Disabled Combat Timer by default and migrated old profiles without overwriting an explicit later user choice.
- Added Forever-safe Aura Reminders filtering for available auras, weapon enchants, instance reminders, and Party Frame missing-buff reminders.
- Added Unit Frame and Party Frame level and PvP indicators, configurable typography and offsets, Elite/Rare classification indicators, circular portrait defaults, portrait borders, and correct overlay strata.
- Added visible Unit Frames and Party Frames toggles and live-preview rendering for level and PvP indicators; Target PvP now sits outside the right side of a right-hand portrait.
- Moved Target portrait to the right by default and made Target level, PvP, and classification indicators follow the actual portrait anchor whenever the portrait is moved.
- Corrected Unit Frames and Party Frames module enable toggles and made dispel overlay toggles apply immediately to every relevant aura/border path.
- Added configurable friendly-player levels to Nameplates and retained shared font, size, outline, shadow, color, X, and Y controls.
- Restyled Objective Tracker quest titles with the accent color across Forever legacy tracker blocks and added safer tracker discovery without assuming Retail ScrollBox APIs.
- Restored Armory visibility and Forever-compatible stats handling without feeding missing Retail stat strings into Blizzard tooltip formatters.
- Hardened KUI Move for Forever build/version semantics, accepted existing Forever frames marked with obsolete Retail ranges, and suppressed expected missing-frame noise.
- Fixed Skins option builders and other Forever frame/API differences that caused nil callback failures.
- Protected TeleportMenu cooldown comparisons, Action Bar and TextStatusBar paths, and other tainted/secret-number operations from Lua arithmetic and comparisons.
- Patched Rogue/Feral Combo Points in Resource Bars, Unit Frames custom Class Power, oUF ClassPower, and the oUF cpoints tag; Feral-only Druid mapping avoids applying Combo Points to other Druid specs.
- Fixed Aura Reminders and Party Frame APIs for Forever-only spell/item availability and removed Retail-only assumptions from reminder catalogs.
- Improved Chat whisper history so all outgoing whispers display, including Forever events with lineID 0, while keeping protected native chat handling safe.
- Moved the default Damage Meter position down and left, improved its protected-value handling, and kept custom user positions intact.
- Kept diagnostics available through /ktdebug and /ktpersistdebug, with persistence logging disabled by default after the migration was verified.
- Validated changed Lua files with Lua 5.1 syntax checks and validated repository whitespace with git diff --check.

## 5.0.7 (2026-09-18)
- Added WoW Forever and WoW Forever Beta detection to Enhanced Friend List, including the dedicated WoW Forever artwork and distinct tooltip labels.
- Hardened Enhanced Friend List native tab handoff and embedded Raid navigation while preserving Blizzard's protected click path.
- Fixed Raid Warning taint caused by secret or unit-derived values by using a safe static warning message and protected-value checks.
- Improved Chat handling for protected and secret message data, including safer whisper capture and native channel integration.
- Refined Minimap utility-button collection and restoration so addon launchers are handled without disturbing Blizzard's map, waypoint, POI, or scanner controls.
- Reduced Cooldown Manager background work with coalesced event-driven refreshes and safer handling of protected cooldown values.
- Improved Mythic+ History damage matching and ranking fallbacks, added font fallback support, and added an option for LFG class-colour bars.
- Hardened Aura Reminders, Nameplates text rendering, and Modern KUI skins for current protected UI and Blizzard frame changes.

## 5.0.6 (2026-09-13)
- New Feature: Mythic+ History. A detailed Mythic+ history has been added to the Enhancements module, allowing you to track completed keys and view a keystone summary breakdown, including a damage meter to see who did the most DPS during the run. NOTE: The Mythic+ History will only display all party members after activating the submodule, as KullThranUI needs to start saving the runs internally from that point forward.
- Localization updates: Translations have been applied across all KullThranUI modules. Localization and compatibility have been expanded to cover 97% of the addon and its features. Added country flags to easily     distinguish languages. Fixed translation errors across several Widget elements and the Enhancements submodule.
- Skins module update: New visual style applied. Improved the visibility and overall readability of the reskinned default Blizzard frames.
- Added a scrollbar to the Widget system. It will now appear automatically in all modules that have enough options to require scrolling.
- Added a Minimap button to open KUI options directly.
- Fixed an issue in the Objective Tracker where the 'Scenario' header would display even when not inside an instance.
- Fixed KUI Tracker behavior in the CooldownManager. Potion and Warlock Healthstone cooldowns will now properly reset after a raid boss wipe/reset (when the appropriate conditions are met).
- KullThranUI is now officially available on GitHub! Future updates for CurseForge and Wago will be deployed from there, and Pull Requests will soon be enabled so the community can help improve translations.
- Added a configurable Combat Timer to Enhancements, with an idle display, a short final-duration hold, styling controls, Unlock Mode support, and a frame width that follows the rendered timer text.
- Promoted Melli Reforged to the default status-bar texture across KUI, including a one-time Resource Bars migration from Melli and synchronized texture selection for health, primary, and secondary resources.
- Added per-module profile import and export controls to options pages and corrected profile ownership for Action Bars, Bags, Progress Bars, External Addons, Enhancements, and other scoped settings.
- Expanded Nameplates target highlighting with multiple indicator styles, reversible direction, indicator shadow glow, configurable indicator and target-glow colors, scaling, previews, and preset support.
- Refined the Nameplates Display live preview with compact one-row font, outline, and bar-texture selectors, and fixed health-bar clicks so they open the corresponding size settings.
- Improved SharedMedia selectors throughout KUI with complete registered font and texture lists, inline previews, dependable scrolling, and support for media added by other addons.
- Reworked the Cooldown Manager potion tracker with stable combat, health, healthstone, and optional mana slots, selectable potion quality, corrected Midnight item ranks, and combat-safe layout updates.
- Restored Action Bars hotkeys, overlay glows, mouseover behavior, bindings refreshes, and visual enhancements on protected buttons while isolating unsafe cooldown hooks for Midnight APIs.
- Updated Aura Reminders for Midnight Season 2 with locale-independent instance IDs, spell icons, scrollable talent selectors, and compatibility with older name-based reminders.
- Improved Party Frames with selectable SharedMedia health and absorb textures, matching live previews, and missing-buff reminders that ignore non-player companions and scenario NPCs.
- Extended Unit Frames with Melli Reforged defaults, full SharedMedia font and status-bar support per unit, live media previews, and a corrected Default Texture control.
- Reworked Character and Armory navigation with accent-aware Stats, Titles, Equipment, and Progress tabs, more reliable pane visibility, and a compact configuration button beside the close control.
- Hardened Enhanced Friend List raid navigation by passing protected roster clicks through Blizzard's native control and correctly restoring or suppressing the native frame artwork.
- Fixed the dedicated Group chat tab so it receives the complete native group-message set while respecting secure and combat-locked chat restrictions.
- Refined the minimap button drawer so it captures only genuine addon launchers, leaves Expansion Summary, waypoints, POIs, and scanner pins untouched, and restores original button sizes.
- Expanded the Tooltip live preview with real player identity, guild, specialization, faction, item level, Mythic+ or PvP score, raid progress, and class-colored health styling.
- Added a configurable Great Vault skin, refined World Map breadcrumbs and search styling, fixed Ready Check decision labels, and removed the duplicate protected Game Menu skin path.
- Hardened the Escape Menu against FrameMeasurement taint by removing unsafe enumeration of foreign overlay frames anchored to protected nameplates.
- Fixed Ready Check layouts for both incoming and self-initiated checks, removing leftover Blizzard artwork and the empty panel behind consumable trackers.
- Eliminated periodic Cooldown Manager combat freezes by coalescing tracker refreshes and avoiding repeated inventory, tooltip, and item-spell scans.
- Reduced Nameplates interrupt-tracker overhead by replacing global cooldown-event rebuilds with lightweight local ticker updates.
- Expanded /ktfreeze diagnostics with event/addon attribution and Lua allocation/GC tracking without intrusive global CPU polling.
- Reworked Enhancements with a Mythic+ timer that owns its tracker presentation, key details, forces progress, deaths, boss objectives, chest thresholds, and completion state.
- Expanded Mythic+ timer configuration with independent fonts, textures, sizes, widths, heights, colours, glow controls, chest-one, chest-two, chest-three, and forces-bar typography, plus a remaining-time-only display with localized forces text.
- Made SharedMedia font and texture selectors complete and usable throughout Enhancements, including installed fonts and textures, inline preview rendering in dropdowns, left-aligned option labels, and corrected selector placement.
- Reworked Damage Meter configuration and preview with realistic player/spec data, working dynamic Blizzard window discovery, font and texture controls, centered bar layout, selectable spec/class/hidden player icons, rounded icon support, and corrected bar spacing.
- Added automatic LFG role-check controls under Automation & Social, including selectable Tank, Healer, and Damage roles and automatic confirmation when queueing alone or with a group.
- Refined Enhancements navigation with module-specific artwork, accent-coloured icons, the red sword Damage Meter icon, Blizzard chat artwork for Automation & Social, and clearer Interface & Comfort and System Tuning references.
- Hardened LFG and popup skins for current Retail UI changes, including accent-only queue-ready borders, working close buttons, black uncovered popup surfaces, preserved dungeon artwork, and safer handling of native NineSlice and border textures.
- Fixed the KUI Unlock Mode navigation state so closing and reopening the main options window cannot leave Unlock Mode visually selected as the active page.
- Completed the Enhancements localization pass across the supported locales for the new timer, Damage Meter, LFG automation, typography, texture, forces, preview, and navigation strings.
- Restored reliable per-conversation whisper capture on secure-chat builds by mirroring Blizzard-rendered whisper lines into KUI history, including Battle.net conversations, without bypassing the selected whisper thread.
- Hardened Chat integration for protected message and channel data by avoiding unsafe native filter and channel-list mutations, preventing taint attribution and protected-table failures during PvP and other restricted chat dispatches.
- Reworked first-time setup for new characters with a dedicated starting-profile choice, allowing existing saved profiles to be selected or KUI defaults to be used without forcing every character onto the KullThranUI profile.
- Improved Installer and profile startup handling with stable per-character tracking, safer specialization-profile transitions, correct layout imports into the active profile, and more reliable continuation through conflict detection and setup.
- Expanded the Fonts & Colors page with live font previews, a separate Launcher and Options font, individual typography controls for major HUD, social, character, and inspection areas, and additional color controls for interface surfaces, action bars, progress displays, Chat, Armory, and Inspect.
- Reworked global font inheritance so modules that still follow the global font update together while explicitly customized areas preserve their own selection, with combat-safe deferred refreshes across the supported interface.
- Refined the main configuration window with an accent-colored KUI logo, a new resize grip, a slimmer navigation scrollbar, immediate minimap social-icon recoloring, and a scalable nine-slice background that preserves its proportions at preset and custom window sizes.
- Redesigned KUI Unlock Mode with a wider and cleaner sidebar, clearer active-element feedback, improved mover menus, direct access to profile importing, an animated opening logo, and an automatically retracting sidebar that remains available from the edge of the screen.
- Improved the in-game changelog window so its complete “Don’t show again” row is clickable, the current patch suppression state is restored correctly, and enabling or disabling the option is saved immediately.
- Hardened Chat against protected edit-box state changes during combat, preventing unsafe whisper, Battle.net, and chat-type mutations while retaining the normal input flow outside combat.
- Reduced Cooldown Manager background work by replacing continuous glow polling with coalesced event-driven updates, refreshing only affected bars when possible, and avoiding redundant transition passes once Blizzard’s Cooldown Viewer pools have stabilized.
- Improved Cooldown Manager trackers by hiding unavailable potion items, keeping owned potion ranks synchronized, stabilizing player and target frame anchoring around narrow CDM layouts, and making arena, battleground, specialization, and world-transition recovery more selective.
- Reworked centered horizontal Party and Arena layouts so the player remains in the intended middle position as the group fills, with a corrected bottom-center default position for horizontal Party Frames.
- Improved Party Frames range, phase, roster, aura, and encounter handling with more reliable out-of-range recovery, independent dispel indicators, properly layered AuraKit dispel effects, boss-frame activation during encounters, and fewer unnecessary full roster rebuilds while zoning.
- Refined Modern KUI group-interface skins with complete accent borders for selected LFG entries, clearer role-selection feedback, and a rebuilt Ready Check presentation with restored portraits, dedicated Ready and Not Ready buttons, consistent surfaces, and accent-aware artwork.
- Restored reliable first-run Installer startup for new users and brought back the visible "Don't show again" control, with synchronized login settings so the prompt can be disabled or re-enabled cleanly.
- Hardened Chat against protected and secret PvP payloads, preventing duplicated battleground system messages while preserving Blizzard's native message handling.
- Restored access to Blizzard's Group Management controls, including raid and world-marker tools, when KullThranUI Party Frames are active.
- Improved Party Frames during PvP and arena transitions with safer protected-unit handling and more reliable roster, role, raid-target, and aura refreshes.
- Fixed KullThranUI Bags tainting Blizzard's protected container click path, restoring item use, equipping, dragging, and background drops without UseContainerItem() forbidden-action errors.
- Redesigned the main KullThranUI configuration window around expandable module categories, with dedicated 60x40 category artwork, compact module shortcuts, persistent multi-category expansion, and reliable toggling from both the category row and its arrow.
- Added category overview pages that present every available module as a large shortcut card with its icon and a concise description, while keeping the most recently selected category open in the right-hand panel.
- Corrected category selection and navigation feedback so only the active category remains highlighted, module counts appear only on category overview pages, and expanded categories can coexist without changing the active page.
- Refined the global options presentation with a slightly brighter panel background, consistent category-arrow artwork based on the KUI minimap button, and cleaner icon, spacing, and selected-state behavior throughout the sidebar.
- Reworked private whisper persistence so opened character and Battle.net conversations can survive a UI reload, including conversations opened before any message is exchanged, while closed conversations remain dismissed and session state is cleared on disconnect.
- Hardened Chat against protected and secret strings when capturing whisper targets or copying chat history, and prevented closed temporary Blizzard whisper windows from reopening automatically.
- Corrected Action Bar cooldown presentation so active cooldowns use a properly darkened swipe over every supported button shape instead of retaining the normal colored background.
- Rebuilt Damage Meter player pinning around a pinned final row: the player remains visible without corrupting the real ranking order, scrolling can inspect the complete list, and combat-start refreshes no longer push the meter to an unrelated position.
- Improved Damage Meter combat-session handling, saved history, protected-value support, and live refresh scheduling to avoid redundant delayed updates during continuous combat events.
- Added a genuinely opaque Objective Tracker background mode with a solid black surface, an accent-colored top border, and an accurate live preview that cannot inherit the legacy gradient or fade.
- Expanded Armory PvP item-level support with a working live-preview indicator and independent controls for visibility, label, decimals, font, size, outline, color, and horizontal or vertical positioning.
- Repositioned Installer Party Frame test controls into a compact left-aligned group so Party, Raid, and Raid 40 tests no longer overlap or distort the live preview.
- Significantly reduced Party Frames update cost through unit-scoped event registration, coalesced aura refreshes, bounded absorb queues, cached aura state, and a centralized duration driver that runs only while required.
- Improved Nameplates runtime efficiency with reusable frame pooling and cached threat, quest-target, and contextual state, reducing repeated allocation and expensive unit scans during combat.
- Optimized Resource Bars to reuse resolved layout and marker data and to update ranges, values, and text only when their relevant unit state changes.
- Extended protected and secret-value safeguards across Party Frames, Resource Bars, Nameplates, Chat, Damage Meter, and other high-frequency combat paths for improved Midnight API compatibility.
- Added and reviewed localization for the new 5.0.0 category pages, Objective Tracker background controls, Armory PvP item-level settings, and related interface text across every supported language.
- Improved package hygiene by removing unused development artifacts, reference trees, duplicate media, temporary scripts, and unreferenced external resources, and added a KullThranUI license that explicitly preserves third-party ownership and licensing terms.
- Reworked the Installer flow so first-time setup opens reliably for every character, reload-required changes return to the exact previous step, and the Installer can be opened directly with `/installer` or `/ins`.
- Expanded the Installer with a dedicated Resource Bars step, clearer module enable and disable behavior, localized reload prompts, improved pressed-state feedback, and the correct KullThranUI background across every page.
- Redesigned Installer previews for Action Bars, Buffs & Debuffs, Party Frames, Resource Bars, Nameplates, and Armory so configuration choices use realistic layouts, class abilities, aura examples, and their actual icon shapes.
- Restored shape support across Action Bars, Buffs & Debuffs, and Cooldown Manager, including masked cooldown swipes, hotkeys rendered above masks, shape-aware selection feedback, and removal of square shadows from non-default shapes.
- Improved cooldown handling for protected and secret values, preventing repeated ActionButton and SetCooldown errors without relying on continuous texture updates.
- Reworked dispel and status overlays in Party Frames and Unit Frames for Magic, Poison, Curse, Disease, and Bleed effects, with the intended diffused presentation across party, raid, arena, and supported dungeon follower frames.
- Fixed friendly units retaining hostile colors after a duel and corrected additional reaction, target, and state refresh edge cases in Unit Frames and Party Frames.
- Improved Nameplates options with correctly initialized default slider values and search-style highlights restricted to the relevant configuration gears instead of covering complete option rows.
- Corrected Armory live previews so empty equipment slots remain empty, displayed stats match the real panel, and movement speed is calculated from the appropriate game values.
- Expanded and refined Modern KUI skins for Trade, Ready Check, Arena Shuffle, group invitations, role popups, PvP inspection, consumable frames, and other Blizzard dialogs.
- Fixed missing role icons in group invitation and acceptance popups, accent colors not applying to Ready Check consumables, and popup errors caused by invalid texture layers or unsafe hooks.
- Improved Enhanced Friend List invite-button styling so the original artwork follows the active accent instead of being replaced or remaining white.
- Reorganized minimap utility buttons outside the map with dedicated Calendar, Tracking, Mail, Friends, Guild, and Teleport Menu controls, consistent Modern KUI backgrounds, accent-aware social icons, and pixel-perfect edge anchoring.
- Separated Teleport Menu from the KullThranUI minimap-button collector, added a dedicated custom portal button and corrected label, and replaced the menu settings icon with the standard KUI gear artwork.
- Reworked Buffs & Debuffs with fully custom AuraKit containers managed through KUI Unlock Mode, preserving existing user positions during migration and applying consistent minimap-relative defaults and spacing.
- Restored the original Masque Simplicity appearance for auras, fixed weapon-enchant text initialization, improved the live preview layout, and made short durations clearly distinguishable from application counts.
- Optimized Buffs & Debuffs aura processing and improved icon reliability under the protected and secret aura restrictions used during combat.
- Reworked Cooldown Manager update scheduling to eliminate redundant full refreshes caused by cooldown and aura event storms, substantially reducing combat CPU usage.
- Fixed inconsistent CDM proc glows, missing or incorrectly spaced buff-bar icons, protected icon visibility errors, and tracking failures after the first use of an ability or item.
- Restored KUI Tracker defensive, racial, potion, and trinket tracking in raids and Mythic+, corrected potion rank and quantity selection, improved cooldown text visibility, and added reliable feedback for passive trinket procs.
- Added a Modern KUI skin for Blizzard's native Cooldown Manager and a direct button in KUI CDM options to open it, with combat-safe loading and proper support for its frame-based side tabs.
- Fixed a severe Bags performance issue caused by cooldown events. Bag item cooldowns now update incrementally, including Hearthstones, while item-level text is restricted to actual equipment.
- Added the `/ktcombat` combat profiler with per-addon CPU deltas, event counters, spike tracking, and detailed CDM phase and bar diagnostics.
- Optimized Party Frames aura and event processing in both idle and combat, restored dispel-type textures, and corrected AFK and Raid Assistant icons across group, raid, and Raid 40 layouts.
- Improved protected-frame handling across Unit Frames, Nameplates, Party Frames, and Cooldown Manager to prevent taint errors and forbidden frame-strata or visibility operations.
- Fixed the Damage Meter scrolling to random ranking sections and ensured that a manually selected top position remains stable while combat data updates.
- Corrected Armory movement-speed calculations and rebuilt stat-label sizing to prevent overlap without unnecessarily truncating Intellect, Stamina, Critical Strike, Mastery, and other labels.
- Fixed misplaced private whisper windows and prevented hidden Friends controls from intercepting right-clicks while the Social window is closed.
- Repaired Enhanced Friend List layout and interaction regressions, removed the Lua local-variable limit warning and nil-function error, and restored reliable opening, refreshing, and button behavior.
- Fixed missing role artwork in group invitations, the dark lower section of self-initiated Ready Checks, and Release Spirit availability during raid and Mythic boss encounters where releasing is not allowed.
- Fixed Aura Reminders continuing to request food after the player had already eaten from a feast.
- Improved Guild, LFG, popup, and Objective Tracker skin behavior and corrected several profile and localization edge cases.

## 5.0.5 (2026-09-05)
- Added a configurable Combat Timer to Enhancements, with an idle display, a short final-duration hold, styling controls, Unlock Mode support, and a frame width that follows the rendered timer text.
- Promoted Melli Reforged to the default status-bar texture across KUI, including a one-time Resource Bars migration from Melli and synchronized texture selection for health, primary, and secondary resources.
- Added per-module profile import and export controls to options pages and corrected profile ownership for Action Bars, Bags, Progress Bars, External Addons, Enhancements, and other scoped settings.
- Expanded Nameplates target highlighting with multiple indicator styles, reversible direction, indicator shadow glow, configurable indicator and target-glow colors, scaling, previews, and preset support.
- Refined the Nameplates Display live preview with compact one-row font, outline, and bar-texture selectors, and fixed health-bar clicks so they open the corresponding size settings.
- Improved SharedMedia selectors throughout KUI with complete registered font and texture lists, inline previews, dependable scrolling, and support for media added by other addons.
- Reworked the Cooldown Manager potion tracker with stable combat, health, healthstone, and optional mana slots, selectable potion quality, corrected Midnight item ranks, and combat-safe layout updates.
- Restored Action Bars hotkeys, overlay glows, mouseover behavior, bindings refreshes, and visual enhancements on protected buttons while isolating unsafe cooldown hooks for Midnight APIs.
- Updated Aura Reminders for Midnight Season 2 with locale-independent instance IDs, spell icons, scrollable talent selectors, and compatibility with older name-based reminders.
- Improved Party Frames with selectable SharedMedia health and absorb textures, matching live previews, and missing-buff reminders that ignore non-player companions and scenario NPCs.
- Extended Unit Frames with Melli Reforged defaults, full SharedMedia font and status-bar support per unit, live media previews, and a corrected Default Texture control.
- Reworked Character and Armory navigation with accent-aware Stats, Titles, Equipment, and Progress tabs, more reliable pane visibility, and a compact configuration button beside the close control.
- Hardened Enhanced Friend List raid navigation by passing protected roster clicks through Blizzard's native control and correctly restoring or suppressing the native frame artwork.
- Fixed the dedicated Group chat tab so it receives the complete native group-message set while respecting secure and combat-locked chat restrictions.
- Refined the minimap button drawer so it captures only genuine addon launchers, leaves Expansion Summary, waypoints, POIs, and scanner pins untouched, and restores original button sizes.
- Expanded the Tooltip live preview with real player identity, guild, specialization, faction, item level, Mythic+ or PvP score, raid progress, and class-colored health styling.
- Added a configurable Great Vault skin, refined World Map breadcrumbs and search styling, fixed Ready Check decision labels, and removed the duplicate protected Game Menu skin path.
- Hardened the Escape Menu against FrameMeasurement taint by removing unsafe enumeration of foreign overlay frames anchored to protected nameplates.

## 5.0.4 (2026-09-01)
- Fixed Ready Check layouts for both incoming and self-initiated checks, removing leftover Blizzard artwork and the empty panel behind consumable trackers.
- Eliminated periodic Cooldown Manager combat freezes by coalescing tracker refreshes and avoiding repeated inventory, tooltip, and item-spell scans.
- Reduced Nameplates interrupt-tracker overhead by replacing global cooldown-event rebuilds with lightweight local ticker updates.
- Expanded /ktfreeze diagnostics with event/addon attribution and Lua allocation/GC tracking without intrusive global CPU polling.
- Reworked Enhancements with a Mythic+ timer that owns its tracker presentation, key details, forces progress, deaths, boss objectives, chest thresholds, and completion state.
- Expanded Mythic+ timer configuration with independent fonts, textures, sizes, widths, heights, colours, glow controls, chest-one, chest-two, chest-three, and forces-bar typography, plus a remaining-time-only display with localized forces text.
- Made SharedMedia font and texture selectors complete and usable throughout Enhancements, including installed fonts and textures, inline preview rendering in dropdowns, left-aligned option labels, and corrected selector placement.
- Reworked Damage Meter configuration and preview with realistic player/spec data, working dynamic Blizzard window discovery, font and texture controls, centered bar layout, selectable spec/class/hidden player icons, rounded icon support, and corrected bar spacing.
- Added automatic LFG role-check controls under Automation & Social, including selectable Tank, Healer, and Damage roles and automatic confirmation when queueing alone or with a group.
- Refined Enhancements navigation with module-specific artwork, accent-coloured icons, the red sword Damage Meter icon, Blizzard chat artwork for Automation & Social, and clearer Interface & Comfort and System Tuning references.
- Hardened LFG and popup skins for current Retail UI changes, including accent-only queue-ready borders, working close buttons, black uncovered popup surfaces, preserved dungeon artwork, and safer handling of native NineSlice and border textures.
- Fixed the KUI Unlock Mode navigation state so closing and reopening the main options window cannot leave Unlock Mode visually selected as the active page.
- Completed the Enhancements localization pass across the supported locales for the new timer, Damage Meter, LFG automation, typography, texture, forces, preview, and navigation strings.
