# Estudio de migración: KullThranUI → WoW Forever

**Fecha:** 2026-09-18 · **Estado:** Fase 0 en curso (sonda API desplegada)

---

## 1. Resumen ejecutivo

KullThranUI está hecho para **retail WoW 12.1 (Interface 120100)**. WoW **Forever**
no es un servidor privado ni un cliente Vanilla: **Blizzard confirmó oficialmente
(Discord WoW UI)** que Forever comparte la **arquitectura UI de Mainline** — todo el
árbol fuentes y la vasta mayoría de APIs de 12.1.5 — siendo Forever y Midnight **dos
game types** del mismo código Mainline: **Camelot** (Forever, será renombrado antes
de launch) y **Standard** (Midnight). El desarme de addons de Midnight (secrets) y
los cambios AuraContainer/AuraButton de 12.1.0 **también están activos en Forever**.

Consecuencia directa: **la API es casi idéntica a retail** (incluye secret values y
AuraContainer, que KullThranUI ya maneja con guards 12.x). El trabajo real de
migración no es reescribir la UI, sino:

1. Ajustar el **Interface number** del TOC → **`160001` ÚNICO** (valor real del cliente
   Forever; los 26 TOCs del workspace y la sonda ya quedaron con `## Interface: 160001`).
2. **Neutralizar/ocultar contenido retail inexistente**: Mythic+, Reward Vault,
   Blizzard DamageMeter, dragonriding/skyriding, covenants/Evoker, talentos modernos,
   Housing (según resultado de sonda).
3. Migrar por **oleadas de riesgo** (11 directos, 7 parciales, 5 no migrables/rehacer).

---

## 2. Cliente objetivo: WoW Forever (verificado localmente)

| Dato | Valor | Cómo se obtuvo |
|---|---|---|
| Carpeta | `C:\Program Files (x86)\World of Warcraft\_classic_beta_` | $ |
| Flavor | `wow_classic_beta` | `.flavor.info` |
| Versión cliente | **1.60.1** (build 69893) | `WowB.exe` FileVersion + `WowB.exe` product |
| Versión realm | 1.60.1.69800 | dumps de Error |
| Interface TOC | **160001 ÚNICO** (confirmado por usuario; ya aplicado a los 26 TOCs) | 18-sep-2026 |
| Addons cargados hasta ahora | **KullThranUI core SÍ (00:40, perfil creado + Installer "defaults")**; resto según listado | SV `KullThranUI.lua` (76 KB) en WTF |

