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
### 2026-10-01 - Classic: hueco transparente entre el anillo y el portrait

- El backdrop del portrait recorta sus propias texturas al cuadrado de 64px (SetClipsChildren), así que expandir _bg nunca llegaba a la apertura real del UI-TargetingFrame, que es más ancha: quedaba una media luna transparente entre el anillo y el retrato.
- Nuevo frame de relleno (_ktClassicPortraitFill, en ThemeClientAssets.lua) sin recorte, un nivel por debajo del portrait, con un disco oscuro enmascarado en círculo que solo se amplía 3px por abajo y por el lado de las barras (derecha en Player, izquierda en Target); arriba y por fuera asomaba fuera del anillo (CLASSIC_PORTRAIT_FILL_PAD). El anillo opaco tapa cualquier exceso. Sigue la visibilidad del portrait y se oculta al salir de Classic.
- Pendiente de QA en juego: confirmar que el hueco desaparece en Player/Target y que el disco no asoma por fuera del anillo; si asoma, bajar CLASSIC_PORTRAIT_FILL_PAD.
### 2026-10-01 - Visual Styles: tarjetas, botones de color y preview de Classic

- Tarjetas de Visual Styles: la fila de action bars (capRowHeight) sube de 24/29 a 27/32 (~12%).
- Botones HEALTH/CLASS rediseñados como control segmentado (ThemePreview.lua): pista oscura común, mitad activa con fondo teñido, barra inferior de 2px y etiqueta brillante, chip de color en cada mitad y hover sutil. Sin bloques planos ni texto con contorno.
- KullThranUI Style: su tarjeta ahora también tiene los botones HEALTH/CLASS (antes solo Classic/Forever/Retail) y la miniatura sigue el color real de salud en vez de forzar siempre el de clase. DrawFlatFrame replica el live preview de Unit Frames: retrato redondo con anillo, nombre dentro de la barra, absorción verde, porcentaje a la derecha y barra de poder fina pegada debajo; sin nivel; caja de tamaño proporcionado en vez de rellenar todo el escenario.
- Live preview de Unit Frames con tema Classic (KUI_UnitFrames_Options.lua): la foto del retrato se escalaba 1.55x y se salía del anillo. Ahora replica el frame real: foto a 64px recortada a su caja, máscara circular ampliada 0.275 y disco oscuro de relleno con el mismo padding asimétrico. Al salir de Classic se restaura el recorte y el tamaño del retrato.
- Pendiente de QA en juego: las tres zonas (la sintaxis solo se ha comprobado con un contador de bloques, no hay intérprete de Lua en este entorno).
### 2026-10-01 - Visual Styles: zona de tarjetas y botones de KUI Style

- La tarjeta de KullThranUI Style incluye una fila de 5 botones planos tipo action bar bajo el unit frame (ThemePreview.lua, rama flat de AddEndCapArt), en el hueco donde las otras tarjetas llevan sus end caps.
- Las tarjetas ya no van de borde a borde pegadas al riel y al borde derecho del bloque Visual Theme (Options.lua). Ahora están dentro de una bandeja con fondo propio, borde fino y 10px de relleno, con margen bajo la descripción. ThemeSelector.lua admite xOffset para esto.
- Pendiente de QA en juego.
### 2026-10-01 - Visual Styles: IN USE, botón Apply, action bars y traducciones

- IN USE ya no se pisa con el título: pasa a ser una pastilla con borde de acento en la línea del subtítulo, justo a continuación del texto, y el conjunto se recentra (ThemePreview.lua).
- La fila de action bars sube 5px respecto al botón (la tarjeta mantiene su altura, el espacio extra queda sobre APPLY TO ALL).
- Botón APPLY TO ALL rediseñado: base oscura teñida con el acento de la tarjeta, borde fino de acento, brillo superior y barra de 2px abajo; hover más intenso; la tarjeta ya aplicada se atenúa.
- Nuevo Locales/Modules/VisualStyles.lua (registrado en el .toc tras OptionsGaps.lua) con 32 textos en esES, deDE, frFR, itIT, ptBR, ruRU, koKR, zhCN y zhTW: bloque Visual Theme, nombres/etiquetas/descripciones de las tarjetas, APPLY TO ALL, IN USE, HEALTH, CLASS, tooltips y los 12 nombres de Preset Colors. Solo rellena lo que no tiene traducción real. ThemePreview.lua usa un helper T() sobre KT:GetLocale() y Options.lua localiza los nombres de preset.
- Los nombres de marca (WOW FOREVER, WOW RETAIL, WOW CLASSIC, KUI) se dejan sin traducir a propósito.
- Pendiente de QA en juego, sobre todo anchuras de texto en ruso y alemán.
### 2026-10-01 - Visual Styles: CLASS/HEALTH sincronizado entre tarjetas

- Al pulsar CLASS o elegir un color en una tarjeta solo se repintaba su propia miniatura; las otras tres conservaban el color anterior y su segmento activo (tras aplicar un tema el perfil queda con healthClassColored=false y verde, así que el resto de tarjetas seguía verde). ThemePreview.lua guarda ahora un registro de las tarjetas visibles (RegisterCardHealthView / RefreshAllCardHealth, reiniciado en cada CreateSelector) y Commit repinta miniaturas y segmentos de todas.
- En la tarjeta de KUI el color de salud usa SetVertexColor (conserva la textura de la barra) y el anillo del retrato sigue ese color.
- Pendiente de QA en juego.
### 2026-10-01 - Damage Meter: skin por Visual Style

- Enhancements_DamageMeter.lua: nueva capa METER_SKINS + ApplyDamageMeterSkin, ejecutada al final de RefreshDamageMeterStyle. Solo recolorea y añade cromo: no mueve filas ni toca datos, colores de clase ni el layout.
- Classic (estilo Recount): panel marrón oscuro con borde naranja-ocre y barra de título roja con degradado, título dorado claro, filas con fondo oscuro.
- Retail (medidor de Blizzard): panel oscuro de esquinas redondeadas (UI-Tooltip-Border), título dorado, línea dorada bajo la cabecera, barras con contorno negro de 1px e iconos de clase con marco dorado.
- Forever: la estructura de Retail en bronce, con marco interior bronce de 2px alrededor de las filas.
- kui no cambia. Los botones de cabecera (StyleHeaderButton) toman el color del título del skin y dejan de pintar el bloque dorado translúcido. Respeta la opción Mostrar fondo: sin fondo se omite el panel pero se mantiene la cabecera.
- Pendiente de QA en juego; el degradado de la cabecera usa SetGradient y cae a color plano si el cliente no lo admite.
### 2026-10-02 - Visual Styles: HEALTH/CLASS independiente por tarjeta

