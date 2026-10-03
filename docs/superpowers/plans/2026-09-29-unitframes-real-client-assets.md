# UnitFrames Real Client Assets Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make `classic` and `forever` UnitFrames render with real per-client texture/atlas art (portrait frame, health bar fill, portrait ring) instead of KullThranUI's own recolored assets, while `retail`/`kui` stay untouched.

**Architecture:** A new rendering-only file, `ThemeClientAssets.lua`, exposes one apply/clear function pair per theme. `classic`'s functions slice real, fixed-path Blizzard files (no atlas, no swap risk) and reuse the already-built `ThemeBorderKit` for the border. `forever`'s functions draw a real Forever-native atlas piece, gated at every call by a live `C_Texture.GetAtlasInfo` check with a fallback to the current (already-shipped) fixed-accent-color look. `KUIUnitFrames.lua`'s existing theme-render path (already wired to `ThemeBorderKit` for `classic`) gains one call per theme, with a hide/restore call when that theme is not active.

**Tech Stack:** World of Warcraft addon Lua 5.1, AceAddon-3.0/AceDB-3.0. Automated tests run outside the game client via `"/c/Program Files (x86)/Lua/5.1/lua.exe" tests/visual_themes.lua` — this only proves the VisualThemes adapter/profile-data layer; there is no WoW API stub for rendering, so this plan's render-layer work is verified by code-reading/arithmetic and disclosed as pending in-game QA, the same way `ThemeBorderKit`'s own border crop was in the prior plan.

**Spec:** `docs/superpowers/specs/2026-09-29-unitframes-real-client-assets-design.md`

## Global Constraints

