# VisualThemes: honest per-theme rendering (Forever workspace)

**Status:** approved design, ready for implementation planning.
**Workspace:** `KullThranUI-Forever-Workspace` (this pass targets Forever only; Retail port is a later, separate effort — see Non-goals).
**Related:** `ESTUDIO_SELECTOR_ESTILOS_INSTALLER_RETAIL.md` section 30 (running log of problems/decisions found while building this in Forever, kept up to date as this design is implemented).

## 1. Problem

`KullThranUI/Modules/VisualThemes/Adapters/*.lua` lets the user pick one of four visual themes (`kui`, `classic`, `forever`, `retail`) and applies it across modules by writing values into each module's own saved-variable profile, then reloading the UI. Each adapter's `seed()` function is supposed to write *real, valid* values that module's own renderer understands.

In-game testing of `forever` showed the UnitFrames rendering as plain KullThranUI-style black frames with a yellow bar — visually indistinguishable from `kui` apart from color. Investigating why led to two findings:

1. **Systemic bogus values.** `UnitFrames.lua`, `ResourceBars.lua`, `CastBar.lua`, `CooldownManager.lua`, `Nameplates.lua`, and `PartyFrames.lua` all seed texture/style fields with invented display strings (`"Blizzard"`, `"Melli Dark"`, `"Blizzard Raid Bar"`, `"Melli Reforged"`) that do not exist in the corresponding module's real options whitelist. Each module's own texture lookup silently falls back to its default when it doesn't recognize the string, so the seed has no visible effect. This exact bug was already found and fixed once this session, independently, in the Damage Meter adapter — it turned out to be the same bug copy-pasted across most of the adapter set. `Skin.lua` is the one adapter that already uses real enum values and is unaffected.
2. **A deeper, more honest question.** Even once the bogus strings are replaced with real ones, KullThranUI's frame modules (UnitFrames, ActionBars, CastBar, ResourceBars, CooldownManager, Nameplates, PartyFrames) are fully custom-built rendering engines — not reskins of Blizzard's native frames. They cannot, by picking among their own existing options, ever produce something that reads as "actual Classic-era Blizzard art" or "actual modern Retail art." Pretending otherwise (as the current adapters implicitly do, by naming values `"Blizzard"`) overpromises.

