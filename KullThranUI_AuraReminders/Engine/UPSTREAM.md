# Embedded aura engine

This directory includes the complete ForeverAuras 1.3.8 runtime, options,
archive, templates and model paths, adapted to run inside KullThranUI Aura
Reminders. No separately installed ForeverAuras or WeakAuras addon is required.

ForeverAuras is a fork of M33kAuras, derived from WeakAuras. This integration
is not endorsed by those projects.

- WeakAuras contributors: https://github.com/WeakAuras/WeakAuras2
- m33shoq and M33kAuras contributors: https://github.com/m33shoq/M33kAuras

Upstream code and the adaptations in this directory are under GNU GPL v2;
see `KUIAR_Engine/LICENSE` and `KUIAR_Engine/NOTICE.txt`. Bundled libraries,
fonts, sounds and images retain their accompanying licences and notices,
including `KUIAR_Engine/Media/Provided by.txt`. Copyright notices in source
comments have been preserved.

Integration changes (2026-11-11): internal loading and initialization of the
five upstream modules; isolated globals, saved variables, widget names and
media paths; dedicated chat commands; original custom-code sandbox aliases;
KUI toolbar icons and an editor hosted in Custom Auras. The engine's trigger,
display, conditions, animation, import and export implementations are retained.
Aura loading also respects AuraReminders' Enable Module setting.
Import strings saved by a newer engine build (a higher internal version) are
imported with a warning instead of being refused.
Media paths of the standalone addons (ForeverAuras, WeakAuras, M33kAuras) in
aura data point at the same files bundled here, on every load and import.
The upstream CurseForge localization directives in the locale files are kept
as plain comments; the bundled translations below them are used as they are.
The Custom Auras creation gallery, action toolbar and viewport presentation
are provided by KUI. The embedded window title/version and community footer
are not shown in the module. Engine-generated aura option forms are retained.
KUI draws the controls of those forms in its own style from outside the engine
(KUIAuraReminders_EmbeddedSkin.lua); a released control gets its original look
back. Displays anchored to the screen are placed in KUI's unlock mode
(KUIAuraReminders_EmbeddedMovers.lua), which saves only their offsets.
The bundled libraries register in the engine's own library registry
(Loader.lua), not in the global LibStub, so other addons' copies of the same
libraries are never used in their place. Only LibSharedMedia-3.0 and the
optional Masque, CustomNames and AceConsole-3.0 go through the global LibStub.
Chomp's end-of-load step moved from an inline XML script to Libs/Chomp/Loaded.lua,
LibUIDropDownMenu reads the engine registry, and the start-up library check
reports in KUI's chat output (2026-11-12).
Anchors to other displays use the upstream "WeakAuras:" and "ForeverAuras:"
formats again; the "KUIAR_Runtime:" spelling earlier KUI builds saved is also
read (2026-11-12).
Internal module environments expose the client's native mixin tables directly
for APIs that require raw environment lookups, including atlas vector data.

Saved variables use the KUIAR_Engine prefix. Existing standalone addon data
is not overwritten or imported automatically. Use the full editor's import
and export tools to transfer displays. Existing KUI auras remain available
through their original editor and keep their original saved format.

The upstream runtime recognizes Forever 1.60.x and Retail 12.x. Inclusion
does not establish in-game validation on either client or allow addons to
bypass the client's restrictions on secret values.

Translations (2026-11-12): KUI added translations for the strings the upstream
locale files leave in English, in the Locales folders of KUIAR_Engine and
KUIAR_EngineOptions for deDE, esES, esMX, frFR, itIT, koKR, ptBR, ruRU, zhCN
and zhTW. Each block is marked with a "-- KUI: translations added" comment
before the file's closing line. Names, code and API terms stay in English.

Archivist's debug-only line (`Archivist.debug = true`, in an already packaged
`@debug@` block) was removed (2026-11-14): the CurseForge packager closed the
block a second time and the file no longer compiled in packaged builds.
