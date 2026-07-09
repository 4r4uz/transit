import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vehiculos_provider.dart';
import '../models/vehiculo.dart';

class VehiculosScreen extends StatefulWidget {
  const VehiculosScreen({super.key});

  @override
  State<VehiculosScreen> createState() => _VehiculosScreenState();
}

class _VehiculosScreenState extends State<VehiculosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehiculosProvider>().fetchVehiculos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VehiculosProvider>(
      builder: (context, vehiculosProvider, child) {
        if (vehiculosProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (vehiculosProvider.errorMessage != null) {
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
                      'Error al cargar vehículos',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(vehiculosProvider.errorMessage!),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => vehiculosProvider.fetchVehiculos(),
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
            // Header con botón crear
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Gestión de Vehículos',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showFormDialog(context),
                    icon: Icon(Icons.add),
                    label: Text('Nuevo Vehículo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Tabla de vehículos
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 48),
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Patente')),
                        DataColumn(label: Text('Marca')),
                        DataColumn(label: Text('Modelo')),
                        DataColumn(label: Text('Año')),
                        DataColumn(label: Text('Capacidad')),
                        DataColumn(label: Text('Estado')),
                        DataColumn(label: Text('Acciones')),
                      ],
                      rows: vehiculosProvider.vehiculos.map((vehiculo) {
                        return DataRow(
                          cells: [
                            DataCell(Text(vehiculo.id?.toString() ?? '-')),
                            DataCell(Text(vehiculo.patente)),
                            DataCell(Text(vehiculo.marca)),
                            DataCell(Text(vehiculo.modelo)),
                            DataCell(Text(vehiculo.anio?.toString() ?? '-')),
                            DataCell(Text(vehiculo.capacidad?.toString() ?? '-')),
                            DataCell(
                              Chip(
                                label: Text(
                                  vehiculo.estado,
                                  style: TextStyle(fontSize: 12),
                                ),
                                backgroundColor: vehiculo.estado == 'activo' 
                                    ? Colors.green[100] 
                                    : Colors.red[100],
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue, size: 20),
                                    onPressed: () => _showFormDialog(context, vehiculo: vehiculo),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red, size: 20),
                                    onPressed: () => _confirmDelete(context, vehiculo),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFormDialog(BuildContext context, {Vehiculo? vehiculo}) {
    final isEditing = vehiculo != null;
    final patenteController = TextEditingController(text: vehiculo?.patente ?? '');
    final marcaController = TextEditingController(text: vehiculo?.marca ?? '');
    final modeloController = TextEditingController(text: vehiculo?.modelo ?? '');
    final anioController = TextEditingController(text: vehiculo?.anio?.toString() ?? '');
    final colorController = TextEditingController(text: vehiculo?.color ?? '');
    final capacidadController = TextEditingController(text: vehiculo?.capacidad?.toString() ?? '');
    final tipoController = TextEditingController(text: vehiculo?.tipo ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Editar Vehículo' : 'Nuevo Vehículo'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: patenteController,
                decoration: InputDecoration(
                  labelText: 'Patente',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: marcaController,
                decoration: InputDecoration(
                  labelText: 'Marca',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: modeloController,
                decoration: InputDecoration(
                  labelText: 'Modelo',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: anioController,
                decoration: InputDecoration(
                  labelText: 'Año',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: colorController,
                decoration: InputDecoration(
                  labelText: 'Color',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: capacidadController,
                decoration: InputDecoration(
                  labelText: 'Capacidad',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: tipoController,
                decoration: InputDecoration(
                  labelText: 'Tipo',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final nuevoVehiculo = Vehiculo(
                id: vehiculo?.id,
                patente: patenteController.text,
                marca: marcaController.text,
                modelo: modeloController.text,
                anio: anioController.text.isNotEmpty ? int.tryParse(anioController.text) : null,
                color: colorController.text.isEmpty ? null : colorController.text,
                capacidad: capacidadController.text.isNotEmpty ? int.tryParse(capacidadController.text) : null,
                tipo: tipoController.text.isEmpty ? null : tipoController.text,
                estado: vehiculo?.estado ?? 'activo',
              );

              final provider = context.read<VehiculosProvider>();
              bool success;
              
              if (isEditing) {
                success = await provider.updateVehiculo(nuevoVehiculo) != null;
              } else {
                success = await provider.createVehiculo(nuevoVehiculo) != null;
              }

              if (success && context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEditing ? 'Vehículo actualizado' : 'Vehículo creado'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(provider.errorMessage ?? 'Error'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(isEditing ? 'Guardar' : 'Crear'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Vehiculo vehiculo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Vehículo'),
        content: Text('¿Está seguro de eliminar el vehículo "${vehiculo.patente}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await context.read<VehiculosProvider>().deleteVehiculo(vehiculo.id!);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Vehículo eliminado' : 'Error al eliminar'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}