- Todas las tarjetas leían y escribían los mismos ajustes de salud de Player/Target, así que cambiar una cambiaba las cuatro. Ahora cada tarjeta guarda su elección en profile.visualThemeHealth[tema] = { classColored, color } (ThemePreview.lua).
- Solo la tarjeta del tema en uso modifica los frames reales; las demás únicamente recuerdan su elección. Sin elección guardada una tarjeta muestra el valor por defecto de su tema (clase en kui, verde en los demás) o el perfil real si es el tema activo.
- Adapters/UnitFrames.lua (validate) reaplica la elección guardada de cada tema al cambiar a él.
- Pendiente de QA en juego.
### 2026-10-02 - Live preview de Unit Frames con Forever/Retail

- El atlas del marco se estiraba a la caja de 232x100; ahora se dibuja a su tamaño nativo y centrado, como ApplyForeverUnitFrameArt, de modo que el anillo y las pistas de barra coinciden con las barras (KUI_UnitFrames_Options.lua).
- La foto del retrato ya no se escala 1.55x: se queda al tamaño stock, recortada, con la máscara ampliada 5 unidades, como el frame real.
- Nombre y valor pasan al frame de nivel, por encima del arte y fuera del recorte de Health, para que se vean sobre la pestaña del nombre.
- Retail comparte esta geometría, por lo que queda corregido a la vez. Pendiente de QA en juego.
### 2026-10-02 - Damage Meter Forever: más claro y borde bronce completo

- El skin de Forever pasa de un panel casi negro a uno marrón cálido más claro (panelBg 0.15/0.11/0.075, 90%) con filas algo más claras.
- El marco bronce interior alrededor de las filas se sustituye por un borde bronce de 2px alrededor de todo el marco (panelEdgeSize en METER_SKINS.forever). Sin esquinas redondeadas de tooltip.
- Pendiente de QA en juego.

## 2026-10-02 — Damage Meter: tamaño por defecto unificado
- Defaults nuevos para todos los Visual Styles y ventanas adicionales: ancho 338, alto 201 (altura de barra 19, filas máx. 10 y fuente 12 ya eran el valor por defecto).
- Cambiado en Enhancements.lua (defaults), Enhancements_DamageMeter.lua (fallbacks, ventanas adicionales) y Enhancements_Options.lua (preview y sliders).
- El adapter de Visual Themes del Damage Meter no toca tamaño. Perfiles con tamaño ya guardado conservan sus valores (usar Reset / sliders).

## 2026-10-02 — Unit Frames: textura de barra independiente por Visual Style
- `Default Texture` (KUI_UnitFrames_Options.lua) ya no se bloquea por el tema activo (`IsColorOwnedPath` incluye `healthBarTexture`).
- Cada estilo guarda su textura en su propio slot (SaveSlot al cambiar de tema); al volver se restaura. Primera visita sigue usando el seed del tema.

## 2026-10-02 — Retail/Forever: textura por defecto Blizzard Raid Bar
- Seeds ya la tenían (Adapters/UnitFrames.lua); añadida migración única `MigrateRaidBarDefault` (ThemeEngine.lua, flag `raidBarDefault20261002`) que fuerza "Blizzard Raid Bar" en los slots forever/retail y en el perfil vivo si el tema activo es uno de ellos.
- Posición de Target: pendiente de diagnóstico (no reproducible sin datos in-game).

## 2026-10-02 — Unit Frames: parpadeo al /reload + smooth nativo
- Parpadeo: los frames se creaban visibles antes de aplicar el layout real (SavedVariables/posición). Ahora `BeginStartupMask`/`ns.EndStartupMask` (KUIUnitFrames.lua) los mantienen con alpha 0 hasta la primera pasada de layout (0.4s tras RefreshAfterPersistenceReady, tope duro 1.2s).
- Smooth: `ApplySmoothBar` usa primero la interpolación nativa `Enum.StatusBarInterpolation` (si existe, también con valores "secret"); si no, el tween Lua previo. `smoothBars=true` por defecto es un default AceDB, igual para todos los styles.

## 2026-10-02 — Unit Frames: ornamentos por estilo + borde Rare/Elite en Player
- `ns.GetThemeOrnamentColor` (KUIUnitFrames.lua): Forever bronce (0.80,0.56,0.24), Retail amarillo, Classic fallback. Usado en el borde del círculo PvP (ahora 26px) y en el borde de los anillos de combo points (Classic blanco).
- KUI Style: el círculo de fondo del icono PvP siempre oculto; sombra (`_kuiPvPShadow`) bajo el icono en player/target.
- Opción `playerClassificationBorder` (none/rare/elite) en Unit Frames > General: muestra el borde elegido en Player; en Forever/Retail oculta el arte bronce base, en Classic lo mantiene.
- Sin locales nuevas a nivel de archivo (límite 200).

## 2026-10-02 — Unit Frames: círculo de nivel, facing, borde Player y posición Target
- Círculo de nivel (Forever y Retail, `usingClassicLevelOrnament`): máscara con expand x0.85, tamaño 32, sin pixel-snap -> disco redondo en vez de cuadrado redondeado.
- `portraitFacingMode` (auto/normal/flipped) por unidad, válido en todos los styles (GetPortraitFacing lo respeta primero). El preview usa `KT.ResolvePortraitFacing(unit)` para coincidir con el juego. Desplegable "Portrait Facing" ahora con Auto.
- Borde Rare/Elite de Player: se voltea según hacia dónde mira el portrait (normal = derecha, hacia el CDM).
- Target descolocado: `PersistKUIUnitFramePosition` (KUICooldownManager.lua) guardaba GetCenter() sin convertir la escala del frame (132%), así que cualquier re-aplicado (ReloadFrames, toggles) lo movía. Ahora convierte a unidades del frame. Posiciones ya corrompidas: usar Reset Position de Target en Unlock Mode.

## 2026-10-02 — Retail/Forever: druida, círculo de nivel, portrait con ring, dorado
- Druida transformado en Retail/Forever: ya no se fuerza "flipped" (GetPortraitFacing); Classic mantiene su lógica.
- Círculo de nivel: máscara nativa `Interface\CharacterFrame\TempPortraitAlphaMask` (lienzo completo, sin padding) y sin expansión -> círculo completo.
- Retail con Rare/Elite en Player: portrait circular (`frame._ktCircularPortrait`, ThemeClientAssets.lua) en lugar de la máscara "gota", con compensación de padding.
- Anillo Rare/Elite en Forever/Retail crece hasta tocar la barra de vida (tope 1.45x del portrait) para cerrar el gap al ocultar el arte base.
- Color Retail de adornos (borde círculo PvP, pips): dorado (0.96,0.76,0.22).

## 2026-10-02 — Druida (portrait hacia afuera) y gap anillo/barras
- Revertido el caso especial Retail/Forever en `GetPortraitFacing`: el portrait de druida vuelve a "flipped" (con "normal" miraba hacia afuera). El anillo Rare/Elite de Player ahora sigue la dirección VISUAL (facing normal XOR transformado), así no depende del flip del portrait.
- Gap: se quita el crecimiento del anillo; ahora `frame._ktRingHugShift` (KUIUnitFrames mide el hueco entre anillo y barra de vida) desplaza vida/poder/nombre en `ApplyForeverUnitFrameArt` (ThemeClientAssets.lua) hacia el anillo, dejando 2px de solape. Se resetea al quitar el anillo. Cast bar de Player no se desplaza.

