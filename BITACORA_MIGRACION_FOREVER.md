# BITÁCORA DE MIGRACIÓN KullThranUI → WoW Forever

**Propósito:** registro de reanudación. Si se agotan los tokens, una IA nueva debe leer ESTE archivo
(+ `ESTUDIO_MIGRACION_FOREVER.md`) y continuar exactamente por donde quedó.
**Última actualización:** 18-sep-2026 (sesión tarde; API real del cliente extraída → verificación estática completa).
**Idioma de conversación:** español. **Estado global:** Fase 0 y verificación de API completadas + Fase 1 en curso.

---

## 1. RESUMEN EJECUTIVO (para reanudar en 10 segundos)

KullThranUI (retail 12.1, Interface 120100) se está migrando a **WoW Forever** (beta Classic+, carpeta
`_classic_beta_`, versión 1.60.1 build 69893). Blizzard confirmó que **Forever comparte la arquitectura
UI de Mainline 12.1.5** (game type **Camelot**), con contenido Classic+ nivel 60.

- ✅ **Interface TOC = 160001 ÚNICO** (confirmado por el usuario). **Aplicado a los 26 TOCs** del
  workspace (core + 24 satélites + MinimapStats) y a la sonda.
- ✅ **Blizzard confirmó (Discord WoW UI):** Forever = mismo código Mainline que Midnight (dos game
  types: Camelot=Forever, Standard=Midnight). APIs de 12.1.5 en su mayoría, secrets/desarme activos.
- ✅ **El core KullThranUI YA carga y funciona en Forever** (escribió SV con datos reales el 18-sep 00:40).
- ✅ Arregladas las **4 causas raíz de errores Lua** detectadas en el beta (ver §4).
- ✅ **API real extraída del cliente** (`_classic_beta_\BlizzardInterfaceCode`, 639 archivos de docs
  generadas) → **verificación estática completa, ya NO bloqueada por colas/sonda** (ver §3.6).
  Conclusión: las APIs modernas EXISTEN (M+, Vault, DamageMeter, CooldownViewer…); lo que hay que
  comprobar es el CONTENIDO activo por game type (`AllowLoadGameType`, ver §3.6).
- ⏳ **Pendiente:** validación in-world (0 errores con la sonda) cuando el login se estabilice;
  blindaje runtime restante (dragonriding); decisión de DragonRiding en el build.
- ⏳ Siguiente fase: **Fase 1/2 restantes** (ver §5).

---

## 2. RUTAS CRÍTICAS

| Elemento | Ruta |
|---|---|
| Workspace (repo git) | `C:\Users\Pablo\Documents\KullThranUI-Forever-Workspace` |
| Cliente beta (Forever) | `C:\Program Files (x86)\World of Warcraft\_classic_beta_` |
| Cliente retail | `C:\Program Files (x86)\World of Warcraft\_retail_` |
| Ejecutable beta | `...\_classic_beta_\WowB.exe` |
| Addons del beta | `...\_classic_beta_\Interface\AddOns\` (junctions al workspace + `KTForeverProbe` real) |
| SV del account | `...\_classic_beta_\WTF\Account\134826506#1\SavedVariables\` |
| SV del personaje | `...\134826506#1\70\Abusador-Depicaros\SavedVariables\` |
| Errores del cliente | `...\_classic_beta_\Errors\` (txt + dmp) |
| Estudio completo | `<workspace>\ESTUDIO_MIGRACION_FOREVER.md` |
| Bitácora (este archivo) | `<workspace>\BITACORA_MIGRACION_FOREVER.md` |
| **API real extraída** (código UI Blizzard + docs) | `...\_classic_beta_\BlizzardInterfaceCode\Interface\AddOns\` (639 docs en `Blizzard_APIDocumentationGenerated\`) |

Notas de entorno: cwd por defecto de la sesión = `...\_retail_\Interface\AddOns`.
`rg` **no existe** en PowerShell; usar `Select-String` o las herramientas Read/Glob/Grep.
Directorio temporal aprobado: `C:\Users\Pablo\AppData\Local\Temp\opencode`.

---

## 3. LO QUE SE HA HECHO (completo, en orden)

### 3.1. Estructura y contexto
- Inventariado el workspace: core `KullThranUI` (~57.100 líneas) + **24 addons satélite** (`KullThranUI_*`),
  todos `## Dependencies: KullThranUI`, TOC `Interface: 120100, 120007, 120005, 120001, 120000`.
- Persistencia única: `KullThranDB` (AceDB-3.0) en el core, sin SV propias en satélites.
- Confirmado en el cliente beta: flavor `wow_classic_beta`, v1.60.1.69893, juego type Camelot,
  secret values activos, blizzard UIPanels modernos.

### 3.2. Investigación de API (fuentes web 16-17-sep-2026)
- Forever comparte UI de Mainline 12.1.5; Midnight y Forever son game types de la misma rama.
- Dumps del beta confirman APIs modernas: `Blizzard_DamageMeter.lua` y `Blizzard_LegacyChallengeTracker.lua`
  presentes en el SV del personaje → **Forever SÍ tiene DamageMeter Blizzard** (C_DamageMeter probable).
- Beta del 17-sep a ~21-oct (cap 30). Launch global 4-nov-2026.

### 3.3. Fase 0 — Sonda e interface
- Creada **`!_classic_beta_\Interface\AddOns\KTForeverProbe\`** (toc + lua):
  - `KTForeverProbe.toc`: `## Interface:` cambiado a **`160001` ÚNICO** (valor real del cliente Forever).
  - `KTForeverProbe.lua`: sondea al **cargar** Y en `PLAYER_LOGIN`; guarda en `KTForeverProbeDB`
    (GetBuildInfo, `select(4,...)`, todas las `WOW_PROJECT_*`, ~45 namespaces C_* y ~95 sub-funciones
    de contenido moderno: ChallengeMode, MythicPlus, WeeklyRewards, DamageMeter, Housing, ClassTalents,
    Traits, CooldownViewer, AddOnProfiler, Secrets, EditMode…). Comando `/ktprobe`.
  - **Resultado preliminar:** `KTForeverProbeDB = nil` en SV → no llegó a sonar (sin PLAYER_LOGIN en la
    sesión corta). **Conclusión válida igualmente:** el core (120100) SÍ cargó → interface real = 120100.

### 3.4. Diagnóstico de errores del beta (dump Errors\2026-09-18_00.42.34_Error_15496.txt)
- **TODOS los addons cargaron** (lista `<Set.Addons.All.Loaded>` con los 25 + sonda).
- `Time in World: 00:00:02` → el usuario entraba al mundo y lo echaba a los 2 s.
- Crash nativo: `ASSERTSAFE(gameObj, ...)` en `GameObject_C.cpp` (cliente, NO de addons).
- **30 errores Lua = 4 causas raíz** exactas (con stack traces):
  1. `KullThranUI_Bags\Modules\Bags\Bags.lua:3144` → `GetItemInfoInstant()` = nil.
  2. `KullThranUI_Armory\Modules\Armory\Armory.lua:826` → `GetSpecialization()` = nil.
  3. `KullThranUI_AuraReminders\Modules\KUIAuraReminders\KUIAuraReminders.lua:46` → `GetSpecialization()` = nil.
  4. `KullThranUI\Libraries\LibRangeCheck-3.0\LibRangeCheck-3.0.lua:4599` → evento
     `LEARNED_SPELL_IN_TAB` no existe en Forever.
