import 'package:app_waa/web/models/vehiculo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../providers/mapa_provider.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // El MapaProvider inicia el polling automáticamente
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapaProvider>(
      builder: (context, mapaProvider, child) {
        if (mapaProvider.isLoading && mapaProvider.vehiculosEnRuta.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        if (mapaProvider.errorMessage != null && mapaProvider.vehiculosEnRuta.isEmpty) {
          return Center(
            child: Card(
              color: Colors.red[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    SizedBox(height: 16),
                    Text(
                      'Error al cargar mapa',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(mapaProvider.errorMessage!),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => mapaProvider.fetchVehiculosEnRuta(),
                      child: Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Column(
          children: [
            // Header con información
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mapa en Vivo',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Vehículos en ruta en tiempo real',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: mapaProvider.isPolling ? Colors.green[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: mapaProvider.isPolling ? Colors.green : Colors.grey,
                        ),
                        SizedBox(width: 6),
                        Text(
                          mapaProvider.isPolling ? 'En vivo' : 'Pausado',
                          style: TextStyle(
                            fontSize: 12,
                            color: mapaProvider.isPolling ? Colors.green[700] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Mapa
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      // Centro por defecto: Los Lagos, Chile
                      initialCenter: LatLng(-40.5736, -73.1435),
                      initialZoom: 13.0,
                      interactionOptions: InteractionOptions(
                        flags: InteractiveFlag.all,
                      ),
                    ),
                    children: [
                      // Tiles de CartoDB (más permisivo que OpenStreetMap)
                      TileLayer(
                        urlTemplate: 'https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app_waa',
                        additionalOptions: {
                          'attribution': '© OpenStreetMap contributors © CARTO',
                        },
                      ),

                      // Marcadores de vehículos
                      MarkerLayer(
                        markers: _getVehicleMarkers(mapaProvider.vehiculosEnRuta),
                      ),

                      // Capa de rutas (si hay datos)
                      // TODO: Agregar PolylineLayer cuando se implemente el trazado de rutas
                    ],
                  ),

                  // Leyenda
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Vehículos activos: ${mapaProvider.vehiculosEnRuta.length}',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Actualización: cada 10s',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<Marker> _getVehicleMarkers(List<Vehiculo> vehiculos) {
    // TODO: Reemplazar con coordenadas reales del backend
    // Por ahora generamos posiciones simuladas alrededor de Los Lagos
    
    final markers = <Marker>[];
    final baseLat = -40.5736;
    final baseLng = -73.1435;

    for (var i = 0; i < vehiculos.length; i++) {
      // Simulación: distribuir vehículos en un radio de ~0.1 grados
      final lat = baseLat + (i % 3) * 0.02 - 0.02;
      final lng = baseLng + (i ~/ 3) * 0.02 - 0.02;

      markers.add(
        Marker(
          point: LatLng(lat, lng),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              _showVehicleInfo(context, vehiculos[i]);
            },
            child: Icon(
              Icons.directions_bus,
              color: Colors.blue,
              size: 40,
            ),
          ),
        ),
      );
    }

    return markers;
  }

  void _showVehicleInfo(BuildContext context, Vehiculo vehiculo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.directions_bus, color: Colors.blue),
            SizedBox(width: 8),
            Text('Vehículo en Ruta'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow('Patente', vehiculo.patente),
            SizedBox(height: 8),
            _InfoRow('Marca', vehiculo.marca),
            SizedBox(height: 8),
            _InfoRow('Modelo', vehiculo.modelo),
            if (vehiculo.anio != null) ...[
              SizedBox(height: 8),
              _InfoRow('Año', vehiculo.anio.toString()),
            ],
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'En servicio',
                style: TextStyle(color: Colors.green[700], fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _InfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}