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

Settings: the default bar sizes of each style are unchanged. If you picked combo points under the player frame yourself, that choice is kept.

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