- Errores de Blizzard propios (no nuestros): `PaperDollFrameStats.lua:286 bad argument #1 to 'format'`
  (dump 00:05), `HelpFrame` blocked URL.

### 3.5. Fase 1 — Parches aplicados (ediciones EXACTAS ya hechas)

Archivo: `<workspace>\KullThranUI\Core.lua` (bloque de compatibilidad al inicio, tras los `local`
de la línea ~22; ahora ocupa **líneas 24-~125**):
- **Shim `GetItemInfoInstant`** (solo si el global falta):
  - 1º `C_Item.GetItemInfoInstant` (existe en Forever, doc `ItemDocumentation.lua:659`).
  - 2º `C_Item.GetItemInfo` → **re-mapea** 18 valores (itemName 1º) al layout de instant
    `(itemID, itemType, itemSubType, itemEquipLoc, icon, classID, subClassID)`.
  - 3º global `GetItemInfo` → mismo re-mapeo.
  - 4º función vacía.
  - (CORREGIDO respecto a la primera versión: antes asumía posiciones 1..13 compartidas, era FALSO.)
- **Shim `GetSpecialization`** (si falta): `C_SpecializationInfo.GetSpecialization`, si no
  `GetPrimaryTalentTree` (>0), si no vacío.
- **Shim `GetSpecializationInfo`** (si falta): pass-through de
  `C_SpecializationInfo.GetSpecializationInfo` (layout nuevo: `specId, name, description, icon, role, …`).
  **Verificado**: TODOS los call-sites del addon esperan ese layout (p. ej. `Options.lua:4914`
  `local specID, specName, _, specIcon`; `Armory.lua:828` `_, _, _, icon`). Correcto.
- **Shims adicionales** (replican `Blizzard_DeprecatedSpecialization`, que NO carga en Camelot):
  `GetNumSpecializationsForClassID`, `GetActiveSpecGroup` (vararg, alias fiel a
  `C_SpecializationInfo.GetActiveSpecGroup`), `GetSpecializationMasterySpells` (tabla→2 valores),
  `GetTalentInfo` (query table).
- **NO requieren shim (nativos del engine, existen en Forever):** `GetNumSpecializations` (lo usa el
  propio código Blizzard: `PaperDollFrame.lua:2355`), `GetSpecializationInfoByID`,
  `GetSpecializationInfoForClassID`, `GetArenaOpponentSpec`.

Archivo: `<workspace>\KullThranUI\Libraries\LibRangeCheck-3.0\LibRangeCheck-3.0.lua`:
- Añadido handler `lib:LEARNED_SPELL_IN_SKILL_LINE()` (llama a `scheduleInit`).
- El registro cambia de `LEARNED_SPELL_IN_TAB` a **`LEARNED_SPELL_IN_SKILL_LINE`** (nombre moderno,
  ver `ActionButton.lua:274`, guide `11_0_0_SpellBookAPITransitionGuide.lua:150`), envuelto en `pcall`.

### 3.6. **Extracción del API real del cliente** (HITO — elimina el bloqueo de la sonda)

El usuario extrajo con la consola de desarrollador el código UI completo del cliente:
`...\_classic_beta_\BlizzardInterfaceCode\Interface\AddOns\`. Contiene el código de Blizzard de
**todos** los game types + `Blizzard_APIDocumentationGenerated\` (639 archivos, 289 namespaces `C_*`).

**Hallazgo clave — `AllowLoadGameType` en los TOCs de Blizzard** (define qué sistemas están ACTIVOS
en cada game type). Camelot = Forever. Addons que cargan en camelot:

```
Blizzard_CooldownViewer, Blizzard_CovenantToasts, Blizzard_DamageMeter, Blizzard_DelvesCompanionConfiguration,
Blizzard_Gamepad*, Blizzard_GroupFinder_VanillaStyle, Blizzard_GuildRename, Blizzard_HardcoreUI,
Blizzard_IslandsPartyPoseUI/IslandsQueueUI, Blizzard_LegacyChallengeTracker, Blizzard_LegacySystem,
Blizzard_MoneyReceipt, Blizzard_PetBattleUI, Blizzard_PVPMatch, Blizzard_QuestTimer,
Blizzard_RestrictedAddOnEnvironment, Blizzard_StableUI, Blizzard_Statistics, Blizzard_SwingTimer, Blizzard_Tutorials
```

**NO cargan en camelot** (solo standard/mainline): todos los `Blizzard_Housing*`, `Blizzard_ChallengesUI`
(UI de M+), `Blizzard_EncounterJournal`, la mayoría del contenido retail moderno.
`Blizzard_DeprecatedSpecialization` = **classic, standard** → confirma por qué los globals de spec NO
existen en Forever (de ahí los shims).

**Matiz esencial:** un namespace puede existir en la doc (el cliente es multi-game-type) pero su
**contenido/UI no estar activo** en camelot. Por eso la estrategia correcta es **guards + detección
runtime**, no eliminar módulos.

**Verificado que el addon ya se auto-protege:**
- `C_Housing` (TeleportMenu) → guards `if C_Housing and C_Housing.GetPlayerOwnedHouses` (no crash).
- M+ → `C_ChallengeMode.IsChallengeModeActive` existe (`ChallengeModeInfoDocumentation.lua:273`) y
  `Enhancements_MythicPlusCombatTimer.lua:679` hace early-return si no hay challenge activo (no crash).
- `C_DamageMeter` → módulo funcional (Blizzard_DamageMeter carga en camelot).

---

## 4. ESTADO ACTUAL DEL CÓDIGO (no tocar sin entender)

Modificados en el workspace (las junctions del beta los ven al instante):
- `KullThranUI\Core.lua` (bloque de compatibilidad ampliado: 7 shims + comentarios de layout).
- `KullThranUI\Libraries\LibRangeCheck-3.0\LibRangeCheck-3.0.lua` (evento moderno + handler).
- Creado (fuera del repo, solo en el cliente): `KTForeverProbe` (`_classic_beta_\Interface\AddOns\`).
- Documentos: `ESTUDIO_MIGRACION_FOREVER.md` y `BITACORA_MIGRACION_FOREVER.md` (este) actualizados.

SV existentes en el beta (evidencia de que el core funcionó):
- `WTF\Account\134826506#1\SavedVariables\KullThranUI.lua` (~76 KB) y `.lua.bak`: perfil
  `Abusador Depicaros - Classic Beta PvP`, Installer "defaults", EditMode/cursor/blizzframes.
- `WTF\Account\134826506#1\SavedVariables\KTForeverProbe.lua`: `nil` (pendiente de relanzar).

---

