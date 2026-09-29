# Estudio: selector de cuatro estilos para el installer de KullThranUI

**Estado:** estudio y plan de implementación. No hay código del selector implementado todavía.  
**Fecha del estudio:** 2026-09-29.  
**Workspace donde se guarda el estudio:** `KullThranUI-Forever-Workspace`.  
**Destino previsto de la primera implementación:** `C:\Users\Pablo\Documents\KullThranUI-Workspace` (Retail).

## 1. Objetivo

Crear más adelante un paso visual del installer, similar al selector de EllesmereUI, con cuatro tarjetas:

1. **WOW CLASSIC**
2. **WOW FOREVER**
3. **WOW RETAIL**
4. **KULLTHRANUI STYLE**

El cuarto estilo representa el diseño propio que KullThranUI usa actualmente:

- En Retail: marcos de unidad de color, planos y sin retrato por defecto.
- En Forever: la variante propia actual con retratos, especialmente jugador y objetivo.

El objetivo no es cambiar solo una paleta de colores. Cada estilo debe poder cambiar arte, geometría, retratos, forma de iconos, bordes y texturas en varios módulos, manteniendo las funciones de KullThranUI.

## 2. Conclusión del estudio

La mejor ruta es construir un **motor de estilos visuales independiente del installer** y hacer que el nuevo paso sea solamente uno de sus consumidores.

No conviene implementar las cuatro tarjetas como botones que escriben directamente una lista grande de opciones en `Installers.lua`. Eso produciría tres problemas:

- El installer pasaría a conocer los detalles internos de todos los módulos.
- Un cambio futuro de una clave en UnitFrames, ActionBars o CDM rompería silenciosamente un estilo.
- Al alternar estilos se perderían ajustes personalizados o se mezclarían valores de dos estilos.

La arquitectura recomendada tiene cuatro piezas:

1. **Catálogo de estilos:** nombres, textos, color de tarjeta, disponibilidad y constructor de la miniatura.
2. **Registro de módulos:** un adaptador por cada superficie visual que sabe leer, guardar, aplicar y validar su parte del estilo.
3. **Motor de cambio:** guarda las opciones propiedad de cada estilo, restaura la ranura del estilo de destino y coordina la recarga.
4. **Paso del installer:** presenta las tarjetas, muestra cuál está en uso y solicita la aplicación global.

La elección debe escribirse solamente al confirmar la recarga. Si el usuario cancela, la base de datos debe quedar intacta.

## 3. Fuentes examinadas

### EllesmereUI 9.3.1

Ruta estudiada: `C:\Users\Pablo\Desktop\EllesmereUI-9.3.1`.

Archivos principales:

- `EllesmereUI/EllesmereUI_StyleCards.lua`
- `EllesmereUI/EllesmereUI_StyleChoicePopup.lua`
- `EllesmereUI/EllesmereUI_StyleLaunchPopup.lua`
- `EllesmereUIOptions/EUI_Style_Options.lua`
- `EllesmereUI/EllesmereUI_FirstInstall.lua`
- `EllesmereUI/EllesmereUI_ForeverLayout.lua`
- `EllesmereUI/EllesmereUI_ClassicArt.lua`
- `EllesmereUI/EllesmereUI_RetailAtlas.lua`
- `EllesmereUI/EllesmereUI_ClientGate.lua`
- `EllesmereUI/EllesmereUI_Lite.lua`
- Implementaciones de estilo en UnitFrames, ActionBars, Nameplates, ResourceBars y CooldownManager.

### KullThranUI Forever

Archivos principales:

- `KullThranUI_Installer/Modules/Installers/Installers.lua`
- `KullThranUI_Installer/Modules/Installers/Installer_Options.lua`
- `KullThranUI/Options.lua`
- `KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUIUnitFrames.lua`
- `KullThranUI_PartyFrames/Modules/PartyFrames/PartyFrames.lua`
- `KullThranUI_ActionBars/Modules/ActionBars/ActionBars.lua`
- `KullThranUI_ResourceBars/Modules/KUIResourceBars/KUIResourceBars.lua`
- `KullThranUI_CastBar/Modules/CastBar/CastBar.lua`
- `KullThranUI_CooldownManager/Modules/KUICooldownManager/KUICooldownManager.lua`
- `KullThranUI_Nameplates/Modules/Nameplates/Nameplates.lua`

### KullThranUI Retail

Se contrastó la estructura actual de `C:\Users\Pablo\Documents\KullThranUI-Workspace`.

- El installer de Retail tiene actualmente **20 pasos**.
- El installer de Forever tiene actualmente **19 pasos**.
- Retail incluye un paso para Mythic+ Timer que Forever no tiene.
- Los dos installers conservan el mismo patrón general, pero sus números no son intercambiables.
- Los módulos principales existen en ambos workspaces, pero sus defaults y las APIs del cliente no siempre coinciden.

## 4. Cómo resuelve EllesmereUI este problema

### 4.1 Las tarjetas son una vista reutilizable

`EllesmereUI_StyleCards.lua` construye las tarjetas y sus miniaturas. La misma función se usa en:

- La elección del primer arranque.
- La cabecera de la página permanente de estilos.
- El anuncio de la función.

La tarjeta no aplica valores por sí sola. Solo emite una clave como `eui`, `blizzard`, `classic` o `forever`.

Cada tarjeta tiene:

- Identificador estable.
- Título y subtítulo.
- Color propio.
- Miniatura construida con frames y texturas.
- Estado `IN USE`.
- Estado deshabilitado cuando no hay nada que cambiar.
- Acción `Apply to All` o una acción equivalente según el contexto.

Esta separación es correcta y debe conservarse en KullThranUI.

### 4.2 Existe un registro central de módulos

`EUI_Style_Options.lua` registra cada superficie visual con:

- Clave estable del módulo.
- Carpeta del addon.
- Nombre mostrado.
- Función que localiza su perfil.
- Funciones de lectura y escritura del estilo.
- Función que informa del estilo que realmente se renderiza en la sesión.
- Semilla opcional para la primera activación de un estilo.

El registro cubre, entre otros:

- Action Bars.
- Unit Frames.
- Player Aura Bars.
- Nameplates.
- Cooldown Manager Icons.
- Tracked Buff Bars.
- Player Cast Bar.
- Resource Bars.
- Minimap.
- Damage Meters.
- Quest Tracker.
- Chat.
- Raid Frames.
- Character Sheet.

La ventaja es que `ApplyAll` no contiene lógica específica de cada módulo. Recorre el registro y delega.

### 4.3 El estilo se fija por sesión

Los módulos de Ellesmere leen el estilo al cargar y lo mantienen durante toda la sesión. Un cambio requiere recarga porque puede modificar:

- Geometría.
- Máscaras.
- NineSlice y atlas.
- Tamaño de marcos.
- Posiciones relativas.
- Creación o ausencia de retratos y piezas de arte.

La página de opciones puede mostrar el estilo solicitado en la base de datos y, por separado, el que se está renderizando en ese momento.

### 4.4 La escritura se realiza al confirmar

El popup de recarga es transaccional:

1. Calcula qué módulos cambiarían.
2. Muestra una sola confirmación.
3. Si se cancela, no escribe flags ni ajustes.
4. Si se confirma, cambia todos los módulos y recarga.

Esto evita una sesión con varios módulos en estados incompatibles.

### 4.5 Cada estilo conserva sus propios ajustes

Ellesmere no se limita a sobrescribir valores. Cada módulo puede tener `_styleSlots` con las claves que pertenecen al aspecto visual.

Al pasar de A a B:

1. Guarda en la ranura A los valores visuales actuales.
2. Busca una ranura guardada de B.
3. Si existe, la restaura.
4. Si B nunca se usó, aplica una semilla inicial.
5. Mantiene fuera del intercambio las opciones que no pertenecen al estilo.

Así, si el usuario ajusta el tamaño del borde Classic, cambia a Retail y vuelve a Classic, recupera su ajuste Classic.

### 4.6 Forever es una variante con capacidades propias

En EllesmereUI 9.3.1, `forever` solo se ofrece en el cliente Forever. Internamente parte de la lógica reutiliza la base Blizzard y añade flags y ranuras exclusivas de Forever.

También hay correcciones de layout dependientes del estilo. Por ejemplo, `ForeverLayoutForLook` mueve la barra de actitudes únicamente si sigue en una posición que el addon había colocado. Si el usuario la movió, no la pisa.

Este detalle es importante: un estilo puede necesitar posiciones distintas, pero nunca debe recolocar a ciegas un elemento que el usuario ya personalizó.

## 5. Diferencia entre versión del cliente y estilo visual

Hay que mantener dos conceptos separados:

- **Cliente:** Retail o Forever. Determina APIs, atlas disponibles, restricciones de seguridad y módulos existentes.
- **Estilo visual:** Classic, Forever, Retail o KullThranUI Style. Determina la apariencia elegida.

No debe usarse una variable como `isForever` para decidir automáticamente el estilo. Un usuario de Retail debe poder elegir el aspecto Forever y un usuario de Forever debe poder elegir un aspecto Retail, siempre que exista un adaptador compatible.

La resolución recomendada es:

```lua
local clientFlavor = KT:GetClientFlavor() -- "retail" o "forever"
local visualTheme = profile.visualTheme.active -- "classic", "forever", "retail" o "kui"
local adapter = Registry[moduleKey]
adapter:Apply(visualTheme, clientFlavor)
```

El adaptador decide si usa:

- Un atlas nativo del cliente.
- Una textura original de KullThranUI.
- Una composición creada con piezas de Blizzard disponibles.
- Una aproximación compatible cuando el cliente no tiene el recurso exacto.

## 6. Definición funcional de los cuatro estilos

Los nombres visibles pueden revisarse antes de implementar. Las claves internas deben ser cortas, estables y no traducidas.

| Clave | Nombre visible provisional | Definición |
|---|---|---|
| `classic` | WOW CLASSIC | Arte vanilla: marcos clásicos, anillos, slots cuadrados y texturas clásicas donde existan. |
| `forever` | WOW FOREVER | Bronce, glifos, badges redondos, retratos y arte coherente con Forever. |
| `retail` | WOW RETAIL | Arte moderno de Blizzard Retail, atlas y geometría moderna cuando el cliente los permita. |
| `kui` | KULLTHRANUI STYLE | Diseño propio plano de KullThranUI. En Retail, UnitFrames sin retrato por defecto; en Forever, variante propia con retratos. |

### 6.1 WOW CLASSIC

Objetivo visual:

- UnitFrames con marco y retrato de inspiración vanilla.
- ActionBars con slot cuadrado clásico.
- CastBar y ResourceBars con marco clásico cuando sea viable.
- CDM con iconos cuadrados y bordes clásicos.
- Nameplates planos con textura clásica.

No debe significar ejecutar código del cliente Classic ni depender de `WOW_PROJECT_CLASSIC`. Es una apariencia emulada dentro del cliente activo.

### 6.2 WOW FOREVER

Objetivo visual:

- Marcos bronce.
- Retratos redondos o integrados según el módulo.
- Badges de nivel y PvP compatibles.
- Iconos y remates coherentes con el arte Forever.
- En Retail, usar solamente recursos propios de KullThranUI o recursos Blizzard cuya redistribución/uso sea válido y estable.

Este estilo necesita una revisión de assets antes de implementarse en Retail. Los atlas exclusivos de Forever no pueden darse por existentes en Retail.

### 6.3 WOW RETAIL

Objetivo visual:

- Arte de Blizzard Retail para marcos, botones y cast bars.
- Formas y atlas modernos.
- Mantener las funciones, filtros, textos, auras y lógica de KullThranUI.

No se recomienda desactivar los módulos KUI y devolver todo a los frames nativos. Eso cambiaría comportamiento, opciones, anclajes y compatibilidad. La ruta coherente es que los módulos KUI sigan siendo los propietarios y rendericen un kit visual Retail.

### 6.4 KULLTHRANUI STYLE

Debe ser el estilo propio actual, sin depender de EllesmereUI instalado.

- Retail: conservar los marcos planos de color y `showPortrait = false` para jugador y objetivo como defaults del workspace Retail.
- Forever: conservar `showPortrait = true` para jugador y objetivo y `portraitStyle = "circular"`, de acuerdo con el diseño actual de Forever.
- Mantener las texturas Melli y la paleta elegida en el paso de color.

El nombre visible queda fijado como **KullThranUI Style** y la clave interna como `kui`.

## 7. Relación con los temas de color actuales

El tema visual y la paleta son ejes separados: `profile.visualTheme.active` guarda `kui`, `classic`, `forever` o `retail`; `profile.skin.stylePreset` conserva la paleta.

Los presets y los colores manuales solo tienen efecto y permanecen interactivos con `kui`. En los otros tres temas se conservan, pero quedan atenuados y bloqueados. Cambiar una paleta no debe seleccionar `kui` automáticamente, y regresar a `kui` debe recuperar la paleta anterior.

La implementación exacta del bloqueo y del layout se define en las secciones 29.2 y 29.3.

## 8. Lugar recomendado dentro del installer

### Ruta principal recomendada

Añadir el selector como **último paso**, después de `ShowModuleSelectionStep`, y trasladar el botón Finish al nuevo paso.

Motivos:

1. Los perfiles de resolución ya se habrán importado y no podrán sobrescribir el estilo después.
2. La selección de módulos ya estará decidida.
3. El motor podrá aplicar el estilo a todos los módulos activos y guardar la preferencia global para los desactivados.
4. La recarga de estilo será la última operación del installer.
5. Al volver tras la recarga, el paso puede mostrar la tarjeta `IN USE` y permitir finalizar.

Estado actual que debe respetarse al portar:

- Retail: 20 pasos. El nuevo paso sería inicialmente el 21.
- Forever: 19 pasos. El nuevo paso sería inicialmente el 20.

No se debe copiar el número de un workspace al otro.

### Mejora recomendada antes de seguir aumentando pasos

El installer usa números repetidos en `TOTAL_INSTALLER_STEPS`, `OpenCurrentStep`, cada función de página y los botones Next/Back. Conviene introducir constantes:

```lua
local STEP = {
    WELCOME = 1,
    LANGUAGE = 2,
    COLOR_THEME = 3,
    -- ...
    MODULE_SELECTION = 20, -- Retail en el estado estudiado
    VISUAL_STYLE = 21,
}
```

Una segunda fase podría usar una tabla ordenada por cliente. Para la primera implementación basta con constantes, pero no deben quedar números nuevos dispersos.

### Alternativa no recomendada para la primera versión

Mostrar la elección inmediatamente después del idioma sería más visible, pero obligaría a mantener un estado `pendingVisualTheme` hasta el final. Los imports de perfil posteriores podrían sobrescribir parte de lo elegido. Solo merece la pena si se implementa una transacción completa del installer.

## 9. Archivos nuevos propuestos en Retail

Nombres orientativos:

```text
KullThranUI/
  Modules/
    VisualThemes/
      VisualThemeCatalog.lua
      VisualThemeEngine.lua
      VisualThemeRegistry.lua
      VisualThemeSlots.lua
      Adapters/
        UnitFrames.lua
        PartyFrames.lua
        ActionBars.lua
        ResourceBars.lua
        CastBar.lua
        CooldownManager.lua
        Nameplates.lua

KullThranUI_Installer/
  Modules/
    Installers/
      VisualThemeCards.lua
```

También se puede ubicar el motor en una carpeta `Core/VisualThemes`. Lo importante es que pertenezca al addon base y no al installer, para poder reutilizarlo desde opciones.

El TOC debe cargar el catálogo, slots y registro antes de cualquier página que los use. Los adaptadores no deben forzar la carga de módulos desactivados; pueden registrarse desde cada addon al inicializarse o utilizar adaptadores de datos simples en el núcleo.

## 10. Modelo de datos propuesto

```lua
profile.visualTheme = {
    active = "kui",
    requested = "kui",
    schemaVersion = 1,
    modules = {
        -- Ausente significa heredar `active`.
        -- unitframes = "forever",
    },
    slots = {
        -- Solo claves propiedad del estilo, separadas por módulo y estilo.
        -- unitframes = { kui = {...}, retail = {...} },
    },
}
```

Significado:

- `active`: estilo que se espera que esté renderizándose tras la última recarga completada.
- `requested`: elección confirmada para la próxima carga. Puede ser útil durante migraciones y diagnóstico.
- `schemaVersion`: versión del formato, independiente de la versión del addon.
- `modules`: override opcional por módulo para una futura página avanzada.
- `slots`: ajustes visuales guardados por estilo.

Para la primera versión no hace falta exponer overrides por módulo, pero el formato debe permitirlos para no tener que migrar toda la base de datos después.

## 11. Contrato del registro de módulos

Cada adaptador debería proporcionar un contrato parecido a este:

```lua
KT.VisualThemes:RegisterModule("unitframes", {
    isAvailable = function(clientFlavor) end,
    getProfile = function() end,
    getRenderedStyle = function() end,
    getOwnedPaths = function(styleKey, clientFlavor) end,
    seed = function(profile, styleKey, clientFlavor) end,
    validate = function(profile, styleKey, clientFlavor) end,
    refreshPreview = function(styleKey, parent) end,
})
```

Responsabilidades:

- `isAvailable`: informa de si el módulo existe en ese cliente.
- `getProfile`: devuelve su tabla de configuración sin asumir que el frame está creado.
- `getRenderedStyle`: devuelve el estilo fijado al inicio de sesión.
- `getOwnedPaths`: lista exacta de claves que el estilo puede intercambiar.
- `seed`: define los valores de primera visita.
- `validate`: normaliza valores incompatibles antes de recargar.
- `refreshPreview`: opcional; permite reutilizar una representación del módulo.

## 12. Claves propiedad del estilo

Cada adaptador debe declarar explícitamente qué claves puede tocar. Una regla simple:

> Si una opción determina arte, forma o geometría necesaria para ese arte, puede ser propiedad del estilo. Si determina comportamiento o contenido, debe conservarse.

### Deben conservarse entre estilos

- Posiciones movidas por el usuario, salvo una migración condicional comprobada.
- Escala global y perfil de resolución.
- Hechizos seguidos.
- Filtros de auras.
- Keybinds.
- Visibilidad por combate o instancia.
- Orden de barras.
- Configuración de click casting.
- Textos elegidos por el usuario, salvo que un kit no tenga físicamente ese slot.
- Módulos activados o desactivados.

### Pueden cambiar por estilo

- Retratos y su forma.
- Atlas, texturas y NineSlice.
- Forma y máscara de botones.
- Grosor y tipo de borde.
- Textura de barras.
- Tamaños mínimos necesarios para el arte.
- Insets del retrato y de las barras.
- Posición relativa de badges que pertenecen al marco.
- Iconos de clasificación, PvP y rol cuando formen parte del kit.

### Regla para posiciones

Si un estilo necesita mover un elemento, el adaptador solo debe hacerlo cuando la posición actual coincide con una posición anterior conocida del addon. Si no coincide, se considera posición del usuario y se conserva.

## 13. Matriz inicial de módulos

### Fase 1: necesaria para que las cuatro tarjetas sean reales

| Módulo | Estado actual útil | Trabajo requerido |
|---|---|---|
| UnitFrames | Ya soporta retratos por unidad, estilos circular/attached/detached/none, texturas, bordes, color de clase y class power. Forever ya tiene defaults de retrato propios. | Crear kits de render `classic`, `forever`, `retail`, `kui`; separar el kit de las opciones generales; hacer las migraciones de retrato conscientes del estilo. |
| ActionBars | Ya tiene `buttonStyle`, `buttonShape`, máscaras, bordes y formas por barra. | Añadir kits de slot/borde para Classic, Forever y Retail; decidir qué opciones quedan bloqueadas bajo cada kit. |
| CooldownManager | Ya tiene forma de icono, borde, fondo, animación y configuración separada para barras. | Separar estilo de iconos y estilo de buff bars; registrar dos superficies aunque la tarjeta global aplique ambas. |
| CastBar | Ya tiene textura, color mode, icono y geometría propia. | Añadir kit de marco Classic/Forever/Retail y conservar color/textos elegidos. |
| ResourceBars | Ya tiene textura por barra, borde, color mode y pips. | Añadir marco por estilo sin reemplazar configuración funcional ni colores de recurso. |
| Nameplates | Ya tiene texturas, cast bar, glow, slots de texto y metadatos dinámicos. | Añadir kits visuales sin alterar lógica de nivel/clasificación; comprobar recursos exclusivos del cliente. |

### Fase 2: coherencia global

| Módulo | Trabajo probable |
|---|---|
| PartyFrames | Kits de borde, textura, iconos de rol y highlights; preservar presets DPS/Heal y posiciones. |
| Buffs & Debuffs | Bordes de icono y forma de slot según estilo. |
| Minimap | Anillo/cabecera Classic, Forever y Retail, manteniendo botones y tracking. |
| Damage Meter | Ventana, fondo y textura de barras. |
| Chat | Marco y pestañas. |
| Objective Tracker | Marco visual; no cambiar objetivos ni filtros. |
| Skins / ventanas Blizzard | Tema de ventanas coordinado, con adaptadores separados por cliente. |
| Armory | Arte de panel y slots; especial cuidado con el layout distinto de Forever y Retail. |

La primera versión no debe mostrar “Apply to All” como completado si solo UnitFrames cambia. Para publicar el selector hacen falta al menos los seis módulos de la fase 1 y pruebas visuales de todos ellos.

## 14. Particularidades de UnitFrames

Este módulo es el principal riesgo porque el retrato modifica el ancho útil, los anchors y los metadatos.

Defaults confirmados en el estado estudiado:

- Forever: jugador y objetivo tienen `showPortrait = true`; el estilo global de retrato es circular.
- Retail: jugador y objetivo tienen `showPortrait = false` en los defaults actuales.
- Ambos workspaces comparten muchas rutas y opciones, pero no deben recibir la misma tabla sin adaptación.

La semilla propuesta para `kui`:

```lua
if clientFlavor == "forever" then
    profile.portraitStyle = "circular"
    profile.player.showPortrait = true
    profile.target.showPortrait = true
else
    profile.player.showPortrait = false
    profile.target.showPortrait = false
end
```

No debe ponerse siempre `portraitStyle = "none"` en Retail, porque esa clave también afecta a otras unidades. El adaptador debe declarar por separado las claves de jugador, objetivo, focus, boss y pet.

Hay que auditar las migraciones actuales de Forever como `ApplyForeverPortraitDefaults`. Una migración unilateral no debe volver a activar retratos después de que el usuario elija `retail` o `classic`.

## 15. Algoritmo de aplicación recomendado

```text
ApplyAll(targetStyle):
    validar que targetStyle existe
    detectar clientFlavor
    construir lista de adaptadores disponibles
    calcular cambios sin escribir
    si no hay cambios, marcar tarjeta IN USE y terminar
    mostrar popup Reload Required

onConfirm:
    para cada adaptador:
        localizar perfil
        determinar estilo de origen
        guardar en slot de origen solo ownedPaths
        restaurar slot de destino si existe
        si no existe, ejecutar seed de destino
        validar resultado para este cliente
        guardar override/herencia del módulo
    guardar visualTheme.requested y visualTheme.active
    guardar schemaVersion
    solicitar recarga mediante la ruta segura del cliente
```

La operación debe protegerse con `pcall` por adaptador y registrar fallos. Si un adaptador falla antes de la recarga, el motor debe restaurar el snapshot en memoria de los adaptadores ya modificados y no marcar el estilo como activo.

## 16. Integración exacta con el installer

Cambios futuros en Retail:

1. Incrementar `TOTAL_INSTALLER_STEPS` de 20 a 21.
2. Añadir `ShowVisualThemeStep` al enrutador `OpenCurrentStep`.
3. Cambiar el botón final de `ShowModuleSelectionStep` por `Next`.
4. Hacer que ese botón abra `ShowVisualThemeStep`.
5. Mover Finish, Join Discord y el cierre definitivo al nuevo paso.
6. Hacer que Back vuelva a `ShowModuleSelectionStep`.
7. En una recarga confirmada, guardar `reopenStep`/`resumeStep` en el paso visual.
8. Tras recargar, mostrar `IN USE` y permitir Finish sin otra recarga.
9. Añadir textos localizables para títulos, captions, botones, confirmación y fallos.

