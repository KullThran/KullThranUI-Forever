# UnitFrames: real per-client art for Classic and Forever themes

**Status:** approved design, ready for implementation planning.
**Workspace:** `KullThranUI-Forever-Workspace` (Forever only — Retail explicitly deferred, see Non-goals).
**Amends:** `docs/superpowers/specs/2026-09-29-visual-themes-honest-rendering-design.md`, whose §3 Non-goals ("real modern Retail atlas fidelity... deferred") stays true for Retail, but whose ceiling for `classic`/`forever` on non-bar-owning-module elements ("fixed accent color + reuse existing options only, no new render branch") is raised here, for UnitFrames specifically, to real per-client art.
**Related:** `ESTUDIO_SELECTOR_ESTILOS_INSTALLER_RETAIL.md` §30 (continuing log).

## 1. Problem

The prior design gave `forever`/`retail` a fixed accent color plus whichever real options a module already had — deliberately, because at the time the user themselves doubted a fully custom-built frame engine could ever render real per-expansion art. That ceiling is now proven live in `forever`: a screenshot of the resulting UnitFrame shows a standard KullThranUI frame with nothing but a bronze-tinted border — visually underwhelming, and the user has reversed their own original position after seeing it. Their words: real per-client textures, placed onto the existing frame, not a KullThranUI-flavored approximation, and they now consider this *easier* than approximating a look with KullThranUI's own assets.

That intuition holds for two of the three non-`kui` themes, and does not for the third:

- **Classic**: already proven this session. `Interface\CastingBar\UI-CastingBar-Border` — a real, fixed-path (non-atlas) file that ships with every client — was sliced into a border and reused generically (`ThemeBorderKit.lua`). The same technique extends cleanly to other real, fixed-path vanilla-era unit-frame files; there is no atlas-swap risk because these are literal texture files, not atlas names.
- **Forever**: plausible and unbuilt. WoW Forever only reskins *retail* atlas names under the same string — its **own** native atlas names are never swapped inside its own client, so real Forever atlas art (portrait rings, corner ornaments) can be used directly via `SetAtlas` without the sheet-extraction workaround Retail needs.
- **Retail**: still hard, unchanged from the prior spec. Inside this Forever workspace, real modern Retail atlas names are exactly the ones Forever swaps for its own bronze art under the same name — "just use the real Retail textures" does not resolve this; it's the same confirmed blocker, only provable from an actual Retail client. Retail's ceiling stays as-is (fixed accent + existing options) until a Retail-workspace port.

## 2. Goals

- `classic` UnitFrames render with real, fixed-path vanilla-era Blizzard texture files for the portrait/frame art and the health bar fill, not KullThranUI's own custom textures recolored.
- `forever` UnitFrames render with real Forever-native atlas art (portrait ring / corner ornament) via `SetAtlas`, verified present at runtime (`C_Texture.GetAtlasInfo`) with a safe fallback to the current fixed-accent-color look if a name doesn't resolve.
- `retail` and `kui` are untouched by this spec.
- No tag, comment, identifier, or string anywhere may reference EllesmereUI or any third-party project by name — same absolute rule as before. Real Blizzard file paths and real Blizzard-defined atlas name strings are facts about the game client, not EllesmereUI's IP, and are fine to use; EllesmereUI's own code, comments, or internal identifiers are not.
- This is the flagship module for the pattern; ActionBars' gryphon/wyvern side ornaments and any other module are explicitly out of scope here and get their own future spec/plan following the same shape.

## 3. Non-goals

- Retail real-asset fidelity (unchanged deferral from the prior spec).
- ActionBars' side decorations (explicitly deferred to their own future pass, per the user's own scoping decision).
- Any other module (CastBar, ResourceBars, CooldownManager, Nameplates, PartyFrames) beyond what the already-merged plan already gave them.
- Any change to `kui`'s or `retail`'s current seeded values or rendering.
- Porting to the Retail workspace.

## 4. Architecture

### 4.1 New shared file: `ThemeClientAssets.lua`

`KullThranUI/Modules/VisualThemes/ThemeClientAssets.lua`, loaded in `KullThranUI.toc` after `ThemeBorderKit.lua`. Rendering tools only — no adapter logic, no saved-variable reads/writes, same separation of concerns already established by `ThemeBorderKit.lua`.