## 2026-10-02 — Classic: anillo Rare/Elite más grande
- En Classic el anillo (Player y Target) se multiplica x1.12 (KUIUnitFrames.lua, tamaño del `portraitRing`) para cubrir el marco del jugador.

## 2026-10-02 — Forever/Retail: anillo Rare/Elite x1.10
- El anillo se agranda un 10 % en Forever y Retail (KUIUnitFrames.lua) para evitar gaps; el ajuste de barras (`_ktRingHugShift`) se mide después de este tamaño.

## 2026-10-02 — Gap anillo/barras (2ª pasada)
- El hug mide contra el borde VISIBLE del anillo (44% del ancho, la textura tiene margen transparente) y deja 4px de solape; antes usaba el 50% y 2px, y se quedaba corto.

## 2026-10-02 — Player Rare/Elite en Forever/Retail: anillo x1.10 adicional (total x1.21 sobre el base)

## 2026-10-02 — Rare/Elite Player: live preview + selector con botones
- Live preview de Unit Frames (todos los styles): `ns.ApplyPreviewUnit` envuelve el aplicado base y dibuja el anillo RARE/ELITE sobre el portrait de Player (tamaño por style: kui 1.18, classic x1.12, forever/retail x1.21; mirada según `KT.ResolvePortraitFacing`); Forever/Retail ocultan el arte base como en el juego.
- Opciones: el desplegable se sustituye por dos botones con la textura (Rare / Elite), el seleccionado resaltado; pulsar el activo lo desactiva.

## 2026-10-02 — Preview del anillo Rare/Elite arreglado + botón Default
- Bug: el preview leía `db.player.playerClassificationBorder` pero la opción vive en la raíz del perfil (`db.playerClassificationBorder`); ahora usa `globalDB`.
- Selector con 3 botones: Default (arte normal del tema), Rare, Elite. Se elige directamente (ya no se desactiva pulsando de nuevo).

## 2026-10-02 — Preview del anillo: dirección
- `ns.ApplyPreviewUnit` aplica la misma regla que el juego: mira a la derecha = (facing normal) XOR (transformado), porque el preview muestra el portrait vivo (p.ej. forma de águila de druida) y le faltaba el XOR.

## 2026-10-02 — Accent cards, instalador combinado, Rare/Elite gris sin portrait
- `KT:CreateAccentPresetGrid` (ThemeSelector.lua): tarjetas de accent (punto con anillo, etiqueta, barra, tinte al seleccionar). Usado en Options > Preset Colors (3 columnas) y en el instalador (6 columnas).
- Instalador: el paso 3 "Color Theme" pasa a "Visual Style & Color" (tarjetas de Visual Style compactas arriba + accent cards + Class/Custom). Aplicar un estilo recarga la UI y reabre en el paso 3 (resume flags, limpiados al salir de la página). Eliminado el paso 20 (Visual Theme): ahora el paso 19 (módulos) es el último con Finish + Join Discord; TOTAL_INSTALLER_STEPS=19; el paso 20 guardado cae en el 19.
- Unit Frames: los botones Default/Rare/Elite se atenúan (alpha .35) y se deshabilitan cuando el portrait del Player está desactivado.
- Locales de las nuevas cadenas en VisualStyles.lua.

## 2026-10-02 — Nombres cirílicos y CJK (chat y unit frames)
- Diagnóstico: Unit Frames ya cambiaba por texto a Russo One (`EnableTextFontFallback` -> `ResolveTextFontPath`) pero solo para cirílico y solo si la base era Avant Garde. Chat: el ScrollingMessageFrame tiene UNA fuente para todas las líneas y se dejaba sin tocar -> cirílico/CJK salía como cuadrados.
- KullThranUI.lua: `DetectCJKScript` (hangul/kana/han por bytes UTF-8), `IsCJKCapableFont`, `GetCJKFontForScript` (KR para hangul/kana, SC/TC/KR para han según idioma activo) y `ResolveTextFontPath` ahora cambia a Noto cuando el texto es CJK y la fuente base no lo soporta. Cobertura verificada con fontTools: NotoSansKR cubre latín+cirílico+kana+han+hangul; SC/TC cubren todo menos hangul; Russo One solo latín+cirílico.
- `KT:GetMultiScriptFontObject` (CreateFontFamily con una fuente por alfabeto) usado en Chat.lua (`ApplyConfiguredFontToFrame`) con pcall; si el cliente no tiene la API no cambia nada.

## 2026-10-02 — KUI Style: anillo Rare/Elite y buffs
- Anillo Rare/Elite en KUI x1.15 (juego y live preview) para envolver el portrait redondo.
- Buffs de Player/Target en KUI: `GetKUIStyleBuffYOffset` 5 -> 11 (la fila de buffs seguía solapando el borde superior del frame).

## 2026-10-02 — Fix: DetectCJKScript comparaba un string 'secret' (text == "") antes de comprobar issecretvalue; reordenado.

## 2026-10-02 — KUI Style: ajuste del anillo Rare/Elite en Player
- El x1.15 dejaba el anillo sobredimensionado respecto al portrait redondo y chocaba con nivel/PvP. Multiplicador KUI ahora x0.95 (juego y live preview). Constante a afinar en `RefreshForeverMetadata` (rama kui) y `ApplyPreviewUnit`.

## 2026-10-02 — Nameplates: forma del combo (Circles / Pips)
- Nueva opción `classPowerShape` ("circle"|"pip") en Nameplates > Class Resource ("Combo Point Shape"). Antes los combo points eran siempre círculos.
- Por defecto: círculos; en KUI Style pips (si el valor no está definido se resuelve por tema en `GetClassPowerShape`; el adapter de temas lo siembra al cambiar de estilo y es path propio del tema).
- Archivos: Nameplates.lua, Nameplates_Options.lua, VisualThemes/Adapters/Nameplates.lua.

## 2026-10-02 — Anillo Rare/Elite: recentrado de la abertura
- Medido en ELITE.png/RARE.png (512x512): la abertura del anillo está en x≈0.44, y≈0.52 (no 0.5/0.5) y mide ≈0.57 del ancho. El anillo se anclaba por el centro del PNG, por eso salía desplazado a izquierda/abajo.
- Ahora se desplaza 0.06*ancho (signo según flip) y 0.02*alto arriba, en el frame real (RefreshForeverMetadata) y en el live preview.

## 2026-10-02 — Facing de portraits en KUI Style
- Causa: el perfil por defecto guarda `portraitFacing` (player "flipped", target "normal"), así que la rama KUI shapeshift-aware (`not settings.portraitFacing`) nunca se ejecutaba: player siempre "flipped" (bien en forma druida, hacia fuera en humano).
- Fix: KUI usa la misma regla que Classic/Forever/Retail en `GetPortraitFacing` (player: forma -> flipped, humano -> normal; target = espejo del player). El modo explícito `portraitFacingMode` sigue ganando.