Cambios equivalentes en Forever:

- Partir de 19 pasos y añadir el paso 20.
- No introducir Mythic+ Timer ni rutas Retail en el orden de Forever.
- Usar el mecanismo de recarga que sea válido en Forever; no llamar a `ReloadUI()` desde lógica compartida sin pasar por la abstracción existente.

## 17. Diseño de las tarjetas

La captura aportada es una buena referencia de composición:

- Cuatro tarjetas en una fila.
- Banda superior con el color de estilo.
- Nombre grande.
- Etiqueta corta.
- Miniatura oscura.
- Descripción de dos o tres líneas.
- Botón `Apply to All`.
- Badge `IN USE` sobre la tarjeta activa.

Para el tamaño actual del installer hay que comprobar si cuatro tarjetas de unos 200 px caben. Si el frame no llega a unos 900 px útiles, opciones válidas:

1. Aumentar el ancho del installer solo para esta página.
2. Usar tarjetas de aproximadamente 170–180 px.
3. Usar una cuadrícula 2 × 2 en resoluciones estrechas.

La recomendación es una disposición adaptable:

- Cuatro columnas cuando el ancho útil sea suficiente.
- Dos columnas y dos filas si no lo es.

Las miniaturas deben construirse con primitivas propias o assets permitidos. No deben ser capturas estáticas que queden obsoletas al cambiar una textura.

## 18. Estado `IN USE`

Una tarjeta solo debe mostrar `IN USE` si:

- Todos los módulos disponibles heredan ese estilo, o
- El usuario está en modo global y no hay overrides divergentes.

Si más adelante se permiten estilos por módulo, la cabecera debe mostrar `MIXED` cuando haya diferencias.

Con módulos desactivados:

- El estilo global se guarda igualmente.
- El módulo lo adopta la próxima vez que se active.
- La tarjeta puede considerarse `IN USE` si todos los módulos activos coinciden y los desactivados heredan la clave global.

Esto mejora el comportamiento de Ellesmere, donde los módulos sin perfil cargado pueden quedar fuera de `ApplyAll`.

## 19. Compatibilidad y capacidades por cliente

El catálogo debe poder declarar capacidades:

```lua
styles.forever.capabilities = {
    nativeOn = { forever = true },
    emulatedOn = { retail = true },
}
```

No se debe comprobar solo si un atlas tiene un nombre conocido. Antes de usarlo:

- Consultar `C_Texture.GetAtlasInfo` cuando exista.
- Mantener una alternativa propia.
- Evitar file IDs que no existan en Forever.
- Mantener rutas específicas del cliente fuera de los defaults compartidos.

Retail y Forever también difieren en restricciones de seguridad. La aplicación del estilo debe ocurrir fuera de combate y la recarga debe pasar por una única abstracción.

## 20. Licencia y reutilización de EllesmereUI

`EllesmereUI/license.txt` declara copyright 2026 y reserva todos los derechos que no estén concedidos explícitamente.

Consecuencia para KullThranUI:

- Se puede estudiar el comportamiento y diseñar una arquitectura equivalente de forma independiente.
- No se debe copiar código, texturas, mockups ni recursos de EllesmereUI sin permiso explícito del autor.
- Las miniaturas y kits visuales de KullThranUI deben escribirse desde cero.
- Para estilos Blizzard se pueden usar recursos proporcionados por el cliente mediante sus rutas/atlas, con fallback propio cuando falten.

El archivo `SKINNING_API.md` es una API para que addons externos adopten el tema de EllesmereUI cuando EllesmereUI está instalado. No resuelve este objetivo, porque el nuevo selector debe funcionar de forma autónoma dentro de KullThranUI.

## 21. Migración de perfiles existentes

Primera carga después de introducir el sistema:

1. Si `profile.visualTheme` no existe, detectar el workspace/cliente.
2. En Retail, asignar `kui` sin modificar los valores existentes.
3. En Forever, asignar `kui` sin modificar los valores existentes.
4. Crear la ranura inicial `kui` a partir de las claves visuales actuales.
5. Marcar `schemaVersion = 1`.

No debe ejecutarse una semilla `kui` sobre perfiles existentes. El perfil actual es la fuente de la ranura inicial y puede contener personalizaciones.

Para perfiles nuevos, sí se usan las semillas oficiales de cada cliente.

Al importar un perfil antiguo:

- Si no trae `visualTheme`, se captura como `kui`.
- Si trae una versión de esquema antigua, se migra antes de construir frames.
- Nunca se borran ranuras desconocidas durante una actualización; se conservan hasta completar la migración.

## 22. Página permanente en General

La ubicación permanente queda fijada en `General > Advanced Style System`. El selector ocupa la columna derecha junto a `Preset Colors` y `Manual Colors` pasa debajo a ancho completo.

`General` y el futuro paso del installer deben reutilizar el mismo catálogo, las mismas tarjetas, los mismos previews y la misma operación de aplicación. La especificación completa está en la sección 29.

## 23. Pruebas necesarias

### Pruebas de datos

- Cambiar `kui -> classic -> kui` y comprobar que los valores KUI regresan.
- Personalizar Classic, cambiar a Retail y volver a Classic.
- Cancelar el popup y comprobar que no cambia ninguna SavedVariable.
- Simular un error en un adaptador y comprobar rollback.
- Activar después un módulo que estaba desactivado y comprobar que hereda el estilo global.
- Importar un perfil antiguo sin `visualTheme`.
- Cambiar de perfil AceDB y comprobar aislamiento de ranuras.

### Pruebas visuales por estilo

- UnitFrames: jugador, objetivo, focus, pet, ToT y boss.
- Retratos a izquierda/derecha y ausencia de retrato.
- Nivel dinámico y clasificación sin solaparse.
- Cast bars con y sin icono.
- ActionBars con proc glow, swipe y cargas.
- CDM con varias barras, filas y shapes.
- Nameplates hostiles, amistosas, elite, rare y casting.
- ResourceBars con diferentes clases y recursos secundarios.
- PartyFrames en party, raid, arena y test mode.

### Matriz de ejecución

- Retail, instalación limpia.
- Retail, perfil existente personalizado.
- Forever, instalación limpia.
- Forever, perfil existente personalizado.
- Cambio fuera de combate.
- Intento durante combate: debe aplazarse o bloquearse con mensaje claro, sin escritura parcial.
- Resoluciones 1080p, 1440p y 4K.
- Escala de UI automática y manual.

### Validación real

`luac -p` solo valida sintaxis. Esta función requiere capturas o comprobación dentro de cada cliente porque depende de layering, atlas, masks, frame levels y anchors.

## 24. Fases de implementación propuestas

### Fase 0: inventario visual

- Capturar el aspecto actual de los módulos principales en Retail y Forever.
- Identificar assets Blizzard disponibles en ambos clientes.
- Diseñar assets originales que falten.
- Aprobar nombres finales y captions de las cuatro tarjetas.

### Fase 1: núcleo sin UI

- Crear catálogo, registro, slots y migración.
- Implementar transacción y rollback.
- Añadir API de registro de adaptadores.
- Añadir logging de diagnóstico.

### Fase 2: UnitFrames como piloto

- Implementar los cuatro kits.
- Comprobar retratos Retail/Forever.
- Validar que posiciones y opciones funcionales sobreviven a los cambios.
- No publicar todavía el selector global.

### Fase 3: resto de módulos principales

- ActionBars.
- CooldownManager icons y bars.
- CastBar.
- ResourceBars.
- Nameplates.
- PartyFrames si se incluye en la primera entrega pública.

### Fase 4: tarjetas y página permanente

- Construir miniaturas originales.
- Añadir estados `IN USE`, hover y disabled.
- Crear página de opciones reutilizable.

### Fase 5: paso del installer

- Integrar la página final.
- Conectar Next/Back/Finish.
- Confirmar recarga y reapertura.
- Añadir localización.

### Fase 6: port a Forever

- Reusar el motor y el contrato.
- Sustituir solamente adaptadores y assets dependientes del cliente.
- Mantener orden y número de pasos propios de Forever.
- Ejecutar la matriz completa de pruebas.

## 25. Riesgos principales

1. **Sobrescribir posiciones:** evitarlo con claves propiedad del estilo y migraciones condicionales.
2. **Mezclar paleta con geometría:** mantener `skin.stylePreset` y `visualTheme.active` separados.
3. **Atlas ausentes:** capability checks y fallbacks.
4. **Retratos que alteran anchors:** kits de UnitFrames con layout propio y pruebas por unidad.
5. **Migraciones antiguas que fuerzan defaults:** hacerlas conscientes del estilo activo.
6. **Recarga cancelada con datos ya escritos:** escribir solo en `onConfirm`.
7. **Módulos desactivados:** guardar herencia global y aplicar al habilitarlos.
8. **Números de paso divergentes:** constantes y orden específico por workspace.
9. **Copiar material protegido:** reimplementación independiente y assets originales/Blizzard.
10. **Declarar éxito por código sin revisar el render:** validación dentro de Retail y Forever.

## 26. Decisiones pendientes antes de programar

- Nombre visible final del cuarto estilo: `KullThranUI Style`.
- Si PartyFrames forma parte de la primera entrega o de la segunda.
- Si el selector global cambia también la fuente y el skin de ventanas.
- Qué assets originales se crearán para emular Forever en Retail.
- Si WOW RETAIL en Forever será una reproducción completa o una aproximación documentada.
- Si la página avanzada permitirá overrides por módulo desde la primera versión.
- Tamaño final del installer para cuatro tarjetas.

## 27. Checklist para el siguiente agente

Antes de editar código:

- [ ] Leer este documento completo.
- [ ] Comprobar el estado actual de ambos workspaces; los números de paso pueden haber cambiado.
- [ ] Confirmar los cuatro nombres visibles con el usuario.
- [ ] Hacer inventario de assets y verificar licencia.
- [ ] Crear primero el motor en el addon base, no en `Installers.lua`.
- [ ] Definir `ownedPaths` de UnitFrames antes de escribir semillas.
- [ ] Capturar el perfil actual como ranura `kui` durante la migración.
- [ ] Implementar y probar UnitFrames como piloto.
- [ ] Añadir el resto de adaptadores principales.
- [ ] Crear tarjetas originales y reutilizables.
- [ ] Insertar el nuevo paso al final del installer Retail.
- [ ] Escribir solo al confirmar la recarga.
- [ ] Probar ida y vuelta entre todos los estilos.
- [ ] Validar visualmente en juego, no solo con sintaxis Lua.

## 28. Qué no se ha hecho en este estudio

- No se ha añadido ningún paso al installer.
- No se ha creado ningún preset ejecutable.
- No se han copiado archivos ni assets de EllesmereUI.
- No se han cambiado defaults de UnitFrames, ActionBars, CDM ni otros módulos.
- No se ha modificado el workspace Retail.

Este documento es el punto de partida para la implementación posterior.

## 29. Refinamiento vinculante: General, previews y guía para IA

Esta sección sustituye cualquier alternativa anterior sobre la ubicación permanente, el nombre del cuarto tema y el funcionamiento de los colores. La implementación aún no debe comenzar; estas son instrucciones para el agente que la realice después.

### 29.1 Decisiones cerradas

- El selector permanente va en `General > Advanced Style System`.
- Se coloca en la columna derecha, al lado de las paletas actuales.
- `Preset Styles` pasa a llamarse visualmente `Preset Colors` para evitar confundir paleta con tema.
- `Manual Colors` se mueve debajo, en un bloque a ancho completo.
- `Preset Colors` y `Manual Colors` solo funcionan con `KullThranUI Style`.
- El cuarto tema se llama `KullThranUI Style` y usa la clave interna `kui`.
- El installer tendrá más adelante un paso que reutiliza el mismo selector; no tendrá una implementación paralela.
- Ningún archivo distribuido debe contener tags, comentarios, nombres internos o textos que mencionen el proyecto usado como referencia.

### 29.2 Layout exacto de General

```text
ADVANCED STYLE SYSTEM
┌─────────────────────────────┬─────────────────────────────┐
│ PRESET COLORS               │ VISUAL THEME                │
│ paletas actuales            │ [kui]       [forever]       │
│                             │ [retail]    [classic]        │
└─────────────────────────────┴─────────────────────────────┘
┌───────────────────────────────────────────────────────────┐
│ MANUAL COLORS                                             │
│ colores base                 overrides por módulo         │
└───────────────────────────────────────────────────────────┘
```

En `KullThranUI/Options.lua`:

1. Conservar `BeginOptionBlocks` para la fila superior.
2. Construir `Preset Colors` con `AddOptionBlock(..., "left", ...)`.
3. Construir `Visual Theme` con `AddOptionBlock(..., "right", ...)`.
4. Cerrar la fila con `EndOptionBlocks`.
5. Crear `Manual Colors` debajo mediante `CreateOptionBlock` con ancho `sc:GetWidth() - 22`.
6. Finalizarlo con `FinalizeOptionBlock`.
7. No modificar el helper de dos columnas para forzar un bloque completo.
8. Dentro de Manual Colors usar dos columnas internas:
   - Izquierda: Accent, Window Background, Main Text, Secondary Text y Background Tint.
   - Derecha: Unlock Mode, Friend List, Armory, Objective Tracker, Bags y Menu Icons.

Pseudocódigo orientativo:

```lua
local styleCols = BeginOptionBlocks(sc, y, 10, 12)

AddOptionBlock(styleCols, "left", "Preset Colors", BuildPresetColors)
AddOptionBlock(styleCols, "right", "Visual Theme", function(content)
    KT.VisualThemes:CreateSelector(content, {
        columns = 2,
        compact = true,
    })
end)

y = EndOptionBlocks(styleCols) + 8

local frame, content = CreateOptionBlock(
    sc, "Manual Colors", 10, -y, sc:GetWidth() - 22
)
local height = BuildManualColors(content, { columns = 2 })
y = y + FinalizeOptionBlock(frame, content, height) + 8
```

### 29.3 Bloqueo de las opciones de color

El estado debe depender del tema que realmente está renderizado en la sesión:

```lua
local enabled = KT.VisualThemes:GetRenderedTheme() == "kui"
```

Aplicar un helper único, por ejemplo `RefreshColorThemeAvailability`, a `Preset Colors` y `Manual Colors`:

- Con `enabled == true`: alpha 1 e interacción normal.
- Con `enabled == false`: contenido a alpha aproximada de 0.38.
- Añadir un blocker transparente por encima del contenido bloqueado para capturar clics.
- Tooltip del blocker: `Color presets and manual palette controls are available with KullThranUI Style.`
- No cambiar automáticamente a `kui` al pulsar una paleta.
- No borrar, normalizar ni sobrescribir la paleta guardada.
- Al regresar a `kui`, habilitar controles y recuperar la paleta anterior.
- Refrescar al construir la página y después de recargar.
- `Visual Theme` siempre queda habilitado.

El blocker de bloque completo es preferible a repartir lógica de deshabilitado por todos los color pickers y dropdowns existentes.

### 29.4 Mapa de archivos de KullThranUI para el agente

La primera implementación se hace en `C:\Users\Pablo\Documents\KullThranUI-Workspace`. Después se porta a `C:\Users\Pablo\Documents\KullThranUI-Forever-Workspace`.

Antes de editar, abrir todos los TOC implicados. No fiarse de nombres parecidos. En el estado investigado, UnitFrames carga `KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUI_UnitFrames_Options.lua`; también existe `KUI_Unit_Frames_Options.lua`, pero no es el cargado por el TOC actual.

| Área | Archivos que se deben leer |
|---|---|
| General y paletas | `KullThranUI/Options.lua`: buscar `Advanced Style System`, `STYLE_PRESETS`, `ApplySmartStylePreset`, `ApplyManualStyle` y helpers de bloques. |
| UnitFrames | `KullThranUI_UnitFrames/Modules/KUIUnitFrames/KUIUnitFrames.lua` y el archivo de opciones declarado por su TOC. |
| PartyFrames | `KullThranUI_PartyFrames/Modules/PartyFrames/PartyFrames.lua` y `PartyFrames_Options.lua`. |
| ActionBars | `KullThranUI_ActionBars/Modules/ActionBars/ActionBars.lua` y `ActionBars_Options.lua`. |
| ResourceBars | `KullThranUI_ResourceBars/Modules/KUIResourceBars/KUIResourceBars.lua` y `KUI_ResourceBars_Options.lua`. |
| CastBar | `KullThranUI_CastBar/Modules/CastBar/CastBar.lua` y su archivo de opciones indicado en TOC. |
| Cooldown Manager | `KullThranUI_CooldownManager/Modules/KUICooldownManager/KUICooldownManager.lua` y `KUI_CooldownManager_Options.lua`. |
| Nameplates | `KullThranUI_Nameplates/Modules/Nameplates/Nameplates.lua` y `Nameplates_Options.lua`. |
| Installer | `KullThranUI_Installer/Modules/Installers/Installers.lua` y `Installer_Options.lua`. |

En cada módulo:

1. Localizar defaults.
2. Seguir el setter de opción hasta la función final de render.
3. Separar arte, geometría, retrato y textura de posiciones, filtros y comportamiento.
4. Declarar solo las claves propiedad del tema.
5. Registrar diferencias Retail/Forever antes de escribir defaults compartidos.
6. Revisar migraciones antiguas. `ApplyForeverPortraitDefaults`, o su equivalente vigente, no puede forzar retratos si el tema activo indica otra geometría.

### 29.5 Dónde encontrar los diseños y assets

Tema KullThranUI:

- `KullThranUI/Modules/SimplicityTextures/Backdrop.tga`
- `KullThranUI/Modules/SimplicityTextures/Normal.tga`
- `KullThranUI/Modules/SimplicityTextures/Overlay.tga`
- `KullThranUI/Modules/SimplicityTextures/Border.tga`
- `KullThranUI/Modules/SimplicityTextures/circle_border.tga`
- `KullThranUI/Libraries/KUITextures/CustomTextures/MelliReforged.tga`
- `KullThranUI/Libraries/texture/media/portraits/`: máscaras y bordes circle, csquare, diamond, hexagon, shield, portrait y square.
- `KullThranUI/Libraries/texture/media/icons/UnitFramesIcons/`.
- `KullThranUI/Libraries/KUITextures/`: fondos y botones usados por el installer.

`KullThranUI_ActionBars/Modules/ActionBars/ActionBars.lua` ya contiene `SHAPE_MASKS`, `SHAPE_BORDERS`, `SMP` y `SHAPE_MEDIA`. Se estudian para construir el kit `kui` sin convertir sus constantes locales en dependencias globales.

Tema Classic, mediante recursos Blizzard con fallback:

```text
Interface\TargetingFrame\UI-TargetingFrame
Interface\Buttons\UI-Quickslot
Interface\Buttons\UI-Quickslot2
Interface\TargetingFrame\UI-StatusBar
Interface\MainMenuBar\UI-MainMenuBar-EndCap-Dwarf
Interface\CastingBar\UI-CastingBar-Border
```

Tema Retail:

- Usar atlas del cliente.
- Comprobar `C_Texture.GetAtlasInfo` antes de `SetAtlas`.
- Declarar fallback para cada pieza.
- Mantener la lógica funcional de KUI aunque cambie el chrome.

Tema Forever:

- En Forever, inventariar primero recursos disponibles en ese cliente.
- En Retail, no asumir que los atlas exclusivos existen.
- Para emularlo en Retail se necesitan assets originales de KullThranUI o piezas Blizzard válidas.
- UnitFrames debe considerar los retratos circulares y badges propios de Forever.

### 29.6 Referencia privada que puede consultar el agente

Ruta: `C:\Users\Pablo\Desktop\EllesmereUI-9.3.1`.

Archivos útiles para entender responsabilidades, sin copiar código ni nombres:

- `EllesmereUI/EllesmereUI_StyleCards.lua`: composición de tarjetas y miniaturas.
- `EllesmereUI/EllesmereUI_ClassicArt.lua`: piezas clásicas compartidas.
- `EllesmereUI/EllesmereUI_RetailAtlas.lua`: compatibilidad de atlas.
- `EllesmereUIUnitFrames/EllesmereUIUnitFrames.lua`: kits de UnitFrames.
- `EllesmereUIActionBars/EllesmereUIActionBars.lua`: estilos de slots.
- `EllesmereUICooldownManager/EllesmereUICooldownManager.lua` y `EllesmereUI/EllesmereUICdmBuffBars.lua`.
- `EllesmereUIResourceBars/EllesmereUIResourceBars.lua`.
- `EllesmereUINameplates/EllesmereUINameplates.lua`.

Esta ruta aparece únicamente en el estudio para que otro agente pueda reproducir la investigación. No debe trasladarse a Lua, XML, TOC, changelog, release notes, UI o metadatos de assets.

### 29.7 Construcción de los live previews

Crear una API compartida:

```lua
KT.VisualThemes:CreatePreview(parent, themeKey, options)
KT.VisualThemes:UpdatePreview(preview, themeKey, options)
KT.VisualThemes:ReleasePreview(preview)
KT.VisualThemes:CreateThemeCard(parent, themeKey, options)
```

`General` presenta cuatro tarjetas 2 × 2. El installer puede usar cuatro columnas con ancho suficiente y 2 × 2 en ancho reducido.

Todos los previews muestran la misma escena ficticia:

1. Mini UnitFrame con nombre, vida, recurso, nivel y retrato cuando corresponda.
2. Fila de cuatro o cinco slots.
3. Banda corta de recurso o cast.

Reglas:

- Crear texturas y font strings propios dentro del `stage`.
- No reparentar UnitFrames, ActionBars, CDM o frames seguros.
- No escribir SavedVariables ni llamar setters o `ApplyAll`.
- No registrar eventos ni `OnUpdate`.
- Usar `SetClipsChildren(true)` cuando exista.
- Fijar frame levels de fondo, barras, retrato, marco, textos e iconos.
- Limpiar capas al reciclar.
- El hover solo cambia realce y tooltip.
- Validar atlas y fallback.
- El preview `kui` usa la paleta guardada sin modificarla.

Kits:

- `kui`: Melli, color plano, borde propio y retrato según cliente.
- `classic`: rutas clásicas Blizzard y slots cuadrados.
- `retail`: atlas modernos disponibles y fallback.
- `forever`: bronce, retrato y badge con assets propios/permitidos.

Previews KUI existentes que sirven para estudiar patrones, no para reparentar frames:

- `CreateBagsInstallerLivePreview`
- `CreateDamageMeterInstallerLivePreview`
- `CreateCooldownManagerInstallerLivePreview`
- `CreateUnitFramesInstallerLivePreview`
- `CreatePartyFramesInstallerLivePreview`
- `CreateNameplatesInstallerPreview`
- `CreateResourceBarsInstallerLivePreview`

PartyFrames exporta `KullThranUI_PartyFramesOptions.CreateLivePreview`. UnitFrames también exporta una API de preview desde el archivo cargado. ResourceBars y Nameplates contienen renderers que pueden aportar helpers puros.

### 29.8 Estructura propuesta

```text
KullThranUI/
  Modules/
    VisualThemes/
      ThemeCatalog.lua
      ThemeEngine.lua
      ThemeRegistry.lua
      ThemeSlots.lua
      ThemePreview.lua
      Adapters/
        UnitFrames.lua
        PartyFrames.lua
        ActionBars.lua
        ResourceBars.lua
        CastBar.lua
        CooldownManager.lua
        Nameplates.lua
```

API propia: `KT.VisualThemes`. Datos: `profile.visualTheme`. Claves: `kui`, `classic`, `forever` y `retail`. `profile.skin.stylePreset` sigue siendo únicamente la paleta.

Orden para el agente:

1. Inventario real de TOC, claves y assets.
2. Núcleo y migración sin UI.
3. UnitFrames como piloto.
4. Renderer de preview independiente.
5. Selector permanente en General y bloqueo de colores.
6. ActionBars.
7. ResourceBars y CastBar.
8. Cooldown Manager.
9. Nameplates.
10. PartyFrames.
11. Futuro paso del installer.
12. Port a Forever cuando Retail esté validado.

