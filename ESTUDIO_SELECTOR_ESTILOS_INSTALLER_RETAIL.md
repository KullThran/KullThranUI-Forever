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