## 2026-10-02 — Nameplates: forma de combo con tarjetas + default pips en KUI
- Bug: el bucle de defaults copiaba `classPowerShape="circle"` a la DB, así que nunca llegaba a resolverse "pip" para KUI. Quitado de `defaults`; migración `_classPowerShapeMigrated_v2` borra el "circle" autorrellenado. Sin valor: KUI=pip, resto=circle.
- UI: el dropdown se sustituye por dos tarjetas (Circles / Pips) con 5 puntos de muestra (3 llenos), como las tarjetas Rare/Elite.

## 2026-10-02 — KUI Style: icono PvP del Player -2px a la izquierda con Rare/Elite
- En `RefreshForeverMetadata`, tras decidir el anillo: si kui + player + anillo activo, el icono PvP se re-ancla con x-2 (el ancla se reinicia en cada refresh, no se acumula).

## 2026-10-02 — Combo points / shards: borde negro 1px, sombra, más anchos y separados
- Nameplates (pips rectangulares: shards, chi, holy power..., y combo en modo Pips): `SetPipDecor` dibuja borde negro 1px + sombra (alpha 0.5, offset abajo/derecha); ancho x1.4 y +2 de separación. En modo Pips el combo deja de usar el cuadrado 2.5x y usa la misma geometría plana. Círculos sin cambios.
- Unit Frames: pips rectangulares del combo de target (18x10 gap3 -> 24x10 gap5; borde negro en vez del color de clase) y class power custom Bars/Modern (ancho x1.4 en moderno, +2 gap), con `ns.KTTargetCombo:_DecorateRectPip`. Estilo Circles intacto.

## 2026-10-02 — Chat: texto centrado y cuadrados CJK
- Causa del centrado: `SetFontObject` (font family) sobre el ScrollingMessageFrame reinicia la justificación del objeto de fuente (centrada). Eliminado.
- Causa de los cuadrados: `CreateFontFamily` elige miembro por locale del cliente, no por glyph, así que no resolvía CJK. Sustituido por un hook de `AddMessage` por frame: si el mensaje trae hangul/kana/han/cirílico, el frame completo cambia a la Noto empaquetada (KR para hangul/kana, SC/TC por idioma para han; todas incluyen latín). Se queda así hasta cambiar la fuente en opciones o recargar.
- Limitación: una sola fuente por frame; si coinciden coreano y chino en pantalla, las líneas antiguas del otro script pueden verse como cuadrados. Intenté fusionar NotoSansSC+KR en un solo TTF pero fontTools no soporta CFF CID-keyed.
- Los strings secretos no se pueden inspeccionar (no se detecta script).

## 2026-10-02 — Chat/CJK: fuentes nativas de Blizzard primero
- Los cuadrados persistían: NotoSans*.ttf del addon son CFF (OpenType), no TrueType glyf, y el cliente puede rechazarlas (hipótesis). Ahora `KT:GetScriptFontCandidates` devuelve primero fuentes del cliente (2002.TTF hangul/kana, ARKai_T / bKAI00M han, FRIZQT___CYR cirílico) y luego las Noto; el hook de chat prueba cada una hasta que SetFont no devuelva false. `GetCJKFontForScript` también prioriza las nativas.

## 2026-10-02 — Rare/Elite de Classic (Blizzard) como opción + sustitución en estilo Classic
- Nuevas opciones del borde del Player: `classicrare` / `classicelite` (tarjetas "Classic Rare/Elite"), válidas en todos los estilos. Usan `Interface\TargetingFrame\UI-TargetingFrame-Rare|-Elite|-Rare-Elite` (misma hoja 256x128 que la base) recortada alrededor del portrait (`ns.ClassicRing`: cropW/H, portraitCX/CY, uLeft/uRight, scale — constantes sin verificar en juego).
- Estilo Classic: Rare/Elite (propios y los classic) y targets elite/rare ya NO dibujan el anillo custom; se cambia la textura de `_ktClassicPortraitArt` por la hoja de Classic correspondiente (mismos texcoords que la base). Sin clasificación vuelve a `UI-TargetingFrame`.
- Preview: mismo recorte.
- No se pudo ver la textura (descarga bloqueada): recorte y escala son estimaciones.

## 2026-10-02 — Nivel dentro del círculo de la hoja Classic Rare/Elite
- Con el borde Classic Rare/Elite del Player (cualquier estilo) el nivel se ancla al centro del portrait + (`levelDX`,`levelDY`) = (-18,-23) px de arte x escala (posición del adorno de nivel stock de Classic dentro del recorte) y se oculta nuestro badge, para que quede dentro del círculo propio de la hoja. Constantes en `ns.ClassicRing`, sin verificar en juego.

## 2026-10-02 — Anillo Classic Rare/Elite: capa por debajo de nivel y PvP
- El recorte Classic ya no se dibuja en la textura `portraitRing` de iOvr: usa un host propio (`_kuiClassicRingHost`/`_kuiClassicRingTex`) con frame level = iOvr-1, de modo que el overlay de nivel/PvP (`lvlOvr`, iOvr+1: nivel, círculo PvP, borde y icono) queda siempre por encima. El anillo normal se oculta mientras el Classic está activo.

## 2026-10-02 — Nivel con anillo Classic: "..." por caja demasiado estrecha
- La caja del nivel era 18*sc de ancho (~11px) y el número se truncaba a "...". Ahora 40x16 fijo, sin word-wrap, centrada en el ancla.

## 2026-10-02 — Classic: la hoja del Player ya no se queda fija
- `ApplyClassicUnitFrameArt` re-ejecutaba `art:SetTexture(UI-TargetingFrame)` en cada pase de estilo y pisaba la hoja Rare/Elite elegida. Ahora usa `frame._ktClassicSheetPath` (guardado desde `RefreshForeverMetadata`; nil = base). La rama Classic también cubre `frameArtKit == "classic"`.

## 2026-10-02 — Classic: las tarjetas Rare/Elite modernas vuelven a dibujar el anillo custom
- En estilo Classic solo "Classic Rare/Elite" cambian la hoja del frame; "Rare/Elite" (modernas) dibujan el anillo custom sobre el frame Classic (antes también cambiaban la hoja y el anillo moderno nunca salía). Preview igual. Targets elite/rare en Classic siguen usando la hoja.

## 2026-10-02 — Pips: compatibilidad futura Retail (Evoker Essence, Caballero de la Muerte Runas)
- Nameplates: `CLASS_POWER_MAP` añade EVOKER (Essence, 5) y DEATHKNIGHT (Runes, 6) solo si `Enum.PowerType.Essence/Runes` existen (nil en clientes Classic). Resolver de runas (`GetRuneCooldown`: rellena = lista), evento `RUNE_POWER_UPDATE`, color de clase DK. Pasan por el mismo render de pips (forma, borde, sombra, separación).
- Unit Frames ya contemplaba Essence/Runes en `CLASS_POWER_TYPES` (con RUNE_POWER_UPDATE); sin cambios.