## 5. SIGUIENTES PASOS (orden recomendado)

> **Nota:** la extracción del API (§3.6) ya desbloqueó la verificación estática. La sonda pasó de ser
> "fuente de verdad" a "validación de runtime/contenido". Se puede avanzar sin ella.

### Paso 1 (BLOQUEADO por server, no bloqueante técnicamente): validación in-world
- Pedir al usuario que entre en Forever Beta cuando las colas lo permitan (problema de Blizzard,
  reconocido: "we're working through some final issues").
- Con `!KTForeverProbe` activo + `/ktprobe`, y salir del juego con menú (NO Alt+F4).
- Luego leer `WTF\Account\134826506#1\...\SavedVariables\KTForeverProbe.lua` y confirmar **0 errores**
  (las APIs ya están verificadas estáticamente).

### Paso 2 — Blindaje runtime (Fase 1, casi completa)
- **YA cubierto/verificado:** shims de spec/item, LibRangeCheck, C_Housing con guards, M+ con
  `IsChallengeModeActive` + early-return, DamageMeter funcional.
- **DragonRiding: VERIFICADO SIN RIESGO** (`KullThranUI_DragonRiding\...\DragonRiding.lua`):
  módulo autocontenido, todo guardado (`C_Spell.*`, `C_PlayerInfo.IsPlayerInDragonriding` + pcall,
  `C_MountJournal.IsDragonriding` + pcall, `UnitPowerBarID`, `Enum.PowerType.AlternateMount` con
  fallback 29) y `C_PlayerInfo.GetGlidingInfo` EXISTE en Forever (`PlayerInfoDocumentation.lua:103`).
  En Classic+ no hay vigor/skyriding → la barra nunca se muestra, pero **no crashea**. Decisión:
  **conservar el módulo** (opcional: ocultar su opción en el menú, cosmético).
- **Pendiente:** repetir dump de errores tras un login limpio para cazar globals raros no vistos aún.

### Paso 3 — TOCs / packaging (Fase 2)
- **✅ HECHO:** Interface **160001 ÚNICO** aplicado a los 26 TOCs + sonda.
- **✅ DECIDIDO:** NO excluir `Enhancements_MythicPlus*` ni `Enhancements_DamageMeter` (las APIs
  existen; los módulos ya se auto-protegen con guards/early-return).
- **Pendiente:** decidir `KullThranUI_DragonRiding` (probable conservar con guard de data; eliminar
  solo si en Classic+ no hay skyriding real).

### Paso 4 — Migración por oleadas (Fase 3)
- 11 directos (ActionBars, Bags, BuffsAndDebuffs, CastBar, Chat, Cursor, ExperienceBar, Minimap,
  Nameplates, ResourceBars, UnitFrames).
- 7 parciales (CooldownManager, ExternalAddons, InspectArmory, Installer, ObjectiveTracker,
  PartyFrames, Skins).
- 5 a revisar: Armory, AuraReminders, Enhancements, TeleportMenu (Housing con guard), DragonRiding.

---

## 6. DATOS DE LA CUENTA/USUARIO (para diagnóstico)

- Battle tag: `KullThran#2929`. Personaje en la beta: `Abusador Depicaros` (Druida, "Célico Formavientos"),
  realm "Classic Beta PvP" (id 70 en WTF), GUID `Player-4619-00605C89`, zona Aldea Shen'dar (mapId 2991).
- Cuenta WTF: `134826506#1`. Locale: esES.

---

## 7. COMANDOS ÚTILES (PowerShell 5.1)

```powershell
# Ver los últimos errores del cliente beta (txt/dmp)
Get-ChildItem "C:\Program Files (x86)\World of Warcraft\_classic_beta_\Errors" -Recurse | Sort LastWriteTime -Desc | Select -First 5

# Extraer errores Lua únicos de un dump
Select-String -Path "<dump>.txt" -Pattern '^Lua Error:' | % Line | Sort -Unique

# Listar los 25 TOCs y su Interface
Get-ChildItem "<workspace>" -Recurse -Filter *.toc | ? FullName -notmatch 'Libraries|Media' |

# Leer SV de la sonda
Get-Content "C:\Program Files (x86)\World of Warcraft\_classic_beta_\WTF\Account\134826506#1\SavedVariables\KTForeverProbe.lua"

# API: qué addons Blizzard cargan en camelot (Forever)
$b="...\_classic_beta_\BlizzardInterfaceCode\Interface\AddOns"
Get-ChildItem "$b" -Recurse -Filter *.toc | % { $m=Select-String $_.FullName -Pattern 'AllowLoadGameType\s*:\s*(.+)'; if($m -and $m.Matches.Groups[1].Value -match 'camelot'){ $_.Name } }

# API: funciones de un namespace (ej. ChallengeMode)
Select-String "$b\Blizzard_APIDocumentationGenerated\ChallengeModeInfoDocumentation.lua" -Pattern '^\s*Name ='
```

---

## 8. ADVERTENCIAS

- **NO** usar `rg` (no existe). Usar las herramientas propias (Read/Grep/Glob) o `Select-String`.
- El commit/git: el workspace es repo git; **no hacer commit salvo que el usuario lo pida**.
- Los `@project-version@` en versiones del TOC/SV son placeholders normales de packaging (no error).
- El interface del TOC no debe tocarse por ahora; los cambios que falten son de contenido, no de versión.
---

## 9. Sesión 18-sep-2026 — módulos que no aplican a Forever y Skins

### Decisiones de alcance

- Dragon Riding: se excluye del paquete de release de Forever y su TOC queda LoadOnDemand: 1. No se borran sus fuentes para conservar la compatibilidad futura, pero deja de cargarse automáticamente y desaparece de los índices, tipografía y lista de módulos de KullThranUI.
- Mythic+ Timer: queda desactivado en Forever. El valor por defecto pasa a false, los perfiles antiguos se fuerzan a false durante Enhancements:OnInitialize, no se inicializa su tracker y se oculta su categoría/opción de navegación. El Combat Timer normal se conserva.
- Mythic+ History: se reconduce a Dungeon History. Se mantienen aliases de configuración, almacenamiento, /ktkeys y métodos antiguos para no romper perfiles/scripts previos; el acceso nuevo es /ktdungeons.

### Implementación del historial de mazmorras

- Enhancements_MythicPlusHistory.lua expone Mod.DungeonHistory y mantiene Mod.MythicPlusHistory como alias.
- Se migra la configuración de mplusHistory a dungeonHistory y el almacenamiento global usa dungeonHistory, conservando mythicPlusHistory como alias de compatibilidad.
- Se añade captura de instancias party sin key: al entrar se guarda nombre, dificultad, mapa/instancia, hora y miembros; al salir se registra duración y se conserva el grupo capturado.
- La interfaz elimina la dependencia de nivel, afijos, límite de tiempo y puntuación para las mazmorras normales. Las ejecuciones M+ antiguas/importadas siguen pudiendo visualizarse si existen datos.
- El historial se limita a 50 entradas por personaje y mantiene la captura detallada solo mientras está habilitado.

