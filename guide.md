# Plan de Implementación: Panel de Gestión Web (RuraLink/UrbaLink)

## Contexto del proyecto (leer antes de empezar)

Este panel es el módulo de administración web del sistema **RuraLink/UrbaLink**, sistema de gestión de transporte rural público para la Municipalidad de Río Negro (Los Lagos, Chile).

- **Stack app móvil existente**: Flutter/Dart
- **Backend**: FastAPI (Python), mismos endpoints que consume la app móvil — NO se crean endpoints admin nuevos, se reutiliza la API existente
- **Base de datos**: PostgreSQL self-hosted
- **Mapas**: OpenStreetMap + Leaflet (en Flutter usar `flutter_map`)
- **Deployment**: Cloudflare Tunnel para exposición LAN/pública
- **State management**: Provider (mismo patrón que el resto del proyecto, NO introducir Riverpod/Bloc)
- **Rol del solicitante**: Jefe de Proyecto / Analista Programador Full-Stack (Nicolás Arauz)

## Objetivo

Construir un panel de gestión web en Flutter (target `web`) que permita a administradores municipales gestionar rutas, choferes, vehículos y visualizar operación en tiempo real, consumiendo la misma API FastAPI que usa la app móvil de usuarios.

## Restricciones obligatorias

1. Usar **Provider** para state management. No introducir otro patrón.
2. Consumir la **misma API FastAPI** existente. Antes de crear cualquier llamada nueva, revisar los endpoints ya implementados para la app móvil y reutilizarlos.
3. Mantener consistencia de estilo/estructura de carpetas con el proyecto móvil existente (mismo repo o repo hermano, según se indique).
4. El panel es de **uso interno administrativo**, no público — debe incluir capa de autenticación con rol admin.
5. Mapas: usar `flutter_map` + tiles OpenStreetMap (no Google Maps).

---

## Pasos a seguir

### Paso 1 — Setup del proyecto
1. Confirmar si el panel web vive en el mismo proyecto Flutter (agregando target `web`) o en un proyecto Flutter separado. Si no hay indicación explícita, crear proyecto separado `ruralink_admin_panel` para no mezclar builds móvil/web.
2. Habilitar soporte web: `flutter create . --platforms web` (si es proyecto nuevo, `flutter create ruralink_admin_panel`).
3. Verificar versión de Flutter/Dart SDK usada en el proyecto móvil y usar la misma para evitar incompatibilidades de paquetes compartidos.
4. Agregar dependencias base en `pubspec.yaml`:
   - `provider`
   - `http` o `dio` (usar el mismo que la app móvil para reutilizar modelos/servicios)
   - `flutter_map` + `latlong2`
   - `go_router` (navegación con rutas nombradas, necesario para deep-linking en web)
   - `flutter_secure_storage` o `shared_preferences` (para persistir token de sesión admin)

### Paso 2 — Revisar y reutilizar capa de datos existente
1. Localizar en el repo de la app móvil los archivos de: modelos (`models/`), servicios/API client (`services/` o `api/`), y constantes de endpoints.
2. Copiar o referenciar (según arquitectura de monorepo vs. multi-repo) esos modelos y servicios en el panel web, sin duplicar lógica innecesariamente.
3. Confirmar la URL base del backend FastAPI y el mecanismo de autenticación actual (JWT, sesión, API key) para replicarlo en el login admin.
4. Listar los endpoints ya disponibles que apliquen a gestión (rutas, choferes, vehículos, viajes) antes de escribir nuevas llamadas HTTP.

### Paso 3 — Autenticación admin
1. Crear pantalla de login (`login_screen.dart`) que use el mismo endpoint de auth que la app móvil, verificando rol admin en la respuesta del backend.
2. Implementar `AuthProvider extends ChangeNotifier` que maneje: estado de sesión, token, rol, y métodos `login()`, `logout()`, `isAuthenticated`.
3. Proteger rutas del panel con un guard en `go_router` (`redirect` basado en `AuthProvider`).

### Paso 4 — Estructura base del panel (layout)
1. Crear `AdminShell` (scaffold general): sidebar de navegación + área de contenido, responsive (colapsar sidebar en pantallas angostas).
2. Secciones de navegación mínimas: Dashboard, Rutas, Choferes, Vehículos, Mapa en vivo, (Reportes — opcional según alcance real del proyecto).
3. Definir rutas con `go_router`: `/login`, `/dashboard`, `/rutas`, `/choferes`, `/vehiculos`, `/mapa`.

### Paso 5 — Módulo Dashboard
1. Provider `DashboardProvider` que obtenga métricas resumen desde endpoints existentes (ej. viajes activos, choferes en ruta, alertas).
2. Vista con tarjetas/resumen (widgets simples, sin gráficos complejos salvo que ya exista una librería de charts definida en el proyecto).

### Paso 6 — Módulo Gestión de Rutas
1. `RutasProvider extends ChangeNotifier`: `fetchRutas()`, `createRuta()`, `updateRuta()`, `deleteRuta()`, usando los endpoints ya existentes.
2. Vista de listado (tabla o `DataTable`) con acciones editar/eliminar.
3. Formulario de creación/edición de ruta (modal o pantalla dedicada), validando campos según el modelo de datos real del backend.

### Paso 7 — Módulo Gestión de Choferes y Vehículos
1. Repetir patrón del Paso 6: `ChoferesProvider` y `VehiculosProvider`, cada uno con su CRUD contra los endpoints existentes.
2. Vincular chofer-vehículo-ruta si el modelo de datos del backend contempla esa relación (revisar schema real antes de asumir).

### Paso 8 — Módulo Mapa en vivo
1. Integrar `flutter_map` con tiles de OpenStreetMap.
2. `MapaProvider` que consuma el endpoint de posiciones/tracking en tiempo real (polling periódico si no hay WebSocket disponible; si el backend expone WebSocket, usarlo).
3. Mostrar marcadores de vehículos activos y trazado de rutas sobre el mapa.

### Paso 9 — Manejo de errores y estados de carga
1. Estandarizar manejo de estados `loading / error / data` en cada Provider (patrón consistente en todos los módulos).
2. Mostrar feedback visual uniforme (snackbars o banners) ante errores de red o de autorización (401/403).


---

## Entregar al finalizar cada paso
Para cada paso implementado, reportar:
- Archivos creados/modificados
- Endpoints del backend consumidos (método + ruta)
- Cualquier supuesto asumido por falta de información del modelo de datos real (para que el Jefe de Proyecto lo confirme)

## Notas finales para la IA ejecutora
- No inventar endpoints: si un endpoint necesario no existe en el backend actual, señalarlo explícitamente como bloqueante en vez de simularlo.
- No cambiar el patrón de state management a otro que no sea Provider.
- Priorizar consistencia visual/código con la app móvil existente por sobre soluciones "más modernas" no solicitadas.