## 2026-10-02 — Forever: minimapa y cabecera del damage meter en bronce
- Minimap (adapter): borde de Forever 0.82/0.65/0.23 -> bronce 0.80/0.56/0.24 (el mismo de `ns.GetThemeOrnamentColor`); `validate` migra perfiles que aún guardan el dorado antiguo mientras el tema renderizado es forever.
- Damage Meter: `METER_SKINS.forever.title` (texto "Damage Done"/"Current" y flechas) -> bronce. Solo Forever; Classic/Retail/KUI sin cambios.

## 2026-10-02 — Recorte Classic Rare/Elite: sin restos del overlay de barras
- El recorte (136px de arte) dejaba a la derecha del portrait las muescas de la caja de barras de Classic. `cropW` 136 -> 112 y `uRight` 0.46875 -> 0.5625 (= 1 - 112/232*0.90625). Solo afecta a estilos no Classic (en Classic se usa la hoja completa).

## 2026-10-02 — Recorte Classic Rare/Elite: sin gap con las barras (Forever/Retail)
- Tras recortar el overlay, quedaba hueco entre el borde del recorte y las barras (la base stock está oculta). Se reactiva el desplazamiento medido de barras/nombre (`_ktRingHugShift`) para el anillo Classic: borde visible = centro portrait + (cropW - portraitCX)*sc, solape 4px.

## 2026-10-02 — Localización de las novedades
- Revisadas las cadenas nuevas de Unit Frames, Nameplates e Installer contra todos los ficheros de `Locales`. Faltaban (en los 9 idiomas) y se añaden a `Locales/Modules/VisualStyles.lua`: Classic Rare, Classic Elite, Combo Point Shape, Circles, Pips, Smooth Health/Power Bars, Show Elite / Rare Indicator, Show PvP Icon Backdrop Circle, Show Character Level, Level Font Size / Text Color / Text Outline / X Offset / Y Offset, Frame Size.
- Ya estaban traducidas: Portrait Facing, Auto, Normal, Flipped, Default, Theme portrait, Rare, Elite, Player Rare / Elite Border, textos del installer combinado y tarjetas de acento.

## 2026-10-02 — Accent de Forever = #DC8560
- #DC8560 = (0.862745, 0.521569, 0.376471). Aplicado a: accent/color del tema Forever en `ThemeCatalog`, `Adapters/Skin.lua` (accentColor + customBorderColor, con migración en `validate` desde el dorado 0.82/0.65/0.23), borde del minimapa (adapter Minimap, migra dorado y bronce anterior), cromo del damage meter (`ThemeEngine` DAMAGE_METER_CHROME_COLORS) y `METER_SKINS.forever.title` (títulos "Damage Done"/"Current" y flechas), y `GetAccent()` del Objective Tracker (si el tema renderizado es Forever y no hay color custom).
- No tocados: adapters CastBar/Nameplates/PartyFrames/ResourceBars (siguen con su valor propio), ornamentos bronce de Unit Frames.

## 2026-10-02 — #DC8560: aplicación efectiva en Forever (migración + tracker)
- Los valores guardados (slots del tema y perfiles activos) seguían con el dorado/bronce y los seeds solo corren al cambiar de tema. `ThemeEngine:MigrateForeverAccent` (flag `foreverAccentDC8560`) escribe #DC8560 en los slots Forever de `minimap` (borderColor) y `skin` (accentColor, customBorderColor) y, si Forever está activo, en los perfiles vivos; reintenta si el módulo aún no existe.
- Objective Tracker: en Forever el acento es #DC8560 aunque haya color custom guardado (antes el custom ganaba).

## 2026-10-02 — Objective Tracker: títulos en #DC8560 en Forever
- `ApplyTitleAccent` usaba el color de clase para los títulos de misión; en Forever ahora usa #DC8560 (resto de estilos igual).

## 2026-10-02 — Classic: barra de casteo estilo Classic y texto sin cortes (player/target/focus)
- `SeatStockCastbar` ya recortaba el texto, pero el pase de ajustes de KUIUnitFrames reaplicaba `castSpellNameSize/castDurationSize` (13) justo después, anulándolo. Nuevo `ns.ApplyClassicCastbarLook(frame)` (llamado tras esos bloques): en Classic pone textura Blizzard `UI-StatusBar` (barra + capa de tinte), color amarillo Classic (1, .7, 0; también en `PostCastStart`) y limita Text/Time a 0.85 x alto de la barra; fuera de Classic restaura WHITE8X8.

## 2026-10-02 — Classic: borde del círculo PvP plateado
- El borde del círculo del icono PvP en Classic pasa de amarillo (1,.82,.2) a plata (0.78,0.80,0.85). Forever bronce / Retail oro sin cambios.

## 2026-10-02 — Classic cast bar: texto aún alto e icono casi invisible
- El tope de fuente se anulaba con cualquier `SetFont` posterior: ahora `hooksecurefunc(fs,"SetFont")` en Text/Time recorta siempre a 0.70 x alto de barra (mín. 8) mientras el modo Classic está activo.
- Icono del hechizo: en Classic pasa a max(alto+6, 18) px y se eleva al strata/nivel del overlay de indicadores (+3) para no quedar bajo el arte del frame; fuera de Classic se restaura strata/nivel.

## Classic: borde PvP gris oscuro, cast bar más corta y texto menor
- Borde del círculo PvP (Classic): plateado → gris oscuro (0.42, 0.43, 0.46).
- Cast bar Classic: inset de 6px por lado en `SeatStockCastbar` (player/target) para no tapar la textura del marco.
- Texto de cast bar: tope `max(7, h*0.55)` (antes `max(8, h*0.70)`).
- No probado en juego: requiere /reload.

## Classic cast bar: corrección
- Revertido el inset (la barra recupera su ancho completo por la derecha).
- Player en Classic: icono dentro de la barra a la izquierda (como target/focus), tamaño = alto de barra −1, ya no cuelga sobre el overlay.
- No probado en juego: /reload.

## Objective Tracker: textos en amarillo en Classic
- `Skin.lua`: títulos de misión/cabeceras y cabecera "Dungeon Bosses" en amarillo (1, 0.82, 0) cuando el tema renderizado es Classic. Bordes sin cambio. No probado en juego: /reload.

## Party frames: retratos activados en todos los temas
- Default `party.showPortrait = true` (PartyFrames.lua, 3 bloques) y el adapter `partyframes` lo siembra en todos los temas (kui/classic/forever/retail); `party.showPortrait` pasa a ser path propio del tema.
- Migración one-shot (`_portraitsAllThemesV1`) activa los retratos en perfiles existentes. Solo modo party (no raid). No probado en juego: /reload.

## Party frames: retratos — migración al cargar el módulo
- La migración vía adapter no se ejecutaba si el tema ya estaba activo. Añadida migración one-shot en `Mod:EnsureDB` (`partyPortraitsAllThemesMigrated`): `party.showPortrait=true` y estilo "circular" si estaba en none/nil. No probado en juego: /reload.