### 29.9 Prohibición de nombres, tags y comentarios externos

El código final debe usar nombres propios: `KT.VisualThemes`, `visualTheme`, `themeKey`, `ThemeCatalog`, `ThemeEngine`, `ThemePreview`, `kui`, `classic`, `forever` y `retail`.

Queda prohibido en archivos nuevos o modificados:

- Tags o comentarios que mencionen el proyecto de referencia.
- Comentarios `inspired by`, `port`, `compat` o similares asociados a esa marca.
- Variables, funciones, tablas, constantes, prefijos o sufijos como `eui` o `EUIStyle`.
- Textos visibles, logs, SavedVariables, changelog o release notes con esa marca.
- Metadatos de procedencia en assets.
- Nombres de funciones privadas copiados de la referencia.

Antes de cerrar la implementación:

```powershell
rg -n -i "ellesmere|eui" <archivos-nuevos-o-modificados-del-sistema-de-temas>
```

El resultado esperado es cero. La búsqueda se limita a los archivos de esta función porque este documento de estudio y el historial pueden contener referencias necesarias.

### 29.10 Criterios de aceptación

- `General` conserva la fila de dos columnas sin solapes.
- `Manual Colors` aparece debajo a ancho completo.
- Las cuatro tarjetas tienen previews construidos en tiempo real.
- Solo `kui` habilita paletas y colores manuales.
- Cambiar de tema no borra la paleta KUI.
- Abrir previews no modifica SavedVariables.
- Cambiar `kui -> classic -> retail -> forever -> kui` recupera el aspecto KUI previo.
- Se prueban UI scales 100 %, 125 % y 150 %.
- Se validan perfiles nuevos, antiguos e importados.
- Se ejecutan parser Lua y `git diff --check`.
- Se revisa visualmente Retail antes de portar.
- Se repite la matriz completa en Forever.
- La búsqueda de nombres prohibidos da cero en los archivos de implementación.

## 30. Problemas surgidos durante la implementación en Forever y soluciones

1. **Orden de carga en el TOC (KullThranUI.toc)**:
   - **Problema**: El documento sugería cargar VisualThemes antes de que las opciones lo usaran. Sin embargo, al insertarlo antes de Options.lua, fue necesario asegurar que el namespace KT ya estuviera completamente inicializado por KullThranUI.lua.
   - **Solución**: Insertar el bloque de VisualThemes exactamente después de Widgets.lua y antes de Options.lua. Esto garantiza que los helpers de UI estén disponibles si el motor de temas los necesita, y que Options.lua pueda acceder a KT.VisualThemes para registrar las páginas.

2. **Refactorización de Options.lua (Manual Colors)**:
   - **Problema**: La sección Manual Colors estaba programada como una función anónima pasada a AddOptionBlock para la columna derecha, encapsulando variables locales como skin y ApplyManualStyle. Al moverla a un bloque de ancho completo debajo de la cuadrícula, el alcance de estas variables se rompe si no se extraen adecuadamente.
   - **Solución**: Se deben elevar las declaraciones de skin y ApplyManualStyle al ámbito superior de la función creadora de la página de opciones, para que tanto Preset Colors como el nuevo bloque de ancho completo de Manual Colors puedan acceder a ellas sin errores de variable nil.

3. **Invocación de ReloadUI()**:
   - **Problema**: El prototipo de ThemeEngine.lua llamaba directamente a ReloadUI(). En Retail, esto puede causar un error de interfaz bloqueada (taint) si se ejecuta desde código inseguro sin un evento de hardware (click).
   - **Solución**: Reemplazar la llamada directa a ReloadUI() por el wrapper nativo de la UI, KT:Reload() o usar el popup de confirmación estándar de KullThranUI (StaticPopup_Show("KT_RELOAD_UI")), asegurando que la acción provenga siempre de la confirmación del usuario.

4. **Semilla de UnitFrames y Defaults de AceDB**:
   - **Problema**: Al implementar el adaptador de UnitFrames, los perfiles recién creados a veces aplicaban los defaults de AceDB definidos en Defaults.lua *después* de que la semilla del tema intentara configurar portraitStyle.
   - **Solución**: Asegurar que ThemeEngine:ApplyAll() o la semilla inicial del adaptador se ejecute en el evento PROFILE_CREATED o PLAYER_ENTERING_WORLD tras la carga del perfil de AceDB, o bien inyectar la semilla directamente en la tabla de defaults antes de inicializar la DB.

5. **Bloqueo Visual de Colores**:
   - **Problema**: Al intentar añadir un "blocker" transparente sobre Manual Colors cuando enabled == false, los dropdowns de AceGUI/KUI a veces filtraban clics a través del frame bloqueador debido al frame level.
   - **Solución**: Asegurar que el frame bloqueador tenga EnableMouse(true) y un FrameLevel sustancialmente más alto que el contenedor principal (locker:SetFrameLevel(container:GetFrameLevel() + 10)), además de gestionar el estado alpha de los textos y texturas manualmente para dar el feedback visual correcto.
6. **Sincronización de getOwnedPaths en los Adaptadores**:
   - **Problema**: Módulos como Nameplates y Cooldown Manager tienen configuraciones visuales muy profundas (p. ej. profile.nameplates.units.TARGET.healthbar.texture). Declarar todas estas rutas manualmente en getOwnedPaths es propenso a errores u omisiones si se añaden nuevas opciones visuales en el futuro.
   - **Solución**: Es recomendable implementar un helper en el núcleo del motor de temas que permita definir patrones o rutas parciales (ej. *.texture, *.borderTheme) para extraer iterativamente las opciones correspondientes de la tabla de defaults, evitando el mantenimiento duplicado.

7. **Lazy Loading y Modificación Temprana**:
   - **Problema**: Algunos módulos de KullThranUI utilizan *lazy loading* para instanciar sus frames y registrar sus opciones. Cuando el instalador o el menú inyectan la semilla de un nuevo tema, podrían inicializar tablas en KullThranDB antes de que el módulo principal las asigne o valide.
   - **Solución**: Los adaptadores solo deben devolver la estructura plana esperada de opciones. La validación o forzado de actualización visual de los frames (como ActionBars o CastBar) no debe realizarse inmediatamente; en su lugar, se confía en que el ReloadUI() forzará la inicialización natural de todos los módulos con los valores actualizados en la base de datos.
8. **Transición del Instalador (Paso de Módulos a Tema Visual)**:
   - **Problema**: Originalmente, el paso de selección de módulos evaluaba si había cambios sucios (
eedsReload) y lanzaba el ReloadUI() al hacer clic en Finish. Al cambiar Finish por Next, esta validación se pierde o se retrasa hasta el nuevo paso, donde el motor de temas puede lanzar su propia recarga.
   - **Solución**: El estado moduleSettingsDirty debe conservarse a nivel del instalador. El botón "Apply" de las tarjetas visuales debe marcar la recarga como inminente. Alternativamente, la recarga del instalador y la recarga del motor de temas deben unificarse en una única llamada transaccional al pulsar Finish en el último paso.

9. **Comportamiento Abrupto de la Recarga desde la Tarjeta**:
   - **Problema**: El ThemeSelector.lua implementado muestra un popup (StaticPopup_Show) que llama a ReloadUI() de inmediato al confirmar. En el contexto del instalador, esto corta abruptamente la experiencia antes de que el usuario pulse Finish.
   - **Solución**: Para la integración final del instalador, CreateSelector debe aceptar un callback u opción onApply que anule la recarga inmediata, permitiendo que el instalador guarde la petición (profile.visualTheme.requested = key) y ejecute la recarga solo al finalizar el wizard, tal y como especifica el estudio original ("La recarga de estilo será la última operación del installer").

10. **Problema de renderizado de tarjetas (Width = 0)**:
   - **Problema**: El menú Options.lua generaba el contenedor de tarjetas sin un tamaño predefinido explícito. El motor de WoW devolvía GetWidth() == 0, lo que causaba que las tarjetas de los estilos intentaran calcular anchos negativos y no se mostraran en la interfaz.
   - **Solución**: Enviar explícitamente el ancho calculado de la columna styleCols.blockW - 20 desde Options.lua hasta KT.VisualThemes:CreateSelector() en options.width, y añadir fallbacks seguros en ThemeSelector.lua.

11. **Alcance del namespace KT (LibStub vs Tabla Privada)**:
   - **Problema**: Las tarjetas no se generaban porque KT.VisualThemes se evaluaba como nulo en Options.lua. Esto ocurría porque los archivos de VisualThemes se definían con local addonName, KT = ..., lo que inyectaba VisualThemes en la tabla privada 
s, pero Options.lua buscaba en la instancia global del addon creada por LibStub("AceAddon-3.0").
   - **Solución**: Refactorizar la cabecera de los 15 archivos nuevos de VisualThemes para usar local KT = LibStub("AceAddon-3.0"):GetAddon("KullThranUI"), asegurando que KT.VisualThemes se adhiera al scope global correcto del framework de Ace3.

12. **Paths anidados (e.g., "player.showPortrait") interpretados literalmente**:
   - **Problema**: Los adaptadores que reportaban en su getOwnedPaths claves como "player.showPortrait" fallaban al guardar y restaurar datos, porque ApplyAll hacía p[path], generando una clave string literal en lugar de adentrarse en la sub-tabla player.
   - **Solución**: Implementar los helpers GetPath y SetPath en ThemeEngine.lua para resolver rutas separadas por puntos de forma recursiva, permitiendo manipular jerarquías profundas en las bases de datos de los módulos.

13. **Cuelgues por DB nula al ejecutar ReloadUI**:
   - **Problema**: Algunos adaptadores como ActionBars devolvían 
il en su getProfile() si el usuario jamás había tocado las opciones o el módulo estaba inactivo. Esto causaba un error en dapter.seed(p, ...) y detenía el bucle de ApplyAll(), impidiendo que ReloadUI() se llegara a disparar, con lo que el popup no hacía nada aparente.
   - **Solución**: Envolver la ejecución del adaptador dentro de if p then en ThemeEngine.lua, y garantizar en los getProfile() de los adaptadores la creación on-the-fly (or {}) anclada directamente en la base de datos principal (KT.db.profile.modulo).

14. **Colores de tema con formato equivocado en ThemePreview.lua (`color[1]` vs `color.r`)**:
   - **Problema**: `ThemeCatalog.lua` define `theme.color` como `{ r=, g=, b= }`, pero los helpers `Color()`/`AddEdges()` de `ThemePreview.lua` indexaban `color[1..4]` (formato array, usado internamente por la tabla `PREVIEW`). Al llamar `AddEdges(card, theme.color, ...)` en `CreateThemeCard`, `color[1]` daba `nil` y `SetColorTexture(nil, nil, nil, 1)` lanzaba `bad argument #1`, rompiendo el selector entero (`ThemeSelector.lua` -> `Options.lua`) en cuanto se abria la pagina.
   - **Solución**: Se anadio un helper `ColorParts(color)` que detecta si la tabla trae `r/g/b` o indices numericos y devuelve siempre 4 numeros; `Color()` y `AddEdges()` lo usan internamente. No se toco el formato de `ThemeCatalog.lua` porque otros sitios ya leen `theme.color.r/g/b` directamente.

15. **La tarjeta "Forever" del selector no debe ser un kit aparte**: se decidio que su miniatura reutilice literalmente los flags de forma de "Classic" (`classicSlots = true`, retrato cuadrado sin mascara) y solo cambie la paleta a bronce/dorado, en vez de mantener un diseno plano independiente (antes usaba `roundPortrait = true`, casi identico a `kui`). De paso, el color de los iconos de slot clasicos estaba hardcodeado (`0.78, 0.65, 0.40`) igual para Classic y Forever; ahora sale de `kit.border` para que cada tema se vea con su propio tono.

16. **Adaptador de Damage Meter apuntaba a texturas que no existen**: `seed()` asignaba `barTexture = "Blizzard"` / `"Blizzard Raid Bar"` para classic/retail, pero esos nombres nunca estuvieron en la whitelist real (`DAMAGE_METER_TEXTURE_PATHS` en `Enhancements_DamageMeter.lua` / `DAMAGE_METER_TEXTURES` en `Enhancements_Options.lua`), asi que `GetDamageMeterBarTexture` caia siempre al Melli por defecto sin avisar. Se registro una textura nativa real y sin coste de asset, `Interface\TargetingFrame\UI-StatusBar`, con el nombre visible "Blizzard", y se usa para classic/retail/forever por igual (el cromado, no la textura, es lo que distingue a Forever). Pendiente decidir si Classic merece su propia textura distinta mas adelante; de momento comparte la misma con Retail, como pidio el usuario ("blizzard o forever").

17. **Cromado dorado/bronce del Damage Meter, alcance deliberadamente acotado**: se anadio `KT.VisualThemes:GetDamageMeterAccentColor()` en `ThemeEngine.lua` (dorado fijo para classic/retail, bronce fijo para forever, `nil` para kui, que sigue el acento manual del usuario). Solo se aplico a: el fondo idle y hover de los botones de cabecera (`StyleHeaderButton`, `CreateHeaderButton`) y a `frame.accentLine` (borde superior, oculto salvo en forever, que es el "borde bronce" pedido). **No** se toco: los colores por clase de las filas, el modo "flat accent" cuando `classColors == false`, ni el panel de desglose (`BreakdownPanel`/`ApplyBreakdownBackgroundTheme`), que sigue el sistema de skin/preset normal sin distincion de tema. Si en el futuro se quiere que el desglose tambien recoloree por tema, es un cambio aparte y mas grande (ese panel usa `GetAccentColor()` en mas de una decena de sitios propios).

18. **Minimapa: no hacia falta desocultar nada de Blizzard**: la sospecha inicial era que `MinimapBorder`/`MinimapBorderTop` (ocultados a proposito en `Mod:HandleBorders()`) debian mostrarse para dar identidad visual por tema. Investigando `Minimap.lua` se confirmo que el addon ya dibuja su propio borde en pixeles (`CreatePixelPerfectBorder`/`UpdatePixelPerfectBorder`), que ya soporta forma cuadrada o circular (`db.shape`) y color propio (`db.borderColor = {r,g,b,a}`) tanto para el modo circulo como cuadrado. No se toco `HandleBorders()`. Se creo `VisualThemes/Adapters/Minimap.lua` (nuevo, registrado en `KullThranUI.toc` junto a los demas adaptadores) que solo hace `seed()` de `shape = "ROUND"` + `borderColor` bronce (forever) o dorado (classic) sobre `KT.db.profile.minimap` directamente (sin pasar por `KT:GetModule("Minimap")`, para no depender del orden de carga entre el addon principal y `KullThranUI_Minimap`). Retail y kui quedan sin tocar a proposito: implementacion solo en Forever por ahora, pendiente de portar a Retail una vez validada en juego.

19. **`ThemeBorderKit.lua` (Task 1): recorte de textura provisional, sin confirmar en juego**: se creo `KullThranUI/Modules/VisualThemes/ThemeBorderKit.lua` (registrado en `KullThranUI.toc` justo despues de `ThemeEngine.lua` y antes de `ThemePreview.lua`) con tres funciones publicas -- `KT.VisualThemes:CreateClassicBorder(parent, layer, sublevel)`, `:SeatClassicBorder(border, rect, scale)`, `:ShowClassicBorder(border, shown)` -- que cortan 8 piezas (4 esquinas + 4 bordes, sin pieza central) de `Interface\CastingBar\UI-CastingBar-Border` (hoja de 256x64px). **Este entorno de trabajo no tiene cliente de WoW**, asi que el recorte de `SetTexCoord` (esquinas asumidas en 32px de los 256px de ancho y 16px de los 64px de alto) y el tamano en pantalla del marco (`BASE_RING_SIZE = 16px` a escala 1) se derivaron unicamente razonando sobre las proporciones de la hoja, no midiendo el resultado visual. **Pendiente de QA manual**: abrir el juego, crear un borde de prueba sobre un frame descartable (`CreateClassicBorder` + `SeatClassicBorder` + `ShowClassicBorder(border, true)`), confirmar que se ve como un marco metalico continuo (sin piezas estiradas, cortadas, o mostrando la parte equivocada de la hoja) y ajustar `SHEET_CORNER_W`/`SHEET_CORNER_H`/`BASE_RING_SIZE` en el archivo si hace falta, antes de dar esto por visualmente correcto. La memoizacion de `SeatClassicBorder` (guardada en `border._ktSeatRect/_ktSeatScale/_ktSeatWidth/_ktSeatHeight`) sigue el mismo espiritu que `UpdatePixelPerfectBorder` de `Minimap.lua`, adaptada al caso mas simple de anillo hueco de 8 piezas (sin orientacion horizontal/vertical, ya que todas las barras de este addon son siempre horizontales).

20. **UnitFrames (Task 2): `classThemeStyle` confirmado muerto y retirado; `borderColor` resulto NO estar muerto**: se audito `KUIUnitFrames.lua` en busca de los dos "sospechosos" senalados por el plan. `classThemeStyle` (leido en `:3253`/`:5597`/`:6176` pero nunca consultado por `ApplyClassIconTexture`) se confirmo muerto de verdad; `KullThranUI/Modules/VisualThemes/Adapters/UnitFrames.lua` dejo de escribirlo (se retiro el parametro `classStyle` de `SetUnitValues`, que ahora es `SetUnitValues(profile, showPortrait, texture)`, 3 args) y se quito `key .. ".classThemeStyle"` de `getOwnedPaths()`. `unit.borderColor`, en cambio, **si se consume** en render: colorea el borde unificado de cada frame en `ApplyBorderAppearance`/`CreateUnifiedBorder` (fase de creacion, `:3701-3750`) y se reaplica en cada `ReloadFrames()` (`:7319-7331`, via `donorSettings.borderColor`), ademas de un uso puntual en la barra de recursos de clase (`:7695`, bloque `classPowerPosition == "above"`). Por tanto el Paso 8 alternativo del plan (colorear un borde que nadie lee) no aplicaba: solo hacia falta que el adaptador empezara a escribir valores reales por tema en vez de dejar siempre `{0,0,0}`. Se anadio una funcion pequena separada, `SetUnitBorderColor(profile, r, g, b)`, en vez de meter los 3 colores como argumentos extra de `SetUnitValues` (el brief pedia textualmente que `SetUnitValues` quedara en exactamente 3 args tras quitar `classStyle`); ambas se llaman una tras otra en las ramas `classic`/`forever`/`retail` de `seed()`. Colores por tema: `classic` `{0.92, 0.72, 0.22}` (dorado), `forever` `{0.82, 0.65, 0.23}` (bronce), `retail` `{0.20, 0.58, 1.00}` (azul); la rama `kui` no toca ni `borderColor` ni `frameArtKit`, dejando que el snapshot/restauracion del motor de temas recupere lo que el usuario tenia. Tambien se añadio `frameArtKit = "default"` a la tabla `defaults.profile` de `KUIUnitFrames.lua` (junto a `darkTheme`, mismo nivel que `portraitStyle`) para que un perfil que nunca vio un tema tenga un valor definido, ya que el motor de temas solo escribe `profile.frameArtKit` al aplicar/seedear un tema.

    Ademas se conecto el marco clasico de `ThemeBorderKit.lua` (Task 1) al render real: nueva funcion `ApplyClassicFrameArt(frame, unit)` en `KUIUnitFrames.lua` (justo antes de `CreateUnifiedBorder`) que, cuando `db.profile.frameArtKit == "classic"`, crea (una vez, cacheado en `frame.classicBorder`) y muestra el marco de 8 piezas alrededor del frame completo de la unidad (`SeatClassicBorder(frame.classicBorder, frame, 1)` -- mismo rectangulo que ya tinta `frame.unifiedBorder`, sin alterar su layout), y lo oculta (`ShowClassicBorder(..., false)`) en cualquier otro caso. Se llama en dos sitios: dentro de `CreateUnifiedBorder` (creacion inicial del frame, los 5 call sites de `StyleFullFrame`/`StyleFocusFrame`/`StyleSimpleFrame`/`StylePetFrame`/`StyleBossFrame`) y dentro del bucle general de `ReloadFrames()` justo despues del bloque que reaplica `frame.unifiedBorder` (`:7319-7331`), para que tambien se corrija sin un `/reload` completo si algo llama a `Mod:Refresh()` sin pasar por `ReloadUI()`. `frameArtKit` es un campo global de perfil (no por unidad), asi que la misma decision aplica igual a las 5 unidades.

    **Sin cliente de WoW en este entorno**: no se pudo verificar en juego. Ademas de la QA pendiente de la entrada 19 (recorte de textura), queda pendiente de QA manual esta entrada: `/reload` y ciclar `kui -> classic -> forever -> retail -> kui` desde `General > Advanced Style System`, confirmando que (a) `classic` muestra el marco de 8 piezas + acento dorado, (b) `forever` muestra borde bronce sin marco clasico, (c) `retail` muestra borde azul sin marco clasico, (d) `kui` vuelve exactamente al aspecto de hoy (borde negro, sin marco), y (e) el cambio `classic -> forever` no deja ninguna pieza del marco visible colgada (el cacheo en `frame.classicBorder` mas `ShowClassicBorder(..., false)` deberia bastar, pero no se ha visto renderizado). El test automatizado (`tests/visual_themes.lua`) solo cubre la capa de datos del adaptador (que `borderColor`/`frameArtKit` se escriban y restauren correctamente); no existe forma de testear `KUIUnitFrames.lua` en este entorno (no hay stubs de `CreateFrame`/texturas), asi que el cableado de render se verifico solo por lectura cuidadosa de codigo, igual que el borde de la Tarea 1.