### Error del módulo Skins

- Se corrigió KullThranUI_Skins/Modules/Skins/Skins_Options.lua: el builder utilizaba LText("Great Vault") sin declarar LText, causando attempt to call a nil value al abrir opciones. Ahora usa KT.Options.LText con fallback seguro.

### Archivos modificados en esta sesión

- KullThranUI_Skins/Modules/Skins/Skins_Options.lua
- KullThranUI_DragonRiding/KullThranUI_DragonRiding.toc
- KullThranUI_Enhancements/KullThranUI_Enhancements.toc
- KullThranUI/scripts/Build-KullThranUIRelease.ps1
- KullThranUI/Options.lua
- KullThranUI/Modules/Enhancements/Enhancements.lua
- KullThranUI/Modules/Enhancements/Enhancements_Options.lua
- KullThranUI/Modules/Enhancements/Enhancements_MythicPlusHistory.lua
- KullThranUI/Modules/Enhancements/Enhancements_MythicPlusHistoryUI.lua

### Comprobaciones realizadas

- luac -p correcto en los seis Lua modificados de Skins, Options y Enhancements.
- git diff --check sin errores; solo avisos existentes de conversión de finales de línea LF/CRLF.
- No se eliminó ningún módulo fuente ni se hizo commit.
## 10. Selector de idioma protegido y bloqueo definitivo del Installer automático (2026-09-18)

- KullThranUI/Options.lua: el selector de idioma ya no llama directamente a ReloadUI() desde el OnClick del dropdown. Ese camino estaba provocando en Forever el mensaje genérico de acción de interfaz bloqueada por un addon. Ahora guarda el idioma, normaliza las fuentes y abre el popup de confirmación de recarga de KUI.
- KullThranUI/Core.lua: añadido IsInstallerAutoOpenSuppressed() como fuente única de verdad para dontShowAgain, incluyendo el shadow global por perfil o por personaje que se escribe al marcar la casilla. El bloqueo se aplica a MaybeAutoOpenInstaller, ProcessLoginPopups, el watcher de PLAYER_ENTERING_WORLD, los reintentos de 2/5 segundos y las aperturas diferidas al salir de combate.
- Las aperturas automáticas pasan explícitamente como automáticas y la apertura manual por /installer, /ins, /installers o el botón de opciones sigue disponible.
- KullThranUI_Installer/Modules/Installers/Installers.lua: OnEnable y su ticker de reapertura se detienen inmediatamente cuando dontShowAgain está activo, evitando que el módulo vuelva a levantar la ventana después de que Core lo haya bloqueado.
- Comprobación prevista: validar sintaxis Lua, git diff --check y probar en Forever marcando la casilla, /reload, cierre completo y cambio de idioma.
## 11. TeleportMenu: cooldowns con secret values de Forever (2026-09-18)

- KullThranUI_TeleportMenu/Modules/TeleportMenu/TeleportMenu.lua: protegido UpdateAllCooldowns frente a duraciones secretas devueltas por C_Spell.GetSpellCooldown y C_Item.GetItemCooldown.
- Las duraciones secretas ya no se comparan directamente con cero; se pasan al widget Cooldown mediante pcall y se evita mostrar el dimmer propio cuando no se puede conocer de forma segura si el cooldown está activo.
- Las duraciones normales conservan el comportamiento anterior. El cambio evita el error “attempt to compare local 'duration' (a secret number value)” de Forever.
## 12. Persistencia tardía de Forever: idioma e Installer (2026-09-18)

- El selector de idioma ahora guarda el valor también en sombras globales por perfil y personaje, y ejecuta FlushPersistence después de completar todos los cambios. Esto evita que Forever pierda la selección al recargar cuando el perfil vivo todavía es el default de AceDB.
- Tras conectar SavedVariables, Core restaura primero el idioma shadow y vuelve a normalizar fuentes/ruta de fuente.
- Si Forever no entrega SavedVariables después del fallback de 15 segundos, KUI marca la persistencia como no disponible y bloquea todas las aperturas automáticas del Installer. La apertura manual continúa disponible.
- La casilla Don't show again del Installer sincroniza las claves de perfil y personaje, limpia los flags de reapertura y hace FlushPersistence al final, no antes.

## 13. Niveles y clasificación en Unit Frames y Party Frames (2026-09-18)

- Unit Frames: añadido showCharacterLevel = true y toggle Show Character Level en la sección Global.
- Unit Frames: añadido showClassification = true y toggle Show Elite / Rare Indicator en Global.
- El nivel se pinta arriba a la izquierda del frame; se obtiene dentro de pcall y se descarta si Forever devuelve un número protegido/secret, evitando comparaciones o formatos tainted.
- La clasificación de Unit Frames utiliza los mismos atlas que Nameplates:
  - elite/worldboss: nameplates-icon-elite-gold
  - rareelite: nameplates-icon-elite-silver
  - rare: nameplates-icon-star
- La lectura se actualiza al entrar al mundo, cambiar target/focus, cambiar roster, UNIT_LEVEL y UNIT_FLAGS.
- Party Frames: añadido showCharacterLevel = true como opción raíz y toggle visible en el modo Party.
- El nivel aparece arriba a la izquierda de cada Party Frame y también en el modo de prueba con nivel de muestra 80.
- UNIT_LEVEL se registra por unidad de roster. El toggle aplica ApplyLayout("party") inmediatamente y se aplaza si hay combate.
- Validado con luac -p en Unit Frames y Party Frames, y git diff --check.
## 14. Unit Frames: corrección de sublevel del indicador Elite/Rare (2026-09-18)

- Forever rechazaba la textura del indicador de clasificación porque Unit Frames la creaba con sublevel 8.
- Corregido a sublevel 7, el máximo admitido por Frame:CreateTexture() en esta build (-8 a 7).
- El error era de inicialización del módulo y no de la API de clasificación.
## 15. Personalización del texto de nivel (2026-09-18)

- El texto de nivel de Unit Frames y Party Frames ahora permite configurar fuente, tamaño, outline, color y offsets X/Y desde opciones.
- Unit Frames guarda estos valores en la raíz del perfil: levelFont, levelFontSize, levelFontOutline, levelColor, levelX y levelY.
- Party Frames utiliza los mismos campos en la raíz de su perfil y aplica los cambios mediante ApplyLayout("party").
- Los offsets X/Y son relativos a la esquina superior izquierda del frame y aceptan también el valor 0.
- La personalización usa LibSharedMedia y el fallback de fuentes de KUI cuando la fuente seleccionada no está disponible.
## 16. Aura Reminders: APIs de inventario y activación dentro de instancias (2026-09-18)

### Diagnóstico