## Classic Rare/Elite del player: recorte en vez de hoja completa
- Con la hoja completa `UI-TargetingFrame-Rare|Elite` como arte del frame, las barras salían amarillas (visto en juego). En Classic el player ya no cambia la hoja: conserva el arte base y dibuja el recorte alrededor del retrato (`playerClassicRingKind`). Target sigue cambiando hoja por clasificación. No probado en juego: /reload; el ajuste del recorte en Classic (nivel/PvP) puede necesitar retoque.

## Recorte Classic Rare/Elite: no cortar la parte inferior
- El recorte cortaba garras/cola inferiores del dragón: `cropH` 100→128 y `vBottom` 0.78125→1 (toda la altura de la hoja). Izquierda/derecha sin cambio. No probado en juego: /reload.

## Recorte Classic Rare/Elite: ampliado por el lado de las barras
- El recorte terminaba en una línea vertical (x=144 de la hoja) y cortaba cabeza/cola del dragón junto a la caja de barras: `cropW` 112→136, `uRight` 0.5625→0.46875 (x=120). Nuevo `hugW=112` mantiene el cálculo de acercamiento de barras en Forever/Retail. Sin verificar en juego: /reload. Si el recorte más ancho tapara las barras, bajar `cropW`/subir `uRight`.
- Nota: el recorte NO cambia el color amarillo de la barra de poder (sigue igual), así que la causa previa que di no era correcta.

## Recorte Classic Rare/Elite: dos tiras
- Ensanchar todo el recorte dejó ver líneas doradas del marco de barras de la hoja (cortadas en vertical). Revertido a cropW=112/uRight=0.5625 para las filas superiores; una segunda textura (`_kuiClassicRingTex2`, `extW/extU/extV` en `ns.ClassicRing`) cubre solo la franja inferior (desde 71.9% de la altura) más ancha, para no cortar garras/cola. Idem en la vista previa de opciones (`classificationRing2`). `extV` y `extU` son estimados desde la captura: sin verificar en juego (/reload).

## Revertido: Classic Rare/Elite del player vuelve a la hoja completa
- A petición del usuario se deshacen los intentos de recorte: en Classic el player vuelve a cambiar la hoja completa (`UI-TargetingFrame-Rare|Elite`), y las constantes del recorte (usado en otros estilos) vuelven a cropW=112, cropH=100, vBottom=0.78125; eliminadas las texturas de franja extra. La barra de poder amarilla se deja como está.

## Damage meter Classic: borde negro; chat: fuente de respaldo temporal
- `METER_SKINS.classic.panelEdge` pasa a negro (0,0,0,1).
- Chat: al llegar un mensaje en chino/coreano/japonés/ruso se usa la fuente de respaldo de Blizzard solo mientras haya ese texto: cada mensaje rearma un temporizador de 45 s y al vencer se restaura la fuente del usuario (Avant Garde). No se fuerza si la fuente base ya cubre el script o si SetFont falla. No probado en juego: /reload. Limitación: el frame tiene una única fuente, así que durante esos 45 s todo el chat usa la de respaldo.

## PvP circle dorado con Rare en Classic
- Player + tema Classic + borde `rare` o `classicrare`: el borde del círculo PvP pasa a dorado (0.96, 0.76, 0.22); resto, gris oscuro. No probado en juego: /reload.

## Corrección: PvP circle dorado solo con Elite
- El círculo dorado aplica con borde `elite`/`classicelite` (no Rare). No probado en juego: /reload.

## Live preview: nivel en el círculo de la hoja Classic Rare/Elite
- En la vista previa, con Classic Rare/Elite el nivel se colocaba con el layout normal (descolocado). Ahora usa los mismos offsets que el frame real (`levelDX/DY` de `ns.ClassicRing`), oculta el círculo propio y el anillo se dibuja bajo el texto (ARTWORK,7). No probado en juego: /reload. Si el orden de refresco del preview recolocara el nivel después del anillo, habrá que llamar al anillo tras el layout del nivel.

## Live preview Classic: porcentaje de vida centrado en la barra
- `ApplyStockLayoutToPreview`: en Classic el texto de valor se ancla al CENTER de la barra de vida (antes junto al nombre). Solo preview; no probado en juego: /reload. No toca el frame real.

## Auditoría: toggles de overlay de dispel (Unit Frames / Party Frames)
- Revisado por lectura de código: Party (`showDispelOverlay` en render manual, `b.dispel:SetShown`, estilos AuraKit) y Unit Frames (`dispelOverlay` en KTDispelSlots, dispelBorderFrame, estilo de debuffs del target) respetan el toggle fuera de combate.
- Hallazgo: en combate ambos "se quedaban bloqueados" — UF: `ReloadFrames` salía sin hacer nada; PF: `SetConfigValue` solo guardaba y difería el layout. Corregido: `ns.ApplyDispelOverlayLive()` (UF) y refresco directo de contenedores/auras (PF) para las claves dispel*/showDispelOverlay. No probado en juego.
- No verificado: que un `AuraContainer` se pueda mostrar/ocultar en combate sin restricciones del cliente (envuelto en pcall).

## Castbar del player editable en todos los estilos
- Quitado `LockIfThemeOwned` del toggle "Show Castbar" (Unit Frames options). El tema sigue sembrándola activa al aplicarse y `player.showPlayerCastbar` sigue guardándose por slot de tema, así que la elección se conserva por estilo. No probado en juego: /reload.

## Perfiles: etiqueta de variante (Forever/Retail) + importación cruzada con aviso
- Ya existía: prefijo "KullThranUI Forever|Retail - " en el nombre, `KT.PROFILE_FLAVOR`, envoltorio `flavor` en las cadenas, y rechazo de cadenas de otra variante.
- Nuevo (`KullThranUI.lua`): `GetProfileFlavorFromName`, `GetProfileDisplayName` ("[Forever] Nombre") y `StampProfileMeta` (`profile._flavorMeta = {flavor, interface, importedFrom}`; no se exporta). Sellado al cargar (`Core.lua`, tras `SanitizeProfileForFlavor`) y tras importar.
- `Profiles.lua`: `ValidatePayloadFlavor` ya no rechaza la otra variante; devuelve un aviso (3er valor) que se imprime, se añade al popup y deja `importedFrom` en `_flavorMeta`. Los perfiles se ven como "[Forever] X" en el desplegable. `SanitizeProfileForFlavor` sigue apagando lo exclusivo de Retail al importar en Forever. La lista de perfiles sigue filtrada por la variante actual.
- No probado en juego: /reload. Los perfiles Retail guardados en SavedVariables solo aparecerían en la lista cuando se use la variante Retail (el filtro por prefijo no cambia).

## Cast bar del player en Forever/Retail: icono dentro de la barra
- El icono del player colgaba a la izquierda de la barra y tapaba el aro del retrato. La condición que ya movía el icono dentro de la barra (como target/focus) pasa de "solo Classic" a "cualquier estilo distinto de KUI" (Classic, Forever, Retail). KUI conserva el icono fuera. No probado en juego: /reload.

