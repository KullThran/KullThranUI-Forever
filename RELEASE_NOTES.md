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