- Everything happens in the `KullThranUI-Forever-Workspace` only. `retail` and `kui` are not touched. Any port to Retail is out of scope.
- ActionBars' side ornaments are explicitly out of scope (deferred to a future spec/plan).
- No tag, comment, identifier, or string in any changed file may reference any third-party project by name. Real Blizzard file paths (`Interface\TargetingFrame\UI-StatusBar`, `Interface\TargetingFrame\UI-TargetingFrame`) and real Blizzard-defined atlas name strings are facts about the game client and are fine to use.
- `forever`'s real atlas name is not pinned by the spec or this plan — it is Task 2's own first step to identify one, and the render code must always gate its use behind `C_Texture.GetAtlasInfo(name) ~= nil`, falling back to the current fixed-accent-color look (already shipped) when it doesn't resolve.
- `classic`'s texture-coordinate slice of `UI-TargetingFrame` is derived independently by inspection in Task 1, not copied from any reference material's own reverse-engineered cuts, and is disclosed as provisional/unverified pending in-game QA — same discipline `ThemeBorderKit`'s crop already used.
- Switching away from a theme must call that theme's own clear/restore function (hide, not just stop updating) — same rule enforced throughout the already-merged plan.
- Every task appends its findings to `ESTUDIO_SELECTOR_ESTILOS_INSTALLER_RETAIL.md` §30, continuing the numbering (currently ends at entry 28; this plan's tasks start at 29).
- Automated check: `"/c/Program Files (x86)/Lua/5.1/lua.exe" tests/visual_themes.lua`, expected final line `visual theme engine tests passed`. This only proves the adapter/profile-data layer — no task in this plan should claim it proves rendering.

## Review Focus

- **Forever's atlas name doesn't exist in this client at all** (a live-only fact this environment cannot check): the render code must still produce today's current, correct fixed-accent look, not a Lua error or a blank frame — Task 2's own code-reading verification step (not an automated test, since no `C_Texture` stub exists in `tests/visual_themes.lua`) traces the guard clause to confirm this explicitly.
- **A profile that has never touched UnitFrames before applies `classic`/`forever` for the first time**: the apply functions must not index into a nil unit-frame table or nil sub-region — Task 1/2's own nil-safety guards, verified by code reading against the same nil-safe idiom already used by `ThemeBorderKit`.
- **Switching `classic -> forever` (or to `kui`/`retail`) leaves a leftover decoration on screen**: Task 3's wiring must call the leaving theme's own clear/restore function, not just stop calling its apply function — verified by tracing the render path's branch structure, the same "hide-on-leave" check every task in the prior plan's render-wiring used.
- **Repeated theme-refresh calls (e.g. on every `/reload` or options change) leak or duplicate texture objects** instead of reusing a cached set: Task 1/2 must follow `ThemeBorderKit`'s own create-once/reposition-every-call split (`CreateClassicBorder` vs `SeatClassicBorder`), not recreate textures on every call — verified by code reading against that existing pattern.
- **The `UI-TargetingFrame` texture-coordinate slice reads the wrong sub-rectangle of the sheet** (visually broken portrait frame): unverifiable without a WoW client — Task 1 must disclose this exactly as provisional in both the code comments and the §30 log entry, exactly as `ThemeBorderKit`'s own crop was disclosed, rather than claiming it's correct.

---

## Task 1: ThemeClientAssets — Classic real-asset UnitFrame functions

**Files:**
- Create: `KullThranUI/Modules/VisualThemes/ThemeClientAssets.lua`
- Modify: `KullThranUI/KullThranUI.toc` (insert the new file's path immediately after `Modules\VisualThemes\ThemeBorderKit.lua` and before `Modules\VisualThemes\ThemePreview.lua`)
- Test: manual/code-reading only for this task (see Global Constraints — no WoW API stub exists to automate render-layer checks)

**Interfaces:**
- Consumes: `KT.VisualThemes:CreateClassicBorder/SeatClassicBorder/ShowClassicBorder` (already built, from the prior merged plan's Task 1 — do not modify, do not reimplement).
- Produces (used by Task 3): `KT.VisualThemes:ApplyClassicUnitFrameArt(frame, unitRegion, healthBarTexture) -> nil` and `KT.VisualThemes:ClearClassicUnitFrameArt(frame) -> nil`. `frame` is the unit frame's outer Frame/Region; `unitRegion` is the portrait/backdrop region the frame art seats around; `healthBarTexture` is the StatusBar texture object whose fill this function retextures. Exact additional parameters are the implementer's call, but these three are the minimum contract Task 3 relies on by name.

- [ ] **Step 1: Write the file header and real-asset constants**

  Follow the existing file header pattern used by every other file under `KullThranUI/Modules/VisualThemes/` (`local addonName, ns = ...` / `local KT = LibStub("AceAddon-3.0"):GetAddon("KullThranUI")` / `KT.VisualThemes = KT.VisualThemes or {}`). Declare `local HEALTHBAR_TEXTURE = [[Interface\TargetingFrame\UI-StatusBar]]` and `local PORTRAIT_FRAME_TEXTURE = [[Interface\TargetingFrame\UI-TargetingFrame]]` (exact values pinned by the spec — use these literal paths, not a guess).

- [ ] **Step 2: Derive and write the `UI-TargetingFrame` texture-coordinate crop**

  Inspect what is knowable about this sheet's layout from the codebase's own prior research (the same independent-inspection approach `ThemeBorderKit.lua`'s header comment already used and documented for `UI-CastingBar-Border` — read that file's own top-of-file comment block for the pattern to follow) and derive your own sub-rectangle constants for whatever portrait/frame piece you choose to use from this sheet. Write your reasoning as a comment block at the top of the new constants, explicitly marked provisional/unverified (mirror `ThemeBorderKit.lua`'s own "OUTSTANDING MANUAL QA ITEM" comment style) — do not claim this crop is correct; you have no way to check it here.

- [ ] **Step 3: Implement `KT.VisualThemes:ApplyClassicUnitFrameArt(frame, unitRegion, healthBarTexture)` in `ThemeClientAssets.lua`**

  - `healthBarTexture:SetTexture(HEALTHBAR_TEXTURE)`.
  - Create (once, cached on `frame` — follow `ThemeBorderKit.lua`'s `CreateClassicBorder`-caches-on-return-table pattern, e.g. `frame._ktClassicPortraitArt`) one texture object on `unitRegion` using `PORTRAIT_FRAME_TEXTURE` and the Step 2 texcoords, sized/anchored to `unitRegion`. If `frame._ktClassicPortraitArt` already exists, reuse it (reposition only) rather than recreating — same discipline as `ThemeBorderKit`'s `SeatClassicBorder`.
  - Nil-guard: if `frame`, `unitRegion`, or `healthBarTexture` is not a table/region, return without erroring (mirror `ThemeBorderKit.lua`'s own `type(...) ~= "table"` guards).

- [ ] **Step 4: Implement `KT.VisualThemes:ClearClassicUnitFrameArt(frame)` in `ThemeClientAssets.lua`**

  Hides `frame._ktClassicPortraitArt` if it exists (does not destroy it — matches `ShowClassicBorder`'s hide-not-destroy pattern so re-showing it later is cheap). Nil-safe if never created.

- [ ] **Step 5: Register the file in the TOC**

  Add `Modules\VisualThemes\ThemeClientAssets.lua` to `KullThranUI/KullThranUI.toc` right after the `ThemeBorderKit.lua` line.

- [ ] **Step 6: Syntax-check**

  Run: `luac -p KullThranUI/Modules/VisualThemes/ThemeClientAssets.lua`
  Expected: no output.

- [ ] **Step 7: Code-reading verification against Review Focus**

  Re-read your own `ApplyClassicUnitFrameArt`/`ClearClassicUnitFrameArt` against this plan's Review Focus list: confirm nil-safety on a never-initialized `frame`, confirm the texture object is created once and repositioned (not recreated) on repeat calls. Note the result in your task report — this is the verification bar for this task, there is no automated test to run.

- [ ] **Step 8: Log findings**

  Append entry 29 to `ESTUDIO_SELECTOR_ESTILOS_INSTALLER_RETAIL.md` §30, including the disclosed-provisional texcoord crop and what a human must check in-game.

- [ ] **Step 9: Commit**

  ```bash
  git add KullThranUI/Modules/VisualThemes/ThemeClientAssets.lua KullThranUI/KullThranUI.toc ESTUDIO_SELECTOR_ESTILOS_INSTALLER_RETAIL.md
  git commit -m "feat: add real Classic unit frame art (portrait sheet + health bar texture)"
  ```

---

## Task 2: ThemeClientAssets — Forever real-asset UnitFrame functions

**Files:**
- Modify: `KullThranUI/Modules/VisualThemes/ThemeClientAssets.lua` (adds to the file Task 1 created)
- Test: manual/code-reading only, same reason as Task 1

**Interfaces:**
- Consumes: Task 1's file (same module, additive). The existing fixed-accent-color mechanism already shipped by the prior merged plan (`KT.VisualThemes:GetDamageMeterAccentColor`-style pattern — for UnitFrames specifically, this is whatever per-theme `borderColor` field the prior plan's Task 2 already wired into `KUIUnitFrames.lua`; read that existing code before assuming its exact name).
- Produces (used by Task 3): `KT.VisualThemes:ApplyForeverUnitFrameArt(frame, unitRegion) -> nil` and `KT.VisualThemes:ClearForeverUnitFrameArt(frame) -> nil`, same shape as Task 1's pair minus the health-bar-texture parameter (Forever keeps its existing health bar texture choice; this task only adds the portrait ring/ornament).

- [ ] **Step 1: Identify a real Forever-native atlas name**

  Search this repo and this session's own prior research notes (the design spec's §4.3 discussion, and the original `ESTUDIO_SELECTOR_ESTILOS_INSTALLER_RETAIL.md` sections written before this plan) for any real, plausible Forever-native atlas name suitable for a unit-frame portrait ring or corner ornament. If nothing concrete is found, choose a real Blizzard-defined atlas name pattern consistent with Forever's own UI (not a retail name, not an invented string) and document the uncertainty explicitly — this is expected to be provisional pending in-game confirmation, exactly like Task 1's texcoord crop. Write the chosen name as a `local FOREVER_PORTRAIT_ATLAS = "..."` constant with a comment stating it is unverified.

- [ ] **Step 2: Implement `KT.VisualThemes:ApplyForeverUnitFrameArt(frame, unitRegion)` in `ThemeClientAssets.lua`**

  ```lua
  function KT.VisualThemes:ApplyForeverUnitFrameArt(frame, unitRegion)
      if type(frame) ~= "table" or type(unitRegion) ~= "table" then return end
      if not (C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(FOREVER_PORTRAIT_ATLAS)) then
          self:ClearForeverUnitFrameArt(frame)
          return
      end
      -- create-once-then-reposition texture on frame._ktForeverPortraitArt,
      -- SetAtlas(FOREVER_PORTRAIT_ATLAS), anchored to unitRegion; show it.
  end
  ```
  The code comment shows the required control flow (the `C_Texture.GetAtlasInfo` gate, and falling back to `ClearForeverUnitFrameArt` when it fails) — write the real texture creation/anchoring body yourself, following the same create-once/reposition-every-call discipline as Task 1 and `ThemeBorderKit`.

- [ ] **Step 3: Implement `KT.VisualThemes:ClearForeverUnitFrameArt(frame)` in `ThemeClientAssets.lua`**

  Same shape as `ClearClassicUnitFrameArt` — hides `frame._ktForeverPortraitArt` if present, nil-safe otherwise.

- [ ] **Step 4: Syntax-check**

  Run: `luac -p KullThranUI/Modules/VisualThemes/ThemeClientAssets.lua`
  Expected: no output.

- [ ] **Step 5: Code-reading verification against Review Focus**

  Trace `ApplyForeverUnitFrameArt`'s control flow by hand for both cases (atlas name resolves / doesn't resolve) and confirm the "doesn't resolve" path leaves the frame in exactly the state it was in before this task existed (today's fixed-accent-color look, no error, no half-applied texture). Note this trace in your task report.

- [ ] **Step 6: Log findings**

  Append entry 30 to `ESTUDIO_SELECTOR_ESTILOS_INSTALLER_RETAIL.md` §30, stating plainly that the atlas name is unverified and exactly what a human must check in-game (does it resolve at all in this Forever client; if so, does it look like a portrait ring; if not, confirm the fallback silently keeps today's look).

- [ ] **Step 7: Commit**

  ```bash
  git add KullThranUI/Modules/VisualThemes/ThemeClientAssets.lua ESTUDIO_SELECTOR_ESTILOS_INSTALLER_RETAIL.md
  git commit -m "feat: add real Forever unit frame portrait ring with safe fallback"
  ```

---

## Task 3: Wire ThemeClientAssets into KUIUnitFrames.lua's render path

**Files:**
- Modify: `KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUIUnitFrames.lua` (exact call site: locate the existing branch that already calls `KT.VisualThemes:CreateClassicBorder/SeatClassicBorder/ShowClassicBorder` for `frameArtKit == "classic"`, added by the prior merged plan's Task 2 — grep for `ClassicBorder` in this file to find it)
- Test: `tests/visual_themes.lua` only if this task discovers it needs a new adapter-visible field (see Step 1); otherwise no automated test applies (render-layer only, same as Tasks 1-2)

**Interfaces:**
- Consumes: Task 1's `ApplyClassicUnitFrameArt(frame, unitRegion, healthBarTexture)` / `ClearClassicUnitFrameArt(frame)`; Task 2's `ApplyForeverUnitFrameArt(frame, unitRegion)` / `ClearForeverUnitFrameArt(frame)`.

- [ ] **Step 1: Locate the existing theme-render branch and confirm no new adapter field is needed**

  Grep `KUIUnitFrames.lua` for `ClassicBorder` to find the exact existing `if uSettings.frameArtKit == "classic" then ... else ... end`-shaped branch from the prior plan. Confirm `uSettings.frameArtKit` (or whatever the prior plan actually named it — verify against the real file, don't assume) already distinguishes `"classic"` from other values, and that the active theme (`"forever"` vs `"retail"`/`"kui"`) is independently derivable at this same call site (e.g. via `KT.VisualThemes:GetRenderedTheme()`, already used elsewhere in this codebase — grep for it). If both are true, no new adapter field is needed; state this confirmation in your task report. If not, this step becomes a BLOCKED report explaining exactly what's missing rather than inventing a field ad hoc — a new field would need the nil-safe + round-trip-test treatment this plan currently assumes isn't necessary.

- [ ] **Step 2: Add the Classic and Forever branches at the located call site**

  Alongside the existing `ShowClassicBorder`/border-hide branch, add: when the rendered theme is `"classic"`, call `KT.VisualThemes:ApplyClassicUnitFrameArt(frame, <the same unitRegion already used for the border>, <this unit's health bar texture object>)`; otherwise call `KT.VisualThemes:ClearClassicUnitFrameArt(frame)`. When the rendered theme is `"forever"`, call `KT.VisualThemes:ApplyForeverUnitFrameArt(frame, <unitRegion>)`; otherwise call `KT.VisualThemes:ClearForeverUnitFrameArt(frame)`. Both new calls are independent of each other and of the existing border calls (a frame can be in exactly one theme at a time, so exactly one of the four apply/clear pairs is "apply" and the rest are "clear" on any given render pass).

- [ ] **Step 3: Syntax-check**

  Run: `luac -p "KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUIUnitFrames.lua"`
  Expected: no output.

- [ ] **Step 4: Run the existing automated suite to confirm no regression**

  Run: `"/c/Program Files (x86)/Lua/5.1/lua.exe" tests/visual_themes.lua`
  Expected: `visual theme engine tests passed` (this file isn't loaded by that harness, so this only confirms nothing else broke; state this plainly in the task report rather than claiming this proves the new code).

- [ ] **Step 5: Code-reading verification against Review Focus**

  Trace all four theme cases (`classic`, `forever`, `retail`, `kui`) through the new branch and confirm exactly one apply-pair fires and the other three clear-pairs fire, for each case — this is the "hide-on-leave" check from Review Focus. Note the trace in your task report.

- [ ] **Step 6: Log findings**

  Append entry 31 to `ESTUDIO_SELECTOR_ESTILOS_INSTALLER_RETAIL.md` §30 — the definitive statement that Classic and Forever UnitFrames now attempt real per-client art, both pending in-game QA, and exactly what to look for when that QA happens (does the portrait frame read as classic-era Blizzard art; does the Forever ring appear or silently fall back).

- [ ] **Step 7: Commit**

  ```bash
  git add "KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUIUnitFrames.lua" ESTUDIO_SELECTOR_ESTILOS_INSTALLER_RETAIL.md
  git commit -m "feat: wire real Classic/Forever unit frame art into the render path"
  ```