## Cast bar Forever/Retail: texto 2 px menor
- `SeatStockCastbar` pasa `shrinkPx=2` a `ScaleStockBarText` para `castbar.Text`/`castbar.Time` fuera de Classic (tamaño final −2, mínimo 6) y guarda un tope (`_ktStockCastCap`) con hook de `SetFont` para que refrescos posteriores no lo deshagan. Classic sin cambios. No probado en juego: /reload.

## Action Bars: Action Bar Art (cartas) + respeta Hide Bar Art; opciones editables en todos los estilos
- Nuevo selector visual "Action Bar Art" (General): tarjetas Default (arte del cliente) / Retail (wyvern/gryphon vía `ResolveRetailAtlasOverride`) / Classic (EndCap-Dwarf) con mini barra. Guarda `frameArtKit`.
- El arte ya no lo fuerza el tema: se quitó el forzado en `StyleAllBars` y en `validate` del adapter (solo repara valores inválidos); el tema solo siembra.
- `Mod.IsBarArtHidden`: lee el ajuste de Edit Mode `HideBarArt` de la barra principal; si está activo, ningún kit dibuja caps/borde (oculta chrome nativo y el host Classic) y se re-aplica con hook a `UpdateSystemSettingHideBarArt`. Sin verificar en juego que ese enum/método exista en Forever.
- CDM: `validate` deja de forzar borde (tamaño/color), `reskinBorders` y `frameArtKit`; solo repara shapes inválidas. Nameplates/damage meter no tenían bloqueo de UI.
- Pendiente de /reload y prueba en juego.

## Logo Forever del panel de opciones sin tinte en el estilo Forever
- `Options.lua`: `_foreverLogo` junto a la versión usa vertex color blanco (textura original) cuando el estilo renderizado es Forever; en los demás estilos sigue con el accent. Aplicado en la creación y en el refresco de accent. No probado en juego: /reload.

## Action Bar Art: previews más completos
- Tarjetas apiladas (470x92): placa oscura con rieles de color por kit, 12 botones con iconos reales de hechizos y borde, caps grandes solapando la placa, nombre y subtítulo. Mismas texturas/atlas que antes. No probado en juego: /reload.

## Action Bar Art: previews corregidos
- Tarjetas centradas en el panel (holder anclado a TOP). Retail ahora usa `KT.GetRetailAtlasPixels` (arte Retail real, independiente del tema activo; antes `ResolveRetailAtlasOverride` devolvía nil fuera del tema Retail y se veía el de Forever). Caps con su proporción real (sin estirar) y pegados a los extremos de la placa; placa y botones centrados sobre el mismo eje.
- Iconos: acciones reales del jugador (slots 1–72) y después hechizos de clase conocidos del libro de hechizos (`IsPlayerSpell` filtra lo que no existe en el cliente); relleno con iconos genéricos. API de spellbook sin verificar en juego (envuelta en pcall). Interpreté "filtro de habilidades de Forever" como ese filtro de hechizos conocidos; si te referías a otra cosa, dímelo.

## Action Bar Art: caps dentro del marco y etiqueta "Forever"
- Los caps se escalan para caber entre el borde de la tarjeta y la placa (`CAP_MAX_W`=68, alto máx 76) manteniendo proporción; el de Forever se salía del marco. La tarjeta "Default" ahora se llama "Forever" (la clave guardada sigue siendo `default`). No probado en juego: /reload.

## Versión 0.0.9
- `## Version:` 0.0.8 → 0.0.9 en los 26 TOC (KullThranUI, 24 módulos y MinimapStats). `KT.VERSION` se lee del TOC (con fallback "0.0.4" solo si no hay metadata). Entrada 0.0.9 añadida a `CHANGELOG.md`. El archivo de historial interno de `Options.lua` (`CHANGELOG_LATEST_ARCHIVED_VERSION`, 0.0.4) no se ha tocado.

## Pet frame: arte por estilo (Classic / Forever / Retail)
- Referencia: EllesmereUI (`EUI_UnitFrames` kit `pet`): Classic usa la hoja `Interface\TargetingFrame\UI-SmallTargetingFrame` (128x64) con retrato 37px, barras 69x8 y nombre encima; Forever/Retail usan el atlas mini `UI-HUD-UnitFrame-TargetofTarget-PortraitOn` (120x49) con las máscaras `Party-PortraitOn-Bar-Health/Mana-Mask`.
- `ThemeClientAssets.lua`: nuevas `VT:ApplyPetFrameArt(frame, portrait, kind, {scale})` / `VT:ClearPetFrameArt(frame)` (geometría en una tabla `PetArt`, sin tocar player/target). El arte se escala con `frameWidth/101` (el ancho del pet sigue siendo editable); colores, fuentes, textos y borde siguen siendo del usuario. Fuerza el retrato visible mientras haya arte (el default del pet es sin retrato) y lo vuelve a ocultar al limpiar.
- `KUIUnitFrames.lua`: rama `unit=="pet"` en `ApplyClassicFrameArt` (Classic → hoja Classic; Forever/Retail → atlas mini; otro tema → limpia y repone anclas de power/retrato/texto), llamada final al final de `StylePetFrame` y tras el layout genérico de `ReloadFrames` (rama pet).
- Sin verificar en juego: nombre exacto del atlas ToT y las máscaras Party en Forever; no existe override de píxeles Retail para ese atlas, así que en un cliente Forever el estilo Retail dibuja el arte del cliente (no el dorado). Si el atlas no resuelve, el pet cae al render normal. /reload.

## Live preview de Unit Frames: pet con arte por estilo
- `KUI_UnitFrames_Options.lua`: `PREVIEW_STOCK_GEOMETRY` gana `pet` en forever/retail (atlas mini ToT 120x49) y classic (`UI-SmallTargetingFrame` 128x64 en caja 128x53, con `artW/artH/artX/artY` en la rama de textura cruda). `ApplyStockLayoutToPreview` escala el pet con `frameWidth/101` (igual que el marco real), no dibuja nivel y centra el valor en la barra solo si el texto derecho no es "none". Mismos números que `PetArt.geom` de `ThemeClientAssets.lua`. No probado en juego: /reload (en KUI sigue el layout normal del preview).

