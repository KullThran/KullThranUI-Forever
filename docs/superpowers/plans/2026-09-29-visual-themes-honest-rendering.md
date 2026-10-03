# VisualThemes Honest Per-Theme Rendering Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make each of the four VisualThemes (`kui`, `classic`, `forever`, `retail`) render as a visibly distinct identity in every module that owns one, instead of `forever`/`retail` reading as near-duplicates of `kui`.

**Architecture:** A new shared `ThemeBorderKit.lua` draws a real 9-piece border from the vanilla cast-bar sheet (`Interface\CastingBar\UI-CastingBar-Border`), reusable by any bar-owning module. `classic` is the only theme wired to it. `forever`/`retail` get a fixed per-theme accent/border color layered onto each module's own already-real texture/shape options — the same pattern already used this session for the Damage Meter and Minimap adapters. Each of the seven remaining adapters (`UnitFrames`, `CastBar`, `ResourceBars`, `CooldownManager`, `Nameplates`, `PartyFrames`, `ActionBars`) is its own task with its own audit-then-fix-then-verify cycle.

**Tech Stack:** World of Warcraft addon Lua (5.1), AceAddon-3.0/AceDB-3.0, LibSharedMedia-3.0. Automated tests run outside the game client via `"/c/Program Files (x86)/Lua/5.1/lua.exe" tests/visual_themes.lua` (a plain Lua 5.1 script that stubs `LibStub`/`KT` and loads the real `VisualThemes` files with `loadfile` — no WoW API available, so it can only prove adapter/profile-data correctness, never rendering).

**Spec:** `docs/superpowers/specs/2026-09-29-visual-themes-honest-rendering-design.md`

## Global Constraints

- Everything in this plan happens in the `KullThranUI-Forever-Workspace` only. No file in `KullThranUI-Workspace` (Retail) is touched.
- No tag, comment, identifier, or string in any created/modified file may reference any third-party addon by name.
- `kui`'s seeded values must not change observably, except for dropping a field already confirmed to have zero rendering effect (`classThemeStyle` in UnitFrames).
- `forever` and `retail` seeds may only: (a) pick among texture/shape/style values already real and already validated by that module, and (b) set a fixed accent/border color. Neither gets a new render branch.
- Only `classic`, and only in `UnitFrames`, `CastBar`, `ResourceBars`, `CooldownManager`, gets the new 9-slice border option.
- Every task's automated check is `"/c/Program Files (x86)/Lua/5.1/lua.exe" tests/visual_themes.lua`, expected final line `visual theme engine tests passed`. Every task also requires an in-game check (switch to the theme in `General > Advanced Style System`, confirm the module visibly changed and `kui` didn't regress) before being marked done — the automated test only proves the adapter writes/restores the right profile values, never that the renderer reacts to them.
- Every task ends by appending its findings (bugs, surprises, decisions) to `ESTUDIO_SELECTOR_ESTILOS_INSTALLER_RETAIL.md` §30, continuing the existing numbering (next entry is 19).

## Review Focus

- A profile where a module was never touched before (`getProfile()` previously returned an empty table) must seed the new fields without a nil-index error — every new field write goes through a `profile.x = profile.x or {}` guard exactly like the existing adapters already do.
- A user who manually customized a real field (e.g. `UnitFrames.borderColor`, `ResourceBars.primary.texture`) under `kui`, then cycles `kui -> classic -> kui`, must get their exact custom value back, not `kui`'s seed default — every task's test adds this round-trip case in the same style already present in `tests/visual_themes.lua` (see its `actionbars`/`unitFrames` restore assertions).
- Applying a theme while `InCombatLockdown()` is true is already refused by `ThemeEngine:ApplyAll` — no new task needed, but no new code in this plan may bypass that guard by calling a module's render function directly outside of the normal reload path.
- The very first time `classic` is ever selected on a profile that has no saved slot for it yet (fresh `seed()` call, not a restore), the new border-kit field must come from the adapter's `seed()`, not be assumed to already exist — covered by each bar-owning task's "fresh apply" test case.
- Switching away from `classic` to any other theme must hide the border-kit pieces, not merely stop repositioning them — each render-wiring step includes an explicit "hide when not classic" branch, and its in-game check includes a `classic -> forever` switch specifically to confirm no leftover border remains.

