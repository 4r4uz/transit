import 'package:flutter/material.dart';

class Horario {
  final int? id;
  final int rutaId;
  final String rutaNombre;
  final String patenteBus;
  final String choferNombre;
  final TimeOfDay horaSalida;
  final String diasSemana; // Ej: "Lun,Mar,Mie,Jue,Vie"
  final String estado; // 'programado', 'en_curso', 'completado', 'cancelado'
  final int? pasajeros;
  final String? observaciones;

  Horario({
    this.id,
    required this.rutaId,
    required this.rutaNombre,
    required this.patenteBus,
    required this.choferNombre,
    required this.horaSalida,
    required this.diasSemana,
    this.estado = 'programado',
    this.pasajeros,
    this.observaciones,
  });

  factory Horario.fromJson(Map<String, dynamic> json) {
    final horaParts = (json['hora_salida'] as String).split(':');
    return Horario(
      id: json['id'],
      rutaId: json['ruta_id'],
      rutaNombre: json['ruta_nombre'] ?? '',
      patenteBus: json['patente_bus'] ?? '',
      choferNombre: json['chofer_nombre'] ?? '',
      horaSalida: TimeOfDay(
        hour: int.parse(horaParts[0]),
        minute: int.parse(horaParts[1]),
      ),
      diasSemana: json['dias_semana'] ?? '',
      estado: json['estado'] ?? 'programado',
      pasajeros: json['pasajeros'],
      observaciones: json['observaciones'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'ruta_id': rutaId,
      'ruta_nombre': rutaNombre,
      'patente_bus': patenteBus,
      'chofer_nombre': choferNombre,
      'hora_salida': '${horaSalida.hour.toString().padLeft(2, '0')}:${horaSalida.minute.toString().padLeft(2, '0')}',
      'dias_semana': diasSemana,
      'estado': estado,
      'pasajeros': pasajeros,
      'observaciones': observaciones,
    };
  }

  String get horaSalidaFormateada {
    return '${horaSalida.hour.toString().padLeft(2, '0')}:${horaSalida.minute.toString().padLeft(2, '0')}';
  }

  String get estadoFormateado {
    switch (estado) {
      case 'programado':
        return 'Programado';
      case 'en_curso':
        return 'En Curso';
      case 'completado':
        return 'Completado';
      case 'cancelado':
        return 'Cancelado';
      default:
        return estado;
    }
  }

  Color get estadoColor {
    switch (estado) {
      case 'programado':
        return Colors.orange;
      case 'en_curso':
        return Colors.green;
      case 'completado':
        return Colors.blue;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}