## KUI Tracker en los estilos nuevos: auras y live preview
- Revisión: el tracker se ancla a la caja del `PlayerFrame`. En Classic la fila de buffs va sobre el borde superior del marco (`CLASSIC_BUFFS_ABOVE_FRAME_GAP`) y chocaba con los trackers `TOPRIGHT_OUT/TOPLEFT_OUT` (defensive/interrupt); en Forever/Retail la fila queda dentro de la franja del arte, por debajo del borde superior de la caja, y no choca.
- `ThemeClientAssets.lua`: los renders de player Classic/Forever calculan `frame._ktAuraRowLift` (alto de la fila de buffs por encima del borde superior; 0 si no sobresale) y lo limpian al retirar el arte.
- `KUICooldownManager.lua` (ancla `playerframe`): si el tracker es KUI, el lado es `TOPRIGHT_OUT`/`TOPLEFT_OUT` y los buffs del player se muestran, suma `_ktAuraRowLift` al offset Y. Interrupt sigue apilado sobre Defensive.
- `KUI_CooldownManager_Options.lua`: el preview del KUI Tracker dibuja, en Classic/Forever/Retail, la caja stock 232x100 (arte, retrato circular, barras, nombre, valor centrado) y la fila de buffs si `showBuffs` no es false, con la misma elevación de los trackers. KUI mantiene el preview de siempre. Datos en `ns.TRACKER_PREVIEW_STOCK` (copia de la geometría del player).
- No probado en juego: /reload. Sin verificar: que el tracker se re-ancle al cambiar de estilo sin /reload.

## KUI Tracker: Unlock Mode no movía los trackers
- Causa: `RegisterCDMUnlockElements` registra los KUI Tracker como barras normales (`CDM_kui_<tipo>`). Su `savePosition` guardaba la posición y ponía `anchorTo="none"`, pero no marcaba `customTracker[tipo].positionMode="free"`; el siguiente `BuildAllCDMBars` → `SyncKUITrackerBars` lo volvía a anclar al player frame y la posición arrastrada se perdía. (El bloque "Utility trackers" busca frames `KUI_CustomTracker_<tipo>` que no se crean en ningún sitio, así que nunca registraba nada.)
- Arreglo (`KUICooldownManager.lua`): para barras `kui_*`, `savePosition` marca `positionMode="free"` y `_kuiTrackerFreePosition`; `loadPosition` solo devuelve posición guardada en modo libre; nuevo `clearPosition` que vuelve a anclar al player frame.
- Sin diagnosticar: el solape visual de los movers de Defensive/Interrupt/Trinket con Resource Bars/Cast Bar en el screenshot (parecen centrados sobre la esquina del player frame en vez de pegados a ella). No probado en juego: /reload.

## KUI Tracker: catálogos exclusivos de Forever + racial del Haranir
- Referencia EllesmereUI: mantiene un catálogo Forever aparte y, con `IS_FOREVER`, quita los presets de Retail (lust, Time Spiral, pociones de temporada) y sustituye la healthstone por las piedras vanilla (5 familias: 9421/19012/19013, 5510/19010/19011, 5509/19008/19009, 5511/19006/19007, 5512/19004/19005); detecta Forever por interfaz 16000–19999 (`EllesmereUI_ClientGate.lua`).
- `KUICooldownManager.lua`: `ns.KUI_IS_FOREVER` ya no exige `==16001` (rango 16000–19999 o `KT.IS_FOREVER`). En Forever: `HEALTH_ITEMS` pasa a pociones de curación vanilla + las 15 healthstones (marcadores de grupo 300/60), `PREPOT_ITEM_IDS`/prioridad de poción de combate, prioridad de poción de vida y de healthstone (todas las piedras, de mayor a menor) son vanilla; el fallback de defensivos por `partyTracker` (IDs retail) queda desactivado. Eso alimenta tanto el auto-detect como el catálogo del picker (`GetExtraSpells`). Retail conserva sus listas.
- Racial del elfo nuevo: `RACE_RACIALS.Haranir` tenía `{1287685, 12594416}` (IDs no válidos); ahora `{1237885}` (Thorn Bloom, el mismo ID que usa EllesmereUI), con lo que `BuildAutoTrackerSpells("defensive")` la autodetecta por raza.
- {unverified}: los IDs de pociones vanilla (curación 118/858/929/1710/3928/13446 y combate 13442/5634/3387/13455) van de memoria, y si Haranir existe en Forever. Las pociones de maná siguen el fallback por tooltip. No probado en juego: /reload.

## KUI Tracker: picker por tracker (sin pociones en Racials) + racial 1259416
- Causa del screenshot: `BuildTrackerCandidates` (`KUI_CooldownManager_Options.lua`) añadía las pociones de salud (`CDMHealthItemsByID`) y las prepot (`CDMPrepotItemIDs`) al picker de TODOS los trackers; los ítems sin nombre cacheado se veían como `-1000929`.
- Arreglo: esas dos listas solo salen en el tracker Potions (incluye también las healthstones, cooldown 60), ordenadas y con nombre real (`GetItemNameByID`, pide la carga del ítem si no está cacheado; "Item N" como último recurso). El tracker Defensive lista la racial propia (`ns.IsSpellKnownSafe`, exportado) para poder volver a añadirla.
- `RACE_RACIALS.Haranir = { 1259416 }` (ID dado por el propietario; sustituye al 1237885 de EllesmereUI que puse antes). `BuildAutoTrackerSpells("defensive")` la elige por raza + conocida, así que entra por defecto en su aura. No probado en juego: /reload.

## Chat: Avant Garde fija, sin cambios bajo ningún concepto
- `Chat.lua`: `GetResolvedFont` devuelve siempre `KT.DEFAULT_FONT_PATH` (AAA_ITC_Avant_Garde.ttf); ya no lee `db.font` ni el LSM. `KT_DEFAULT_FONT` (chrome: pestañas, botones, título) usa también esa fuente en vez de la global. `db.font` se fuerza a "AAA_ITC_Avant_Garde" en cada carga.
- Se elimina el cambio temporal de fuente por scripts CJK/cirílico (hook de `AddMessage`) y se desactiva el fallback por región (`EnableChatFrameTextFontFallback`). Cada frame de chat lleva un candado: hooks de `SetFont`/`SetFontObject` que devuelven la fuente a Avant Garde manteniendo el tamaño/flags pedidos (Blizzard u otros addons no pueden cambiarla).
- `Chat_Options.lua`: se quita el desplegable "Font" (tamaño y contorno siguen editables) y el preview usa siempre Avant Garde.
- Efecto conocido: el texto chino/coreano/ruso se verá con cuadrados si Avant Garde no tiene esos glifos (decisión explícita). No probado en juego: /reload.

## 2026-10-02 — Combo points estilo Classic en el marco de jugador
- `KUIUnitFrames.lua`: en tema Classic (Rogue/Druida) el adorno de combo points se muestra siempre bajo las barras del player (aunque `classPowerStyle` sea "none"/"blizzard"; el valor guardado no se modifica). Sondea los atlas `ComboPoints-*` con `C_Texture.GetAtlasInfo`; si faltan, usa placa oscura con borde + orbes `Interface\COMMON\Indicator-Red` (activo) / `Indicator-Gray` oscuro (vacío). Druida sin API de spec (Forever) → combo points de Cat. Otros temas sin cambios.
- No probado en juego, /reload.
- Fix combo Classic: `MakeBorder` no existe en KUIUnitFrames.lua (llamada a nil abortaba la creación) → borde dorado 1px propio; re-chequeo a los 1.5s por si el tema no estaba resuelto al cargar. No probado en juego, /reload.
