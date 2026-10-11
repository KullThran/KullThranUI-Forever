# Loot visibility diagnosis

The temporary observer loads with Enhancements in both workspaces. It is enabled
by default for this investigation and records native loot events without replacing
handlers, changing positions, restoring visibility or choosing Need/Greed/Pass.

## Capture a disappearance

1. Reload the updated addon and run `/ktlootdebug clear` before a pending drop.
2. Let a Need/Greed/Pass window disappear without clicking a roll option.
3. Run `/ktlootdebug dump` immediately. Include the retained hide calls and latest
   events in the report. `/ktlootdebug` also prints current frame/parent visibility.
4. Disable the observer with `/ktlootdebug off` after capturing the issue.

The log includes `START_LOOT_ROLL`, cancellation, native Add/Remove frame calls,
`RollOnLoot`, Hide/OnHide, SetShown, SetAlpha and SetParent. Hide/opacity callers
include their stacks. Snapshots walk the parent chain and record shown/visible,
alpha, effective scale, anchors, bounds, strata, frame level and remaining roll time. Late-created frames are
observed after native loot updates.

At most 160 entries and 12 retained hide calls are kept in
`KT.db.global.lootVisibilityDebug`, saved with the core addon SavedVariables.
Hide calls are retained separately so timer updates cannot overwrite the cause.
The watcher stops after cancellation or 180 seconds; countdown alone does not
produce visibility-change records. This observer is diagnostic and does not
establish which addon caused the disappearance until a real capture is inspected.

## Relevant existing paths

- Enhancements filters cosmetic alerts and has a pending-roll visibility guard.
- Forever also loads BlizzardFrames with a separate roll visibility watcher.
- Blizzard handles Need/Greed/Pass and legitimate roll completion/cancellation.

The dump must distinguish an explicit choice, timer expiration or cancellation
from a frame/ancestor being hidden while a choice is still pending.

## Validation

`tests/loot_visibility_debug.lua` exercises hide caller stacks, parent opacity,
late frames, choice/cancellation observation, bounded persistence, disabling the
observer and absence of automatic rolls or extra frame visibility writes.
Existing loot filtering/recovery tests remain required. A real in-client capture
is still needed to identify the caller responsible for the reported disappearance.

## Forever recovery when reload reveals a pending roll

The build 1.60.1.70291 native `GroupLootFrame_OnShow` removes the keyboard roll
frame when `GetLootRollItemInfo` has no item name yet. Recovery must inspect the
result of `Show`, rather than treat an existing `rollID` as proof of presentation.
The Forever guard requests missing item data and retries on
`GET_ITEM_INFO_RECEIVED` and late loading of `Blizzard_UIPanels_Game`.
Recovery applies with ordinary alert settings, preserves Blizzard's waiting
queue and callbacks, and stops after presentation, cancellation or expiry.
Invalid/offscreen roll geometry is recovered without moving valid anchors.

`tests/loot_roll_visibility.lua` covers cold-cache recovery without reload,
rejected native first show, default settings, queue duplication, viewport scales,
late notifications after a choice/cancellation and expiry during another roll.
These checks simulate the native lifecycle; the next real group-loot drop must
still verify appearance and clicking Need/Greed/Pass in the client.
