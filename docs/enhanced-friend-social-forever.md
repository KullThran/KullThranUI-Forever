# EnhancedFriendList y SocialUI de Forever

## Referencias comparadas

- Cliente instalado: Forever 1.60.1, build 70291 (`.build.info`).
- [Fuente de ese build](https://github.com/Gethe/wow-ui-source/tree/9465cb273b5513495d8ecc12fbb19930dd6b8957/Interface/AddOns/Blizzard_SocialUI).
- Retail usado como referencia: 12.1.0, build 69933, commit `09b9db7948abc9b9648dedaab51eb0cf3ee67b31` del mismo repositorio.
- Se compararon SocialUI, SocialUIShared, FriendsFrame, RecentAllies y documentación de API; se revisaron además AddFriend, QuickJoin, RaidFrame y RecruitAFriend de Forever.
- Copias de consulta en `scratch/social-70291`; no son dependencias del addon ni deben distribuirse.

## Diferencias que afectan a la integración

| Área | EnhancedFriendList anterior | SocialUI de Forever y diferencia frente a Retail |
| --- | --- | --- |
| Ventana | `FriendsFrame`, pestañas globales numeradas | `SocialUIFrame`, definiciones de pestañas y botones de un pool. Forever registra su ventana en UIPanelManager y calcula el espacio adicional con funciones propias. |
| Disponibilidad | Lista fija de contactos, Who, banda y acceso rápido | Amigos, Aliados recientes, solicitudes, acceso rápido, reclutamiento y banda dependen de servicios. Forever valida la disponibilidad al seleccionar una pestaña y antes de abrir ventanas asociadas. |
| Amigos | Dataset propio sobre API antigua y filas propias | Tarjetas con `accountInfo`, amigos de cuenta y de título, favoritos, notas y etiquetas. Forever obtiene intereses/roles soportados por tipo de juego; no copia el catálogo fijo de Retail. |
| Aliados recientes | Subvista dentro de contactos | Pestaña propia con búsqueda, categorías de interacción, ubicación, notas, fijación y solicitud pendiente. Forever usa nombre completo/regional y categorías de interacción distintas de los filtros de intereses de Retail. |
| Solicitudes | Acciones integradas en el dataset anterior | Lista propia, aceptación, menú de rechazo, aviso Real ID. Forever comprueba si la solicitud admite bloqueo de Battle.net y si aún existe antes de rechazar. |
| Ventanas laterales | Reparentado de frames antiguos | Mensaje de Battle.net, aviso de desconexión, ignorados y guardados de banda gestionados por `sideWindowFrames`. Forever ajusta anchuras y cierra ventanas si deja de estar disponible su pestaña. |
| Iconos de juegos | Resolver propio de EFL | Slot nativo `GameIconHolder.Icon`, con prioridad de invocación RAF. Forever usa `Enum.TitleIconVersion.Small`; se añade el resolver EFL sin invadir el estado de presencia. |
| Texto | Tamaños y anchors de las filas propias | TextSizeManager y layouts compactos/ampliados nativos. Forever tiene reglas distintas de truncamiento de nombre/clase. Se conserva el tamaño vigente y se aplica la fuente de KUI. |

## Implementación

Solo en este workspace Forever. `EnhancedFriendList_SocialUI.lua` se carga después de EnhancedFriendList en el addon Enhancements.

Cuando `C_SocialUI.IsSystemEnabled()` devuelve true, EFL restaura cualquier reparentado anterior, oculta su ventana antigua y utiliza el adaptador nuevo. Si SocialUI todavía no se ha cargado, espera a la carga normal de Blizzard. El evento de estado del servicio permite cambiar de controlador durante la sesión. Si el servicio no existe o está deshabilitado se conserva el camino anterior.

El adaptador reconstruye la estructura de EFL: ventana de 478 x 640, cabecera de 56, icono propio, panel interior, footer de 28 y navegación inferior de 34. Reubica las pestañas reales de Blizzard en esa navegación y añade sus nombres; conserva sus clics, disponibilidad, contadores y notificaciones. Usa los botones completos de EFL, incluyendo hover, pulsación y selección, y elimina también las tres piezas del botón rojo nativo.

Los controles Battle.net y los paneles nuevos conservan sus padres originales y se anclan a la estructura EFL. Las posiciones, tamaños, colores y regiones originales se restauran al desactivar. Los cambios de geometría y su restauración se posponen hasta salir del combate, ya que SocialUI puede contener el roster seguro de banda. El adaptador reutiliza las texturas y la paleta de EFL para ventana, encabezado Battle.net, filtros, botones, filas y paneles laterales. Añade sus iconos de proyecto de WoW en el slot nativo y conserva la prioridad RAF. También adapta los diálogos de añadir amigo, confirmar solicitud y amigos de amigos. Itera las definiciones y ventanas realmente presentes; no crea pestañas que el servicio no ofrezca.

Blizzard conserva datos, filtros, selección, scroll, tooltips, menús, invitaciones, restricciones y el contenido de sus paneles. El adaptador no modifica scripts de clic, búsquedas, API de amigos ni atributos seguros de los jugadores de banda. Los dropdowns mantienen sus menús nativos y los controles conservan sus iconos y feedback de selección.

Se guarda el arte sustituido y la fuente original para restaurarlos al desactivar la opción o Enhancements. Los hooks permanecen inactivos al desactivar. Las listas visibles se refrescan con los datos actuales al restaurar, evitando devolver a una fila reciclada el icono de otro amigo.

Los grupos y notas locales del antiguo dataset EFL no se convierten en etiquetas/notas de Battle.net ni se muestran como grupos nuevos en este adaptador. Sus datos guardados se conservan. La organización y los menús de la nueva lista son los de SocialUI.

## Comprobaciones

- Sintaxis de ambos módulos con Lua 5.1.
- `tests/enhanced_friend_social.lua`: carga diferida, elección real del controlador EFL, cambio de perfil, restauración del controlador anterior, reutilización de filas, callbacks nativos intactos, geometría EFL y restauración de tamaños/anchors, eliminación del botón rojo compuesto, iconos de otros juegos, escala de texto, spacers vacíos y desactivación repetida.
- Revisión del diff de los archivos afectados; no se cambian assets ni el workspace Retail.

Estas comprobaciones no equivalen a ejecutar WoW. Validación visual y funcional pendiente en el cliente:

1. `/reload`, abrir Amigos con EnhancedFriendList habilitado; cambiar a Aliados recientes y solicitudes, y desplazarse hasta reciclar filas.
2. Buscar por texto, combinar/quitar filtros, colapsar encabezados; comprobar nombres largos y subir/bajar la escala de texto.
3. Abrir estado online y menú Battle.net, copiar BattleTag y editar mensaje; abrir ignorados y amigos de amigos. Comprobar cierre, Escape y espacio reservado para las ventanas laterales.
4. Abrir añadir amigo y su página informativa; cancelar una confirmación de solicitud. Para verificar acciones que escriben datos, usar una cuenta de prueba.
5. Si los servicios las ofrecen, abrir acceso rápido, reclutamiento, banda y guardados; comprobar selección y sus controles originales.
6. Comprobar amigos Forever, Retail, Classic, otro juego y desconectados; comprobar una tarjeta con invocación RAF disponible.
7. Desactivar/reactivar EnhancedFriendList con la ventana abierta y cambiar de perfil; comprobar que vuelve el arte nativo, mantiene búsqueda/selección y no queda una segunda ventana.