Notas del entorno:
- Los 25 addons (core + satélites) están enlazados como **junctions** dentro de
  `_classic_beta_\Interface\AddOns\` apuntando al workspace
  `C:\Users\Pablo\Documents\KullThranUI-Forever-Workspace`.
- El cliente beta escribe logs de **EditMode**, **UIParentPanelManager** y
  **Camelot** (blizzard UIPanels) → framework moderno compartido con Mainline.
- **Interface del TOC = 160001** (no 120100 ni 16001). Con 120100 el core cargó solo
  porque "load out-of-date addons" estaba activado; ahora los 26 TOCs llevan 160001.
- La beta va del 17-sep a finales de octubre (cap 30). Launch global: 4-nov-2026.

---

## 3. Evidencia de API (fuentes web, sep-2026)

- Wowhead (16-sep): "WoW: Forever **shares Mainline WoW's UI architecture**,
  including the vast majority of APIs available in 12.1.5. Forever y Midnight son
  dos game types de la familia Mainline: *Camelot* (Forever) y *Standard*.
  Los **cambios de desarme de addons de Midnight (secrets) estarán activos en
  Forever**. Los cambios de **AuraContainer/AuraButton de 12.1.0** están disponibles."
- WoW Classic (Foros Blizzard, 14-sep): "Forever parece basado en un cliente muy
  cercano a retail; esperaría modificaciones mínimas" (comunidad addon-dev).
- Config.wtf del beta incluye cvars modernos (raidGraphics*, EditMode, videoOptions
  version 52) → motor moderno.

**Implicación**: muchas addons de Classic tendrán que rehacerse, pero muchas addons
de Midnight (como KullThranUI) se portarán con relativa facilidad.

---

## 4. Comparativa de API (retail 12.1 ↔ Forever 1.60.1)

### 4.0. **EVIDENCIA DEFINITIVA: extracción del API real del cliente** (18-sep-2026)

El usuario extrajo con la consola de desarrollador el código UI completo del cliente
Forever (Beta ≥ build que incluye Camelot): `C:\Program Files (x86)\World of
Warcraft\_classic_beta_\BlizzardInterfaceCode`. Contiene:

- `Interface\AddOns\*` → todo el código UI de Blizzard de Forever.
- `Blizzard_APIDocumentationGenerated\` (639 archivos) → **documentación generada
  del API completo del cliente**: 289 namespaces `C_*` + `math`/`string`/`table`.

**Resultado**: la sonda ya NO es la única fuente de verdad; la doc del propio
cliente define exactamente qué existe. Confirmado directamente:

| API / sistema | ¿Existe en Forever? | Evidencia |
|---|---|---|
| `C_Item.GetItemInfoInstant` | **SÍ** (namespace) | `ItemDocumentation.lua:659`. El **global `GetItemInfoInstant` NO**; el global `GetItemInfo` SÍ (Bags:3049 no falló). |
| `C_SpecializationInfo.*` | **SÍ** (48 funcs) | `GetSpecialization`, `GetSpecializationInfo`, `GetNumSpecializationsForClassID`, `GetActiveSpecGroup`, `GetSpecializationMasterySpells`, `GetTalentInfo`… Los **globals NO** (Blizzard_DeprecatedSpecialization no carga en Camelot: `AllowLoadGameType` = classic/standard; Camelot no incluido). |
| `C_ChallengeMode` / `C_MythicPlus` | **SÍ** (51 / 30 funcs) | M+ existe como sistema (keystones, affixes, score, `IsMythicPlusActive`). |
| `C_WeeklyRewards` | **SÍ** (30 funcs) | Incluye `IsWeeklyChestRetired()` (Vault legacy). |
| `C_DamageMeter` | **SÍ** (18 funcs) | DamageMeter de Blizzard presente → módulo Enhancements viable. |
| `C_Housing` (+12 sub-ns) | **SÍ** (104+ funcs) | Housing existe ⇒ TeleportMenu moderno no está muerto. |
| `C_ClassTalents` / `C_Traits` | **SÍ** (42 / 85 funcs) | Talentos modernos existen (C_ClassTalents.GetActiveConfigID etc.). |
| `C_Secrets` | **SÍ** (28 funcs) | Sistema de secrets (desarme) activo en Forever, como confirmó Blizzard. |
| `C_EditMode` | **SÍ** (19 funcs) | EditMode presente. |
| `C_AddOnProfiler` | **SÍ** (15 funcs) | Profiler 11.1+ presente. |
| `C_CooldownViewer` | **SÍ** (13 funcs) | Cooldown synchronous view presente. |
| `C_Item` / `C_Container` / `C_Spell` / `C_Map` / `C_TooltipInfo` / `C_UnitAuras` / `C_PaperDollInfo` / `C_PvP` (184) | **SÍ** | Framework clásico+moderno intacto. |
| `C_GameModeManager` | **NO aparece** | No existe como namespace en la doc (no se usa). |
| Evento `LEARNED_SPELL_IN_TAB` | **NO** | Renombrado a **`LEARNED_SPELL_IN_SKILL_LINE`** (`ActionButton.lua:274`, `SpellBookDocumentation.lua:851`, guía `11_0_0_SpellBookAPITransitionGuide.lua:150`). |
| Evento `CHARACTER_POINTS_CHANGED` | **SÍ** | `PaperDollFrame.lua:310-315`. |
| `C_DamageMeter` sesiones | **SÍ** | `GetAvailableCombatSessions`, `GetCombatSessionFromID`, etc. |

**Conclusión**: la afirmación inicial "Forever = Classic+ sin APIs modernas" es
FALSA. Forever es **Mainline UI 12.1.5** (fuente oficial + doc extraída). Lo que
hay que neutralizar no es la API (existe), sino posibles **datos vacíos del
contenido Classic** en determinados sistemas según el mundo (M+ score solo aplica
en instancias M+, etc.). Se mantiene protección defensiva vía guards + detección
runtime (`IsMythicPlusActive`, `IsWeeklyChestRetired`), pero sin eliminar nada.

### 4.1. APIs compartidas (portables sin cambios — CONFIRMADAS)

`C_Timer`, `C_AddOns`, `C_Item`, `C_Container`, `C_Spell`, `C_Map`, `C_CVar`,
`C_UnitAuras`, `C_NamePlate`, `C_TooltipInfo`, `C_ClassColor`, `C_CurveUtil`,
`C_BattleNet`, `C_FriendList`, `C_PlayerInfo`, `C_PaperDollInfo`,
`C_SpecializationInfo`, `C_Reputation`, `C_MountJournal`, `C_GossipInfo`,
`C_QuestLog`, `C_EditMode`, `Enum`, `UIParentPanelManager`, `EditModeManagerFrame`,
`hooksecurefunc`, `CreateFrame`+`BackdropTemplate`, `SecureHandlerStateTemplate`,
`GetMouseFoci`, secret values (`issecretvalue`/`canaccessvalue`/`C_UI.IsSecret`),
AuraContainer/AuraButton (12.1.0).

### 4.2. Sistemas retail: **la API existe**, solo condicionar datos por contenido

**La tabla previa ("NO aplican / NUNCA tendrán datos") era INCORRECTA**: todas estas
APIs existen en Forever (doc extraída). El riesgo real es que en el mundo Classic+
los **datos** de algunos sistemas estén vacíos en runs normales (p. ej. M+ score 0
fuera de M+, Vault sin reward generado). Estrategia: **detección runtime en vez de
eliminación**.

| Sistema | Estado (con evidencia) | Acción |
|---|---|---|
| Mythic+ | Existe (`C_ChallengeMode`, `C_MythicPlus` 30 fns) | Guard `IsMythicPlusActive()`; ocultar/secciones con datos vacíos; no eliminar. |
| Reward Vault | Existe (`C_WeeklyRewards` 30 fns) | Usar `IsWeeklyChestRetired()`; el code path ya se auto-protege si no hay rewards. |
| WoW DamageMeter | Existe (`C_DamageMeter` 18 fns, sesiones) | **Dejar habilitado** el módulo Enhancements_DamageMeter. |
| Dragonriding | Mounts 372608+ = datos modernos; API de vuelo existe | Revisar `dragonRiding` en opciones; conservar con guard de data (como en retail). |
| Talentos modernos | Existen (`C_ClassTalents` 42, `C_Traits` 85) | Convertir guards de `C_ClassTalents` a use-if; no neutralizar. |
| Covenants / Evoker / DH | Tablas de datos existen | Ya tienen guards de data; no hay que neutralizar. |
| Housing | Existe (`C_Housing` 104+ fns, 12 sub-ns) | TeleportMenu puede usar Housing con guard runtime; re-mapear portales clásicos. |
| Transmog / Wardrobe / Delves / hero talents | Existen | Ya protegidos por version checks. |
| `C_AddOnProfiler` | Existe (15 fns) | Sin cambios necesarios. |
| `C_Secrets` | Existe (28 fns) | Secrets (desarme) activo en Forever → no requiere acción. |
| `C_GameModeManager` | **No existe** | No se usa en el addon → sin impacto. |

**Pendiente de confirmar (ya NO bloqueante — la doc cubre casi todo):** solo queda
la **detección runtime** en el mundo real (¿se emiten `DAMAGE_METER_*`, `IsMythicPlusActive()`
true, rewards del Vault?) → esto lo valida la sonda/probe cuando el login se estabilice.

---

## 5. Inventario de código (resultados del análisis)

### 5.1. Core (`KullThranUI`) — Interface 120100/…/120000

- ~57.100 líneas en el set core (sin Libraries; raíz ~13.600 + Modules ~43.500).
- **~85% portable** (framework genérico; ya preparado para 12.x/secrets).
- **~15% retail-content**: cluster M+/Vault en `ArmoryProgressBridge`, DamageMeter
  (`Enhancements_DamageMeter.lua` ≈ 3.8k líneas, `C_DamageMeter` — EXISTE en Forever),
  opciones `dragonRiding` (Config/Options/Profiles/FontsColors), tablas DH/Evoker
  (Interrupts, KUIProgressBars), secciones retail en `BlizzMove\Frames.lua`.
  → **Nada que neutralizar** al ser APIs presentes; solo guardar datos vacíos.
- Guards de versión ya presentes: `Core.lua:25-26, 209-218, 1094-1096, 1891`,
  `Widgets.lua:347`, `Options.lua:2528,3909`, `EnhancedFriendList.lua:335-367`
  (**ya detecta WOW_PROJECT_FOREVER_BETA/WOW_PROJECT_FOREVER**),
  `BlizzMove.lua:30,39-48,494`, `EscapeMenu.lua:31-33`, etc.
- Librerías embebidas: Ace3, oUF+AuraKit, LibSharedMedia-3.0, LibActionButton-1.0,
  LibRangeCheck-3.0, LibButtonGlow-1.0, LibDualSpec-1.0, TaintLess,
  WeakAuras_SharedMedia, etc. Varias ya tienen guards `WOW_PROJECT_ID`/Midnight.

### 5.2. Addons satélite (24) — tabla de riesgo

Todos: `## Dependencies: KullThranUI` + `## Interface: 160001` (único — aplicado a los 26 TOCs).
Sin `SavedVariables` propias (todo en `KullThranDB` del core).