21. **CastBar (Tarea 3): `color`/`colorMode` ya eran reales; no existia ningun campo de borde sin usar, asi que se creo `frameArtKit` nuevo, igual que en UnitFrames**: se audito `CastBar_Options.lua` y `CastBar.lua` en busca de los "sospechosos" del brief. El dropdown de `iconShape` (`SQUARE`/`CIRCLE`) es real y unico -- se lee en `CastBar.lua:1077` (`if db.iconShape == "CIRCLE" then ...`). El `colorMode` de la UI, en cambio, no tiene un dropdown propio con 3 opciones: la unica forma de que el jugador ponga `colorMode = "CUSTOM"` es tocar el color swatch "Bar Color" (`CastBar_Options.lua:311-319`, que hace `db.colorMode = "CUSTOM"` como efecto secundario del `ColorSwatch`); cualquier otro valor (incluido el `"THEME"` que pone la rama `kui` del adaptador) cae al mismo camino en `Mod:GetResolvedBarColor()` (`CastBar.lua:324`, `if db.colorMode ~= "CUSTOM" then` usa el acento del tema). Es decir, el enum declarado en `validate()` (`THEME`/`CLASS`/`CUSTOM`) es en la practica binario en el render (`CUSTOM` vs. cualquier-otra-cosa), pero el campo si es real y si se renderiza -- se confirmo que la semilla actual (classic/forever/retail ya ponian `colorMode = "CUSTOM"` + un `color` fijo por tema desde antes de esta tarea) ya pintaba un acento honesto por tema, y se le añadieron assertions de test para blindarlo contra regresiones (no se necesito cambiar el adaptador en esa parte). Para el marco de borde: a diferencia de UnitFrames (que tenia `borderColor` real sin sembrar), CastBar **no tiene ningun campo de color de borde propio** -- la barra solo tiene un backdrop fijo negro (`CastBar.lua:633-640`, `bar:SetBackdropBorderColor(0,0,0,1)`, sin variable de perfil detras) y un fondo de icono igual de fijo (`:684-685`). Por tanto, siguiendo la alternativa que el brief ya anticipaba, se añadio `profile.frameArtKit` (mismo nombre que UnitFrames) como campo nuevo: `"classic"` solo en la rama `classic` de `seed()`, `"default"` explicito en `forever`/`retail`, sin tocar en la rama `kui` (mismo patron que la entrada 20). Se añadio a `getOwnedPaths()` y a las dos tablas de defaults de `CastBar.lua` (`OnInitialize` y el `Mod:Refresh()` de respaldo), con guardas `if self.db.frameArtKit == nil` en ambos sitios de inicializacion (siguiendo el patron ya existente de `classColor`/`colorMode` en el mismo archivo).

    Cableado de render: nueva funcion local `ApplyClassicFrameArt(bar, db)` en `CastBar.lua`, justo antes de `Mod:ApplySettings()`, con la misma forma que `ApplyClassicFrameArt(frame, unit)` de `KUIUnitFrames.lua` -- crea (cacheado en `bar.classicBorder`) y muestra el marco de 8 piezas alrededor de la barra completa (`SeatClassicBorder(bar.classicBorder, bar, 1)`) cuando `db.frameArtKit == "classic"`, y lo oculta en cualquier otro caso. Se llama una sola vez, al final de `Mod:ApplySettings()` (la funcion de render unificada que ya usan `OnEnable`, `Refresh` y cada control de Options que cambia algo -- ver `CastBar.lua:351,612,1478,1690,1694,1703`), asi que no hizo falta anadir una segunda llamada como en UnitFrames (alli hacia falta un sitio extra porque `ReloadFrames()` reaplica el borde unificado sin pasar por la creacion inicial del frame; CastBar solo tiene una barra global, no 5 frames por unidad, y toda `ApplySettings()` ya se re-ejecuta en cada refresco). El marco se ancla justo fuera del backdrop negro existente (sin solaparlo, ver nota de `SeatClassicBorder` sobre anclar "justo fuera" del rect) -- no se toco el backdrop negro fijo en si.

    **Leccion de cobertura de tests aplicada de entrada**: se añadio a `tests/visual_themes.lua` un valor inicial `castbar.frameArtKit = "user_kit"` (sentinela, ya que ningun perfil de usuario real tendria ese valor) antes del ciclo `kui -> classic -> retail -> kui`, con una assertion tras cada paso: `"classic"` tras `classic`, `"default"` tras `retail`, y de vuelta a `"user_kit"` (no `"default"`) tras restaurar `kui` -- confirmando que `LoadSlot`/`SaveSlot` (el snapshot que `ThemeEngine.lua:ApplyAll` toma de `getOwnedPaths` antes de abandonar cada tema) restaura el valor que el usuario tenia, no lo que la rama `kui` de `seed()` habria puesto (que de hecho no toca `frameArtKit` en absoluto). Se añadieron tambien assertions equivalentes para `color`/`colorMode` (ida y vuelta) que antes no existian, aunque esos dos campos ya eran reales antes de esta tarea.

    **Sin cliente de WoW en este entorno**: igual que las entradas 19 y 20, no se pudo confirmar visualmente. Queda pendiente de QA manual: `/reload` y ciclar `kui -> classic -> forever -> retail -> kui` desde `General > Advanced Style System`, confirmando en la cast bar del jugador que (a) `classic` muestra el marco de 8 piezas alrededor de la barra mas el acento dorado (`color = {0.86, 0.62, 0.16}`) sin piezas descolocadas respecto al backdrop negro existente, (b) `forever` muestra el acento bronce (`{0.82, 0.65, 0.23}`) sin marco clasico, (c) `retail` muestra el acento azul (`{0.12, 0.48, 0.95}`) sin marco clasico, (d) `kui` vuelve exactamente al aspecto de hoy (acento del tema del usuario, sin marco), y (e) el marco no deja ninguna pieza colgada al salir de `classic` hacia otro tema. El test automatizado solo cubre la capa de datos (adaptador + motor de temas); el cableado de render en `CastBar.lua` se verifico solo por lectura cuidadosa de codigo (no hay stubs de `CreateFrame`/`StatusBar` en este entorno para probarlo).

22. **ResourceBars (Tarea 4): `borderSize`/`texture` ya reales y compartidos; se audito color por barra antes de decidir donde poner el acento, y se opto por un marco clasico compartido en vez de uno por barra**: se audito `KUI_ResourceBars_Options.lua` (bloques "Health Bar", "Resource 1: Class Specific (Pips)", "Primary Power Bar") y `KUIResourceBars.lua` antes de asumir que no habia ningun campo de color real. Resultado: `health` **si tiene** un campo de color propio, real y siempre renderizado -- `db.health.fillR/fillG/fillB/fillA`, fijado por el `ColorSwatch` "Fill Color Options" (`KUI_ResourceBars_Options.lua:1173-1175`) y pintado sin condicion en `healthBar:GetStatusBarTexture():SetVertexColor(...)` (`KUIResourceBars.lua:1770` antes de este cambio) -- no hay gradiente por porcentaje de vida ni ningun otro camino que lo sobreescriba. `primary` y `secondary`, en cambio, tienen un sistema de color mucho mas rico y **con significado de juego real**: un `colorMode` de verdad con 3 opciones (`spec`/`power`/`custom`, dropdown "Color Source" en `:1197-1200` y `:1314-1317`), donde el modo por defecto (`"power"`) pinta el color real del tipo de poder (mana azul, ira rojo, energia amarilla, etc., via `GetPowerColor`/`ResolveSectionColor`) y `fillR/fillG/fillB/fillA` solo se usan como *fallback* cuando `colorMode == "custom"`. Forzar `colorMode = "custom"` + un color de tema fijo en el adaptador habria sido un cambio de comportamiento real (el jugador perderia la asociacion de color power-type/spec que estas dos barras ya proveen), no solo un "acento honesto" -- asi que se decidio sembrar el acento de tema **solo en `health.fillR/fillG/fillB`** (colores: `classic` `{0.86, 0.62, 0.16}` dorado, `forever` `{0.82, 0.65, 0.23}` bronce, `retail` `{0.12, 0.48, 0.95}` azul, misma familia que CastBar en la entrada 21) y dejar `primary`/`secondary` intactos.

    Para el marco clasico se decidio lo contrario a "un campo por barra": se añadio un **unico** interruptor de perfil, `profile.general.frameArtKit` (mismo nombre y patron que `unitFrames.frameArtKit`/`castbar.frameArtKit`), en vez de uno por seccion (`health.frameArtKit`, `primary.frameArtKit`, `secondary.frameArtKit`). Razon: las tres barras ya comparten `texture`/`borderSize` desde antes de esta tarea (mismo seed, ver adaptador) y se apilan como una sola columna bajo un unico `anchorFrame` (`KUIResourceBars.lua:BuildBars`) -- son tres secciones de un mismo widget "Resource Bars", no tres widgets independientes con vida visual propia (a diferencia de, por ejemplo, unit frames por unidad). Un interruptor compartido evita ademas la combinatoria rara de "salud con marco clasico pero poder primario sin el" que un usuario normal nunca pediria desde la UI (no hay ningun control por-barra hoy para "estilo de marco").

    Cableado de render: `KullThranUI/Modules/VisualThemes/Adapters/ResourceBars.lua` ahora escribe `profile.general.frameArtKit` (`"classic"` solo en la rama `classic`, `"default"` explicito en `forever`/`retail`, intacto en `kui`) y `profile.health.fillR/fillG/fillB` (mismo patron: solo en las 3 ramas de tema, nunca en `kui`), y `getOwnedPaths()` se extendio con `"general.frameArtKit"`, `"health.fillR"`, `"health.fillG"`, `"health.fillB"`. En `KUIResourceBars.lua` se añadio una funcion local nueva, `ApplyClassicFrameArt(frame, db)`, con la misma forma que las de UnitFrames/CastBar: crea (cacheado en `frame.classicBorder`) y muestra el marco de 8 piezas de `ThemeBorderKit.lua` (Tarea 1) alrededor del frame que se le pase (`SeatClassicBorder(frame.classicBorder, frame, 1)`) cuando `db.general.frameArtKit == "classic"`, y lo oculta en cualquier otro caso. Se llama tres veces al final de `BuildBars()` (la funcion de render unificada de este modulo, equivalente a `ApplySettings` de CastBar) -- `ApplyClassicFrameArt(healthBar, db)`, `ApplyClassicFrameArt(primaryBar, db)`, `ApplyClassicFrameArt(secondaryFrame, db)` -- usando `secondaryFrame` (el contenedor, no `secondaryBar`) para el recurso secundario porque ese contenedor existe igual tanto si el recurso se dibuja como barra continua (stagger/algunas clases) como si se dibuja como pips (la mayoria), asi un solo marco cubre ambos modos sin depender de cuantos pips haya en pantalla. Tambien se añadio `frameArtKit = "default"` a las dos tablas de defaults de `db.general` en `GetSafeDB()` (creacion inicial y `db.general = db.general or {...}` de respaldo) mas una guarda `if db.general.frameArtKit == nil then db.general.frameArtKit = "default" end`, siguiendo el mismo patron que las entradas 20/21.

    **Cobertura de test**: se añadio a `tests/visual_themes.lua` `resourceBars.general.frameArtKit = "user_kit"` y `resourceBars.health.fillR/fillG/fillB = 0.4/0.5/0.6` como sentinelas antes del ciclo `kui -> classic -> retail -> kui`, con assertions de ida (`"classic"`/`0.86` tras `classic`, `"default"`/`0.12` tras `retail`) y de vuelta (`"user_kit"` y `0.4/0.5/0.6` tras restaurar `kui`, no `"default"` ni los valores de ningun tema), siguiendo la leccion de la entrada 21 sobre no limitarse a comprobaciones solo-de-ida.

    **Sin cliente de WoW en este entorno**: igual que las entradas 19-21, no se pudo confirmar visualmente. Queda pendiente de QA manual: `/reload` y ciclar `kui -> classic -> forever -> retail -> kui` desde `General > Advanced Style System`, confirmando en las barras de recursos del jugador que (a) `classic` muestra el marco de 8 piezas alrededor de salud, poder primario y recurso secundario (barra o pips) a la vez, mas el acento dorado en la barra de salud, sin piezas descolocadas respecto al pixel border negro ya existente de cada barra; (b) `forever` muestra el acento bronce en salud sin marco clasico; (c) `retail` muestra el acento azul en salud sin marco clasico; (d) `kui` vuelve exactamente al aspecto de hoy (color de salud y marco del usuario, sin marco clasico); (e) el color de poder primario/recurso secundario (mana/ira/energia/etc.) no cambia en ningun tema, ya que se dejo deliberadamente intacto; y (f) el marco no deja ninguna pieza colgada al salir de `classic` hacia otro tema, incluyendo el caso de cambiar de clase (pips <-> barra) mientras el tema sigue en `classic`. El test automatizado solo cubre la capa de datos (adaptador + motor de temas); el cableado de render en `KUIResourceBars.lua` se verifico solo por lectura cuidadosa de codigo (no hay stubs de `CreateFrame`/`StatusBar` en este entorno para probarlo).

23. **CooldownManager (Tarea 5): el whitelist real de formas de icono si existia, solo que en otro archivo del par sugerido por el plan; `borderR/G/B` confirmado real y en vivo, sin trabajo de color nuevo**: el brief marcaba explicitamente que la auditoria previa del plan no habia localizado donde `KUI_CooldownManager_Options.lua` (o `KUICooldownManager.lua`) definia `ns.CDM_SHAPE_MASKS`/`ns.CDM_SHAPE_BORDERS`, solo que se *referenciaban*. Se encontraron ambas tablas fuente (`CDM_SHAPES.masks`/`CDM_SHAPES.borders`) definidas en el propio `KUICooldownManager.lua:118-136`, con `ns.CDM_SHAPE_MASKS = CDM_SHAPES.masks` / `ns.CDM_SHAPE_BORDERS = CDM_SHAPES.borders` como alias de solo lectura en `:210-211` -- el plan no las encontro porque busco la *definicion* en el archivo de Opciones, cuando en realidad Opciones solo *consume* el alias via el dropdown "Custom Icon Shape" (`KUI_CooldownManager_Options.lua:3442-3443`, `values`/`order` con las claves `none, cropped, square, circle, csquare, diamond, hexagon, portrait, shield`). Se confirmo que esa lista es identica, clave por clave, al whitelist de `validate()` del adaptador (`KullThranUI/Modules/VisualThemes/Adapters/CooldownManager.lua:62`) y que los 4 valores que el `seed()` del adaptador ya asignaba por tema (`square`/`circle`/`csquare`/`none`) son las 4 claves reales que usa el dropdown -- no hizo falta corregir ningun valor de forma, ya eran honestos. Sobre color: se confirmo que `bar.borderR/G/B/A` (sembrado por tema desde antes de esta tarea) se consume en render en **dos** sitios reales de `KUICooldownManager.lua`, no uno solo -- los 4 bordes cuadrados de cada icono en `CreateCDMIcon` (`:8198` en la creacion, `:10283` en `RefreshCDMIconAppearance` para iconos ya existentes) y la textura de borde con forma (`borderTex:SetVertexColor`, dentro de `ApplyShapeToCDMIcon`, `:8400`, cuando `iconShape` no es `none`/`cropped`) -- ambos caminos leen el mismo campo de perfil, asi que no era un campo muerto y no se toco.

    Para el marco clasico se opto por un campo **por barra** (`bar.frameArtKit`), no un unico interruptor global como en ResourceBars: a diferencia de las 3 secciones de Resource Bars (que ya comparten `texture`/`borderSize` y se apilan como un solo widget), cada barra de Cooldown Manager (`cooldowns`, `utility`, `buffs`, mas cualquier barra de KUI Tracker que el usuario cree) ya es una unidad visual independiente con su propio `iconShape`/`borderSize`/`borderR/G/B` por barra desde antes de esta tarea (el adaptador ya iteraba `for _, bar in ipairs(profile.cdmBars.bars) do bar.iconShape = shape; ... end`), asi que anadir `bar.frameArtKit` al mismo bucle sigue la granularidad ya establecida en vez de introducir una nueva mas gruesa. Tambien se sembro `profile.cdmBars.barDefaults.frameArtKit` (mismo valor) en las 3 ramas de tema, siguiendo el patron ya existente de `barDefaults.iconShape` -- `barDefaults` es la plantilla que `KUICooldownManager.lua:6863` copia al crear una barra nueva (KUI Tracker), asi que una barra creada mientras el tema esta en `classic` nace ya con el marco activado. La rama `kui` no toca `frameArtKit` en ningun sitio (ni por barra ni en `barDefaults`), igual que en las 3 tareas anteriores, para que el snapshot/restauracion del motor de temas recupere el valor real del usuario.

    Cableado de render: nueva funcion local `ApplyClassicFrameArt(icon, barData)` en `KUICooldownManager.lua` (justo antes de `CreateCDMIcon`), con la misma forma que las 3 versiones anteriores (UnitFrames/CastBar/ResourceBars) -- crea (cacheado en `icon.classicBorder`) y muestra el marco de 8 piezas de `ThemeBorderKit.lua` alrededor del icono (`SeatClassicBorder(icon.classicBorder, icon, 1)`) cuando `barData.frameArtKit == "classic"`, y lo oculta en cualquier otro caso. A diferencia de las tareas anteriores (que tenian una unica funcion de render unificada -- `ApplySettings`/`BuildBars` -- donde bastaba una llamada), Cooldown Manager crea sus iconos en dos sitios distintos que no se llaman entre si: `CreateCDMIcon` (creacion perezosa de un icono nuevo) y `RefreshCDMIconAppearance` (reaplica el aspecto a iconos ya existentes en cada rebuild via `BuildAllCDMBars`). Se anadio la llamada en ambos: justo despues del bloque de forma en `CreateCDMIcon` (tras el `if shape ~= "none" then ApplyShapeToCDMIcon(...) end`) y justo despues de la llamada equivalente a `ApplyShapeToCDMIcon` dentro del bucle de `RefreshCDMIconAppearance` -- deliberadamente **sin** meter la llamada dentro de `ApplyShapeToCDMIcon` misma, porque esa funcion tiene dos `return` tempranos (rama `none`/`cropped` vs. rama de forma personalizada) y anadir la llamada en ambos call-sites del marco clasico es mas simple de leer que anadirla dos veces dentro de una funcion con ramas que retornan.

    **Defaults y migracion**: se anadio `frameArtKit = "default"` a `DEFAULTS.profile.cdmBars.barDefaults` (linea junto a `iconShape = "none"`) para que un perfil de AceDB completamente nuevo ya traiga el campo. Para perfiles ya existentes (donde `cdmBars.bars` ya tiene entradas guardadas y el merge de AceDB no anade retroactivamente una clave nueva dentro de una tabla anidada que ya existe), se anadio una migracion nueva, `migratedCDM_v41`, siguiendo exactamente el patron de `migratedCDM_v29` ya presente en el archivo: si `frameArtKit` es `nil` en `barDefaults` o en cualquier barra, se rellena a `"default"`.

    **Cobertura de test**: se anadio a `tests/visual_themes.lua` `cooldownManager.cdmBars.barDefaults.frameArtKit = "user_kit"` y `cooldownManager.cdmBars.bars[1].frameArtKit = "user_kit"` como sentinelas antes del ciclo `kui -> classic -> retail -> kui`, con assertions de ida (`"classic"` tras `classic`, `"default"` tras `retail`) y de vuelta (`"user_kit"`, no `"default"`, tras restaurar `kui`), con el mismo patron de ida-y-vuelta que las entradas 21/22. Se verifico ademas, revirtiendo temporalmente solo el adaptador (`git stash` del archivo, sin tocar el test) y volviendo a correr la suite, que la assertion nueva falla sin el cambio (`expected classic, got user_kit`) antes de restaurar el adaptador -- confirmando que el test realmente ejercita el codigo nuevo y no es un falso positivo.

    **Hallazgo colateral fuera del alcance original de esta tarea**: al tocar `KUICooldownManager.lua` se encontro un comentario preexistente que nombraba a un proyecto de terceros por nombre ("Same guard shape as EllesmereUI.", junto al manejo de `UNIT_AURA` secreto, sin relacion alguna con VisualThemes). Como el archivo ya estaba dentro del conjunto de archivos modificados por esta tarea, se elimino la mencion del comentario (se conservo el resto de la explicacion tecnica, solo se quito el nombre propio) para cumplir la regla de "ningun archivo modificado puede mencionar terceros por nombre". Una busqueda en todo el repositorio (`grep -ril ellesmere`) encontro 3 archivos mas con la misma mencion (`AddonConflictDetector.lua`, `CombatCPUProfiler.lua`, `PartyFrames.lua`, `WeeklyRewards.lua`) que **no** se tocaron en esta tarea (fuera del alcance de VisualThemes) y quedan pendientes para quien audite esos modulos.

24. **Nameplates (Tarea 6): auditoria pura, todo confirmado real, sin cambios en el adaptador**: a diferencia de las 5 tareas anteriores, esta no encontro nada que arreglar. El adaptador (`KullThranUI/Modules/VisualThemes/Adapters/Nameplates.lua`, 66 lineas) vive junto al modulo real de Nameplates, que **no** esta en `KullThranUI/Modules/Nameplates/` (esa carpeta solo tiene un asset `.tga`) sino en el addon separado `KullThranUI_Nameplates/Modules/Nameplates/Nameplates.lua` -- el primer paso de la auditoria fue justamente localizar el modulo real, porque un grep inicial de `borderStyle`/`targetGlowStyle` dentro de `KullThranUI/Modules/` solo encontraba al propio adaptador (senal de alarma de "campo fantasma" que resulto ser un problema de ubicacion, no de dato muerto). Con el modulo real localizado se confirmaron los 3 campos "sospechosos" del brief:
    - `borderStyle` (sembrado `simple`/`kullthran`/`none` segun tema): consumido en `Nameplates.lua:2417-2429` (`ApplyBorderStyle`), con 3 ramas de render realmente distintas -- `"none"` oculta ambos marcos, `"simple"` muestra `_simpleBorderFrame` (marco fino) y oculta el marco completo, cualquier otro valor (`"kullthran"`) muestra el marco completo (`borderFrame`) y oculta el fino. No es decoracion: cambia que textura geometrica de las 2 precomputadas (`BuildBorderGeometry`, marco completo vs. simple) se ve.
    - `borderColor` (RGB por tema): consumido en `Nameplates.lua:2411-2412` (tinte inicial de ambos marcos via `GetBorderColor()`) y de nuevo en `ApplyBorderColor` (`:2431-2434`, reaplicado en cada refresh) -- vertex color real sobre las texturas del marco, sin ningun valor fijo que lo sobreescriba.
    - `targetGlowStyle` (sembrado `vibrant`/`kullthranui`/`none` segun tema): consumido en dos sitios reales de `Nameplates.lua`, no uno -- `GetTargetGlowStyle()` alimenta `desc.glowNeeded` (`style ~= "none"`) y `desc.vibrantBorder` (`style == "vibrant"`) en `_ResolveTargetVisuals` (`:2150-2152`), y ambos flags del descriptor se consumen en `ApplyTarget` (`:5528-5552`): `glowNeeded` muestra/oculta el halo de 8 piezas alrededor de la barra de vida del objetivo actual, `vibrantBorder` decide si el marco del objetivo se tine del color de glow (verdadero "vibrant") o mantiene su `borderColor` normal (`kullthranui`/`none`). Osea que el enum de 3 valores mapea a 3 comportamientos de render realmente distintos, no a un simple on/off.
    - `healthBarTexture`/`castBarTexture` (y las 2 variantes friendly, `friendlyPlayerHealthTexture`/`friendlyNPCHealthTexture`): reconfirmado el patron ya visto en tareas anteriores -- `ResolveTexturePath` (`Nameplates.lua:906-917`) intenta primero una tabla local y si no encuentra la clave cae a `LibSharedMedia-3.0:Fetch("statusbar", key, true)`; los 4 nombres que siembra el adaptador (`Blizzard`, `Melli Dark`, `Blizzard Raid Bar`, `Melli Reforged`) son nombres de LSM reales, mismo mecanismo que UnitFrames/CastBar/ResourceBars/CooldownManager en tareas 2-5.

    **Fuera de alcance segun el plan, confirmado en el codigo**: Nameplates no es uno de los 4 modulos "dueños de barra" (UnitFrames/CastBar/ResourceBars/CooldownManager) que recibieron el marco clasico compartido de `ThemeBorderKit.lua` en las tareas 1-5, y no se le añadio aqui -- el adaptador ya tenia su propio sistema de marco geometrico independiente (`BuildBorderGeometry`/`ApplyBorderStyle`, preexistente al plan de VisualThemes) que no comparte codigo con `CreateClassicBorder`/`SeatClassicBorder`. No se toco ese sistema.

    **Cobertura de test (regression-lock, no round-trip de un campo nuevo)**: como el brief anticipaba como resultado mas probable, esta tarea no cambio el adaptador, asi que no habia un campo recien sembrado que probar de ida y vuelta. En su lugar se añadieron a `tests/visual_themes.lua` assertions que blindan los valores ya correctos de hoy contra una regresion futura: `borderColor.r`/`targetGlowStyle`/`healthBarTexture` de `_G.KullThranUINameplatesDB_Forever` en las 3 ramas ya cubiertas por el test existente (`classic`, `retail`, restauracion `kui`) mas una rama nueva no cubierta antes (`forever`, en el bloque de "modulos desactivados" que ya ejercita ese tema para otros adaptadores). El valor de restauracion `kui` para `borderColor.r`/`healthBarTexture` no es el que siembra la rama `else` del adaptador (`0.067`/`"Melli Reforged"`) sino el valor original que tenia el perfil de prueba antes de aplicar ningun tema (`0.1`/`"User Texture"`), confirmando de paso que la restauracion a `kui` recupera el snapshot pre-tema del usuario y no vuelve a ejecutar `seed()` con `themeKey == "kui"` -- se detecto por un fallo real del test (`expected 0.067, got 0.1`) al escribir la primera version de la assertion, corregida despues de leer el comportamiento real del motor.

    **Sin cliente de WoW en este entorno**: no se pudo confirmar visualmente que las 3 ramas de `borderStyle` y las 3 de `targetGlowStyle` se vean correctamente sobre una placa real, en ninguno de los 4 temas, ni con objetivos amistosos ni hostiles. **Pendiente de QA manual**: ciclar `kui -> classic -> forever -> retail -> kui` con una placa de objetivo hostil y una amistosa visibles, confirmar que (a) `classic` muestra el marco fino (`simple`) en color bronce oscuro y el glow de objetivo vibrante (tinte blanco/glow del marco), (b) `forever`/`kui` muestran el marco completo (`kullthran`) en su color respectivo y el glow `kullthranui` (halo sin tinte de marco), (c) `retail` no muestra marco ni halo de objetivo, y (d) ninguna rama dejo un marco o halo huerfano al cambiar de tema repetidamente.

    **Sin cliente de WoW en este entorno**: igual que las entradas 19-22, no se pudo confirmar visualmente. Ademas de la QA pendiente de la entrada 19 (recorte de textura del propio `ThemeBorderKit.lua`), queda esta entrada con una duda especifica que no tenian las 3 tareas anteriores: `BASE_RING_SIZE` del marco compartido es 16px a escala 1, y se uso escala 1 aqui tambien (misma llamada que UnitFrames/CastBar/ResourceBars, por consistencia con el helper compartido), pero los iconos de Cooldown Manager son mucho mas pequenos que los frames de esos otros 3 modulos (28-42px de icono por defecto, frente a barras/frames de 100px o mas) y el espaciado por defecto entre iconos es de solo 2px (`barDefaults.spacing = 2`). Es matematicamente posible que un anillo de 16px hacia fuera de cada icono se superponga visualmente con los iconos vecinos en la misma fila (o fila adyacente en barras de `numRows = 2`, como Utility) cuando `frameArtKit == "classic"` esta activo, algo que no ocurria en los otros 3 modulos por tener frames mucho mas grandes en relacion al mismo tamano de anillo fijo. **Pendiente de QA manual explicito**: abrir el juego, activar el tema `classic`, y revisar visualmente si el anillo se superpone de forma inaceptable con los iconos contiguos de la misma barra; si es asi, la correccion mas simple es pasar una escala menor que 1 en la llamada a `SeatClassicBorder(icon.classicBorder, icon, <escala>)` dentro de `ApplyClassicFrameArt` (unico sitio a tocar), no fue posible determinar el valor correcto sin verlo. Ademas de esto, queda la misma lista de QA que las 3 tareas anteriores: ciclar `kui -> classic -> forever -> retail -> kui` y confirmar que (a) `classic` muestra el marco en cada icono de cada barra, (b)/(c) `forever`/`retail` no muestran marco, (d) `kui` vuelve exactamente al aspecto de hoy, y (e) el marco no deja ninguna pieza colgada al cambiar de tema o al crear una barra de KUI Tracker nueva mientras el tema sigue en `classic`. El test automatizado solo cubre la capa de datos (adaptador + motor de temas); el cableado de render se verifico solo por lectura cuidadosa de codigo (no hay stubs de `CreateFrame`/`Button`/`Cooldown` en este entorno para probarlo).