- El error de KullThranUI_AuraReminders en FindWeaponEnchantItem() se producía porque Forever no expone necesariamente la función global Retail GetItemCount(). La llamada directa en la línea del escaneo de WEAPON_ENCHANT_ITEMS provocaba 'attempt to call a nil value'.
- El mismo riesgo estaba presente en la búsqueda de frascos/comida/runa, iconos de objetos y clasificación de armas (GetItemIcon, GetInventoryItemID y GetItemInfoInstant).
- La detección de contenido instanciado rechazaba cualquier instancia cuyo difficultyID todavía fuese nil/0. En Forever el tipo party/raid puede estar disponible antes que la dificultad, por lo que los recordatorios de auras podían quedar desactivados aunque el jugador ya estuviese dentro de una mazmorra.

### Implementación

- KullThranUI_AuraReminders/Modules/KUIAuraReminders/KUIAuraReminders.lua:
  - Añadidos wrappers protegidos GetSafeItemCount() y GetSafeItemIcon(). Prueban las variantes C_Item y globales, capturan errores con pcall y, si GetItemCount no existe, escanean las bolsas 0-4 mediante C_Container por itemID.
  - Sustituidas las llamadas directas de inventario para weapon enchants, frascos, comida, runas, Inky Black Potion y construcción de iconos.
  - GetTemporaryWeaponEnchants() ahora tolera la ausencia de C_PaperDollInfo.GetTemporaryEnchantmentInfo y GetWeaponEnchantInfo.
  - GetWeaponCategory() protege la lectura de inventario y metadatos del objeto.
  - CacheInstanceInfo() y GetCurrentInstanceName() toleran una API de instancia ausente o una dificultad todavía no disponible.
  - InRealInstancedContent() se basa ahora en party/raid/scenario y deja el difficultyID para filtros concretos como runas y dificultades míticas. Así los aura reminders se activan dentro de mazmorras de Forever aunque la dificultad llegue tarde.
  - El contador seguro devuelve un número ordinario después de la comprobación protegida, evitando propagar un posible secret number a comparaciones posteriores.
- No se desactivó Aura Reminders en instancias: se conserva su propósito de mostrar buffs, auras y consumibles aplicables en mazmorras.

### Verificación

- Se revisaron todas las llamadas directas a GetItemCount y GetItemIcon del módulo; solo quedan referencias internas dentro de los wrappers compatibles.
- Pendiente de validar in-world en Forever: entrar en una mazmorra, ejecutar /kuiardebug y confirmar InInstance: true; probar a continuación un weapon enchant o un aura configurado.
## 17. Objective Tracker: accent y compatibilidad con módulos/ScrollBox de Forever (2026-09-18)

### Diagnóstico

- El skin del Objective Tracker resolvía el accent con un fallback local basado en skin.accentColor/BRAND_COLOR, distinto de la paleta central de KUI (GetStyleAccentRGB()), por lo que podía ignorar el preset o el color por clase activo.
- ObjectiveTrackerFrame.modules se recorría con ipairs, asumiendo la estructura indexada de Retail. En Forever puede ser una tabla asociativa y entonces no se enganchaba ningún tracker.
- Los bloques pooled podían marcarse como procesados antes de recibir sus líneas o título; el retorno temprano impedía colorearlos en actualizaciones posteriores.
- La ruta moderna de ScrollBox solo inspeccionaba el scroll target actual y no recorría de forma segura los frames virtualizados visibles.

### Implementación

- KullThranUI_ObjectiveTracker/Modules/Skin.lua:
  - GetAccent() usa ahora KT:GetStyleAccentRGB() y conserva el color personalizado específico del Objective Tracker.
  - Los módulos se recorren con pairs y se añade un recorrido recursivo tolerante para usedBlocks directo o anidado.
  - Los bloques ya conocidos vuelven a ejecutar StyleBlockText() en cada actualización para soportar el pool de Forever.
  - Se reconocen varios nombres de campo para títulos (HeaderText, headerText, Title y title) y se aplica el color también cuando el FontString es un hijo directo, no solo una región.
  - Se añade pasada compatible con ScrollBox:ForEachFrame()/EnumerateFrames() y hook de ObjectiveTrackerFrame:Update() para recolorear los frames que aparecen después.
- La lógica existente de objetivos secundarios permanece gris claro; el accent se aplica a encabezados y títulos de objetivos, respetando la opción Use Blizzard Quest Colors.

### Verificación

- Validar sintaxis con luac -p y revisar git diff --check.
- Probar tras recarga con una misión visible y cambiar entre Accent (Default) y Custom Color; el título del bloque debe actualizarse sin reiniciar el cliente.
## 18. Aura Reminders: filtrado de contenido para Forever (2026-09-18)

### Diagnóstico

- Aura Reminders compartía tablas de Retail con Forever: buffs de grupo, auras de clase, venenos, ritos de paladín, imbues/escudos de chamán, variantes de frascos y buffs de runas.
- El chequeo anterior llamaba directamente a IsPlayerSpell()/IsSpellKnown(), APIs que pueden faltar o comportarse de forma distinta en Forever, y no distinguía entre un ID que no existe en el cliente y un hechizo que el personaje todavía no conoce.
- Las tablas exportadas al módulo de opciones podían seguir mostrando entradas de Retail aunque el cliente Forever no tuviera ese hechizo.

### Implementación

- KullThranUI_AuraReminders/Modules/KUIAuraReminders/KUIAuraReminders.lua:
  - Añadidos SafeSpellInfo() y SpellExists(), protegidos con pcall y compatibles con C_Spell.GetSpellInfo y el GetSpellInfo global.
  - Known() ahora protege IsPlayerSpell(), IsSpellKnown() y C_SpellBook.IsSpellKnown(), con fallback cuando Forever no ofrece ninguna API de conocimiento.
  - Antes de exportar los datos se filtran por catálogo real del cliente las listas de RAID_BUFFS, AURAS, ROGUE_POISONS, PALADIN_RITES, SHAMAN_IMBUES, SHAMAN_SHIELDS, RUNE_BUFF_IDS, INKY_BLACK_BUFF y los buffs de FLASK_ITEMS.
  - Los buffIDs alternativos también se filtran; si una variante no existe se conserva el castSpell válido como fallback para no dejar una entrada sin aura comprobable.
  - Las listas de objetos de frascos, comida y weapon enchants no se eliminan por caché de objetos: en Forever la información de objetos puede ser asíncrona y se siguen resolviendo por inventario seguro.
  - /kuiardebug muestra ahora las estadísticas antes/después del filtro. También se exportan en _G._KUIAR_FILTER_STATS para inspección.

### Verificación

- luac -p correcto para KullThranUI_AuraReminders/Modules/KUIAuraReminders/KUIAuraReminders.lua.
- git diff --check sin errores; permanecen únicamente avisos existentes de conversión LF/CRLF.
- Pendiente de validación in-world: ejecutar /kuiardebug en Forever y confirmar qué entradas se eliminaron del catálogo, después revisar que un druida no reciba recordatorios de clases o hechizos inexistentes.
## 19. Unit Frames: posición dinámica del indicador Elite/Rare (2026-09-18)