| Addon | Riesgo | Razón |
|---|---|---|
| ActionBars | **Bajo** | Actionbuttons/slots genérico |
| Armory | **Medio** | M+ score/Solo Shuffle existen (no vacíos en M+); covenants/Evoker con guards |
| AuraReminders | **Medio** | `C_ClassTalents`/M+ existen; specs Evoker guard |
| Bags | **Bajo** | Genérico; categorías Housing/Keystone vivas pero con datos vacíos fuera de contexto |
| BuffsAndDebuffs | **Bajo** | Auras genérico; EditMode presente |
| CastBar | **Bajo** | Castbar genérico |
| Chat | **Bajo** | Requiere re-mapear canales |
| CooldownManager | **Medio** | `C_CooldownViewer`/`C_TradeSkillUI` existen; runtime propio `KUI_CDM` |
| Cursor | **Bajo** | 100% API global clásica |
| DragonRiding | **Alto→Medio** | Alpha: decidir; con guard de data (mounts modernos) puede sobrevivir |
| Enhancements | **Medio** | M+ existe; `_DamageMeter.lua` usa `C_DamageMeter` que EXISTE → mantener |
| ExperienceBar | **Bajo** | XP/rep clásico y relevante en lvl 60 |
| ExternalAddons | **Medio** | Bridge UUF/Chattynator; no-op si faltan |
| InspectArmory | **Medio** | Sección talentos modernos (existen) |
| Installer | **Medio** | Re-mapear pasos/estado por módulo |
| Minimap | **Bajo** | Minimapa genérico |
| Nameplates | **Bajo** | Nameplates genérico; DB `_G.KullThranUINameplatesDB` |
| ObjectiveTracker | **Medio** | Skins de trackers modernos → no-op; skin base ok |
| PartyFrames | **Medio** | `ArenaDRData` meta moderno |
| ResourceBars | **Bajo** | Recursos de clase clásicos |
| Skins | **Medio** | ~30 frames; los modernos no-op, el resto sirve |
| TeleportMenu | **Medio** | `C_Housing` EXISTE (ya no muerto); re-mapear portales clásicos + guard Housing |
| Tooltip | **Medio** | M+/RaiderIO muerto pero protegido |
| UnitFrames | **Bajo** | oUF = patrón clásico |

