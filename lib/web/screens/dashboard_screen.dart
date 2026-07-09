import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchMetricas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, child) {
        if (dashboardProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (dashboardProvider.errorMessage != null) {
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
                      'Error al cargar métricas',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(dashboardProvider.errorMessage!),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => dashboardProvider.fetchMetricas(),
                      child: Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              Text(
                'Bienvenido al Panel de Administración',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Resumen de la operación',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 32),

              // Resumen de Recursos
              Text(
                'Resumen',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              
              // Choferes
              Row(
                children: [
                  Expanded(
                    child: _ResourceCard(
                      title: 'Choferes Activos',
                      value: dashboardProvider.choferesActivos.toString(),
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _ResourceCard(
                      title: 'Choferes Inactivos',
                      value: dashboardProvider.choferesInactivos.toString(),
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              
              // Vehículos
              Row(
                children: [
                  Expanded(
                    child: _ResourceCard(
                      title: 'Vehículos en Ruta',
                      value: dashboardProvider.vehiculosEnRuta.toString(),
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _ResourceCard(
                      title: 'Vehículos en Mantenimiento',
                      value: dashboardProvider.vehiculosMantenimiento.toString(),
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              
              // Rutas
              Row(
                children: [
                  Expanded(
                    child: _ResourceCard(
                      title: 'Rutas Activas',
                      value: dashboardProvider.rutasActivas.toString(),
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _ResourceCard(
                      title: 'Rutas Inactivas',
                      value: dashboardProvider.rutasInactivas.toString(),
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),

              // Horarios de Hoy
              Text(
                'Horarios',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _ScheduleItem(
                        route: 'Ruta Los Lagos - Puerto Montt',
                        bus: 'ABCD-12',
                        driver: 'Juan Pérez',
                        startTime: '08:00',
                        endTime: '09:30',
                        status: 'En curso',
                        statusColor: Colors.green,
                        passengers: 18,
                      ),
                      Divider(height: 24),
                      _ScheduleItem(
                        route: 'Ruta Río Negro - Osorno',
                        bus: 'EFGH-34',
                        driver: 'María González',
                        startTime: '09:30',
                        endTime: '11:00',
                        status: 'Por salir',
                        statusColor: Colors.orange,
                        passengers: 0,
                      ),
                      Divider(height: 24),
                      _ScheduleItem(
                        route: 'Ruta Los Lagos - Puerto Montt',
                        bus: 'IJKL-56',
                        driver: 'Carlos Muñoz',
                        startTime: '10:00',
                        endTime: '11:30',
                        status: 'Por salir',
                        statusColor: Colors.orange,
                        passengers: 0,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),

              // Actividad Reciente
              Text(
                'Actividad Reciente',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ActivityItem(
                        icon: Icons.route,
                        title: 'Nueva ruta creada',
                        subtitle: 'Ruta Los Lagos → Puerto Montt',
                        time: 'Hace 2 horas',
                      ),
                      Divider(height: 24),
                      _ActivityItem(
                        icon: Icons.person_add,
                        title: 'Chofer registrado',
                        subtitle: 'Juan Pérez',
                        time: 'Hace 5 horas',
                      ),
                      Divider(height: 24),
                      _ActivityItem(
                        icon: Icons.directions_bus,
                        title: 'Vehículo asignado',
                        subtitle: 'Patente ABCD-12',
                        time: 'Hace 1 día',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 24),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _ResourceCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final String route;
  final String bus;
  final String driver;
  final String startTime;
  final String endTime;
  final String status;
  final Color statusColor;
  final int passengers;

  const _ScheduleItem({
    required this.route,
    required this.bus,
    required this.driver,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.statusColor,
    required this.passengers,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    route,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'Bus: $bus • Chofer: $driver',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  '$startTime - $endTime',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            if (passengers > 0) ...[
              SizedBox(height: 4),
              Text(
                '$passengers pasajeros',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
