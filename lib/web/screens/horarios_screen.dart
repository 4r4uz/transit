import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/horarios_provider.dart';
import '../models/horario.dart';
import '../models/ruta.dart';
import '../models/vehiculo.dart';
import '../models/chofer.dart';
import '../services/mock_data_service.dart';

class HorariosScreen extends StatefulWidget {
  const HorariosScreen({super.key});

  @override
  State<HorariosScreen> createState() => _HorariosScreenState();
}

class _HorariosScreenState extends State<HorariosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HorariosProvider>().fetchHorarios();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HorariosProvider>(
      builder: (context, horariosProvider, child) {
        if (horariosProvider.isLoading && horariosProvider.horarios.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        if (horariosProvider.errorMessage != null && horariosProvider.horarios.isEmpty) {
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
                      'Error al cargar horarios',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(horariosProvider.errorMessage!),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => horariosProvider.fetchHorarios(),
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
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Horarios de Salida',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Gestión de horarios de buses',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showHorarioDialog(context, horariosProvider),
                    icon: Icon(Icons.add),
                    label: Text('Nuevo Horario'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Lista de horarios
            Expanded(
              child: horariosProvider.horarios.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.schedule, size: 64, color: Colors.grey[300]),
                          SizedBox(height: 16),
                          Text(
                            'No hay horarios registrados',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      itemCount: horariosProvider.horarios.length,
                      itemBuilder: (context, index) {
                        final horario = horariosProvider.horarios[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: horario.estadoColor.withValues(alpha: 0.2),
                              child: Icon(
                                Icons.schedule,
                                color: horario.estadoColor,
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  horario.horaSalidaFormateada,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: horario.estadoColor.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    horario.estadoFormateado,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: horario.estadoColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                Text(horario.rutaNombre),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.directions_bus, size: 16, color: Colors.grey[600]),
                                    SizedBox(width: 4),
                                    Text(
                                      '${horario.patenteBus} - ${horario.choferNombre}',
                                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                                    SizedBox(width: 4),
                                    Text(
                                      horario.diasSemana,
                                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                                if (horario.pasajeros != null) ...[
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.people, size: 16, color: Colors.grey[600]),
                                      SizedBox(width: 4),
                                      Text(
                                        '${horario.pasajeros} pasajeros',
                                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _showHorarioDialog(
                                    context,
                                    horariosProvider,
                                    horario: horario,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _confirmDelete(
                                    context,
                                    horariosProvider,
                                    horario,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
      }),
            ),
          ],
        );
      },
    );
  }

  void _showHorarioDialog(BuildContext context, HorariosProvider provider, {Horario? horario}) {
    final isEditing = horario != null;
    final rutas = MockDataService.getDemoRutas();
    final vehiculos = MockDataService.getDemoVehiculos();
    final choferes = MockDataService.getDemoChoferes();

    final rutaController = TextEditingController(
      text: isEditing ? horario.rutaNombre : '',
    );
    final patenteController = TextEditingController(
      text: isEditing ? horario.patenteBus : '',
    );
    final choferController = TextEditingController(
      text: isEditing ? horario.choferNombre : '',
    );
    final diasController = TextEditingController(
      text: isEditing ? horario.diasSemana : 'Lun,Mar,Mie,Jue,Vie',
    );
    final pasajerosController = TextEditingController(
      text: isEditing && horario.pasajeros != null ? horario.pasajeros.toString() : '',
    );
    final observacionesController = TextEditingController(
      text: isEditing && horario.observaciones != null ? horario.observaciones! : '',
    );

    Ruta? selectedRuta = isEditing 
      ? rutas.firstWhere((r) => r.id == horario.rutaId, orElse: () => rutas.first)
      : null;
    Vehiculo? selectedVehiculo = isEditing
      ? vehiculos.firstWhere((v) => v.patente == horario.patenteBus, orElse: () => vehiculos.first)
      : null;
    Chofer? selectedChofer = isEditing
      ? choferes.firstWhere((c) => '${c.nombre} ${c.apellido}' == horario.choferNombre, orElse: () => choferes.first)
      : null;

    TimeOfDay selectedTime = isEditing ? horario.horaSalida : const TimeOfDay(hour: 8, minute: 0);
    String selectedEstado = isEditing ? horario.estado : 'programado';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Editar Horario' : 'Nuevo Horario'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ruta
                DropdownButtonFormField<Ruta>(
                  initialValue: selectedRuta,
                  decoration: InputDecoration(
                    labelText: 'Ruta',
                    border: OutlineInputBorder(),
                  ),
                  items: rutas.map((ruta) {
                    return DropdownMenuItem(
                      value: ruta,
                      child: Text(ruta.nombre),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedRuta = value;
                      rutaController.text = value?.nombre ?? '';
                    });
                  },
                ),
                SizedBox(height: 16),

                // Hora de salida
                InkWell(
                  onTap: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (picked != null) {
                      setDialogState(() {
                        selectedTime = picked;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Hora de Salida',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Vehículo
                DropdownButtonFormField<Vehiculo>(
                  initialValue: selectedVehiculo,
                  decoration: InputDecoration(
                    labelText: 'Vehículo',
                    border: OutlineInputBorder(),
                  ),
                  items: vehiculos.map((vehiculo) {
                    return DropdownMenuItem(
                      value: vehiculo,
                      child: Text('${vehiculo.patente} - ${vehiculo.marca} ${vehiculo.modelo}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedVehiculo = value;
                      patenteController.text = value?.patente ?? '';
                    });
                  },
                ),
                SizedBox(height: 16),

                // Chofer
                DropdownButtonFormField<Chofer>(
                  initialValue: selectedChofer,
                  decoration: InputDecoration(
                    labelText: 'Chofer',
                    border: OutlineInputBorder(),
                  ),
                  items: choferes.map((chofer) {
                    return DropdownMenuItem(
                      value: chofer,
                      child: Text('${chofer.nombre} ${chofer.apellido}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedChofer = value;
                      choferController.text = '${value?.nombre} ${value?.apellido}';
                    });
                  },
                ),
                SizedBox(height: 16),

                // Días de la semana
                TextField(
                  controller: diasController,
                  decoration: InputDecoration(
                    labelText: 'Días de la semana',
                    hintText: 'Ej: Lun,Mar,Mie,Jue,Vie',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),

                // Estado
                DropdownButtonFormField<String>(
                  initialValue: selectedEstado,
                  decoration: InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(value: 'programado', child: Text('Programado')),
                    DropdownMenuItem(value: 'en_curso', child: Text('En Curso')),
                    DropdownMenuItem(value: 'completado', child: Text('Completado')),
                    DropdownMenuItem(value: 'cancelado', child: Text('Cancelado')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      selectedEstado = value!;
                    });
                  },
                ),
                SizedBox(height: 16),

                // Pasajeros
                TextField(
                  controller: pasajerosController,
                  decoration: InputDecoration(
                    labelText: 'Pasajeros (opcional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                // Observaciones
                TextField(
                  controller: observacionesController,
                  decoration: InputDecoration(
                    labelText: 'Observaciones (opcional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
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
              onPressed: () {
                if (selectedRuta == null || selectedVehiculo == null || selectedChofer == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor complete todos los campos requeridos')),
                  );
                  return;
                }

                final nuevoHorario = Horario(
                  id: isEditing ? horario.id : null,
                  rutaId: selectedRuta!.id!,
                  rutaNombre: rutaController.text,
                  patenteBus: patenteController.text,
                  choferNombre: choferController.text,
                  horaSalida: selectedTime,
                  diasSemana: diasController.text,
                  estado: selectedEstado,
                  pasajeros: pasajerosController.text.isNotEmpty
                    ? int.parse(pasajerosController.text)
                    : null,
                  observaciones: observacionesController.text.isNotEmpty 
                    ? observacionesController.text 
                    : null,
                );

                if (isEditing) {
                  provider.updateHorario(nuevoHorario);
                } else {
                  provider.addHorario(nuevoHorario);
                }

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEditing ? 'Horario actualizado' : 'Horario creado'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text(isEditing ? 'Guardar' : 'Crear'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, HorariosProvider provider, Horario horario) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Horario'),
        content: Text('¿Está seguro de eliminar el horario de las ${horario.horaSalidaFormateada}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteHorario(horario.id!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Horario eliminado'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}