### 5.3. Acoplamiento core↔satélites

- Arranque idéntico en todos: `ns.KT = _G.KT; ns.KT_NS = _G.KT_NS`. Sin core → nada carga.
- Registro como módulo Ace: `KT:NewModule("<Nombre>", "AceEvent-3.0", ...)`.
- AuraReminders: parchea `KT:RegisterModule`. CooldownManager: runtime + DB propias
  (`_G.KUI_CDM`, `_G._KUI_CDM_AceDB`) pero requiere `_G.KT`.
- **Archivos del core cargados desde TOCs satélite** (rutas `..\KullThranUI\...`):
  - `KullThranUI_Enhancements` → 22 rutas (BlizzMove, BlizzardFrames, EscapeMenu,
    StackCountFix, Interrupts, Enhancements*, M+...).
  - `KullThranUI_Minimap` → MinimapButton, MinimapStats_Options.
  - `KullThranUI_UnitFrames` → UnitFramesWidth.lua.
- Rutas de media hardcodeadas a `Interface\AddOns\KullThranUI\Libraries\...` y
  `Modules\...` (texturas/fuentes/SimplicityTextures/Armory textures/Icons).

---

## 6. Workflow de migración propuesto

### Fase 0 — Cargar el core en Forever (EN CURSO)
- Desplegar **KTForeverProbe** en `_classic_beta_` (probe de API + interface) → listo.
- Confirmar `select(4, GetBuildInfo())` y `WOW_PROJECT_ID` reales.
- Hacer que el **core** cargue (TOC con interface correcto) y validar arranque sin
  errores con el core solo.