25. **PartyFrames (Tarea 7): sin marco clasico (no es modulo "dueño de barra"), pero si un campo de acento real y sin sembrar; se opto por un valor compartido entre los 6 modos, no uno por modo**: el brief ya adelantaba que este modulo no recibe el marco clasico compartido de `ThemeBorderKit.lua` (esa parte del trabajo no aplicaba aqui), y pedia solo auditar si existia un campo de color real sin sembrar, del mismo tipo que las entradas 22/21 (ResourceBars/CastBar). El adaptador real vive en `KullThranUI/Modules/VisualThemes/Adapters/PartyFrames.lua` (43 lineas), pero el modulo de render **no** esta bajo `KullThranUI/Modules/` -- sigue el mismo patron ya visto en la entrada 24 (Nameplates): el addon separado `KullThranUI_PartyFrames/Modules/PartyFrames/PartyFrames.lua` (7286 lineas) es donde vive `GetModeDB`/el render real de las 6 variantes (`party`/`raid`/`raid40`/`arena`/`arenaEnemy`/`boss`).

    Antes de este cambio el adaptador solo sembraba `healthTexture`/`absorbBarTexture` (una unica textura LSM escrita a los 6 modos, confirmado ya real en el brief via `ResolveStatusbarTexture`, `PartyFrames.lua:380`). La auditoria de campos de color encontro `absorbBarColor`, un campo real, siempre-renderizado y **no** sembrado por el adaptador: definido como `DEFAULT_ABSORB_COLOR = { r = 0.11, g = 1.00, b = 0.62, a = 0.82 }` (`PartyFrames.lua:371`), presente ya en 5 de los 6 bloques `DEFAULTS` (`party`/`raid`/`arena`/`arenaEnemy`/`boss`; **no** en `raid40`, que cae al fallback via `or`) y consumido sin condicion en el path de render real (no en el path de test/fake unit) en `PartyFrames.lua:6001-6003`: `local c = db.absorbBarColor or DEFAULT_ABSORB_COLOR; frame.absorb:SetStatusBarColor(c.r or ..., c.g or ..., c.b or ..., c.a or ...)`. Es el mismo hueco que las entradas 21/22 (CastBar/ResourceBars) ya habian encontrado en otros modulos: un campo de color estatico, sin significado de juego (no es color de clase, poder ni spec -- es solo el tinte del overlay de absorcion/escudo), que el usuario ya puede fijar pero que ningun tema pintaba.

    **Decision compartido vs. por modo**: el brief pedia decidir explicitamente mirando el patron ya establecido por `healthTexture`/`absorbBarTexture` (un unico valor por tema escrito a los 6 modos). Se opto por seguir ese mismo patron para `absorbBarColor` en vez de un valor independiente por modo, por dos razones concretas: (1) el campo no tiene ninguna diferencia semantica entre modos -- a diferencia de, por ejemplo, `raidGroupOutline` (que si varia por modo porque solo tiene sentido en raid), el tinte del escudo de absorcion es puramente decorativo y aplica igual a un `party` de 5 que a un `raid40` de 40; y (2) un jugador que rota entre grupo, banda y arena en la misma sesion veria el mismo personaje con un escudo de color distinto segun el marco en el que aparezca, lo que leeria como un bug de sincronizacion, no como una funcion -- la textura ya establece este mismo argumento (un jugador no esperaria que su barra de vida cambiara de textura al pasar de `party` a `raid`).

    Colores elegidos (misma familia ya usada en las entradas 21/22 para acentos sin marco clasico -- CastBar `color` y ResourceBars `health.fillR/G/B`): `classic` `{0.86, 0.62, 0.16}` dorado, `forever` `{0.82, 0.65, 0.23}` bronce, `retail` `{0.12, 0.48, 0.95}` azul, `kui` intacto (rama `else` no toca `absorbBarColor`, igual que el patron de todas las tareas anteriores, para que el motor de temas restaure el valor real del usuario via snapshot/slot en vez de que `seed()` lo pise). Solo se sembraron `r`/`g`/`b`, no `a` (alpha): el alpha de 0.82 del `DEFAULT_ABSORB_COLOR` da al escudo su aspecto translucido/superpuesto sobre la barra de vida, y cambiarlo por tema seria un cambio de comportamiento visual no pedido por el brief (opacidad, no solo color) -- se dejo que el fallback existente (`c.a or DEFAULT_ABSORB_COLOR.a`) siga aplicando para cualquier `absorbBarColor` que no traiga `a`, igual que ResourceBars dejo `fillA` fuera del acento de `health`.

    Cableado de render: ninguno nuevo. `absorbBarColor` ya se leia en el unico sitio real de render (`PartyFrames.lua:6001-6003`); no se toco `PartyFrames.lua` para logica de render en esta tarea, solo el adaptador de VisualThemes. `getOwnedPaths()` se extendio con `mode .. ".absorbBarColor.r/g/b"` para los 6 modos, siguiendo el patron de `unitFrames`/`resourceBars` de tareas anteriores, para que el snapshot/restauracion de `ThemeEngine.lua:ApplyAll` cubra el campo nuevo.

    **Hallazgo colateral fuera del alcance original de esta tarea**: `KullThranUI_PartyFrames/Modules/PartyFrames/PartyFrames.lua` era uno de los 3 archivos que la entrada 23 habia dejado pendientes tras encontrar una mencion a un proyecto de terceros por nombre en un comentario (`grep -ril ellesmere` del repo completo). Como esta tarea si toco ese archivo (para quitar la mencion a un proyecto de terceros del comentario en `UpdateFrameHealthEvent`, sin cambiar la logica: "State-stamped paint (EllesmereUI pattern): ..." paso a "State-stamped paint: ..."), se aprovecho para resolver ese pendiente aqui. Quedan aun 2 archivos con la misma mencion fuera del alcance de VisualThemes (`AddonConflictDetector.lua`, `CombatCPUProfiler.lua`) y 1 mas (`WeeklyRewards.lua`) -- ninguno de los 3 se toco en esta tarea.

    **Cobertura de test (round-trip de un campo nuevo)**: se añadieron a `tests/visual_themes.lua` sentinelas `partyFrames.party.absorbBarColor` y `partyFrames.raid.absorbBarColor = { r = 0.4, g = 0.5, b = 0.6 }` antes del ciclo `kui -> classic -> retail -> kui`, con assertions de ida (`0.86` tras `classic` para `party` y `raid`, `0.12` tras `retail` para `party`) y de vuelta (`0.4`/`0.5`/`0.6` tras restaurar `kui`, no los valores de ningun tema). Se añadio ademas una assertion en el bloque de "modulos desactivados" (donde `partyFrames` se pone a `nil` y se aplica `forever` desde cero) confirmando el valor sembrado (`0.82`) y, al restaurar `kui` desde ahi, que `absorbBarColor.r` vuelve a `nil` (no que la tabla entera desaparezca -- `SetPath` deja una tabla vacia `{}` al aplicar un snapshot de campos nil sobre una tabla ya existente, se confirmo leyendo `GetPath`/`SetPath` en `ThemeEngine.lua:35-60` tras un primer intento de assertion incorrecto que fallaba con `expected nil, got table: ...`). Se verifico que la assertion de ida falla sin el cambio del adaptador (`expected 0.86, got 0.4`) antes de implementar `seed()`, confirmando que el test ejercita el codigo nuevo.

    **Sin cliente de WoW en este entorno**: no se pudo confirmar visualmente. **Pendiente de QA manual**: en un grupo/banda real (o con las fake units de prueba de `party`/`raid`), aplicar dano con un escudo de absorcion activo (ej. Palabra de Poder: Escudo) y ciclar `kui -> classic -> forever -> retail -> kui` desde `General > Advanced Style System`, confirmando que (a) el overlay de absorcion sobre la barra de vida cambia de tinte segun el tema (dorado/bronce/azul) en `party`, `raid` y `raid40` a la vez (banda completa, no solo el jugador), (b) `kui` vuelve exactamente al color que el usuario tenia configurado antes (o al `DEFAULT_ABSORB_COLOR` verde-menta si nunca lo habia tocado), y (c) el color de textura (`healthTexture`/`absorbBarTexture`, ya confirmado real en el brief) sigue aplicandose igual que antes, sin regresion. El test automatizado solo cubre la capa de datos (adaptador + motor de temas); el consumo real del campo en `PartyFrames.lua:6001-6003` se verifico solo por lectura cuidadosa de codigo (no hay stubs de `CreateFrame`/`StatusBar` en este entorno para probarlo).

26. **ActionBars (Tarea 8): auditoria pura confirmando que el whitelist ya es honesto, sin cambios en el adaptador**: como el brief adelantaba, esta tarea era un "confirm-only" sobre los valores ya correctos de `buttonShape`. El adaptador (`KullThranUI/Modules/VisualThemes/Adapters/ActionBars.lua:42-47`, metodo `validate()`) declara una whitelist literal: `{ NONE = true, CIRCLE = true, CSQUARE = true, HEXAGON = true, DIAMOND = true, SHIELD = true }`. La auditoria verifico que esta lista coincida exactamente con el dropdown de opciones reales ("Global Button Shape", `ActionBars_Options.lua:217-223`, funcion `shapeChoices`), encontrando las mismas 6 claves: `NONE`, `CIRCLE`, `CSQUARE`, `HEXAGON`, `DIAMOND`, `SHIELD`, en el mismo orden conceptual (square/circle/rounded-square/polygon/etc.). Sin discrepancias.

    **Cobertura de test (regression-lock via unit test directo, no round-trip del motor)**: como el brief anticipaba el resultado probable ("confirm-only" = "confirmed already correct, no adapter change made"), no habia ningun campo nuevo donde hacer un round-trip a traves de `ApplyAll`/`ApplyCurrentThemeToModule`. En su lugar se anadieron a `tests/visual_themes.lua` assertions que validan el whitelist existente directamente, llamando a `abAdapter.validate()` sobre perfiles de prueba construidos a mano (`{ buttonStyle = "KUI", buttonShape = shape }`), sin pasar por el motor de temas. Este patron es mas estrecho que las entrada 24 (Nameplates) y 25 (PartyFrames) -- aquellas ejercitan el ciclo completo del engine (`ApplyAll`), mientras que aqui se prueba el adaptador en aislamiento. Sin embargo, es el patron necesario aqui: el `seed()` del adaptador solo asigna 2 de las 6 formas validas (`NONE` y `CIRCLE`, en Classic/Forever/Retail); un test de round-trip completo nunca podria ejercitar `CSQUARE`/`HEXAGON`/`DIAMOND`/`SHIELD` (valores que ningun flujo de juego real siembra nunca). Llamar directamente a `validate()` es la unica forma de cerrar todas las 6 claves del whitelist contra una regresion futura. Para cada uno de los 6 valores, se verifica que el valor se conserva intacto tras validacion; se anade ademas una assertion extra que verifica el comportamiento opuesto (un valor invalido `"INVALID"` debe resetear a `NONE`).

    No se toco el archivo de adaptador. El test paso a la primera con todos los valores bloqueados.

27. **Cierre de la Tarea 9 (pase de regresion final): resumen de referencia para el port a Retail y la QA en juego pendiente**. Esta entrada sintetiza las 9 tareas del plan (entradas 19-26 mas el trabajo previo de Damage Meter/Minimap, entradas 16-18) para quien retome el port a Retail o haga la primera pasada de QA en un cliente real. Se confirmo primero que la suite automatizada sigue en verde tras la ultima tarea: `"/c/Program Files (x86)/Lua/5.1/lua.exe" tests/visual_themes.lua` termina con `visual theme engine tests passed`, y `luac -p` no reporta errores de sintaxis en ninguno de los 12 archivos `.lua` tocados por el plan completo (5 adaptadores de VisualThemes, `ThemeBorderKit.lua`, 5 modulos de render reales, y el propio archivo de tests).

    **(a) Modulos que necesitaron una correccion real** (cada uno encontro al menos un hueco genuino, casi siempre una capa de color de acento sin sembrar, alguna vez un valor directamente roto):
    - **UnitFrames** (entrada 20): `borderColor` era un campo real y consumido (`ApplyBorderAppearance`/`CreateUnifiedBorder`) que el adaptador nunca habia sembrado (siempre quedaba en `{0,0,0}`); se le dieron colores reales por tema (dorado/bronce/azul) y se conecto el marco clasico compartido via `frameArtKit`. De paso se confirmo y retiro un campo realmente muerto, `classThemeStyle`.
    - **CastBar** (entrada 21): `color`/`colorMode` ya eran honestos antes de esta tarea (se les añadieron tests de blindaje, sin cambio de adaptador); el hueco real era la ausencia total de un campo de marco -- la barra solo tenia un backdrop negro fijo, sin variable de perfil detras -- asi que se añadio `frameArtKit` desde cero, mismo patron que UnitFrames.
    - **ResourceBars** (entrada 22): `health.fillR/G/B` era un campo de color real y siempre pintado que ningun tema tocaba; se sembro por tema. Deliberadamente **no** se toco el color de `primary`/`secondary` (mana/ira/energia/spec real), decision explicita para no romper la asociacion de color con el tipo de poder. Se añadio ademas `general.frameArtKit` como interruptor **compartido** entre las 3 barras (no uno por barra), reflejando que ya comparten textura/borde y viven bajo un unico `anchorFrame`.
    - **CooldownManager** (entrada 23): el whitelist de formas de icono ya era honesto (solo estaba definido en otro archivo del que el plan esperaba, no roto); el trabajo real fue conectar `frameArtKit` **por barra** (no global, a diferencia de ResourceBars) porque cada barra de CDM ya es una unidad visual independiente con su propio `iconShape`/color. Incluye una migracion de perfiles existentes (`migratedCDM_v41`) porque el merge de AceDB no rellena retroactivamente una clave nueva dentro de una tabla anidada ya existente.
    - **PartyFrames** (entrada 25): `absorbBarColor` (tinte del overlay de escudo/absorcion) era un campo real, siempre renderizado y sin sembrar en 5 de los 6 modos; se sembro un valor **compartido entre los 6 modos** (party/raid/raid40/arena/arenaEnemy/boss), replicando el patron ya usado por `healthTexture`, y explicitamente sin marco clasico (PartyFrames no es un modulo "dueño de barra").

    **(b) Modulos auditados que ya estaban correctos, sin cambio de adaptador**:
    - **Nameplates** (entrada 24): los 3 campos sospechosos del brief (`borderStyle`, `borderColor`, `targetGlowStyle`) resultaron todos reales, cada uno con 2-3 ramas de render genuinamente distintas confirmadas leyendo `Nameplates.lua` del addon separado `KullThranUI_Nameplates`. Solo se añadieron tests de regression-lock (sin round-trip de campo nuevo, porque no habia campo nuevo).
    - **ActionBars** (entrada 26): el whitelist de `buttonShape` (6 formas) ya coincidia exactamente con el dropdown real de opciones. Test de regression-lock llamando a `validate()` en aislamiento (no via el motor completo), porque el `seed()` solo siembra 2 de las 6 formas validas y un round-trip normal nunca ejercitaria las otras 4.

    **(c) Infraestructura compartida añadida**: `KullThranUI/Modules/VisualThemes/ThemeBorderKit.lua` (Tarea 1, entrada 19) provee un marco clasico de 8 piezas (4 esquinas + 4 bordes, sin pieza central) cortado de una hoja de textura nativa de Blizzard, con tres funciones publicas (`CreateClassicBorder`, `SeatClassicBorder`, `ShowClassicBorder`). Lo usan, cada uno con su propia funcion local `ApplyClassicFrameArt` y su propio campo `frameArtKit` en el perfil, exactamente **4 modulos** -- los unicos que el plan considero "dueños de barra": UnitFrames (por unidad, 5 frames), CastBar (una barra global), ResourceBars (interruptor compartido entre 3 barras) y CooldownManager (por barra individual, con migracion de perfiles). Nameplates, PartyFrames y ActionBars **no** lo usan -- Nameplates ya tenia su propio sistema de marco geometrico independiente (preexistente al plan), y PartyFrames/ActionBars no encajaban en la definicion de "dueño de barra" segun el brief.

    **(d) Explicitamente pendiente, y que no se puede cerrar sin un cliente de WoW real** (este entorno de trabajo no tiene cliente de WoW; todo lo listado abajo se verifico solo por lectura cuidadosa de codigo, nunca visualmente):
    - **La correccion visual de los 4 temas en juego, en todos los modulos afectados, nunca se ha confirmado.** Esto incluye los 4 modulos con marco clasico nuevo (UnitFrames, CastBar, ResourceBars, CooldownManager), los 2 con acento de color nuevo sin marco (PartyFrames, y el propio ResourceBars para `health`), los 2 auditados sin cambio (Nameplates, ActionBars), y los 2 modulos ya tematizados antes de este plan de 8 tareas (Damage Meter, Minimap -- ver entradas 16-18). El ciclo completo `kui -> classic -> forever -> retail -> kui` con los 8 modulos visibles a la vez (el Paso 2 original de esta tarea) es el **item de QA manual mas importante que queda en todo el plan** -- nada de lo anterior se ha visto renderizado.
    - **Recorte de textura provisional de `ThemeBorderKit.lua`** (entrada 19): las constantes `SHEET_CORNER_W`/`SHEET_CORNER_H` (32px/16px de una hoja de 256x64) y `BASE_RING_SIZE` (16px a escala 1) se derivaron razonando sobre las proporciones de la hoja, no midiendo el resultado en pantalla. Podrian necesitar ajuste tras verlo la primera vez.
    - **Posible superposicion del anillo clasico con iconos vecinos de CooldownManager** (entrada 23): los iconos de CDM son mucho mas pequenos (28-42px) que los frames de los otros 3 modulos con marco clasico, con solo 2px de espaciado por defecto; el anillo fijo de 16px podria solaparse visualmente con iconos contiguos en `frameArtKit == "classic"`. Si ocurre, la correccion es pasar una escala menor que 1 en la llamada a `SeatClassicBorder` dentro de `ApplyClassicFrameArt` de `KUICooldownManager.lua` (unico sitio a tocar) -- no fue posible determinar el valor correcto sin verlo.
    - **Textura del Damage Meter compartida entre Classic/Forever/Retail sin distincion propia** (entrada 16): se registro una unica textura nativa (`Interface\TargetingFrame\UI-StatusBar`) para los 3 temas por falta de un asset de reemplazo real; pendiente decidir si Classic merece una textura visualmente distinta mas adelante.
    - **Minimap tematizado solo en Forever, no en Retail** (entrada 18): el adaptador de Minimap escribe directamente sobre `KT.db.profile.minimap` sin pasar por el modulo, y esta pendiente de portar a Retail una vez validado en juego.
    - **Purga de menciones a terceros**: las entradas 23 y 25 eliminaron menciones a un proyecto de terceros por nombre en comentarios de 2 archivos tocados por esta plan (`KUICooldownManager.lua`, `PartyFrames.lua`). Quedan **3 archivos fuera del alcance de VisualThemes** con la misma mencion, confirmados de nuevo en esta tarea de cierre (`grep -ril` sobre todo el repo): `KullThranUI/Modules/AddonConflictDetector.lua`, `KullThranUI/Modules/CombatCPUProfiler.lua`, `KullThranUI_Skins/Modules/Skins/WeeklyRewards.lua`. Ninguno se toco aqui (fuera del alcance de este plan).

    **En resumen para el futuro port a Retail**: la capa de datos (adaptadores, `ThemeEngine.lua`, snapshot/restauracion por tema, whitelists) esta probada exhaustivamente a nivel de perfil via `tests/visual_themes.lua`, incluyendo casos de ida-y-vuelta que confirman que salir de un tema restaura el valor real del usuario y no un valor de tema "fantasma". Lo que **no** esta probado, en ningun modulo, es que el resultado se vea correcto en pantalla -- ese es el trabajo que queda antes de poder llamar "terminado" a este plan de 9 tareas.