- El indicador de clasificación usaba un anclaje fijo a X=40, dejando demasiado espacio entre el nivel y el icono y pudiendo solaparse cuando se personalizaba la fuente o el tamaño del nivel.
- KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUIUnitFrames.lua ahora mide el ancho renderizado del texto de nivel y ancla el icono inmediatamente después, con 4 px de separación.
- Si el nivel está oculto o no se puede medir, el indicador vuelve a X=2. La posición se recalcula en cada actualización de metadatos.
- Validado con luac -p en el módulo de Unit Frames.

## 20. Nameplates: nivel configurable de la unidad (2026-09-18)

### Implementación

- KullThranUI_Nameplates/Modules/Nameplates/Nameplates.lua añade un texto de nivel independiente de los slots de nombre/vida.
- Está activado por defecto y se muestra sobre la parte izquierda del nameplate. El valor por defecto X=24/Y=4 deja espacio para el indicador Elite/Rare que ocupa el extremo izquierdo.
- Se añadieron opciones persistentes para mostrar/ocultar, fuente, tamaño, outline, shadow, color y offsets X/Y.
- El nivel se protege contra UnitLevel ausente, errores de API y secret values de Forever.
- Se actualiza al adquirir/reciclar placas y en UNIT_LEVEL; los presets también incluyen los nuevos campos.

### Opciones y preview

- Nameplates_Options.lua incorpora la sección NAMEPLATE LEVEL en Display.
- La preview usa el nivel 30 y refleja en directo todos los ajustes.
- Los offsets permiten colocar el nivel en cualquier lado del nameplate dentro del rango configurable.

### Verificación

- luac -p correcto en Nameplates.lua y Nameplates_Options.lua.
- Pendiente de validación in-world: abrir Display > Nameplate Level, probar cambio de fuente/tamaño/outline/sombra/color/X/Y y comprobar que el valor sobrevive a /reload.

## 21. Party Frames: indicador PvP y estado real de módulos (2026-09-18)

### Indicador PvP
- Party Frames incorpora showPvPIcon = true por defecto.
- Usa EnhancedFriendList/Horde.png y EnhancedFriendList/Alliance.png a 14x14, anclados 2 px a la izquierda del frame.
- El icono solo aparece cuando UnitIsPVP(unit) es verdadero y la facción es Horde/Alliance.
- Las lecturas de UnitIsPVP y UnitFactionGroup están protegidas contra errores y secret values de Forever.
- Se actualiza con UNIT_FACTION por unidad de roster y PLAYER_FLAGS_CHANGED.
- Se añadió el toggle Show PvP Faction Icon en la configuración de Party Frames.

### Enable Module
- Party Frames sincroniza su estado Ace con db.enable durante OnInitialize, registra limpieza en OnDisable y el toggle llama a Enable()/Disable() antes del reload.
- Unit Frames vuelve a comprobar db.enable al entrar en OnEnable, evita crear frames cuando está desactivado y oculta el árbol de frames en OnDisable.
- El toggle cargado por el TOC de Unit Frames sincroniza también Enable()/Disable() antes del reload.
- Auditoría: el resto de módulos conserva el patrón de guardar db.enable y aplicar tras reload; sus OnEnable ya contienen la protección db.enable == false o equivalente. No se modifican indiscriminadamente porque algunos módulos requieren reload para destruir/recrear frames protegidos.

### Verificación
- luac -p correcto en PartyFrames, PartyFrames_Options, KUIUnitFrames y KUI_UnitFrames_Options.
- Assets comprobados: Horde.png y Alliance.png.
- Pendiente en cliente Forever: comprobar icono con PvP propio/miembro, ocultarlo con el toggle y probar Enable Module OFF/ON tras /reload.
## 22. Defaults de retrato, PvP Unit Frames y diagnóstico de compatibilidad

Fecha: 2026-09-18

- UnitFrames: `profile.player.showPortrait` y `profile.target.showPortrait` quedan activados por defecto.
- UnitFrames: `circularPortraitBorderUseCustomColor` queda activado por defecto, manteniendo el color configurado por KUI para el borde circular.
- UnitFrames: añadido el indicador PvP para Player y Target, reutilizando `EnhancedFriendList/Horde.png` y `Alliance.png`; se actualiza con `UNIT_FACTION` y `PLAYER_FLAGS_CHANGED`, y se oculta si el estado PvP no es legible o está desactivado.
- Armory: añadido reintento de creación diferida de cabecera, panel de estadísticas, botón y selector de fondo cuando CharacterFrame/PaperDollFrame aparecen después del login. Esto evita que el panel quede permanentemente vacío por inicializarse antes que la UI de personaje.
- Armory: añadida comprobación segura de `GetSpecialization`/`GetSpecializationInfo` y un `KUIDebugCheck` para detectar APIs ausentes, paneles no creados y último error de refresco.
- Objective Tracker: la inicialización ahora está protegida con `pcall` y reintenta durante el login si `ObjectiveTrackerFrame` llega tarde o Forever no emite el mismo `ADDON_LOADED` que Retail. Añadido `KUIDebugCheck` con estado de addon, frame, ScrollBox y error de inicialización.
- Core: añadido `/ktdebug full` (alias `scan`) para enumerar módulos Ace, comparar `db.enable` con `IsEnabled()`, revisar addons `KullThranUI_*`, APIs/frames sensibles y mostrar errores capturados desde el login. El informe queda también en `KT._compatDebugReport`; los errores recientes se limitan a 80 entradas.
- Core: instalado un capturador seguro del manejador global de errores después de crear AceDB; conserva el manejador anterior y registra los errores para el diagnóstico sin impedir que Blizzard los muestre.

Comprobaciones realizadas:

- `luac -p` sobre Core, UnitFrames, Armory y Objective Tracker.
- `git diff --check`.
- Revisar en juego con `/ktdebug full` después de reproducir el fallo de Objective Tracker, abrir el personaje para probar Armory y ejecutar `/reload` para confirmar defaults.
- Corrección adicional: el default anterior solo activaba el color personalizado, pero mantenía `portraitStyle = attached`; ahora el estilo por defecto es `circular`, y los perfiles existentes que seguían en `attached` se migran una vez a `circular` para que el borde sea visible.
- Ajuste visual posterior: el overlay de nivel, clasificación y PvP de Unit Frames usa ahora strata `HIGH` y nivel elevado, por encima del portrait circular (`MEDIUM`). `RefreshUnitFrameStrata` respeta este overlay para no devolverlo accidentalmente a `LOW`.
- Corrección del diagnóstico: `Config.lua` estaba registrando de nuevo `ktdebug` y sobrescribía el handler de Core, por eso `/ktdebug full` solo mostraba `DB Loaded: Yes`. El registro antiguo ahora delega a `RunCompatibilityDebug`.
- Mejora del diagnóstico: `/ktdebug full` ahora usa `AceAddon:IterateAddons()` y `KT:IterateModules()`; antes intentaba llamar a un inexistente `GetModules()` y por eso el apartado salía vacío. Objective Tracker reporta además si usa módulos legacy, cuántos tiene y cuántos trackers legacy están disponibles.
- Objective Tracker añade un fallback final para Forever: cuando no existen `ScrollBox`, `ObjectiveTrackerFrame.modules` ni los globals legacy de Retail, inspecciona los hijos directos del frame y engancha los que exponen `Update`, `usedBlocks` o `Header`.
- El diagnóstico de Objective Tracker ahora muestra cuántos trackers fueron realmente enganchados; el de Armory distingue entre panel creado, panel visible, CharacterFrame/PaperDoll abiertos y panel nativo visible.
### 2026-09-19 - Lectura del escaneo /ktdebug full

