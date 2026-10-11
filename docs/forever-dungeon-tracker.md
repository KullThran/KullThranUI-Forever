# Forever Dungeon Timer

The Dungeon Timer is on by default (Enhancements → Dungeon Timer → Enable
Dungeon Tracker). Earlier builds saved it as disabled in every profile; a
one-time migration turns it back on, and later choices are kept. The HUD shows
elapsed dungeon time, difficulty, party deaths, defeated bosses and their time
splits. It uses the existing mplusTracker appearance and mover settings.

A run starts when entering a five-player dungeon. Leaving pauses it; returning
to the same map resumes it. A different dungeon, difficulty or character starts
a new run. The active run survives reloads. After resetting the instance for
another attempt, use Restart Dungeon Run (`/ktdungeon reset`).

Bosses are read from the journal if that API exists in this client. The
journal instance is resolved from the player's UI map (the instance ID from
GetInstanceInfo is a different ID space) and bosses are matched by encounter
ID, then by name. If the journal is not ready on the loading screen, the list
is filled in on the next update. Encounter
success and boss-kill events record progress. Completing all known bosses or
receiving the dungeon-finished event freezes the clock. Without a complete
list, the HUD reports observed kills without guessing a denominator. Finish
Dungeon Run (`/ktdungeon finish`) provides an explicit fallback.

`/ktdungeon test` previews a normal run; `/ktdungeon sim [seconds]` plays a
short run (two kills, a death, the final kill and completion) through the same
code paths as a real dungeon; `/ktdungeon stop` returns to live state. Neither
overwrites the saved run. `/ktdungeon status` prints whether the timer is
enabled, the current instance type and whether the HUD is shown. Move the HUD in KUI Unlock Mode.
Secret values in event payloads are ignored rather than compared, and
nameplate UNIT_HEALTH events are dropped before any work is done.
No challenge limits, affixes, keystone insertion, inventory actions or automatic
hiding of Blizzard's quest tracker are used by this module.

Validation: tests/forever_dungeon_tracker.lua executes the real module against
mocked instance, encounter and frame APIs. It covers reloads, splits, duplicate
deaths, completion, leaving/reentering, different maps, temporary previews,
missing journal APIs, late journal data, UI-map journal lookup, secret payloads,
the simulation, the default migration, saved mover anchors, profile changes
and navigation.
Client verification is still required, especially event support on Forever.