28. **Oleada de arreglos de la revision final de toda la rama (3 hallazgos Importantes)**. La revision final (`.superpowers/sdd/2026-09-29-visual-themes-honest-rendering/final-review.md`) encontro tres problemas que solo se ven mirando la rama entera; los tres quedan arreglados en commits separados:
    - **I1 -- esquema 2 -> 3, migracion aditiva** (`ThemeSlots.lua`, `ThemeEngine.lua`): `SCHEMA_VERSION` pasa a 3. `RepairLegacyState` conserva su comportamiento destructivo (restaurar kui, vaciar slots, forzar kui) pero SOLO para esquema < 2 (`LEGACY_REPAIR_SCHEMA_VERSION = 2`); un perfil en esquema 2 ya no pasa por ese borrado. En su lugar, un paso nuevo `MigrateAddedThemePaths` actua por modulo y SOLO sobre las rutas añadidas por este plan (tabla `SCHEMA3_ADDED_PATH_PATTERNS`: UnitFrames `frameArtKit`/`borderColor.*`, CastBar `frameArtKit`, ResourceBars `general.frameArtKit`/`health.fill*`, CDM `frameArtKit`, PartyFrames `absorbBarColor.*`): (a) en el perfil vivo del tema activo, rellena esas rutas con el `seed()` del propio tema activo, sin tocar `state.active` ni el resto de valores (las personalizaciones del usuario en el tema activo se conservan); (b) en los slots ya guardados de otros temas, añade solo las claves que faltan, nunca sobrescribe una existente -- kui recibe el valor vivo del usuario (antes del esquema 3 ninguna de esas rutas era de ningun tema, asi que el valor vivo ES el de kui), los demas temas reciben su propio `seed()`. Desviacion deliberada respecto a "sembrar el tema activo directamente sobre el perfil vivo": un `seed()` completo borraria personalizaciones del tema activo (y en kui sobrescribiria las texturas propias del usuario con las de fabrica); y sin rellenar los slots viejos, volver a kui seguiria mostrando el color de otro tema (la fuga que reprodujo el revisor). Un modulo cuyo perfil aun no existe (p. ej. CastBar deshabilitado) queda en `state.pendingPathMigration` y se migra la primera vez que aparece. Test nuevo en `tests/visual_themes.lua` con un perfil de esquema 2 real (activo `forever`, rutas viejas).
    - **I2 -- solape del anillo clasico en ResourceBars y CastBar** (mismo origen que el arreglo de CDM, entrada 23): `ThemeBorderKit.lua` dibuja 16px hacia fuera a scale 1. ResourceBars: alcance = `anchorGap / 2` (4px por defecto -> 2px, scale 0.125), con tope en 2.5px (mitad de los 5px de auto-posicion de CastBar); entre barras 2 + 2 = 4 <= 4, hacia CDM 2 + 1 = 3 <= 4, hacia CastBar 2 + 2.5 = 4.5 <= 5. CastBar: el anillo rodea ahora un rect auxiliar que une barra + icono (el icono queda dentro del marco en vez de bajo el anillo; antes el anillo de 16px tapaba 14 de los 20px del icono) con alcance 2.5px (scale 0.15625). **QA en juego pendiente**: comprobar especificamente que no hay solape entre las tres barras de recursos, entre la barra de recursos superior y la barra de lanzamiento, y sobre el icono de lanzamiento; y si un anillo de 2-2.5px sigue leyendose como marco (relacionado con M5 de la revision).
    - **I3 -- kui no reiniciaba `frameArtKit`**: la rama kui de los adaptadores de UnitFrames, CastBar, ResourceBars y CooldownManager escribe ahora `frameArtKit = "default"` (el valor por defecto real de cada modulo en sus propias tablas DEFAULTS), para que un modulo aplicado tarde bajo classic no conserve el marco clasico al volver a kui sin slot kui. Test de ida y vuelta classic -> kui (sin slot kui) para los cuatro modulos.

29. **Nuevo plan: arte real por cliente para UnitFrames en Classic y Forever (Tarea 1 de 3 -- funciones de Classic)**. Tras ver "forever" renderizado en juego (fondo oscuro + borde bronce plano sobre un frame KUI estandar, exactamente el techo ya acordado de "solo color"), el usuario decidio subir la ambicion: quiere texturas/atlas reales de cada cliente colocadas sobre el motor propio de KullThranUI, no una aproximacion con assets de KUI recoloreados -- empezando por UnitFrames como modulo insignia, con Classic y Forever primero (Retail queda fuera, mismo bloqueo de sustitucion de atlas ya documentado en la entrada 16 y explicado de nuevo en el nuevo spec). Ver `docs/superpowers/specs/2026-09-29-unitframes-real-client-assets-design.md` y `docs/superpowers/plans/2026-09-29-unitframes-real-client-assets.md`.
    - Nuevo archivo `KullThranUI/Modules/VisualThemes/ThemeClientAssets.lua` (herramienta de render pura, sin logica de adaptador), registrado en el TOC justo despues de `ThemeBorderKit.lua`.
    - Funciones `KT.VisualThemes:ApplyClassicUnitFrameArt(frame, unitRegion, healthBarTexture)` / `:ClearClassicUnitFrameArt(frame)`. La barra de vida usa `Interface\TargetingFrame\UI-StatusBar` (archivo real, ya validado en esta sesion para la textura "Blizzard" del Damage Meter). El retrato/marco usa `Interface\TargetingFrame\UI-TargetingFrame`, una hoja real de ruta fija (no atlas, sin riesgo de sustitucion) -- direccionada con `SetTexCoord`, no `SetAtlas`.
    - **OUTSTANDING MANUAL QA ITEM (provisional, sin cliente de WoW en este entorno)**: se asumieron unas dimensiones de hoja de 256x128px (tamano habitual de las hojas de UI clasicas de esta epoca, no medido) y un recorte cuadrado de 58x58px en la esquina superior izquierda para la pieza de retrato/marco -- ambas cosas son una suposicion razonada, no una medicion, igual que el recorte original de `ThemeBorderKit.lua`. Debe comprobarse en juego (aplicar sobre un frame de prueba, mirar, ajustar `PORTRAIT_ART_SHEET_WIDTH/HEIGHT` y `PORTRAIT_ART_CROP_W/H` en `ThemeClientAssets.lua` si la pieza se ve estirada, cortada, o muestra la parte equivocada de la hoja) antes de darlo por correcto visualmente.
    - Verificado por lectura de codigo (sin arnes automatizado para esta capa, igual que el borde de `ThemeBorderKit`): ambas funciones son nil-safe ante un `frame`/`unitRegion`/`healthBarTexture` nunca inicializado, y la textura de retrato se crea una sola vez (cacheada en `frame._ktClassicPortraitArt`) y se reposiciona -- nunca se recrea -- en llamadas repetidas.

30. **Nuevo plan (Tarea 2 de 3 -- funciones de Forever)**: `KT.VisualThemes:ApplyForeverUnitFrameArt(frame, unitRegion)` / `:ClearForeverUnitFrameArt(frame)`, anadidas a `ThemeClientAssets.lua`.
    - Nombre de atlas elegido: `"ui-hud-unitframe-player-portraiton"`. Razonamiento: la investigacion de esta misma sesion sobre el sistema de atlas de Forever ya confirmo que el cliente Forever sustituye un rango de nombres de atlas de unit frame modernos por su propio arte bronce bajo el mismo nombre -- es decir, llamar `SetAtlas` con uno de esos nombres DENTRO de Forever ya dibuja el arte real de Forever, no el arte retail neutro (ese es precisamente el motivo por el que Retail no puede reusar esos nombres con seguridad). Para el tema Forever esa misma sustitucion es justo lo que se busca. `"ui-hud-unitframe-player-portraiton"` es un nombre real y plausible de esa misma familia de atlas de unit frame moderno.
    - **OUTSTANDING MANUAL QA ITEM (provisional, sin cliente de WoW en este entorno)**: nunca se ha confirmado en vivo que este nombre concreto resuelva via `C_Texture.GetAtlasInfo` dentro del cliente Forever, ni que se vea como un anillo de retrato al aplicarlo. Si no resuelve, la funcion ya cae de forma segura y silenciosa al aspecto actual de solo-acento (sin anillo, sin error) -- nada se rompe, el anillo simplemente no aparece hasta corregir el nombre tras la QA.
    - Verificado por lectura de codigo (trazado a mano de ambos casos): si el atlas resuelve, crea/reposiciona/muestra el anillo (una sola creacion, cacheada en `frame._ktForeverPortraitArt`); si no resuelve, `ClearForeverUnitFrameArt` con `art = nil` es un no-op completo -- nunca se llega a crear la textura ni a llamar `SetAtlas`, el frame queda exactamente como antes de esta tarea.

31. **Nuevo plan (Tarea 3 de 3, cierre -- conexion en `KUIUnitFrames.lua`)**: `ApplyClassicFrameArt(frame, unit)` (dentro de `CreateUnifiedBorder`, 5 sitios de llamada -- uno por unidad) ahora, ademas del marco clasico ya existente, llama a `KT.VisualThemes:GetRenderedTheme()` una vez y dispara Classic/Forever de forma independiente entre si y del bloque de borde: `ApplyClassicUnitFrameArt(frame, frame, frame.Health and frame.Health:GetStatusBarTexture())` cuando el tema es `"classic"` (si no, `ClearClassicUnitFrameArt`), y `ApplyForeverUnitFrameArt(frame, frame)` cuando el tema es `"forever"` (si no, `ClearForeverUnitFrameArt`). `unitRegion` es el mismo `frame` que ya usa el marco clasico (el rectangulo unificado completo, no solo el sub-widget de retrato) -- reutilizado tal cual, sin introducir un segundo anclaje.
    - **Confirmado sin necesitar campo nuevo de adaptador**: el interruptor real en este archivo es `db.profile.frameArtKit` (no `uSettings.frameArtKit` como conjeturaba el plan -- nombre distinto, mismo mecanismo global no-por-unidad), y `KT.VisualThemes:GetRenderedTheme()` ya existe y se usa en otras partes de esta base de codigo -- ambas senales necesarias ya existian, no hizo falta anadir ningun campo ni test de ida-y-vuelta nuevo.
    - `luac -p` limpio. La suite automatizada (`tests/visual_themes.lua`) sigue en verde tras el cambio, pero ese archivo no carga `KUIUnitFrames.lua` -- solo confirma que nada mas se rompio, no prueba el codigo nuevo (no hay arnes de render en este entorno).
    - Verificado por lectura de codigo (trazado de los 4 temas): en `classic` se aplica el arte Classic y se limpia Forever; en `forever` se aplica Forever y se limpia Classic; en `retail` y en `kui` se limpian ambos (cero "apply" en los dos, que es justo lo correcto ya que ninguno de los dos recibe arte nuevo en este plan). El bloque de marco clasico preexistente sigue su propio interruptor `frameArtKit`, consistente en la practica con `GetRenderedTheme()` gracias al arreglo I3 de la revision final del plan anterior.
    - **OUTSTANDING MANUAL QA ITEM, el mas importante de este plan de 3 tareas (sin cliente de WoW en este entorno)**: comprobar en juego el ciclo `kui -> classic -> forever -> retail -> kui` en UnitFrames y verificar (a) si el retrato de Classic se lee como arte real de Blizzard clasico o si el recorte provisional de la entrada 29 necesita ajuste, (b) si el anillo de Forever aparece en absoluto (el nombre de atlas de la entrada 30 nunca se confirmo en vivo) y si se lee como un anillo de retrato, y (c) que Retail y kui no muestren ningun resto de decoracion nueva.

32. **Ronda de arreglo de la revision final de todo este plan de 3 tareas (3 hallazgos Importantes de codigo + 1 de proceso, sin Criticos ni Menores)**. La revision final encontro que las Tareas 1-3 (entradas 29-31) tenian el dato bien pero la conexion mal: el arte nuevo nunca se veria en juego tal cual estaba, independientemente de si el recorte o el atlas fueran correctos. Las firmas y el sitio de llamada descritos en las entradas 29-31 ya NO son exactos tras este arreglo (ver abajo el estado final).
    - **I1 -- el arte se dibujaba debajo de los propios widgets del frame**: ambas texturas se creaban directamente sobre el `frame` exterior, pero `Health`/`Portrait`/`unifiedBorder` son frames-hijos independientes que SIEMPRE se dibujan por encima de las texturas propias de su padre, sin importar capa/sublevel -- el arte nuevo habria quedado invisible en juego. Confirmado contra el propio archivo: `BuildBorderFrame` crea `unifiedBorder` con `SetFrameLevel(frame:GetFrameLevel() + 10)` (sin cambiar strata), y un comentario ya existente en este mismo archivo documenta que el widget `Portrait` se crea deliberadamente en STRATA "MEDIUM"/nivel 50 "siempre por encima del frame LOW" -- exactamente este mismo problema, ya resuelto una vez en esta base de codigo con un salto de strata, no solo de nivel. Arreglo: nueva funcion `EnsureArtHost(frame, cacheKey)` en `ThemeClientAssets.lua` que crea un frame-hijo dedicado a STRATA "MEDIUM" / nivel `frame:GetFrameLevel() + 20`; ambas texturas (Classic y Forever) ahora se crean sobre ese host, no sobre `frame` directamente.
    - **I2 -- el retrato cuadrado se estiraba sobre todo el frame ancho**: se conectaba con `unitRegion = frame`, estirando una pieza pensada para ser cuadrada a una proporcion de ~5:1. El propio archivo ya tiene el idioma `frame.Portrait and frame.Portrait.backdrop` (con `frame` como respaldo) usado en mas de 10 sitios distintos. Era una contradiccion real entre el bloque de Interfaces del plan ("la region de retrato/fondo") y el texto literal del Paso 2 de la Tarea 3 ("el mismo unitRegion que ya usa el borde" = frame) -- el implementador siguio el Paso 2 al pie de la letra y lo declaro sin problema, asi que hizo falta un fallo del controlador, no una culpa. Arreglo: `ApplyClassicFrameArt` calcula ahora `portraitRegion = (frame.Portrait and frame.Portrait.backdrop) or frame` una sola vez y lo pasa como `unitRegion` a ambas funciones.
    - **I3 -- Classic re-aplicaba la textura de la barra de vida en cada pase de render**: sobrescribia lo que el propio seed del tema classic (o una eleccion manual del usuario) ya hubiera puesto, y era redundante ademas -- el seed de `classic` ya pone `healthBarTexture = "Blizzard"`, confirmado antes en esta misma sesion como una resolucion real via LSM al mismo archivo `Interface\TargetingFrame\UI-StatusBar` que esta funcion forzaba a mano. Arreglo: se elimino el parametro `healthBarTexture` y la llamada `SetTexture` de `ApplyClassicUnitFrameArt` por completo (firma final: `ApplyClassicUnitFrameArt(frame, unitRegion)`, dos argumentos); el sitio de llamada en `KUIUnitFrames.lua` ya no pasa un tercer argumento.
    - **I4 -- hallazgo de proceso, sin cambio de codigo**: el nombre de atlas de la entrada 30 (`ui-hud-unitframe-player-portraiton`) pertenece a la misma familia que la spec llama "nombre retail" al bloquear el tema Retail -- pero para Forever es exactamente el mecanismo de sustitucion que la propia spec describe, usado a proposito. El razonamiento ya estaba escrito en el comentario del codigo y en la entrada 30; solo faltaba una linea formal de decision en el ledger del plan, ahora anadida alli.
    - **Estado final tras el arreglo**: `KT.VisualThemes:ApplyClassicUnitFrameArt(frame, unitRegion)` / `:ClearClassicUnitFrameArt(frame)` y `:ApplyForeverUnitFrameArt(frame, unitRegion)` / `:ClearForeverUnitFrameArt(frame)` (firmas de 2 argumentos, sin `healthBarTexture`), ambas creando su textura sobre un host de STRATA "MEDIUM" propio, y el sitio de llamada en `KUIUnitFrames.lua` pasando `portraitRegion` (retrato real, con `frame` solo como respaldo) a las dos.
    - Verificado por lectura de codigo/aritmetica (sin arnes de render en este entorno, mismo limite que el resto de este plan y del anterior): strata/nivel del nuevo host trazados contra los hechos reales ya citados arriba; el nuevo sitio de anclaje comparado contra el idioma ya existente; el seed de textura de salud confirmado que sigue fluyendo sin este codigo. `luac -p` limpio en ambos archivos. La suite automatizada sigue en verde (no carga ninguno de los dos archivos tocados).
    - **OUTSTANDING MANUAL QA ITEM**: sigue siendo el mismo de la entrada 31 (nunca se ha visto nada de esto renderizado), mas confirmar especificamente que el nuevo host de STRATA "MEDIUM" efectivamente dibuja por encima del retrato y no lo tapa al reves.

33. **Primera QA real en juego del retrato/anillo de UnitFrames (sesion de depuracion en vivo con el usuario, 4 commits adicionales tras la entrada 32)**. `/run` esta deshabilitado en este cliente, asi que la unica via de diagnostico en vivo fue `/fstack` (herramienta nativa de Blizzard, no ejecuta script arbitrario). Cada hallazgo se confirmo con evidencia real del cliente, no solo con lectura de codigo:
    - **Nivel del host insuficiente**: `/fstack` confirmo que `_ktForeverArtHost` SI se creaba (o sea, el atlas de la entrada 30 SI resuelve en este cliente -- dato real, ya no una suposicion) y que su textura hija existia en el punto correcto, pero el arreglo original (`frame:GetFrameLevel() + 20`, relativo) resultaba en un nivel efectivo (~22) por DEBAJO del nivel fijo y absoluto que `CreatePortrait` ya usa para su propio backdrop (`SetFrameLevel(50)`, confirmado leyendo esa funcion directamente, no solo por un comentario). El arte quedaba dibujado detras del retrato, con solo las esquinas del cuadrado asomando por fuera de la mascara circular del retrato -- exactamente la forma rara que se veia. Arreglo: `ART_HOST_LEVEL` pasa a ser un nivel absoluto fijo (60), no relativo al frame exterior.
    - **Forma cuadrada forzada**: con el nivel corregido, el arte SI se veia, pero eran las esquinas cuadradas de mi textura asomando (ya no ocultas, pero tampoco recortadas a redondo). Se anadio una mascara circular real -- `Interface\AddOns\KullThranUI\Libraries\texture\media\portraits\circle_mask.tga`, el mismo archivo que este propio addon ya usa para su estilo de retrato "circular" (`PORTRAIT_MASKS.circle` en `KUIUnitFrames.lua`) -- via `CreateMaskTexture`/`AddMaskTexture`, mismo patron ya usado en ese archivo. Con esto la forma exterior salio limpia y redonda, pero el contenido de Forever seguia sin verse bien.
    - **Distorsion del atlas de Forever por estiramiento a un tamano externo**: revisando como `EllesmereUIUnitFrames.lua` pinta sus propias piezas de atlas real (estudiado por tecnica, no copiado -- funcion `ns.UF_PaintBlizzArt`), se confirmo que SIEMPRE usa el tamano nativo real de la pieza (`C_Texture.GetAtlasInfo(...).width/.height`), nunca la estira a un contenedor externo. `ApplyForeverUnitFrameArt` forzaba el atlas a un cuadrado igual al alto del retrato, deformandolo. Arreglo: usar el tamano nativo real, sin mascara (una pieza de atlas real ya viene bien recortada, no como mi recorte manual de Classic).
    - **Tamano nativo real demasiado grande**: con el tamano nativo puro, el anillo salio con la forma correcta (redondo, sin deformar, confirmado visualmente por el usuario) pero mucho mas grande que el retrato compacto de KUI (este atlas esta pensado para un frame de Retail a escala real) -- sobresalia hacia la izquierda del frame. Arreglo final de esta ronda: escalar el atlas de forma uniforme (conservando su proporcion real) para que su dimension mayor coincida con el alto del retrato, en vez de usar el tamano nativo sin escalar o forzarlo a un cuadrado.
    - **Peticion pendiente, aparcada por riesgo**: el usuario pidio que, en vez de escalar el arte real al tamano que ya tiene el retrato de KUI, sea el propio retrato (y probablemente el ancho de la barra) el que adopte las proporciones reales del atlas/asset cuando el tema mande. Se investigo el punto de enganche real (`PP.Size(frame.Portrait.backdrop, adjPortraitH, adjPortraitH)` dentro de un calculo de layout compartido que tambien fija el ancho del frame y reancla la barra de vida, repetido en al menos 4 sitios del archivo -- jugador, objetivo, focus, boss) y se decidio, de acuerdo con el usuario, NO tocarlo todavia: el riesgo de romper el tamano para TODOS los temas (no solo Forever/Retail) es real dado lo entrelazado que esta ese calculo. Queda como mejora futura con su propio estudio cuidadoso, tocando esos 4 sitios uno a uno con pruebas en juego de por medio.
    - Commits de esta ronda: arreglo de nivel absoluto, mascara circular, tamano nativo del atlas, escalado proporcional final.
    - **OUTSTANDING MANUAL QA ITEM**: confirmar en juego el resultado del ultimo commit (escalado proporcional) -- la ultima captura de esta sesion ("casi") corresponde al commit ANTERIOR (tamano nativo sin escalar, demasiado grande), el escalado final aun no se ha visto renderizado. El retrato real de Classic (recorte manual de `UI-TargetingFrame`, mascara circular) tampoco se ha confirmado visualmente todavia -- el contenido del recorte sigue siendo una suposicion no verificada, distinta del problema (ya resuelto) de forma/tamano de Forever.

34. **Correccion de direccion: el atlas nativo ya estaba bien, hay que agrandar el retrato/barras, no encoger el atlas**. Tras ver renderizado el escalado proporcional de la entrada 33 (atlas reducido para caber en el alto del retrato de KUI), el usuario corrigio: el atlas nativo sin escalar YA encajaba bien ("el icono cabia perfectamente"), y el resultado escalado hacia abajo "esta fatal". La peticion real, repetida desde la entrada 33 ("Peticion pendiente, aparcada por riesgo"), es la contraria a lo que se implemento: agrandar el retrato/barras para que coincidan con el tamano real del atlas, nunca encoger el atlas real para caber en el tamano arbitrario que ya tenia el retrato de KUI.
    - **Revertido**: `ApplyForeverUnitFrameArt` en `ThemeClientAssets.lua` vuelve a usar el tamano nativo puro del atlas (`art:SetSize(nativeW, nativeH)`, sin el escalado proporcional de la entrada 33).
    - **Mecanismo nuevo, de riesgo minimo**: en vez de tocar directamente los 4+ sitios de calculo de layout ya identificados como muy entrelazados (entrada 33, "aparcada por riesgo"), se anadio una funcion nueva y aislada `KT.VisualThemes:GetPortraitSizeOverride()` en `ThemeClientAssets.lua`: devuelve `nil` para todo excepto para el tema `forever` con el atlas de la entrada 30 resuelto (en cuyo caso devuelve `math.max(atlas.width, atlas.height)`). Se confirmo por lectura de `KUIUnitFrames.lua` que **no existe una unica funcion compartida** para el calculo de `adjPortraitH` -- son **7 sitios independientes** (jugador, objetivo x2 duplicados, focus x2 duplicados, jugador-con-pool-de-clase, objetivo-con-pool-de-clase), cada uno con su propia expresion inline (`barHeight + pSizeAdj`, `playerHeightWithCp + pSizeAdj`, etc.). Se aplico el mismo cambio mecanico y uniforme a los 7: `local adjPortraitH = (override) or (expresion original del sitio)`. Para todo tema excepto forever-con-atlas-resuelto, `override` es `nil` y el comportamiento de los 7 sitios queda exactamente igual que antes (cero cambio para kui/retail/classic). Para forever con el atlas resuelto, los 7 sitios ahora usan el tamano real del atlas en vez de la formula original basada en `barHeight`/`pSizeAdj`, haciendo que el retrato (y todo lo anclado a el: ancho del frame, barras) crezca para encajar con el arte real, tal y como pidio el usuario.
    - **Riesgo deliberadamente no cubierto por esta correccion**: el "objetivo" del `else` de la linea 4866/6622 anade `pSizeAdj + 10` *despues* de calcular `adjPortraitH` en 2 de los 7 sitios (a diferencia de los otros 5) -- irrelevante para el override en si (el override ignora `pSizeAdj` por completo cuando esta activo), pero significa que ese ajuste posterior de `pSizeAdj` sigue aplicandose a otro codigo mas abajo en esos 2 sitios incluso cuando el override esta activo; no se investigo si eso causa un efecto secundario visible en el layout de "objetivo" bajo Forever, queda como parte del mismo QA manual pendiente.
    - Verificado por lectura de codigo (sin arnes de render, mismo limite del resto de este documento): `luac -p` limpio en `ThemeClientAssets.lua` y `KUIUnitFrames.lua`; la suite automatizada (`tests/visual_themes.lua`) sigue en verde (no carga ninguno de los dos archivos, no prueba el codigo nuevo).
    - **OUTSTANDING MANUAL QA ITEM**: confirmar en juego que, bajo el tema Forever, el retrato y las barras ahora crecen al tamano real del atlas (en vez de que el atlas se encoja), y que el resultado visual coincide con lo que el usuario describio como correcto ("el icono cabia perfectamente"). El recorte de Classic sigue sin confirmar (mismo pendiente de la entrada 33), y `GetPortraitSizeOverride()` deliberadamente solo cubre `forever` por ahora -- extenderlo a `classic` (con un tamano "real" propio, a definir, ya que Classic no tiene metadatos de `GetAtlasInfo` al ser un recorte manual de un archivo de ruta fija) queda pendiente para cuando se resuelva el contenido real del recorte de Classic.