El escaneo de compatibilidad ejecutado en Forever con el perfil Abusador Depicaros - Classic Beta PvP no muestra fallos globales de carga:

- Los modulos Ace principales aparecen con enabled=true; los modulos con db.enable=nil son submodulos internos que no tienen un toggle de configuracion propio.
- Los modulos independientes con configuracion propia, incluidos Armory, ExperienceBar, ObjectiveTracker, PartyFrames, Skins, TeleportMenu, UnitFrames y los restantes, aparecen habilitados.
- Los addons KullThranUI_* cargan correctamente. KullThranUI_DragonRiding queda como DEMAND_LOADED, comportamiento esperado para un modulo que no debe inicializarse hasta que el juego solicite esa carga.
- Las APIs comprobadas por el escaner existen en Forever: especializacion, estadisticas, armadura, nivel de objeto, PvP y faccion.
- ObjectiveTrackerFrame=true y ScrollBox=false indican que Forever utiliza la variante legacy del tracker. El escaner encontro 11 modulos legacy y 11 trackers nombrados; por ello el skin debe apoyarse en la ruta legacy, no asumir la API retail de ScrollBox.
- CharacterFrame=true, PaperDollFrame=true y statsFrame=true prueban que Armory pudo localizar y construir su panel. statsShown=false solo significa que el panel de estadisticas personalizado no estaba visible durante la captura, normalmente porque la ventana del personaje estaba cerrada o la pestana no estaba activa.
- No se capturaron errores desde el login.

Se validaron con Lua 5.1 los archivos de Core, Armory y ObjectiveTracker, y la comprobacion de diferencias no encontro errores de formato. Se anadio informacion adicional al diagnostico para la siguiente prueba: estado visible de CharacterFrame/PaperDollFrame/CharacterStatsPane, cantidad de trackers realmente enganchados y errores de inicializacion del Objective Tracker.

Prueba siguiente recomendada: hacer reload, abrir Character Info en la pestana de personaje/estadisticas y ejecutar /ktdebug full; para Objective Tracker, mantenerlo visible al ejecutar el comando y revisar hookedTrackers e initError.


### 2026-09-19 - Silenciado del diagnostico de persistencia

Las trazas `[PERSIST]` y `[KTUM]` se mostraban porque `KT.persistenceDebugEnabled` estaba activado por defecto y algunos mensajes del flujo de SavedVariables imprimian directamente sin consultar esa bandera.

Cambios realizados:

- El diagnostico de persistencia queda desactivado por defecto (`persistenceDebugEnabled = false`).
- Los mensajes directos de captura, snapshot, merge y comprobacion de Unlock Mode quedan protegidos por la misma bandera.
- `/ktpersistdebug on` sigue activando temporalmente la salida detallada.
- `/ktpersistdebug off` la desactiva y `/ktpersistdebug clear` limpia el historial interno.
- Se comprobo la sintaxis Lua de Core y Unlock Mode con Lua 5.1; ambos archivos pasan correctamente.


### 2026-09-19 - Armory: visibilidad de estadisticas en Forever

El escaneo mostro `paperDollShown=true` pero `characterShown=false`, una combinacion valida en la interfaz de Forever donde el subframe PaperDoll puede permanecer visible aunque el contenedor retail CharacterFrame no reporte visibilidad.

Se ajusto el watcher de Armory para usar `PaperDollFrame` como fuente de verdad al decidir si mostrar `StatsFrame`, manteniendo oculto `CharacterStatsPane` nativo. Antes exigia simultaneamente CharacterFrame y PaperDollFrame visibles, por lo que el panel personalizado nunca llegaba a mostrarse en ese estado.

Se valido `KullThranUI_Armory/Modules/Armory/Armory.lua` con Lua 5.1 y `git diff --check`.


### 2026-09-19 - Objective Tracker: titulo de misiones en Forever

El escaneo confirmo 12 trackers enganchados, pero los nombres de misiones seguian conservando el amarillo nativo en algunos bloques legacy. En Forever el titulo no siempre esta expuesto directamente como `HeaderText`; puede vivir en un hijo del bloque y ser repintado despues por Blizzard.

Se anadio una resolucion segura de FontString para los campos `HeaderText`, `Title`, `QuestTitle` y variantes, con fallback al primer FontString del bloque. El color del titulo se reaplica al final de `StyleBlockText`, despues de estilizar las lineas, y sigue respetando la opcion `useBlizzardQuestColors`.

La captura de Armory confirma que el panel personalizado ya es visible. No se modificaron los valores de estadisticas a partir de la captura; el ajuste realizado en esta iteracion es exclusivamente del titulo del Objective Tracker.

Se valido `KullThranUI_ObjectiveTracker/Modules/Skin.lua` con Lua 5.1.

### 2026-09-19 - Target portrait, BlizzMove Forever y version beta

Unit Frames: el portrait de Target pasa por defecto al lado derecho, opuesto al Player. Los perfiles existentes con Target a la izquierda se migran una sola vez con el marcador `_foreverPortraitDefaults20260919c`; se conserva el borde circular, sus overlays y el resto de configuracion.

BlizzMove: Forever devuelve una version de juego 1.60.x (`16001` en la captura), que no se puede comparar numericamente con rangos retail como `110000`. Se anadio deteccion de Forever y `MatchesCurrentBuild` ignora esos rangos retail en esta rama, permitiendo procesar frames que existen. Los nombres que no existen en la API/namespace de Forever siguen registrados para diagnostico, pero dejan de imprimirse como errores de chat; muchos son frames retail eliminados, renombrados o creados solo al abrir su panel.

Version: el core, los TOC de KullThranUI y modulos y MinimapStats pasan a `0.0.2`. La entrada historica retail `5.0.7` se conserva y se agrega una entrada especifica para Forever beta.

Comprobaciones: `luac -p` sobre Core, Options, KullThranUI, UnitFrames y BlizzMove; `git diff --check` sin errores de whitespace.

### 2026-09-19 - Migracion de supresion del changelog al cambiar de version

Al cambiar la version del paquete Forever de 5.0.7 a 0.0.2, Core migra la supresion del changelog ya registrada para retail 5.0.7. Asi un perfil que ya habia confirmado ese changelog no vuelve a mostrarlo unicamente por el cambio de identificador de version. La migracion se ejecuta una sola vez y conserva la supresion en el almacenamiento global y por perfil. Tambien se actualizaron los fallbacks de version usados por la interfaz para que nunca vuelvan a presentar 5.0.7 si el valor principal no estuviera disponible.
### 2026-09-19 - Experience Bar y Unlock Mode

