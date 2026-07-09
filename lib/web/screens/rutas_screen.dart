import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rutas_provider.dart';
import '../models/ruta.dart';

class RutasScreen extends StatefulWidget {
  const RutasScreen({super.key});

  @override
  State<RutasScreen> createState() => _RutasScreenState();
}

class _RutasScreenState extends State<RutasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RutasProvider>().fetchRutas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RutasProvider>(
      builder: (context, rutasProvider, child) {
        if (rutasProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (rutasProvider.errorMessage != null) {
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
                      'Error al cargar rutas',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(rutasProvider.errorMessage!),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => rutasProvider.fetchRutas(),
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
                      'Gestión de Rutas',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showFormDialog(context),
                    icon: Icon(Icons.add),
                    label: Text('Nueva Ruta'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Tabla de rutas
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
                        DataColumn(label: Text('Nombre')),
                        DataColumn(label: Text('Origen')),
                        DataColumn(label: Text('Destino')),
                        DataColumn(label: Text('Estado')),
                        DataColumn(label: Text('Acciones')),
                      ],
                      rows: rutasProvider.rutas.map((ruta) {
                        return DataRow(
                          cells: [
                            DataCell(Text(ruta.id?.toString() ?? '-')),
                            DataCell(Text(ruta.nombre)),
                            DataCell(Text(ruta.origen)),
                            DataCell(Text(ruta.destino)),
                            DataCell(
                              Chip(
                                label: Text(
                                  ruta.estado,
                                  style: TextStyle(fontSize: 12),
                                ),
                                backgroundColor: ruta.estado == 'activa' 
                                    ? Colors.green[100] 
                                    : Colors.red[100],
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue, size: 20),
                                    onPressed: () => _showFormDialog(context, ruta: ruta),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red, size: 20),
                                    onPressed: () => _confirmDelete(context, ruta),
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

  void _showFormDialog(BuildContext context, {Ruta? ruta}) {
    final isEditing = ruta != null;
    final nombreController = TextEditingController(text: ruta?.nombre ?? '');
    final descripcionController = TextEditingController(text: ruta?.descripcion ?? '');
    final origenController = TextEditingController(text: ruta?.origen ?? '');
    final destinoController = TextEditingController(text: ruta?.destino ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Editar Ruta' : 'Nueva Ruta'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              TextField(
                controller: origenController,
                decoration: InputDecoration(
                  labelText: 'Origen',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: destinoController,
                decoration: InputDecoration(
                  labelText: 'Destino',
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
              final nuevaRuta = Ruta(
                id: ruta?.id,
                nombre: nombreController.text,
                descripcion: descripcionController.text,
                origen: origenController.text,
                destino: destinoController.text,
                estado: ruta?.estado ?? 'activa',
              );

              final provider = context.read<RutasProvider>();
              bool success;
              
              if (isEditing) {
                success = await provider.updateRuta(nuevaRuta) != null;
              } else {
                success = await provider.createRuta(nuevaRuta) != null;
              }

              if (success && context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEditing ? 'Ruta actualizada' : 'Ruta creada'),
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

  void _confirmDelete(BuildContext context, Ruta ruta) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Ruta'),
        content: Text('¿Está seguro de eliminar la ruta "${ruta.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await context.read<RutasProvider>().deleteRuta(ruta.id!);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Ruta eliminada' : 'Error al eliminar'),
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