35. **QA en vivo de la entrada 34: el tamano nativo puro resulto ser demasiado grande para un frame compacto**. Captura del usuario tras aplicar la entrada 34: el anillo (a tamano nativo, sin escalar) resulto enorme -- eclipsando por completo la barra de vida, que quedaba aplastada y semi-oculta dentro del propio anillo en vez de verse limpia al lado. Causa identificada: este atlas concreto esta pensado para un frame de Retail a escala real (una UI mucho mas grande que un frame compacto de KUI); ademas, la proporcion real Blizzard entre el anillo de retrato y el ancho de la barra de vida vive en el XML propio del frame nativo de Blizzard, no en este atlas por si solo -- igualar pixeles nativos 1:1 nunca iba a reproducir esa proporcion real por si mismo. Se presento la situacion al usuario con 3 opciones (escalar el override con un factor fijo, fijar un tamano de portrait manual ignorando el pixel size real, o volver al escalado-para-caber de la entrada 33) y eligio la primera.
    - **Arreglo**: nueva constante `FOREVER_ATLAS_SCALE = 0.55` en `ThemeClientAssets.lua`, un factor de ajuste fijo (no derivado) aplicado de forma identica en los dos sitios que antes usaban el tamano nativo puro: (a) `ApplyForeverUnitFrameArt` ahora dibuja el anillo a `nativeW/H * FOREVER_ATLAS_SCALE` en vez de `nativeW/H` sin escalar, y (b) `GetPortraitSizeOverride()` devuelve `max(nativeW, nativeH) * FOREVER_ATLAS_SCALE` en vez del valor nativo puro. Usar el mismo factor en ambos sitios es deliberado: si solo se escalara el arte visual pero no el override (o viceversa), el anillo y la region del retrato a la que esta anclado dejarian de coincidir en tamano, volviendo a producir desbordamiento o hueco vacio alrededor del anillo.
    - **Naturaleza de la constante**: 0.55 es un valor ajustado a ojo a partir de la proporcion visible en la captura del usuario, no medido ni derivado matematicamente de ningun dato real (a diferencia del tamano nativo del atlas, que si es un dato real via `GetAtlasInfo`). Se espera tener que reajustarlo tras verlo renderizado con el valor nuevo -- es el mismo tipo de "suposicion razonada pendiente de QA visual" que el recorte de `ThemeBorderKit.lua` o el recorte de Classic en la entrada 29.
    - Verificado por lectura de codigo: `luac -p` limpio en `ThemeClientAssets.lua`; la suite automatizada (`tests/visual_themes.lua`) sigue en verde (no carga este archivo, no prueba el codigo nuevo -- sin arnes de render en este entorno, mismo limite de siempre).
    - **OUTSTANDING MANUAL QA ITEM**: confirmar en juego el resultado con `FOREVER_ATLAS_SCALE = 0.55` -- si el anillo sigue demasiado grande o ahora queda demasiado pequeno, ajustar unicamente esta constante (un solo numero, un solo sitio) sin tocar ninguna otra logica.

36. **Correccion final de direccion tras QA en vivo de la entrada 35 (4 intentos fallidos en total) -- se abandona por completo el crecimiento de layout**. Captura del usuario con `FOREVER_ATLAS_SCALE = 0.55`: seguia "roto", "no encaja bien", "el portrait... enorme". Ante una quinta variante fallando en la misma direccion (crecer portrait/layout para encajar con el atlas real), se le pregunto directamente al usuario en vez de seguir ajustando numeros a ciegas. Su respuesta aclaro por fin la intencion real, que resulta ser la CONTRARIA a lo entendido en las entradas 33-35:
    - **Direccion correcta (palabras del usuario)**: "El overlay a tamano normal del frame queda con el tamano original que usan los portraits" -- el retrato NO debe crecer, se queda en su tamano normal/original de KUI. El anillo de Forever debe encajar DENTRO de ese tamano ya existente ("que encaje perfecto"), igual que la UI default de Blizzard dibuja su arte de retrato al tamano del propio retrato. Por separado -- tarea futura, no resuelta aqui -- hay que ajustar POSICION y TAMANO de las barras de vida/mana para que se sienten dentro de los rectangulos que usa la UI default de Blizzard relativos al retrato, dando la sensacion de estar usando la UI nativa. Esto es lo opuesto de "agrandar todo el layout para encajar con el atlas" (entradas 33-35) y mas cercano, en espiritu, al escalado-para-caber ya probado en la entrada 33 -- pero esa vez el problema pudo no ser la direccion en si, sino otros bugs ya corregidos desde entonces (mascara, nivel del host) mezclados con la confusion sobre crecer vs encoger.
    - **Aclaracion sobre "accent"**: el usuario confirmo que el color de acento por tema (bronce en forever, dorado en classic/retail -- el mismo mecanismo ya usado en CastBar/DamageMeter/ResourceBars/Armory, y el borde `borderColor` ya existente en UnitFrames desde el plan anterior) debe permanecer fijo al elegir un tema; el arte nuevo (anillos, recortes reales) son "detalles de cada version" que pueden variar por tema, pero nunca deben sustituir ni competir con el color de acento base. Confirmado por lectura de codigo que ninguna funcion de `ThemeClientAssets.lua` toca `borderColor` ni ningun ajuste de color -- solo crea/posiciona texturas -- asi que no hizo falta ningun cambio de codigo para este punto, solo la confirmacion.
    - **Revertido por completo**: se elimino `GetPortraitSizeOverride()` de `ThemeClientAssets.lua` y su conexion mecanica en los 7 sitios de `adjPortraitH` de `KUIUnitFrames.lua` (jugador, objetivo x2, focus x2, jugador-con-pool, objetivo-con-pool) -- los 7 sitios vuelven exactamente a su expresion original de antes de la entrada 34, sin cambio de comportamiento para ningun tema. Tambien se elimino `FOREVER_ATLAS_SCALE` (ya no aplica, era parte del mecanismo de crecimiento).
    - **Arreglo nuevo**: `ApplyForeverUnitFrameArt` ahora escala el atlas hacia ABAJO (nunca hacia arriba, nunca crece mas alla de su propio tamano nativo) para caber dentro de `unitRegion:GetHeight()` (o `GetWidth()` como respaldo si la altura no esta disponible), preservando la proporcion real del atlas (`fitScale = targetSize / max(nativeW, nativeH)`) -- nunca distorsionado a un cuadrado. `unitRegion` (el retrato real, sin cambios) es la unica referencia de tamano; nada mas en el layout se toca.
    - **Pendiente, explicitamente fuera de esta correccion**: ajustar posicion/tamano de las barras de vida y mana para que se sientan dentro de los "rectangulos" que la UI default de Blizzard usa relativos al retrato (la peticion del usuario de "copiar y adaptar" ese patron). Esto requiere datos reales de geometria del UnitFrame por defecto de Blizzard (offsets/tamanos relativos al retrato) que aun no se han investigado ni derivado en esta sesion -- se trata como su propio trabajo de seguimiento, a abordar solo despues de confirmar en juego que el anillo-dentro-del-retrato de este arreglo ya se ve bien, para no volver a apilar dos cambios sin verificar en el mismo commit (la misma leccion de las entradas 33-35).
    - **Tambien senalado por el usuario, explicitamente aparcado para su propia conversacion de diseno**: las 4 tarjetas de previsualizacion de temas (selector kui/classic/forever/retail) se ven "incompletas y horribles"; el usuario pide rehacerlas inspirandose en como lo hace EllesmereUI (estudiado por tecnica, nunca copiado). No se toco nada de esto en esta ronda -- es un rediseño visual propio, no un bug, y se abordara con su propio brainstorming/diseno una vez cerrado el ciclo de QA del retrato de Forever.
    - Verificado por lectura de codigo: `luac -p` limpio en ambos archivos; la suite automatizada (`tests/visual_themes.lua`) sigue en verde (no carga ninguno de los dos, no prueba el codigo nuevo -- sin arnes de render en este entorno, mismo limite de siempre).
    - **OUTSTANDING MANUAL QA ITEM**: confirmar en juego que, bajo Forever, el anillo ahora encaja limpiamente dentro del retrato existente (sin crecer el frame, sin distorsion) antes de tocar la geometria de las barras de vida/mana como trabajo de seguimiento.

37. **El "anillo" nunca fue un anillo: es la caja completa del frame de Blizzard, y ahora tenemos su geometria real**. QA en vivo de la entrada 36: en vez de un anillo, salio una tira horizontal fina dentro del retrato. Diagnostico: eso no es un bug de escala, es la prueba de que el atlas nunca fue un "anillo de retrato" -- es una imagen ancha y corta (232x100px nativos, casi 2.3:1) que Blizzard usa como la decoracion COMPLETA del frame (retrato + pista de barra de vida + pista de barra de mana, todo en una sola textura), no un elemento circular aislado. Encajarla dentro de una region de retrato cuadrada la aplasta a una tira fina -- exactamente lo visto.
    - **El nombre de atlas nunca fue el problema**: `ui-hud-unitframe-player-portraiton` (entrada 30) es una coincidencia real (sin distinguir mayusculas) del atlas real `UI-HUD-UnitFrame-Player-PortraitOn`. El fallo de las entradas 33-36 no fue "adivinar mal el nombre", fue "adivinar mal la forma" de lo que ese nombre realmente dibuja.
    - **De donde salen los datos reales**: `C:\Users\Pablo\Desktop\EllesmereUI-9.3.1\EllesmereUIUnitFrames\EllesmereUIUnitFrames.lua` (estudiado por tecnica y datos, nunca copiado -- los nombres de atlas y offsets en pixeles son hechos reales del cliente de Blizzard, no propiedad de ese proyecto) confirma la tabla real de geometria `ns.UF_BLIZZ` (lineas ~10732-10795): `player` = caja 232x100, `art = "UI-HUD-UnitFrame-Player-PortraitOn"`, retrato de 60x60 anclado en `TOPLEFT +24,-19` dentro de esa caja, barra de vida 124x20 en `x=85,y=40` (con su propio atlas `...-Bar-Health` + mascara), barra de poder 124x10 en `x=85,y=61`; `target` = misma caja 232x100 mirror-derecha, `art = "UI-HUD-UnitFrame-Target-PortraitOn"`, retrato 58x58 en `TOPRIGHT -26,-19`, barras de vida/mana con sus propios offsets y variantes rare/boss. EllesmereUI nunca estira estas piezas a un ancho de frame arbitrario -- mantiene la caja a su tamano nativo fijo y la escala de forma UNIFORME (comentario propio: "Blizzard Style, where the stock size is fixed").
    - **Arreglo**: nueva tabla `FOREVER_FRAME_GEOMETRY` en `ThemeClientAssets.lua` con las entradas reales de `player` y `target` (caja w/h, nombre de atlas real, punto/offset/tamano del retrato dentro de la caja). `ApplyForeverUnitFrameArt(frame, unitRegion, unit)` gana un tercer parametro `unit`: si `unit` tiene entrada en la tabla (solo `player`/`target` por ahora -- `focus`/`pet`/`boss` no tienen geometria real verificada, asi que se limpian en vez de adivinar otra forma incorrecta), calcula un unico factor de escala uniforme (`unitRegion` real / `geom.portrait.size` de referencia) y lo aplica tanto al tamano completo de la caja (`info.width/height * scale`, usando el tamano REAL resuelto por `GetAtlasInfo`, no el numero de referencia 232x100) como al offset de anclaje (`-(geom.portrait.x * scale), -(geom.portrait.y * scale)`), anclando la caja por el mismo `point` ("TOPLEFT" en player, "TOPRIGHT" en target) para que el sub-rectangulo de retrato QUE YA EXISTE dentro de la caja quede exactamente sobre `unitRegion`, sin importar el lado.
    - **Sitio de llamada actualizado**: `KUIUnitFrames.lua` ahora pasa `unit` a `VT:ApplyForeverUnitFrameArt(frame, portraitRegion, unit)` (antes solo pasaba `frame, portraitRegion`) -- `ApplyClassicFrameArt(frame, unit)` ya recibia `unit` como parametro, solo hacia falta reenviarlo.
    - **Explicitamente NO resuelto en este cambio (siguiente paso, no combinado aqui a proposito)**: la caja ahora se coloca con el tamano/posicion correctos, pero las barras de vida/mana REALES de KUI no se han movido ni redimensionado para encajar dentro de los rectangulos reales (`health`/`power` de la tabla de arriba) -- eso requiere tocar el mismo calculo de layout compartido ya senalado como arriesgado en la entrada 33, y ademas necesita saber el nivel/strata real en el que WoW dibuja `frame.Health`/`frame.Power` en este cliente (no verificable sin `/fstack` en vivo) para intercalar la caja correctamente entre el retrato y las barras. Se deja fuera a proposito, siguiendo la misma leccion repetida de las entradas 33-36: un cambio verificado a la vez.
    - Verificado por lectura de codigo/aritmetica (sin arnes de render en este entorno): `luac -p` limpio en `ThemeClientAssets.lua` y `KUIUnitFrames.lua`; la suite automatizada (`tests/visual_themes.lua`) sigue en verde (no carga ninguno de los dos, no prueba el codigo nuevo).
    - **OUTSTANDING MANUAL QA ITEM**: confirmar en juego que la caja de arte ahora aparece con la forma y proporcion correctas (ancha, no cuadrada ni en tira) alineada con el retrato real de player/target, y observar concretamente si tapa el texto/relleno de las barras de vida o poder (muy probable dado que aun no se ha resuelto el intercalado de capas) -- ese dato en vivo es lo que decide el siguiente paso (mover las barras reales vs. ajustar solo el nivel/strata de la caja).

38. **QA en vivo de la entrada 37: la forma de la caja ya es correcta (anillo circular real, visible), pero "aun no esta bien encajado"**. Captura del usuario: por primera vez en 6 intentos, el resultado es un anillo circular de verdad alrededor del retrato -- avance real. Pero la barra de vida no esta alineada con el a la manera de la UI real de Blizzard (haya un salto/discontinuidad visible entre el anillo y la barra en vez de la union continua del diseño original), porque la barra de vida real de KUI seguia en su posicion/tamano normal (calculada por el layout compartido existente), totalmente independiente de donde la geometria real de Blizzard dice que deberia estar la pista de la barra dentro de la misma caja.
    - **Arreglo**: se completa el paso explicitamente aplazado en la entrada 37. `FOREVER_FRAME_GEOMETRY` gana las entradas `health`/`power` (rectangulo real dentro de la caja: player `health={x=85,y=40,w=124,h=20}`, `power={x=85,y=61,w=124,h=10}`; target `health={x=23,y=40,w=126,h=20}`, `power={x=23,y=61,w=134,h=10}`, tambien de la tabla real `ns.UF_BLIZZ` de EllesmereUI). `ApplyForeverUnitFrameArt` ahora, tras posicionar la caja, reancla `frame.Health`/`frame.Power` (si existen) a `TOPLEFT` de la propia caja (`art`) con el mismo factor de escala uniforme ya calculado para la caja -- **solo se toca el ancla/tamano**, el texture/color/mask de relleno que ya elegio el usuario (o el seed del tema) no se toca para nada.
    - **Por que es seguro sobrescribir la posicion normal sin restaurarla explicitamente al salir de Forever**: se confirmo (leyendo `KUIUnitFrames.lua`) que `CreateUnifiedBorder` (que llama a `ApplyClassicFrameArt`, que llama a esta funcion) se ejecuta SIEMPRE despues de que el layout compartido ya posziono `frame.Health`/`frame.Power` normalmente para este pase de render: sobrescribir despues es seguro. Y un cambio de tema en este addon siempre pasa por un `ReloadUI()` completo (confirmado en otra parte de este mismo documento) -- no existe un camino de "cambiar de tema sin recrear el frame", asi que nunca puede quedar una barra pegada en la posicion de Forever tras cambiar a otro tema.
    - **Explicitamente NO resuelto todavia**: las pistas de fondo reales de las barras (atlas `...-Bar-Health`/`...-Bar-Mana` con sus propias mascaras) no se dibujan -- las barras se reancla al rectangulo real pero conservan el fondo/relleno propios de KUI. Tampoco se ha resuelto el intercalado de capas exacto entre la caja y las barras (mismo pendiente de la entrada 37) -- la caja sigue en el mismo host/nivel ya verificado por encima del retrato, sin verificar aun si tapa o no el relleno/texto de las barras ahora que estan en la posicion real.
    - Verificado por lectura de codigo/aritmetica (sin arnes de render en este entorno): `luac -p` limpio en `ThemeClientAssets.lua`; la suite automatizada (`tests/visual_themes.lua`) sigue en verde.
    - **OUTSTANDING MANUAL QA ITEM**: confirmar en juego si la barra de vida (y poder, si esta visible) ahora se alinea limpiamente con el anillo/caja sin salto visible, y si el texto/relleno de la barra queda tapado por la caja (siguiente cosa a arreglar si ocurre, ajustando el nivel/strata de la caja o de las barras).

39. **Error real en juego tras la entrada 38: ciclo de anclaje ("Cannot anchor to a region dependent on it")**. El primer intento de reanclar `frame.Health` directamente a `art` rompio el frame de player con un error de Blizzard en vez de solo verse mal -- la primera vez que un cambio de esta ronda produce un ERROR real (no solo un problema visual). Mensaje exacto: `Action[SetPoint] failed because[Cannot anchor to a region dependent on it]: attempted from: StatusBar:SetPoint`, con `_ktForeverArtHost` como "Relative" y el frame del jugador como parte de la cadena "Dependent".
    - **Causa raiz**: confirmada leyendo `KUIUnitFrames.lua` (lineas 3216-3220, y las mismas 3 veces mas repetidas en otros pases de layout, ~6334-6344, 6651-6661, 6980-6990) -- en el modo `portraitSide == "top"` (retrato desacoplado/encima), KUI ya ancla `frame.Portrait.backdrop` **relativo a `frame.Health`** (`backdrop:SetPoint("BOTTOM", frame.Health or frame, "TOP", ...)`), justo al reves de la direccion habitual. La entrada 38 anclaba `art` a `unitRegion` (que puede SER ese mismo `Portrait.backdrop`), y luego anclaba `health` a `art` -- cerrando el ciclo: `health -> art -> Portrait.backdrop -> health`. Blizzard detecta y bloquea este ciclo en tiempo real con un error, no un simple defecto visual.
    - **Arreglo**: `health`/`power` ya no se anclan a `art` (ni a nada derivado de `unitRegion`). Se leen las coordenadas de pantalla YA RESUELTAS de `art` (`art:GetLeft()`/`GetTop()`, una lectura puntual, no una dependencia de anclaje en vivo) y se calcula su offset relativo a `frame` (`originX = artLeft - frameLeft`, `originY = artTop - frameTop`); `health`/`power` se anclan directamente a `frame` (objetivo siempre seguro -- `frame` nunca depende de sus propios hijos Health/Portrait) usando `originX/Y + geom.health.x/y * scale`. Mismo rectangulo real de destino, sin crear ninguna dependencia de anclaje nueva hacia `art`/`unitRegion`. Si `GetLeft()/GetTop()` devuelven `nil` (frame aun no dispuesto en este pase), la reubicacion de barras se omite ese pase sin error -- degradacion segura, no un crash.
    - Verificado por lectura de codigo/aritmetica (sin arnes de render en este entorno, y sin forma de reproducir un ciclo de anclaje fuera de un cliente real): `luac -p` limpio en `ThemeClientAssets.lua`; la suite automatizada (`tests/visual_themes.lua`) sigue en verde.
    - **OUTSTANDING MANUAL QA ITEM**: confirmar en juego que el error ya no aparece (en player Y en el modo `portraitSide == "top"` especificamente, que es el que lo disparo) y que la barra de vida/poder sigue aterrizando en el rectangulo real correcto tras el cambio de metodo de anclaje.

40. **QA en vivo de la entrada 39: el error de anclaje desaparecio, el encaje esta "casi", y sobra el borde generico de KUI alrededor**. Captura del usuario: sin errores, la barra de vida ya se ve pegada al anillo real, avance solido ("casi lo encajas, te queda poco"). Pero senala un borde amarillo rectangular alrededor de todo el conjunto (retrato + barra de vida + barra de poder) que "creo que sobra".
    - **Causa**: ese borde amarillo es el borde generico propio de KUI (`ApplyBorderAppearance`, ya existente para TODOS los temas, independiente de VisualThemes -- pinta `frame.unifiedBorder` segun `borderColor`/`borderSize` del perfil). Antes de esta ronda tenia sentido (era la unica decoracion del frame); ahora que el arte real de Forever ya aporta su propio marco visual (el anillo + la caja), ese borde generico queda como decoracion redundante encima del arte real, exactamente lo que se ve en la captura.
    - **Arreglo**: `ApplyForeverUnitFrameArt` ahora devuelve `true` cuando efectivamente dibujo la caja real (geometria conocida + atlas resuelto), `nil` en cualquier otro caso. `ApplyClassicFrameArt` en `KUIUnitFrames.lua` captura ese valor (`usingForeverRealArt`) y, solo cuando es `true`, llama a `frame.unifiedBorder:Hide()` -- nunca se llama a `:Show()` desde este nuevo codigo, para no reactivar un borde que el usuario haya puesto a `borderSize = 0` a proposito en cualquier otro tema.
    - Verificado por lectura de codigo (sin arnes de render en este entorno): `luac -p` limpio en `ThemeClientAssets.lua` y `KUIUnitFrames.lua`; la suite automatizada (`tests/visual_themes.lua`) sigue en verde.
    - **OUTSTANDING MANUAL QA ITEM**: confirmar en juego que el borde amarillo generico ya no aparece cuando el arte real de Forever esta activo (player/target), y que sigue apareciendo con normalidad en kui/retail/classic y en unidades sin geometria real (focus/pet/boss) donde `usingForeverRealArt` sera siempre `false`.

41. **QA en vivo de la entrada 40: sin borde sobrante, pero el texto de la barra (nombre + porcentaje) se solapa**. Captura del usuario: el borde amarillo ya no aparece, el anillo/barra ya encajan en el sitio correcto -- pero el texto queda apretado/solapado ("D:AFK" y el porcentaje pegados). El usuario sugirio simplificar el enfoque completo si esto se complicaba mas; se le pregunto y confirmo seguir con la geometria real, arreglando solo el texto.
    - **Causa**: `textOverlay` (el frame que contiene el texto de nombre/valor) usa `SetAllPoints(frame.Health)`, asi que su TAMAÑO ya sigue en vivo el nuevo ancho/alto real de la barra (eso no era el problema). El problema es el TAMAÑO DE FUENTE: sigue fijo al valor que el usuario configuro para el ancho ANTIGUO (normalmente mucho mas ancho) de la barra; al encoger la barra al ancho real de Blizzard (bastante mas estrecho: `health.w=124` nativos frente al `portrait.size=60` de referencia, en la practica bastante menos que el ancho tipico configurado en KUI), el mismo texto ya no cabe y se solapa.
    - **Arreglo**: nueva funcion `ScaleForeverBarText(fs, scale)` en `ThemeClientAssets.lua`: lee el tamano de fuente ACTUAL de un FontString solo la primera vez (lo cachea como `fs._ktForeverBaseFontSize`, nunca lo vuelve a leer de `GetFont()` en pasadas posteriores) y siempre reaplica `base * scale` -- evita que pasadas repetidas compongan el encogimiento (encoger sobre lo ya encogido), y sigue reaccionando bien si `scale` cambia entre pasadas (p. ej. el usuario ajusta el tamano del retrato). Se aplica a `frame.LeftText`, `frame.RightText` y `frame.CenterText` (nombre, valor de vida, y texto central si lo hay) con el mismo factor de escala ya calculado para la caja y las barras.
    - Verificado por lectura de codigo (sin arnes de render en este entorno): `luac -p` limpio en `ThemeClientAssets.lua`; la suite automatizada (`tests/visual_themes.lua`) sigue en verde.
    - **OUTSTANDING MANUAL QA ITEM**: confirmar en juego que el texto ya no se solapa y sigue siendo legible al tamano reducido (si queda demasiado pequeno para leerse, la alternativa seria truncar/abreviar el texto en vez de encogerlo mas).