A study of EllesmereUI's own equivalent system (a similarly fully-custom frame engine, studied for its technique only — no code, names, or comments from it appear anywhere in KullThranUI) showed a middle path is possible: real Blizzard-shipped texture *files* and *atlas pieces* can be drawn onto arbitrary custom-built textures via `SetTexture`/`SetTexCoord`/`SetAtlas`, independent of Blizzard's own frame hierarchy. This is exactly the same technique already used successfully this session for the Damage Meter (`Interface\TargetingFrame\UI-StatusBar`, a real native file, drawn as a `StatusBar` texture) and for the Minimap (reusing the addon's own already-working pixel-border renderer, just parameterized by theme). It is not, however, a free upgrade for every theme:

- A **plain texture file** (not an atlas) such as `Interface\CastingBar\UI-CastingBar-Border` is safe to reuse directly — it is a fixed sheet that ships with every client and is never swapped or reskinned by anything KullThranUI Forever does.
- **Atlas names**, by contrast, are not safe to assume neutral inside the Forever client: WoW Forever reskins many retail atlas names to draw its own bronze art under the same name. Calling `SetAtlas("ui-hud-unitframe-player-portraiton", ...)` inside Forever would silently draw Forever's own bronze ring, not neutral modern Retail art. Recovering the true retail pixels requires manually resolving the underlying sheet file and texture-coordinate rectangle per atlas name and per resolution tier — real, working, but heavy, single-purpose engineering that only pays off once there's an actual Retail client to validate it against.

## 2. Goals

- Every adapter's `seed()` writes values its own module's renderer actually understands and visibly renders differently.
- Each of the four themes reads as a distinct, deliberate identity per module — not an accidental near-duplicate of another theme.
- `classic` gets one genuinely upgraded, real piece of Blizzard-shipped art: a 9-slice border built from `Interface\CastingBar\UI-CastingBar-Border` (the vanilla cast-bar border sheet), reusable across every module that draws its own bars, wired in as one new legitimate rendering option per module (not a cosmetic-only preview).
- `forever` and `retail` keep the previously agreed ceiling: a fixed accent color per theme plus picking only among texture/shape/style options that already exist and are already validated in that module — no invented names, no atlas-swap engineering.
- No tags, comments, identifiers, or strings anywhere in the changed files reference EllesmereUI or any other third-party project, per the existing project rule (`ESTUDIO_SELECTOR_ESTILOS_INSTALLER_RETAIL.md` §29.9).

## 3. Non-goals

- Real modern Retail atlas fidelity (the atlas-swap-resistant sheet extraction technique). Documented as a known future opportunity, Retail-workspace-only, in the study log — not attempted here because it cannot be validated from inside Forever.
- Redesigning the theme-selector cards (`ThemeSelector.lua`/`ThemePreview.lua` visual polish vs. the EllesmereUI reference layout). Explicitly deferred to its own follow-up design/approval after this lands.
- Any change to `Skin.lua`, `DamageMeter.lua`, or `Minimap.lua` adapters — already fixed and out of scope here.
- Porting anything to the Retail workspace. This design and its implementation happen entirely in `KullThranUI-Forever-Workspace`; the study log's "problems and solutions" section is the hand-off artifact for that later port.

## 4. Architecture

### 4.1 Shared classic border kit (new)

New file `KullThranUI/Modules/VisualThemes/ThemeBorderKit.lua`, loaded in `KullThranUI.toc` immediately after `ThemeEngine.lua` and before any adapter or module that will call it (adapters only *seed a value*; the modules that render bars are what actually call this kit at draw time).

Public API (final names decided during implementation, kept generic and self-explanatory, e.g. `KT.VisualThemes:CreateClassicBarBorder(...)`):

- **Create**: builds the nine texture objects (or however many the final texcoord layout needs) on a given parent frame/layer, from `Interface\CastingBar\UI-CastingBar-Border`. Texture objects are created once and cached on the caller's frame; nothing is recreated on every refresh.
- **Seat**: positions the pieces around a given rect at a given scale, horizontal or vertical orientation. Idempotent/memoized the same way the Minimap's own pixel-border updater already is, so calling it every refresh is cheap.
- **Show/Hide**: toggles the whole border as one unit.

This is a rendering *tool*, not a theme adapter. It has no opinion about which theme uses it — any module's own "border style" option can gain a new real value (e.g. `"classic"`) whose render branch calls this kit, and any theme's seed could in principle select it, though in practice only `classic`'s seed will for this pass.

### 4.2 Per-module audit and fix

For each of the six affected adapters (`UnitFrames`, `ActionBars`, `ResourceBars`, `CastBar`, `CooldownManager`, `Nameplates`, `PartyFrames`), the implementation plan will, per module:

1. Read that module's own options file to find the real, currently-validated set of texture/shape/style enum values (the same audit method already used for Damage Meter's `DAMAGE_METER_TEXTURE_PATHS`).
2. Replace every bogus seed value with one drawn from that real set.
3. For the four bar-owning modules (`UnitFrames`, `CastBar`, `ResourceBars`, `CooldownManager`), add one new real, working border-style value (e.g. `"classic"`) to that module's own whitelist/validate function and its rendering code, wired to §4.1's shared kit; point `classic`'s seed at it.
4. Give `forever` and `retail` a fixed accent color (not the user's manual palette) plus whichever already-existing real option in that module reads closest to that theme's spirit (e.g., simpler/no border for retail, circular/ornate where the module already supports it for forever) — mechanically the same pattern already used for Damage Meter's header chrome and Minimap's border color, applied per-module.
5. `kui` keeps exactly its current values (no regression) unless a module's current `kui` seed itself already contains one of the bogus strings, in which case it's corrected to the module's actual current default.

`ActionBars.lua`'s `buttonStyle` values (`"BLIZZARD"`, `"SIMPLICITY"`, `"KUI"`) look like they may already be real enum values rather than bogus strings — this needs verifying against `ActionBars_Options.lua` before assuming it needs a fix; it is included in the audit regardless so the plan can confirm rather than assume.

### 4.3 Testing / verification

Static syntax checking (`luac -p`) only proves the Lua parses — it says nothing about whether a theme actually looks different in game, exactly as the study document already warns. The implementation plan must include an explicit in-game verification pass per adapter (switch to each theme, confirm the module visibly changes and doesn't regress `kui`), not just a clean `luac -p` run, before any adapter is considered done. Findings (expected or not) get logged in `ESTUDIO_SELECTOR_ESTILOS_INSTALLER_RETAIL.md` §30 as they're discovered, continuing the existing numbering.

## 5. Risks

1. **Scope creep across seven files.** Each module's options file has its own shape/quirks; mitigate by treating each adapter as its own independently-completable task in the implementation plan, not one giant patch.
2. **The new "classic" border option regresses existing users on `kui`/other themes** if wired incorrectly into a module's validate()/render path. Mitigate by keeping the new option strictly additive (existing values keep meaning exactly what they mean today) and only reachable when a profile's border-style field is explicitly `"classic"`.
3. **In-game verification is manual and slow** (four themes × up to seven modules). Mitigate by sequencing the plan so each module's fix is verified once, immediately, rather than batching all seven and debugging blind at the end.
4. **`ActionBars` may not need the bogus-string fix at all** (see §4.2) — if the plan assumes it does and it doesn't, that's wasted work; the audit step exists specifically to catch this before writing any seed changes.