La Experience Bar no estaba conectada al registro actual de Unlock Mode: usaba un registro antiguo contra un modulo EditMode que no consume el mover actual. Se registro como experience_bar mediante KT.RegisterUnlockElement, con carga, aplicacion y guardado de posicion/escala en profile.editMode.frames y en la configuracion del modulo.

Para perfiles Forever antiguos sin posicion canonica se establecio una migracion unica: anclaje BOTTOM centrado, y = 82, ligeramente por encima del nacimiento de las action bars de Blizzard. Esto permite verla aunque las SavedVariables sigan incompletas y no pisa una posicion valida ya guardada.
### 2026-09-19 - Default del Combat Timer

El Combat Timer de Enhancements queda desactivado por defecto (combatTimer.enabled = false). Los perfiles Forever que aun conservaban el true del default anterior se migran una sola vez a false mediante un marcador; despues el usuario puede activarlo desde la configuracion de Enhancements sin que la migracion vuelva a tocarlo.
### 2026-09-19 - Party Frames: reminders de buffs para Forever

Party Frames separa ahora la tabla de buffs de grupo por cliente. En Forever se eliminan del flujo los hechizos Retail modernos como Power Word: Fortitude 21562, Skyfury y Blessing of the Bronze/Evoker, y se comprueban rangos Classic disponibles: Mark of the Wild, Power Word: Fortitude, Arcane Intellect y Battle Shout. Se añaden Windfury Totem para Shaman y Blessing of Kings para Paladin con sus IDs de Forever/Classic.

La deteccion sigue aceptando tanto ID como nombre de aura y el acceso directo ya no exige que exista la API Retail GetUnitAuraBySpellID. La vista previa y los toggles de Party Frames usan la misma lista detectada para no presentar opciones de clases o hechizos ausentes en Forever.
### 2026-09-19 - Eliminación de Mythic+ Timer del build Forever

- Retirado Enhancements_MythicPlusCombatTimer.lua de KullThranUI_Enhancements.toc, por lo que el submódulo no se carga en Forever.
- Eliminado el paso Mythic+ Timer, su preview y su entrada del resumen final del Installer.
- Renumerados los pasos restantes del Installer de 20 a 19 para que no quede un hueco ni rutas de reload inválidas.
- Añadida una migración única para convertir pasos guardados antiguos (incluidos reopenStep/resumeStep) y evitar que un perfil anterior reabra una página incorrecta.
- Conservado Enhancements_MythicPlusHistory.lua y su interfaz como historial de mazmorras, independiente del timer de Mythic+.

### 2026-09-19 - Unit/Party Frames: nivel, PvP y overlays de dispel

- Unit Frames: el indicador de nivel ahora descarta de forma segura valores protegidos antes de compararlos; el icono PvP acepta los formatos booleano y numérico que puede devolver Forever y refresca también el target desde el ciclo común de actualización.
- Unit Frames: el overlay global de dispel se aplica a las ranuras AuraKit del jugador, al borde de player/focus/pet/boss y a los bordes por aura de los debuffs del target. El cambio de opción fuerza el refresco visual inmediato.
- Party Frames: showDispelOverlay ahora controla también los bordes de Magic/Curse/Disease/Poison/Bleed de los contenedores AuraKit ya creados, actualizando sus colores y grosor sin reconstruir el roster.
- Se mantienen los controles actuales: un toggle global de overlays y colores separados por tipo de dispel. No se han añadido filtros de tipos que no existen todavía en la configuración.
- Ajuste adicional: el texto de nivel usa UnitLevel y recurre a UnitEffectiveLevel, igual que el tag de nivel de oUF, cuando Forever devuelve un sentinel desconocido o no expone la primera ruta.
### 2026-09-19 - Damage Meter: posición por defecto inferior derecha

- Ajustada la posición por defecto del Damage Meter a RIGHT/RIGHT, x = -80, y = -300, para colocarlo abajo y ligeramente más a la izquierda, en la zona indicada.
- Incrementada la migración de layout a la versión 8. Solo se mueve automáticamente un perfil que conserve exactamente la posición antigua x = -36, y = 0; cualquier posición personalizada queda intacta.
### 2026-09-19 - Nameplates: nivel en jugadores aliados

- Las placas de jugadores aliados muestran por defecto el nivel a la izquierda del nombre, tanto en modo name-only usando el UnitFrame nativo de Blizzard como en modo de placas completas.
- Se reutilizan el toggle Show Level y la configuracion existente de fuente, tamano, outline, sombra y color del nivel de Nameplates.
- Se anadieron refrescos para UNIT_LEVEL, reciclado de placas, cambios de configuracion y limpieza al retirar una placa, evitando duplicados cuando se alterna entre modos.
### 2026-09-19 - Chat: susurros salientes en Forever

- Corregida la deduplicacion de CHAT_MSG_WHISPER_INFORM y eventos equivalentes: Forever puede enviar lineID = 0, que no es un identificador valido.
- KUI ya no usa ese cero como clave global de deduplicacion; cuando no hay un lineID positivo utiliza la clave compuesta del evento, destinatario y mensaje, permitiendo mostrar todos los susurros salientes.
### 2026-09-19 - Combo Points secretos y metadatos de Target

- Forever puede devolver UnitPower ComboPoints como secret number. Se elimino la comparacion directa de ese valor en Resource Bars y en el Class Power custom de Unit Frames; cada pip usa ahora un StatusBar con rango [i-1, i], que consume el valor protegido sin operaciones Lua.
- Se corrigio tambien la libreria oUF: ClassPower ya no divide, suma, resta ni compara el valor secreto, no ejecuta PostUpdate con ese valor, y el tag cpoints reconoce el valor protegido antes de entrar en la rama numerica.
- La tabla de recursos de Unit Frames limita Combo Points del Druida a Feral (spec 103); Balance, Guardian y Restoration no reciben por error el recurso de Combo Points.
- En Target, nivel, PvP y clasificacion se anclan al Portrait.backdrop real, por lo que siguen al portrait si cambia de lado, tamaño o posicion. El nivel permanece por encima del borde circular; el PvP queda a la izquierda en Player y a la derecha en Target cuando el portrait esta flippeado.
- Comprobaciones pendientes de juego: validar en Forever con Rogue con 0/1/5 puntos, Feral en distintas formas, cambio de spec y Target con portrait a izquierda/derecha. La ruta Lua pasa la validacion estatica.
### 2026-09-19 - Unit/Party Frames: toggles, previews y target invertido

- Se hicieron visibles en las páginas de Unit Frames y Party Frames los toggles Show Character Level y Show PvP Faction Icon.
- Los live previews ahora crean y actualizan el texto de nivel y el icono de facción PvP, respetando el estado de los toggles y la configuración de fuente, tamaño, outline, color y offsets del nivel.
- El target con portrait a la derecha coloca el nivel alineado arriba a la derecha del portrait y el icono PvP fuera del portrait, a su derecha; el indicador Elite/Rare también se espeja para evitar solapamientos.
- Se registró el cambio como parte de la migración 0.0.2 de Forever.