42. **El anillo nunca rodeaba bien el portrait real: se anclaba por una esquina fija, ignorando el lado/posicion real que KUI usa**. El usuario senalo, sin captura esta vez, un problema de fondo: "no estas teniendo en cuenta nuestros elementos y adaptando el overlay a ellos, parece que coges una posicion fija porque nunca esta el borde rodeando correctamente al portrait". Diagnostico confirmado leyendo el propio codigo: `ApplyForeverUnitFrameArt` anclaba la caja por `geom.portrait.point` ("TOPLEFT" fijo para player, "TOPRIGHT" fijo para target -- la convencion de la propia hoja de referencia de Blizzard), asumiendo que el retrato de KUI esta SIEMPRE en ese mismo lado. Pero KUI es totalmente configurable (`portraitSide` puede ser left/right/top, adjunto o no) -- si el usuario tiene el retrato en un lado distinto al que asume la tabla, el ancla por esquina fija coloca la caja donde Blizzard esperaria el retrato, no donde esta el retrato REAL de este usuario. El anillo "por coincidencia" quedaba mas o menos cerca, nunca correctamente centrado.
    - **Arreglo**: nueva funcion `PortraitCenterInBox(geom)` que convierte el rectangulo de retrato de la tabla (dado relativo a una esquina, como lo expresa el dato real de Blizzard) a su CENTRO en coordenadas locales de la caja, sin importar la esquina de origen. `ApplyForeverUnitFrameArt` ahora ancla la caja por **CENTRO a CENTRO** (`art:SetPoint("CENTER", unitRegion, "CENTER", ...)`) en vez de esquina a esquina -- alineando el centro real del retrato de KUI (`unitRegion`, que YA esta correctamente posicionado sea cual sea el `portraitSide`/adjunto que el usuario configuro) con el centro del sub-rectangulo de retrato conocido dentro de la caja real. Esto funciona para cualquier lado/posicion sin necesitar saber ni asumir donde esta el retrato -- se adapta a los elementos reales de KUI en vez de imponer una posicion fija.
    - El reanclaje de las barras de vida/poder (entrada 38) no cambia: ya usaba la posicion REAL resuelta de la caja (`art:GetLeft()/GetTop()`), no una suposicion de esquina, asi que no tenia este mismo bug.
    - Verificado por lectura de codigo/aritmetica (sin arnes de render en este entorno): recalculo a mano para player y target confirmando que `PortraitCenterInBox` reproduce los mismos centros esperados en ambos casos; `luac -p` limpio en `ThemeClientAssets.lua`; la suite automatizada (`tests/visual_themes.lua`) sigue en verde.
    - **OUTSTANDING MANUAL QA ITEM**: confirmar en juego que el anillo ahora rodea correctamente el retrato real en la configuracion actual del usuario (el `portraitSide` que tenga puesto), y en particular probar con un `portraitSide` distinto al que se vio roto antes, ya que ese es exactamente el caso que este arreglo corrige.

43. **QA en vivo de la entrada 42: el anillo ya rodea bien el retrato -- pide 3 ajustes finales de pulido**. Captura del usuario: el anillo circular por fin encierra el retrato correctamente (el arreglo de centro-a-centro funciono). Pide: (1) encoger un poco mas el overlay para que abrace mejor el icono, (2) moldear el ancho de las barras de vida/poder, (3) mover el nombre a la "pestañita" de arriba (el tab de nombre real de Blizzard, separado de la barra de vida), y (4) aplicar lo mismo a target.
    - **(1) Encogido fino**: nueva constante `FOREVER_BOX_FUDGE_SCALE = 0.92`, aplicada al MISMO `scale` que ya usan la caja, las barras y el texto (nunca un fudge independiente por pieza -- eso volveria a desalinear el anillo respecto a las barras). Valor ajustado a ojo, no derivado; es la unica constante a tocar si sigue sin encajar del todo.
    - **(3)/(4) Pestaña de nombre real**: se anadieron las entradas `name` a `FOREVER_FRAME_GEOMETRY` para AMBOS `player` (`x=88,y=-27,w=96`) y `target` (`x=30,y=-26,w=120`), tambien de la tabla real `ns.UF_BLIZZ` de EllesmereUI (el campo `level` -- el numero en el circulo al otro extremo de la pestaña -- se dejo fuera a proposito, el usuario solo pidio el nombre). `ApplyForeverUnitFrameArt` ahora reancla `frame.LeftText` (el texto de nombre en la configuracion POR DEFECTO de KUI, `leftTextContent = "name"`) a esa pestaña real, fuera de la barra de vida -- `frame.RightText` (el valor/porcentaje) se queda en la barra, que ahora tiene todo su ancho solo para si misma. Como el codigo ya era generico por `unit` desde la entrada 37, target recibe el mismo tratamiento automaticamente en cuanto tiene su propia entrada `name` en la tabla -- no hizo falta logica nueva para "hacer lo mismo con target".
    - **(2) Ancho de barras**: no se toco un numero adicional aparte del fudge global -- la expectativa es que mover el nombre fuera de la barra (punto 3) ya libere suficiente espacio para que el porcentaje se lea bien sin mas cambios; si tras esta ronda las barras siguen viendose mal moldeadas, hace falta una nueva captura para saber en que direccion (mas anchas, mas altas, distinta proporcion) ajustar especificamente, en vez de adivinar un numero mas sin datos.
    - **Limitacion conocida, no resuelta**: el nombre solo se mueve si esta en `frame.LeftText` (la configuracion por defecto). Un usuario que haya reasignado `leftTextContent` a otra cosa no vera su nombre movido por este cambio -- no se investigo como identificar el contenido real de cada FontString desde `ThemeClientAssets.lua` (no tiene acceso a `settings` de `KUIUnitFrames.lua`) dado el alcance de esta ronda.
    - Verificado por lectura de codigo (sin arnes de render en este entorno): `luac -p` limpio en `ThemeClientAssets.lua`; la suite automatizada (`tests/visual_themes.lua`) sigue en verde.
    - **OUTSTANDING MANUAL QA ITEM**: confirmar en juego (player y target) que el anillo encaja mejor con el nuevo factor de encogido, que el nombre aparece en la pestaña de arriba en vez de sobre la barra, y si el ancho/alto de las barras de vida y poder todavia necesita un ajuste especifico una vez visto el resultado con el nombre ya fuera de en medio.

44. **Correccion estructural de geometria y capas del frame Forever**. La textura visible del atlas mide aproximadamente 198x71, pero vive centrada dentro de una caja de layout de 232x100. El codigo anterior dimensionaba el atlas como textura visible y despues aplicaba offsets de la caja completa sobre su esquina, por lo que retrato y barras no podian coincidir. Ademas, la caja dependia del retrato circular, el retrato dependia de Health y Health se recolocaba desde la caja: aunque se evitara el error directo de anclaje, cada reaplicacion podia introducir deriva. El host tambien usaba `MEDIUM/60` fijo, por encima de las barras y en conflicto con el barrido de strata de UnitFrames.
    - **Arreglo**: el frame exterior es ahora la caja estable 232x100, escalada uniformemente desde su ancho configurado. El atlas conserva su tamano visible nativo y se centra dentro de esa caja; portrait, Health, Power y la pestana del nombre se anclan como hermanos al mismo marco. Se eliminaron el factor visual `0.92`, las lecturas `GetLeft/GetTop` y la dependencia circular.
    - **Capas y reutilizacion**: el orden se calcula desde el Health real, sin strata absoluto: retrato -> arte -> barras -> textos. Classic reutiliza el mismo contrato completo de caja estable y escala uniforme para player/target, con sus rectangulos vanilla propios y el arte opaco inmediatamente por encima de las barras. Su target vuelve al lado derecho nativo. Retail, que no activa arte extra ni retrato con su preset actual, conserva el layout normal y queda fuera del camino de stock art en lugar de heredar geometria de Forever.
    - **Textura de barras**: Health, Power, fondo y absorcion mantienen las texturas/colores de KUI, pero reciben las mascaras nativas de los tracks para que el relleno respete su forma real. Los anchos salen de la geometria verificada (`124/124` player, `126/134` target), todos bajo la misma escala.
    - **Pruebas**: nuevo arnes `tests/theme_client_assets.lua` con frames simulados. Comprueba caja, tamano visible del atlas, offsets con signo correcto, anchos player/target, mascaras, orden de capas Forever/Classic, limpieza y estabilidad tras dos aplicaciones consecutivas. `tests/visual_themes.lua`, el nuevo arnes y `luac -p` pasan.
    - **OUTSTANDING MANUAL QA ITEM**: hacer `/reload` con el preset Forever y comprobar player/target en juego. El arnes verifica la aritmetica y las relaciones de capas, pero la composicion final del atlas solo puede validarse visualmente dentro del cliente.

45. **Se encontro el arbol de trabajo con la entrada 44 aplicada pero sin terminar (crash real), mas 3 pendientes nuevos del usuario -- se completa la pestana de nombre/buffs de Forever**. Al retomar la sesion, `ThemeClientAssets.lua`/`KUIUnitFrames.lua`/el adaptador de UnitFrames y ambos arneses de test estaban modificados en el working tree (sin commit) con el trabajo de la entrada 44 ya aplicado. La tabla `FOREVER_FRAME_GEOMETRY.player/target.name` habia quedado a medio migrar a `{ h = 14 }` (sin `x`/`y`/`w`), rompiendo `tests/theme_client_assets.lua` con un error real en tiempo de ejecucion (`attempt to perform arithmetic on field 'x' (a nil value)`, linea 507) -- el trabajo de separar "pestana de nombre" y "buffs" en sus propios rectangulos reales se habia empezado pero no se habia terminado.
    - **Arreglo del crash**: se restauraron `x`/`y`/`w` en la entrada `name` de ambos `player` (`x=88,y=-27,w=96`) y `target` (`x=30,y=-26,w=120`), conservando el `h=14` ya anadido. `tests/theme_client_assets.lua` vuelve a pasar sin tocar sus aserciones existentes (todas seguian esperando esos mismos valores).
    - **Peticion nueva del usuario tras ver el resultado de la entrada 44 en juego**: (a) el anillo seguia quedando algo alejado del retrato real -- diagnostico en curso, no resuelto en esta entrada, la estructura ya es la correcta (caja estable + hermanos), pendiente de una captura para saber si hace falta un ajuste fino de escala; (b) el texto de vida debe ir ENCIMA de la barra (ya resuelto por `KT:ApplyStockUFHealthTextGeometry`, parte de la entrada 44, sin cambios aqui); (c) mover los buffs a la pestana superior vacia y poner el nombre en esa misma pestana, con la regla de que el texto se ajuste si es mas grande que el espacio disponible -- explicitamente solo para Forever por ahora.
    - **Arreglo (c)**: nueva funcion `FitTextToWidth(fs, maxWidth)` en `ThemeClientAssets.lua` -- reduce el tamano de fuente de un FontString SOLO si su ancho renderizado actual (`GetStringWidth()`) excede `maxWidth`, nunca lo agranda; se aplica a `frame.LeftText` (el nombre) despues de posicionarlo en la pestana y despues del escalado uniforme normal, para que un nombre largo se encoja mas alla del factor de escala del tema en vez de desbordar la pestana. `frame.Buffs` (si existe) se ancla ahora con `BOTTOMLEFT` al `TOPLEFT` de la MISMA pestana de nombre (creciendo hacia arriba, fuera del texto), usando el ancho/alto reales de la pestana para el tamano de icono y el numero de iconos por fila (mismo calculo de `perRow` que ya usa `KT:ResolveUFAuraBarGeometry` en `KUIUnitFrames.lua`, pero resuelto localmente aqui sin necesitar cruzar de archivo).
    - **Cambio en `KUIUnitFrames.lua`**: `ApplyClassicFrameArt` ya NO llama a `frame._refreshAuraBarGeometry()` cuando Forever esta activo (`usingForeverRealArt == true`) -- esa llamada generica reancla los buffs relativo a Health y deshacia inmediatamente la colocacion en la pestana. Classic y el resto de temas no cambian: siguen llamando al refresco generico como antes.
    - **Posicion de los buffs, primera pasada sin confirmar en juego**: se interpreto "mover los buffs arriba del marco... y en ese mismo marco debe ir el nombre" como: el nombre vive DENTRO del rectangulo real de la pestana, los buffs se anclan JUSTO ENCIMA de ese mismo rectangulo (creciendo hacia arriba desde su borde superior) para no solaparse con el texto del nombre. Es una interpretacion razonada, no confirmada -- si el resultado en juego no es el esperado, es el primer sitio a revisar.
    - **Test nuevo**: se extendio `MakeUnitFrame()` en `tests/theme_client_assets.lua` con un `frame.Buffs` simulado, y se anadieron aserciones para el punto de anclaje, offset (compartido con el nombre), ancho/alto (los de la pestana) y tamano de icono resultante.
    - Verificado por lectura de codigo y ejecucion real (no solo lectura, a diferencia del resto de este documento -- esta vez SI hay arnes automatizado para esta logica): `luac -p` limpio en los 3 archivos tocados; `tests/visual_themes.lua` y `tests/theme_client_assets.lua` (extendido) pasan ambos.
    - **OUTSTANDING MANUAL QA ITEM**: confirmar en juego (player y target, Forever) que (1) el nombre aparece en la pestana superior real en vez de sobre la barra, encogiendose si es largo; (2) los buffs aparecen inmediatamente encima de esa pestana sin solaparse con el nombre; (3) si la posicion de los buffs no es la esperada por el usuario, ajustar unicamente el anclaje de `frame.Buffs` en `ApplyForeverUnitFrameArt` (un solo bloque de codigo); y (4) seguir con el ajuste fino del anillo (punto (a) de esta entrada) una vez lo anterior este confirmado.

46. **QA en vivo de la entrada 45: el nombre no aparece en absoluto en la pestana -- bug real de que slot de texto "es" el nombre**. Captura del usuario: el anillo ya encaja mejor, pero confirmo explicitamente que el nombre "no aparece en absoluto ahi arriba" tras preguntarselo directamente (en vez de asumirlo de la captura, dado que estaba recortada justo encima de la barra). Tambien senalo que el texto/icono de AFK no esta centrado donde esta la vida ahora, pero el mismo lo atribuyo a un problema mas general de iconos de UnitFrames, no especifico de este trabajo -- no se toco en esta entrada.
    - **Causa raiz confirmada por lectura de codigo**: tanto `ApplyForeverUnitFrameArt` como `ApplyClassicUnitFrameArt` asumian que el nombre SIEMPRE vive en `frame.LeftText` (el valor por defecto de `leftTextContent`). Si el perfil de este usuario tiene el nombre asignado a otro slot (`rightTextContent == "name"` o `centerTextContent == "name"`, algo que `ThemeClientAssets.lua` no puede saber porque no tiene acceso a `settings`), mover `frame.LeftText` a la pestana no mueve nada util -- el nombre real seguia en el slot correcto de antes (la barra de vida), sin verse en la pestana. Se documento esta limitacion como conocida en la entrada 45 sin resolverla; esta entrada la resuelve.
    - **Bug relacionado, encontrado al investigar**: `KT:ApplyStockUFHealthTextGeometry` (entrada 44) ya protegia `frame.LeftText` de volver a la barra de vida cuando `leftContent == "name"`, pero NO tenia la misma proteccion para `frame.RightText` ni `frame.CenterText` -- si el nombre estuviera en cualquiera de esos dos slots, esta funcion lo habria reanclado de vuelta a la barra de vida justo despues de que la pestana lo hubiera colocado arriba, ganando la carrera por ser la ultima en ejecutarse dentro de `ApplyClassicFrameArt`.
    - **Arreglo**: `ApplyClassicFrameArt` en `KUIUnitFrames.lua` ahora resuelve, ANTES de llamar a Classic/Forever, cual de los 3 slots (`centerTextContent`, `rightTextContent`, `leftTextContent`, en ese orden de prioridad) vale `"name"`, y guarda el FontString correspondiente en `frame._ktStockNameText` (o `nil` si ninguno lo es). `ThemeClientAssets.lua` ahora usa `frame._ktStockNameText or frame.LeftText` en vez de `frame.LeftText` a secas, en AMBAS funciones (Classic y Forever). `KT:ApplyStockUFHealthTextGeometry` gana el mismo guard `~= "name"` para `rightContent` y `centerContent` que ya tenia `leftContent`, cerrando la condicion de carrera.
    - **Test nuevo**: en `tests/theme_client_assets.lua`, un frame con `_ktStockNameText = frame.RightText` confirma que la pestana se posiciona sobre `RightText` (no sobre `LeftText`, que queda intacto) cuando el override esta presente.
    - Verificado por lectura de codigo y ejecucion real: `luac -p` limpio en `ThemeClientAssets.lua` y `KUIUnitFrames.lua`; `tests/visual_themes.lua` y `tests/theme_client_assets.lua` (extendido) pasan ambos.
    - **OUTSTANDING MANUAL QA ITEM**: confirmar en juego que el nombre ahora SI aparece en la pestana superior (en el slot de texto que sea, segun la configuracion real de este perfil). El punto (a) de la entrada 45 (ajuste fino de la distancia anillo-retrato) y el punto del icono de AFK descentrado siguen sin resolver, pendientes de su propia investigacion.

47. **QA en vivo de la entrada 46: "sigue igual" -- causa raiz real: `ReloadFrames()` solo reaplicaba el tema en 1 de 4 bloques por unidad**. El usuario confirmo que el nombre seguia sin aparecer, y ademas senalo con mas detalle: el texto de vida sigue "muy a la derecha, fuera del marco", y el icono/texto de AFK (que sustituye al valor de vida via tag de oUF cuando el jugador esta AFK) tampoco esta centrado -- ambos sintomas resultaron ser la MISMA causa.
    - **Causa raiz**: `ReloadFrames()` (la funcion que reaplica el estilo en cada refresco de ajustes, sin recrear los frames desde cero) tiene 4 bloques de codigo separados e inline, uno por unidad (player, target, focus, y un cuarto), cada uno con su propia llamada a `frame._applyTextPositions(settings)` (el posicionador de texto POR DEFECTO de KUI, que asume el ancho de barra normal/sin tema). La correccion de la entrada 44 (mover `ApplyClassicFrameArt(frame, unit)` para que se ejecute DESPUES de `_applyTextPositions`, y asi ganar la carrera) solo se aplico a UNO de los 4 bloques -- confirmado con `grep` contando las llamadas: 4 apariciones de `_applyTextPositions(settings)` pero solo 1 de `ApplyClassicFrameArt(frame, unit)` dentro de `ReloadFrames()`. En los otros 3 bloques (player, target y focus, confirmados por sus comentarios explicitos "(player)"/"(target)"/"(focus)"), el posicionamiento de texto por defecto de KUI ganaba la carrera en CADA recarga de ajustes, dejando el texto de vida (y por tanto tambien "AFK", que ocupa el mismo FontString cuando sustituye el tag) en su posicion antigua, pensada para una barra mucho mas ancha que la real de Forever/Classic -- de ahi que se viera "muy a la derecha, fuera del marco".
    - **Arreglo**: se anadio `ApplyClassicFrameArt(frame, unit)` inmediatamente despues de cada uno de los 3 bloques de `_applyTextPositions(settings)` que aun no lo tenian (player, target, focus), replicando exactamente el mismo patron ya usado en el cuarto bloque. Como `ApplyForeverUnitFrameArt`/`ApplyClassicUnitFrameArt` ya son idempotentes (disenadas para reaplicarse en cada pase sin efectos secundarios acumulativos, verificado desde la entrada 44), llamarla una vez mas por bloque es seguro -- solo repite el mismo trabajo, no lo duplica de forma incorrecta.
    - **Por que esto tambien explica el icono de AFK**: "AFK" no es un icono nuevo ni un elemento de `frame.Buffs` -- es el mismo `frame.RightText` (o el slot que corresponda) mostrando el tag de estado de oUF en vez del valor de vida cuando el jugador esta AFK. Al arreglar el reanclaje de ese mismo FontString, el texto de "AFK" deberia quedar tan bien posicionado como el valor de vida normal, sin necesitar ningun cambio adicional.
    - Verificado por lectura de codigo y ejecucion real: `luac -p` limpio en `KUIUnitFrames.lua`; `tests/visual_themes.lua` y `tests/theme_client_assets.lua` pasan ambos (esta correccion vive enteramente en el flujo de refresco de `ReloadFrames()`, que ninguno de los dos arneses ejecuta -- sin cobertura automatizada nueva para este bug concreto).
    - **OUTSTANDING MANUAL QA ITEM**: confirmar en juego, tras un cambio de ajustes cualquiera (no solo el primer `/reload`) que dispare `ReloadFrames()`, que el nombre aparece en la pestana, el valor de vida/AFK queda dentro del marco de la barra, y los buffs siguen en su sitio -- las 4 unidades (player/target/focus/la cuarta) deberian comportarse igual ahora que las 4 tienen el mismo reaplique.

48. **QA en vivo de la entrada 47: "sigue igual" otra vez -- resulta ser una peticion de estilo (centrado), no el mismo bug sin resolver; ademas target tiene su propio problema de encaje de textura**. El usuario aclaro que el texto de vida (y el mismo texto cuando muestra "AFK") tiene que ir CENTRADO en la barra, no solo dentro de sus limites -- `ApplyStockUFHealthTextGeometry` lo anclaba a la derecha (`RIGHT`) a proposito, replicando un layout de barra ancha, no el diseno real centrado de Blizzard. Por separado, senalo que en target la textura de Forever no encaja bien con el retrato, ademas de sufrir los mismos problemas que player.
    - **Arreglo (centrado)**: `frame.RightText` (el valor/estado que antes se anclaba a `RIGHT` de `health` con -2px) ahora se ancla a `CENTER` de `health`, con `SetJustifyH("CENTER")` -- coincide con el diseno real de Blizzard (un unico valor centrado en la barra), y de paso resuelve el aspecto de "AFK" descentrado sin cambios adicionales (mismo FontString).
    - **Target -- investigacion sin resolver**: se releyo `SeatStockPortrait`, la tabla `FOREVER_FRAME_GEOMETRY.target` y el centrado del atlas (`art:SetPoint("CENTER", host, "CENTER")`, identico para player y target) sin encontrar una asimetria de codigo evidente entre ambas unidades -- la logica es generica por `geom`/`portrait.point` y no distingue player de target de ninguna forma que explique un fallo especifico de encaje. Las causas mas probables que NO se pueden verificar sin ver el resultado real son: (a) el atlas real de target (`UI-HUD-UnitFrame-Target-PortraitOn`) resuelve con dimensiones reales distintas a las asumidas, distorsionando su encaje aunque el codigo sea correcto; o (b) el contenido visual del propio atlas de target no esta tan bien mirrorado/alineado como se asumio. Dado que ya van dos rondas seguidas de "sigue igual" sin poder confirmar si un cambio de codigo tuvo efecto, no se hizo ningun cambio de codigo para target en esta entrada -- adivinar un tercer numero sin ver el resultado en juego seria repetir el mismo error que ya costo varias rondas en las entradas 33-37.
    - Verificado por lectura de codigo y ejecucion real (solo el cambio de centrado, target no se toco): `luac -p` limpio en `KUIUnitFrames.lua`; `tests/visual_themes.lua` y `tests/theme_client_assets.lua` pasan ambos.
    - **OUTSTANDING MANUAL QA ITEM**: confirmar en juego que el valor de vida/AFK ahora aparece centrado en player Y target. Para el problema especifico de encaje de la textura de target, hace falta una captura dedicada de target (las capturas hasta ahora se han centrado en player) antes de intentar otro cambio de codigo.