Public API (exact names decided during implementation task breakdown, kept generic):
- A function that applies the **Classic** real-asset look to a given unit frame's portrait/backdrop region and health bar texture object, using real fixed-path files.
- A function that applies the **Forever** real-asset look (an atlas-based portrait ring/ornament) to a given unit frame's portrait region, with a verified-atlas-exists check and a no-op fallback.
- A corresponding "clear/restore" function for each, so switching away from that theme removes the real-asset decoration cleanly (same pattern as `ThemeBorderKit`'s show/hide).

### 4.2 Real assets — Classic (fixed-path files, no atlas risk)

- Health bar fill: `Interface\TargetingFrame\UI-StatusBar` — already validated this session as a real, safe, always-present file (used for Damage Meter's "Blizzard" bar texture).
- Portrait/frame art: `Interface\TargetingFrame\UI-TargetingFrame` — a real, fixed-path sheet used for target/portrait frame art since vanilla, still shipped in every client version. The implementation task must inspect this sheet's actual layout (it is a texture atlas *within a single file*, addressed by `SetTexCoord`, not a WoW `SetAtlas` atlas — no swap risk either way) and slice out the specific sub-rectangles it needs, the same reverse-engineering-by-inspection approach already used for the cast-bar border, independently derived (no copying another addon's own pixel cuts).
- Border: reuse the already-built `ThemeBorderKit` (`CreateClassicBorder`/`SeatClassicBorder`/`ShowClassicBorder`) — no new border code for UnitFrames specifically.

### 4.3 Real assets — Forever (native atlas, verified at runtime)

- The implementation task must independently identify real, currently-valid Forever-native atlas names for a unit-frame portrait ring / corner ornament (this spec does not pin a name, since it cannot be verified without a running client in this environment — pinning an unverified guess would repeat the mistake this whole plan exists to fix). Whatever name(s) are chosen, every use must be gated by `C_Texture.GetAtlasInfo(name)` returning non-nil before calling `SetAtlas`, with the current fixed-accent-color look kept as the fallback when it doesn't (mirrors the existing "real value or safe fallback" pattern used throughout this session's fixes, e.g. LSM-backed texture fetches).
- Do not reuse retail atlas names for this (that's the Retail non-goal's blocker, not Forever's).

### 4.4 Wiring

`KullThranUI/Modules/VisualThemes/Adapters/UnitFrames.lua` gains no new seeded fields for this — the theme is already known (`classic`/`forever`) from the existing `frameArtKit`/theme state. `KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUIUnitFrames.lua`'s existing render path (the same one already wired to `ThemeBorderKit` for `classic`) gains a call to the new Classic asset function alongside the border, and a parallel call to the new Forever asset function when the active theme is `forever`. Switching away from either must call that theme's own clear/restore function, not just stop updating (same "hide-on-leave" rule already enforced throughout the merged plan).

## 5. Testing

- `tests/visual_themes.lua` continues to prove only the adapter/profile-data layer (no WoW API stub exists for rendering) — this spec's changes are almost entirely render-layer, so most of it is **not** coverable by that harness, same as `ThemeBorderKit`'s own geometry wasn't.
- Any new adapter-visible field this work introduces (if the implementation finds it needs one, e.g. to remember which real-asset variant applied) must get the same nil-safety and round-trip test treatment already mandatory throughout this plan.
- In-game verification remains the only way to confirm the Classic texture-coordinate slicing and the Forever atlas name(s) actually look right — required manual QA, explicitly disclosed, not something a subagent in this environment can close.

## 6. Risks

1. **Guessing atlas/texcoord values wrong.** Mitigated by treating exact texture-coordinate/atlas-name discovery as an explicit audit-and-verify task step, not a value this spec pins — the same approach that already caught CDM's real shape-whitelist location and avoided repeating the original "invented value" bug class.
2. **Retail scope creep.** Mitigated by this spec explicitly not touching `retail` at all; any temptation to "just try it for retail too" during implementation should be refused and logged as a separate future decision, not folded in silently.
3. **ActionBars scope creep.** Mitigated the same way — explicitly out of scope per the user's own choice this session.
4. **Unverifiable in-game correctness.** Same standing risk as the rest of this plan; mitigated by the same discipline (disclose, don't claim).
