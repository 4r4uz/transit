import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/choferes_provider.dart';
import '../models/chofer.dart';

class ChoferesScreen extends StatefulWidget {
  const ChoferesScreen({super.key});

  @override
  State<ChoferesScreen> createState() => _ChoferesScreenState();
}

class _ChoferesScreenState extends State<ChoferesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChoferesProvider>().fetchChoferes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChoferesProvider>(
      builder: (context, choferesProvider, child) {
        if (choferesProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (choferesProvider.errorMessage != null) {
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
                      'Error al cargar choferes',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(choferesProvider.errorMessage!),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => choferesProvider.fetchChoferes(),
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
                      'Gestión de Choferes',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showFormDialog(context),
                    icon: Icon(Icons.add),
                    label: Text('Nuevo Chofer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Tabla de choferes
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
                        DataColumn(label: Text('RUT')),
                        DataColumn(label: Text('Licencia')),
                        DataColumn(label: Text('Teléfono')),
                        DataColumn(label: Text('Estado')),
                        DataColumn(label: Text('Acciones')),
                      ],
                      rows: choferesProvider.choferes.map((chofer) {
                        return DataRow(
                          cells: [
                            DataCell(Text(chofer.id?.toString() ?? '-')),
                            DataCell(Text(chofer.nombreCompleto)),
                            DataCell(Text(chofer.rut ?? '-')),
                            DataCell(Text(chofer.licencia ?? '-')),
                            DataCell(Text(chofer.telefono ?? '-')),
                            DataCell(
                              Chip(
                                label: Text(
                                  chofer.estado,
                                  style: TextStyle(fontSize: 12),
                                ),
                                backgroundColor: chofer.estado == 'activo' 
                                    ? Colors.green[100] 
                                    : Colors.red[100],
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue, size: 20),
                                    onPressed: () => _showFormDialog(context, chofer: chofer),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red, size: 20),
                                    onPressed: () => _confirmDelete(context, chofer),
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

  void _showFormDialog(BuildContext context, {Chofer? chofer}) {
    final isEditing = chofer != null;
    final nombreController = TextEditingController(text: chofer?.nombre ?? '');
    final apellidoController = TextEditingController(text: chofer?.apellido ?? '');
    final rutController = TextEditingController(text: chofer?.rut ?? '');
    final licenciaController = TextEditingController(text: chofer?.licencia ?? '');
    final telefonoController = TextEditingController(text: chofer?.telefono ?? '');
    final emailController = TextEditingController(text: chofer?.email ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Editar Chofer' : 'Nuevo Chofer'),
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
                controller: apellidoController,
                decoration: InputDecoration(
                  labelText: 'Apellido',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: rutController,
                decoration: InputDecoration(
                  labelText: 'RUT',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: licenciaController,
                decoration: InputDecoration(
                  labelText: 'Licencia',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: telefonoController,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
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
              final nuevoChofer = Chofer(
                id: chofer?.id,
                nombre: nombreController.text,
                apellido: apellidoController.text,
                rut: rutController.text.isEmpty ? null : rutController.text,
                licencia: licenciaController.text.isEmpty ? null : licenciaController.text,
                telefono: telefonoController.text.isEmpty ? null : telefonoController.text,
                email: emailController.text.isEmpty ? null : emailController.text,
                estado: chofer?.estado ?? 'activo',
              );

              final provider = context.read<ChoferesProvider>();
              bool success;
              
              if (isEditing) {
                success = await provider.updateChofer(nuevoChofer) != null;
              } else {
                success = await provider.createChofer(nuevoChofer) != null;
              }

              if (success && context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEditing ? 'Chofer actualizado' : 'Chofer creado'),
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

  void _confirmDelete(BuildContext context, Chofer chofer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Chofer'),
        content: Text('¿Está seguro de eliminar a "${chofer.nombreCompleto}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await context.read<ChoferesProvider>().deleteChofer(chofer.id!);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Chofer eliminado' : 'Error al eliminar'),
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