---

## Task 1: ThemeBorderKit — shared classic border renderer

**Files:**
- Create: `KullThranUI/Modules/VisualThemes/ThemeBorderKit.lua`
- Modify: `KullThranUI/KullThranUI.toc` (insert the new file's path immediately after `Modules\VisualThemes\ThemeEngine.lua` and before `Modules\VisualThemes\ThemePreview.lua`)
- Test: manual (no WoW API in the Lua test harness — see Step 4)

**Interfaces:**
- Produces (used by Tasks 2, 3, 4, 5):
  - `KT.VisualThemes:CreateClassicBorder(parent, layer, sublevel) -> border` — `parent` a Frame, `layer` a WoW draw layer string (default `"OVERLAY"` if nil), `sublevel` a number (default `0`). Creates 8 texture objects (4 corners + 4 edges — no center piece; callers already have their own bar fill) on `parent`, each `SetTexture("Interface\\CastingBar\\UI-CastingBar-Border")` with a fixed sub-rectangle of texture coordinates, cached in the returned `border` table (`border[1..8]`, plus `border.parent = parent`). Created once; safe to call again on the same `parent` only if the caller has not already created one (callers cache the returned table themselves, exactly as `Minimap.lua`'s `KT_PixelBorderFrame` caching already does).
  - `KT.VisualThemes:SeatClassicBorder(border, rect, scale) -> nil` — `rect` any frame/region to surround, `scale` a number (default `1`). Anchors the 8 pieces around `rect`'s edges, scaled. Idempotent: safe to call every refresh (memoize on `rect`/`scale` the same way `Minimap.lua`'s `UpdatePixelPerfectBorder` already does, to avoid redundant `SetPoint` calls).
  - `KT.VisualThemes:ShowClassicBorder(border, shown) -> nil` — `shown` boolean; shows/hides all 8 pieces as one unit.

- [ ] **Step 1: Write the file**

  In `KullThranUI/Modules/VisualThemes/ThemeBorderKit.lua`, follow the existing adapter file header pattern (`local addonName, ns = ...` / `local KT = LibStub("AceAddon-3.0"):GetAddon("KullThranUI")` / `KT.VisualThemes = KT.VisualThemes or {}`). Implement the three functions above. For the texture coordinate layout: `Interface\CastingBar\UI-CastingBar-Border` is a 256x64 sheet; derive your own reasonable corner/edge proportions independently by inspecting the rendered result in-game and adjusting (Step 4) rather than assuming exact pixel cuts up front — treat the first coordinate guess as provisional until Step 4 confirms it reads as a bordered frame, not as a guess that must be right on the first try.

- [ ] **Step 2: Register the file in the TOC**

  Add `Modules\VisualThemes\ThemeBorderKit.lua` to `KullThranUI/KullThranUI.toc` right after the `ThemeEngine.lua` line and before `ThemePreview.lua`.

- [ ] **Step 3: Syntax-check**

  Run: `luac -p KullThranUI/Modules/VisualThemes/ThemeBorderKit.lua`
  Expected: no output (valid syntax).

- [ ] **Step 4: In-game visual check**

  `/reload`, open any frame this session's later tasks will wire up (or a throwaway test frame via `/run`), call `KT.VisualThemes:CreateClassicBorder(SomeFrame)` then `KT.VisualThemes:SeatClassicBorder(border, SomeFrame, 1)` then `KT.VisualThemes:ShowClassicBorder(border, true)`, and confirm a visible metal-bordered-bar frame appears around it. Adjust the texture coordinates from Step 1 until it does. Log the final coordinates and what they looked like wrong before adjustment in `ESTUDIO_SELECTOR_ESTILOS_INSTALLER_RETAIL.md` §30 entry 19.

- [ ] **Step 5: Commit**

  ```bash
  git add KullThranUI/Modules/VisualThemes/ThemeBorderKit.lua KullThranUI/KullThranUI.toc ESTUDIO_SELECTOR_ESTILOS_INSTALLER_RETAIL.md
  git commit -m "feat: add shared classic border kit for VisualThemes"
  ```

---

## Task 2: UnitFrames — real values, dead-flag removal, accent color, classic border

**Files:**
- Modify: `KullThranUI/Modules/VisualThemes/Adapters/UnitFrames.lua`
- Modify: `KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUIUnitFrames.lua` (exact call site TBD by Step 4's grep — see below)
- Test: `tests/visual_themes.lua`

**Interfaces:**
- Consumes: `KT.VisualThemes:CreateClassicBorder/SeatClassicBorder/ShowClassicBorder` (Task 1).
- Confirmed facts (already audited this session, do not re-derive):
  - Real per-unit texture values (local table + LibSharedMedia fallback): `none`, `Melli Reforged`, `Melli`, `Melli Dark`, `Melli Dark Rough`, `beautiful`, `plating`, `atrocity`, `divide`, `glass`, `gradient-lr/rl/bt/tb`, `matte`, `sheer`, plus any LSM-registered name (`Blizzard`, `Blizzard Raid Bar` included — both are real, see spec §1).
  - `classThemeStyle` is read at `KUIUnitFrames.lua:3253`, `:5597`, `:6176` but its value is never inspected by `ApplyClassIconTexture` (`KUIUnitFrames.lua:1919-1926`) — it has zero rendering effect. Stop seeding it; do not otherwise touch `KUIUnitFrames.lua`'s dead parameter.
  - Real, currently-unseeded per-unit field `unit.borderColor = { r, g, b }` exists in `KUIUnitFrames.lua`'s per-unit defaults (e.g. line 273) with current default `{0,0,0}`.
- Produces: `profile.frameArtKit` (new top-level field on the UnitFrames profile, values `"default"` or `"classic"`).

- [ ] **Step 1: Write the failing test**

  In `tests/visual_themes.lua`, after the existing `expect(KT.VisualThemes:ApplyAll("classic"), true, "apply classic")` block, add:

  ```lua
  expect(KT.db.profile.unitFrames.player.borderColor.r, 0.92, "classic unit border color")
  expect(KT.db.profile.unitFrames.frameArtKit, "classic", "classic unit frame art kit")
  ```

  After the existing `ApplyAll("retail")` block, add:

  ```lua
  expect(KT.db.profile.unitFrames.player.borderColor.r, 0.20, "retail unit border color")
  expect(KT.db.profile.unitFrames.frameArtKit, "default", "retail unit frame art kit")
  ```

  After the existing `ApplyAll("kui")` restore block, add:

  ```lua
  expect(KT.db.profile.unitFrames.player.classThemeStyle, nil, "kui no longer seeds dead classThemeStyle")
  ```

- [ ] **Step 2: Run test to verify it fails**

  Run: `"/c/Program Files (x86)/Lua/5.1/lua.exe" tests/visual_themes.lua`
  Expected: FAIL (error) on the first new `expect` — `borderColor` is currently always `{0,0,0}` and `frameArtKit` doesn't exist yet.

- [ ] **Step 3: Implement the adapter fix in `KullThranUI/Modules/VisualThemes/Adapters/UnitFrames.lua`**

  - Remove `classThemeStyle` from `SetUnitValues`'s parameters and body entirely (it becomes `SetUnitValues(profile, showPortrait, texture)`, three args).
  - Add a `borderColor` write inside `SetUnitValues`'s per-unit loop: `unit.borderColor = { r = colorR, g = colorG, b = colorB }` where `colorR/G/B` are passed in from the theme branch.
  - Add `profile.frameArtKit = "classic"` in the `classic` branch, `"default"` in every other branch.
  - Per-theme colors: `classic` → `{0.92, 0.72, 0.22}`, `forever` → `{0.82, 0.65, 0.23}`, `retail` → `{0.20, 0.58, 1.00}`. `kui` branch: do not set `borderColor` or `frameArtKit` at all (leaves the module's own current default of `{0,0,0}` / whatever the module defaults `frameArtKit` to untouched — see Step 5).
  - Add `"frameArtKit"` and each unit's `.borderColor.r/.g/.b` to `getOwnedPaths()`'s returned list.

- [ ] **Step 4: Run test to verify the data-level assertions pass**

  Run: `"/c/Program Files (x86)/Lua/5.1/lua.exe" tests/visual_themes.lua`
  Expected: still FAILS only on `frameArtKit` restoring to `"default"` under `kui` if `KUIUnitFrames.lua` doesn't yet default the field — confirm by grepping `KUIUnitFrames.lua`'s defaults table for any existing `frameArtKit` key; if absent, add `frameArtKit = "default"` to that same defaults table (the one containing `borderColor = { r = 0, g = 0, b = 0 }` at line 273 and its sibling blocks) so a profile that has never seen a theme still has a defined value. Re-run until all assertions pass.

- [ ] **Step 5: Wire the classic border into the renderer, `KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUIUnitFrames.lua`**

  Grep this file for where the health/power bar's existing backdrop or border texture is created per unit (the frame that `unit.borderColor` already colors, if it's consumed anywhere — if `borderColor` turns out to be read nowhere at render time either, that's a second dead field to wire up here, not just seed). At that call site, add: when `uSettings.frameArtKit == "classic"`, create (once, cached on the unit frame) a border via `KT.VisualThemes:CreateClassicBorder(frame)`, seat it with `KT.VisualThemes:SeatClassicBorder(border, healthBarRegion, 1)`, and `ShowClassicBorder(border, true)`; otherwise (or when the cached border already exists from a previous theme) call `ShowClassicBorder(border, false)`. Apply `unit.borderColor` to the existing border/backdrop path exactly as it does today for the non-classic case.

- [ ] **Step 6: Syntax-check both files**

  Run: `luac -p KullThranUI/Modules/VisualThemes/Adapters/UnitFrames.lua "KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUIUnitFrames.lua"`
  Expected: no output.

- [ ] **Step 7: In-game verification**

  `/reload`. Cycle `kui -> classic -> forever -> retail -> kui` from `General > Advanced Style System`. Confirm: `classic` shows the new bordered frame and gold accent; `forever` shows a bronze-tinted border with no classic frame art; `retail` shows blue; `kui` returns to today's exact look (black border, no classic frame). Confirm switching `classic -> forever` leaves no leftover border piece visible.

- [ ] **Step 8: Log findings**

  Append entry 19 (and 20 if Step 5 uncovered `borderColor` was ALSO dead) to `ESTUDIO_SELECTOR_ESTILOS_INSTALLER_RETAIL.md` §30.

- [ ] **Step 9: Commit**

  ```bash
  git add tests/visual_themes.lua KullThranUI/Modules/VisualThemes/Adapters/UnitFrames.lua "KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUIUnitFrames.lua" ESTUDIO_SELECTOR_ESTILOS_INSTALLER_RETAIL.md
  git commit -m "fix: give UnitFrames themes a real accent color and classic border"
  ```

---

## Task 3: CastBar — audit, accent color, classic border

**Files:**
- Modify: `KullThranUI/Modules/VisualThemes/Adapters/CastBar.lua`
- Modify: `KullThranUI_CastBar/Modules/CastBar/CastBar.lua`
- Test: `tests/visual_themes.lua`

**Interfaces:**
- Consumes: Task 1's `ThemeBorderKit` API.
- To confirm at Step 1 (not yet audited): the real `iconShape`/`colorMode` enums (adapter's own `validate()` already lists `SQUARE`/`CIRCLE` and `THEME`/`CLASS`/`CUSTOM` — confirm these against `CastBar_Options.lua` rather than trusting the adapter's self-declared validate blindly). `texture` is already confirmed real (`CastBar.lua:1034` calls `LSM:Fetch("statusbar", db.texture)`).
- Produces: no new top-level field name is fixed by this plan — decide during Step 3 whether to reuse a field CastBar already has for its frame border (grep for one before assuming none exists, since UnitFrames turned out to already have `borderColor` unused) or add a new `profile.frameArtKit` matching Task 2's naming for consistency.

- [ ] **Step 1: Audit the real options**

  Read `KullThranUI_CastBar/Modules/CastBar/CastBar_Options.lua` for the real `iconShape`/`colorMode` dropdown values and confirm `color` is genuinely applied as the bar's accent (it already is seeded per-theme in the current adapter — confirm this actually renders, since `colorMode` must be `"CUSTOM"` for `color` to take effect per the adapter's own logic). Record findings before writing any test.

- [ ] **Step 2: Write the failing test**

  Add to `tests/visual_themes.lua`, mirroring Task 2's pattern, one new assertion per theme confirming `castbar.frameArtKit` (or whatever field Step 1/Step 3 settles on) is `"classic"` only under `classic`, and that `color`/`colorMode` produce a visibly different, theme-fixed color under `forever`/`retail` (already true today per the current seed — write the test to confirm the CURRENT values are what Step 1 confirmed are real, so this test also guards against future regression).

- [ ] **Step 3: Run test, verify failure only on the new border field**

  Run: `"/c/Program Files (x86)/Lua/5.1/lua.exe" tests/visual_themes.lua`

- [ ] **Step 4: Implement the adapter change**

  Add the classic-border field (name decided in Step 1) to `classic`'s branch only; add it to `getOwnedPaths()`.

- [ ] **Step 5: Wire the classic border into `CastBar.lua`'s render path**

  Locate where the cast bar's border/backdrop is created and follow the same pattern as Task 2 Step 5: create/seat/show the kit only when the new field is `"classic"`, hide it otherwise.

- [ ] **Step 6: Syntax-check, re-run test until green**

  `luac -p` both files; `lua.exe tests/visual_themes.lua`.

- [ ] **Step 7: In-game verification** (same cycle as Task 2 Step 7, scoped to the cast bar).

- [ ] **Step 8: Log findings** to §30 (next entry number).

- [ ] **Step 9: Commit.**

---

## Task 4: ResourceBars — audit, accent color, classic border

**Files:**
- Modify: `KullThranUI/Modules/VisualThemes/Adapters/ResourceBars.lua`
- Modify: `KullThranUI_ResourceBars/Modules/KUIResourceBars/KUIResourceBars.lua`
- Test: `tests/visual_themes.lua`

**Interfaces:** Same shape as Task 3. `texture` already confirmed real via `LSM:Fetch("statusbar", ...)` at `KUI_ResourceBars_Options.lua:793-795`. `borderSize` is already seeded per-theme (0/1/2) — confirm at Step 1 whether a color field already exists per bar (`health`/`primary`/`secondary` each have their own sub-table) or needs adding, and whether one shared classic-border toggle should apply to all three bars or per-bar (recommend one shared `profile.general.frameArtKit` covering all three, for consistency with the "one identity per module" framing in the spec — override only if Step 1's audit shows the three bars are visually independent enough that per-bar makes more sense).

- [ ] **Step 1: Audit the real options** (`KUI_ResourceBars_Options.lua`, plus grep `KUIResourceBars.lua` for any existing per-bar color field before assuming none exists).
- [ ] **Step 2: Write the failing test** in `tests/visual_themes.lua`, same pattern as Task 2/3.
- [ ] **Step 3: Run test, verify failure.**
- [ ] **Step 4: Implement the adapter change** (per-theme accent color on whatever field Step 1 found/decided, classic border field on `classic` only).
- [ ] **Step 5: Wire the classic border into `KUIResourceBars.lua`'s render path**, hidden except when the field is `"classic"`.
- [ ] **Step 6: Syntax-check, re-run test until green.**
- [ ] **Step 7: In-game verification** (cycle all four themes on health/primary/secondary bars).
- [ ] **Step 8: Log findings** to §30.
- [ ] **Step 9: Commit.**

---

## Task 5: CooldownManager — audit, accent color, classic border

**Files:**
- Modify: `KullThranUI/Modules/VisualThemes/Adapters/CooldownManager.lua`
- Modify: `KullThranUI_CooldownManager/Modules/KUICooldownManager/KUICooldownManager.lua`
- Test: `tests/visual_themes.lua`

**Interfaces:**
- To confirm at Step 1: the adapter's own `seed()` already sets `iconShape` to `"square"`/`"circle"`/`"csquare"`/`"none"` and its `validate()` whitelist matches — but this plan's earlier audit did not locate where `KUICooldownManager_Options.lua` itself defines its real shape whitelist (`ns.CDM_SHAPE_MASKS`/`ns.CDM_SHAPE_BORDERS` were referenced but not found in that file directly). Step 1 must locate the real definition and confirm the adapter's four shape values are actually all valid keys in it before trusting them.
- The adapter already seeds `bar.borderR/G/B` per theme (already a real accent-color mechanism, confirmed present in the current file) — this module may already meet the "accent color" bar without new work; Step 1 should confirm these values are actually consumed by the renderer (not another dead field) before concluding no color work is needed here.
- Produces: classic-border field, name TBD at Step 1 (reuse `frameArtKit` naming for consistency unless the module already has an equivalent concept).

- [ ] **Step 1: Audit** — locate the real shape whitelist and confirm `borderR/G/B` are consumed at render time.
- [ ] **Step 2: Write the failing test** for the new classic-border field only (accent color may already be correctly tested by the existing suite — check before duplicating).
- [ ] **Step 3: Run test, verify failure.**
- [ ] **Step 4: Implement the adapter change** (classic-border field on `classic` only; leave the already-real shape/color values alone unless Step 1 found them broken).
- [ ] **Step 5: Wire the classic border into `KUICooldownManager.lua`'s render path** for icon borders, hidden except when `"classic"`.
- [ ] **Step 6: Syntax-check, re-run test until green.**
- [ ] **Step 7: In-game verification.**
- [ ] **Step 8: Log findings** to §30.
- [ ] **Step 9: Commit.**

---

## Task 6: Nameplates — audit and accent color (no classic border)

**Files:**
- Modify: `KullThranUI/Modules/VisualThemes/Adapters/Nameplates.lua`
- Test: `tests/visual_themes.lua`

**Interfaces:**
- Already confirmed real: `healthBarTexture`/`castBarTexture` resolve via LSM (`Nameplates.lua:911`). `borderColor`/`borderStyle`/`targetGlowStyle` are already seeded per-theme with values matching the adapter's own `validate()` whitelist (`kullthran`/`simple`/`none`; `kullthranui`/`vibrant`/`none`) — Step 1 confirms these are real against the module itself (not just the adapter's self-declared validate), same caution as every other task.
- Out of scope per spec: no classic 9-slice border for Nameplates (not one of the four bar-owning modules).

- [ ] **Step 1: Audit** `Nameplates.lua` directly for where `borderStyle`/`targetGlowStyle` are consumed, confirming both are real render branches, not decoration.
- [ ] **Step 2: Write the failing test** only if Step 1 finds something to fix; if the audit confirms everything is already correct, write a new *regression-lock* test (asserting today's already-correct values) instead of a failing one, and say so explicitly rather than inventing a change for its own sake.
- [ ] **Step 3: Run test.**
- [ ] **Step 4: Implement any fix found necessary.**
- [ ] **Step 5: Syntax-check, re-run test until green.**
- [ ] **Step 6: In-game verification** (all four themes, friendly and hostile plates).
- [ ] **Step 7: Log findings** to §30 — explicitly note if this task found nothing to fix, since that's a real, useful finding too.
- [ ] **Step 8: Commit** (only if Step 4 changed anything; otherwise commit just the new regression-lock test).

---

## Task 7: PartyFrames — audit and accent color (no classic border)

**Files:**
- Modify: `KullThranUI/Modules/VisualThemes/Adapters/PartyFrames.lua`
- Test: `tests/visual_themes.lua`

**Interfaces:**
- Already confirmed real: `healthTexture`/`absorbBarTexture` resolve via LSM (`PartyFrames.lua:380`). No accent/border color field is seeded by this adapter today at all (only texture) — Step 1 confirms whether `PartyFrames.lua` has an existing unseeded color field per mode (`party`/`raid`/`raid40`/`arena`/`arenaEnemy`/`boss`), the same shape of gap already found in UnitFrames.

- [ ] **Step 1: Audit** `PartyFrames.lua` for an existing border/accent color field per mode.
- [ ] **Step 2: Write the failing test** for the accent color if Step 1 finds a real field to seed.
- [ ] **Step 3: Run test, verify failure.**
- [ ] **Step 4: Implement the adapter change** (fixed accent color per theme on the real field found).
- [ ] **Step 5: Syntax-check, re-run test until green.**
- [ ] **Step 6: In-game verification** (party and raid frames, all four themes).
- [ ] **Step 7: Log findings** to §30.
- [ ] **Step 8: Commit.**

---

## Task 8: ActionBars — confirm-only

**Files:**
- Modify: `KullThranUI/Modules/VisualThemes/Adapters/ActionBars.lua` (only if Step 1 finds something)
- Test: `tests/visual_themes.lua`

**Interfaces:**
- Already confirmed real this session: `buttonStyle` (`BLIZZARD`/`KUI`/`SIMPLICITY`) matches `ActionBars_Options.lua:195`'s own dropdown; `buttonBackdropColor` is already seeded per-theme (a real accent-color mechanism already in place). This task exists to close the spec's explicit open question, not because a bug is expected.

- [ ] **Step 1: Confirm `buttonShape`'s real whitelist** against `ActionBars_Options.lua` (the adapter's own `validate()` lists `NONE`/`CIRCLE`/`CSQUARE`/`HEXAGON`/`DIAMOND`/`SHIELD` — verify these against the options file's own shape dropdown, not just the adapter's self-declared list).
- [ ] **Step 2: If Step 1 finds a mismatch**, write a failing test in `tests/visual_themes.lua`, fix the adapter, re-run until green. **If Step 1 confirms everything is already correct**, add one regression-lock assertion instead (mirroring Task 6/7's honesty rule) and skip straight to Step 4.
- [ ] **Step 3: Syntax-check** if anything changed.
- [ ] **Step 4: Log findings** to §30 — this task's most likely outcome is "confirmed already correct, no change made," which is itself the useful result to record.
- [ ] **Step 5: Commit** (test-only commit if no adapter change was needed).

---

## Task 9: Full-suite regression pass

**Files:** none created; verification only.

- [ ] **Step 1: Run the full automated suite one more time** after all prior tasks: `"/c/Program Files (x86)/Lua/5.1/lua.exe" tests/visual_themes.lua`. Expected: `visual theme engine tests passed`.
- [ ] **Step 2: In-game, cycle `kui -> classic -> forever -> retail -> kui` once** with every affected module visible at once (UnitFrames, CastBar, ResourceBars, CooldownManager, Nameplates, PartyFrames, ActionBars, plus the already-shipped Damage Meter/Minimap), confirming `kui` at the end looks identical to `kui` at the start and every other theme reads as visibly distinct from it and from each other.
- [ ] **Step 3: Write a short closing summary entry** in `ESTUDIO_SELECTOR_ESTILOS_INSTALLER_RETAIL.md` §30 listing which modules ended up needing real fixes versus which were already correct, as the definitive reference for the future Retail port.
- [ ] **Step 4: Commit** the study-log update.