### Fase 1 — Blindaje runtime (guards) [EN CURSO]
- **La API existe (doc extraída)** → NO eliminar módulos. Solo:
  - Guards defensivos en llamadas a data que pueda estar vacío según el mundo
    (M+ score fuera de M+, Vault sin rewards).
  - `GetItemInfoInstant` shim (fallback C_Item + re-mapeo de posiciones).
  - Evento `LEARNED_SPELL_IN_SKILL_LINE` en LibRangeCheck (reemplaza a la versión `_IN_TAB`).
  - Revisar `dragonRiding` en Options con guard de data; decidir `KullThranUI_DragonRiding`.

### Fase 2 — Ajustar TOCs / packaging [EN CURSO]
- **DONE**: `## Interface: 160001` ÚNICO aplicado a los 26 TOCs + sonda.
- **DONE**: Enhancements mantiene `*MythicPlus*` y `Enhancements_DamageMeter.lua`
  (M+ y DamageMeter EXISTEN en Forever).
- Decidir `KullThranUI_DragonRiding`: por defecto conservar (guard data); eliminar
  solo si en Classic+ no hay mounts/skyriding.
- Valorar `AllowLoadGameType` si el cliente lo exige (por ahora no es necesario).

### Fase 3 — Migración por oleadas
1. **Directos (11):** ActionBars, Bags, BuffsAndDebuffs, CastBar, Chat, Cursor,
   ExperienceBar, Minimap, Nameplates, ResourceBars, UnitFrames.
2. **Parciales (7):** CooldownManager, ExternalAddons, InspectArmory, Installer,
   ObjectiveTracker, PartyFrames, Skins.
3. **Altos (5):** decidir Arnory/AuraReminders/Enhancements/TeleportMenu (rehacer
   partes) y DragonRiding (descartar).

