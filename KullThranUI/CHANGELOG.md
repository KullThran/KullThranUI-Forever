# KullThranUI Changelog

Current addon version: **1.2.4**

Primary source: https://addons.wago.io/addons/kullthranui-forever/versions
Secondary source: https://www.curseforge.com/wow/addons/kullthranui-forever/files/all?page=1&pageSize=20&showAlphaFiles=show

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
- Cooldown Manager: tracked buff bars show their icon on the left by default. Bars still on the old default without an icon get it once.
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