### Fase 4 — Validación en Classic+
- Datos clásicos: spell IDs, talentos, tipos de poder, canales de chat, item slots.
- Beta (cap 30) para iteración; objetivo: funcionando en **launch 4-nov-2026**.
- Con la doc extraída, la validación de API es estática e inmediata; lo que valida la
  sonda es el **runtime** (0 errores, datos reales de M+/Vault/DamageMeter).

---

## 7. Sonda KTForeverProbe (Fase 0)

Desplegada en `_classic_beta_\Interface\AddOns\KTForeverProbe\`:

- `## Interface: 160001` (DONE — valor real del cliente Forever, corroborado por el usuario).
- Al entrar en juego se ejecuta sola (PLAYER_LOGIN) y/o con `/ktprobe`.
- Registra en `KTForeverProbeDB` (SavedVariables): GetBuildInfo completo,
  `select(4,GetBuildInfo())`, constantes `WOW_PROJECT_*`, y presencia + miembros de
  ~45 namespaces y ~95 sub-funciones críticas (M+, Vault, DamageMeter, Dragonriding,
  Housing, ClassTalents, Traits, CooldownViewer, AddOnProfiler, Secrets, EditMode…).
- Comprobación posterior al logout: leer
  `_classic_beta_\WTF\Account\<cuenta>\<reino>\SavedVariables\KTForeverProbe.lua`.

### Resultado esperado
- `tocExpected` (sel 4 de GetBuildInfo) debería ser **160001** (interface real del
  cliente, ya aplicado a los 26 TOCs). Si difiere, usar el valor real.
- **ATENCIÓN**: la doc extraída del cliente ya confirmó que TODAS las APIs críticas
  existen. La sonda ahora valida el **runtime** y los **datos reales** del mundo
  (no es bloqueante para el trabajo).

---

## 8. Próximos pasos inmediatos

1. [x] Verificar interface: **160001 ÚNICO** (confirmado por usuario; aplicado a los 26 TOCs del workspace + sonda).
2. [x] **Diagnóstico errores beta (dump 00:42)**: 30 errores Lua = 4 causas raíz, todos arreglados con shims/guards:
   - `GetItemInfoInstant` nulo (Bags:3144) → shim en Core.lua (fallback C_Item/GetItemInfo, **con re-mapeo de posiciones 1→7**).
   - `GetSpecialization` nulo (Armory:826, AuraReminders:46) → shim en Core.lua (C_SpecializationInfo/GetPrimaryTalentTree).
   - Evento `LEARNED_SPELL_IN_TAB` inexistente (LibRangeCheck) → **registrar el evento moderno `LEARNED_SPELL_IN_SKILL_LINE`** (pcall + handler propio).
   - El crash nativo `ASSERTSAFE(gameObj)` (GameObject_C.cpp) es **del cliente**, no de addons.
3. [x] **API confirmada con la doc extraída del cliente** (`BlizzardInterfaceCode\Blizzard_APIDocumentationGenerated`):
   - `C_SpecializationInfo.*` (48 fns) y `C_Item.GetItemInfoInstant` EXISTEN; los globals NO.
   - `C_MythicPlus`, `C_ChallengeMode`, `C_WeeklyRewards`, `C_DamageMeter`, `C_Housing`,
     `C_ClassTalents`, `C_Traits`, `C_Secrets`, `C_EditMode`, `C_AddOnProfiler`, `C_CooldownViewer` EXISTEN.
   - Freezar la tabla 4.2: **nada se elimina**; solo guards de datos vacíos.
4. [ ] Reintentar sondas API cuando el login se estabilice (problema de colas conocido del launch) — valida runtime+datos, no es bloqueante.
5. [ ] Entrar en WoW **Forever Beta** con el addon `!KTForeverProbe` activo y validar 0 errores en el mundo.
6. [ ] Fase 1 restante: decidir `dragonRiding`/`KullThranUI_DragonRiding` con guard de data; revisar guards de M+/Vault actuales (¿dan problemas con datos vacíos?).

---
*Documento generado por análisis de código + logs/clientes locales + fuentes web
(Wowhead, Foros de Blizzard, guías de addons).*