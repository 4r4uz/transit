import '../models/usuario.dart';
import '../models/ruta.dart';
import '../models/chofer.dart';
import '../models/vehiculo.dart';

class MockDataService {
  // Credenciales de demo
  static const String demoEmail = 'admin@ruralink.cl';
  static const String demoPassword = '123456';

  // Usuario admin de demo
  static Usuario getDemoUser() {
    return Usuario(
      id: 1,
      nombre: 'Administrador',
      email: demoEmail,
      rol: 'admin',
      token: 'demo_token_123456',
    );
  }

  // Rutas de demo
  static List<Ruta> getDemoRutas() {
    return [
      Ruta(
        id: 1,
        nombre: 'Ruta Los Lagos - Puerto Montt',
        descripcion: 'Ruta principal que conecta Los Lagos con Puerto Montt',
        origen: 'Los Lagos',
        destino: 'Puerto Montt',
        latitudOrigen: -40.5736,
        longitudOrigen: -73.1435,
        latitudDestino: -41.4693,
        longitudDestino: -72.9424,
        estado: 'activa',
      ),
      Ruta(
        id: 2,
        nombre: 'Ruta Río Negro - Osorno',
        descripcion: 'Ruta intermunicipal Río Negro - Osorno',
        origen: 'Río Negro',
        destino: 'Osorno',
        latitudOrigen: -40.7333,
        longitudOrigen: -73.2167,
        latitudDestino: -40.5739,
        longitudDestino: -73.1333,
        estado: 'activa',
      ),
      Ruta(
        id: 3,
        nombre: 'Ruta Rural Sector Norte',
        descripcion: 'Ruta rural por el sector norte de la comuna',
        origen: 'Los Lagos',
        destino: 'Sector Norte',
        latitudOrigen: -40.5736,
        longitudOrigen: -73.1435,
        latitudDestino: -40.5236,
        longitudDestino: -73.0935,
        estado: 'activa',
      ),
      Ruta(
        id: 4,
        nombre: 'Ruta Costera',
        descripcion: 'Ruta por la costa',
        origen: 'Puerto Montt',
        destino: 'Caleta La Arena',
        latitudOrigen: -41.4693,
        longitudOrigen: -72.9424,
        latitudDestino: -41.5236,
        longitudDestino: -72.8924,
        estado: 'inactiva',
      ),
    ];
  }

  // Choferes de demo
  static List<Chofer> getDemoChoferes() {
    return [
      Chofer(
        id: 1,
        nombre: 'Juan',
        apellido: 'Pérez González',
        rut: '12.345.678-9',
        licencia: 'A5-12345678',
        telefono: '+56912345678',
        email: 'juan.perez@ruralink.cl',
        estado: 'activo',
      ),
      Chofer(
        id: 2,
        nombre: 'María',
        apellido: 'González López',
        rut: '15.678.901-2',
        licencia: 'A5-87654321',
        telefono: '+56987654321',
        email: 'maria.gonzalez@ruralink.cl',
        estado: 'activo',
      ),
      Chofer(
        id: 3,
        nombre: 'Carlos',
        apellido: 'Muñoz Rojas',
        rut: '18.901.234-5',
        licencia: 'A5-11223344',
        telefono: '+56911223344',
        email: 'carlos.munoz@ruralink.cl',
        estado: 'activo',
      ),
      Chofer(
        id: 4,
        nombre: 'Ana',
        apellido: 'Silva Torres',
        rut: '21.234.567-8',
        licencia: 'A5-55667788',
        telefono: '+56955667788',
        email: 'ana.silva@ruralink.cl',
        estado: 'inactivo',
      ),
    ];
  }

  // Vehículos de demo
  static List<Vehiculo> getDemoVehiculos() {
    return [
      Vehiculo(
        id: 1,
        patente: 'ABCD-12',
        marca: 'Mercedes Benz',
        modelo: 'Sprinter',
        anio: 2020,
        color: 'Blanco',
        capacidad: 20,
        tipo: 'Bus',
        estado: 'activo',
      ),
      Vehiculo(
        id: 2,
        patente: 'EFGH-34',
        marca: 'Volvo',
        modelo: 'B8R',
        anio: 2021,
        color: 'Azul',
        capacidad: 30,
        tipo: 'Bus',
        estado: 'activo',
      ),
      Vehiculo(
        id: 3,
        patente: 'IJKL-56',
        marca: 'Toyota',
        modelo: 'Coaster',
        anio: 2019,
        color: 'Gris',
        capacidad: 15,
        tipo: 'Minibus',
        estado: 'activo',
      ),
      Vehiculo(
        id: 4,
        patente: 'MNOP-78',
        marca: 'Hyundai',
        modelo: 'County',
        anio: 2022,
        color: 'Rojo',
        capacidad: 25,
        tipo: 'Bus',
        estado: 'mantencion',
      ),
    ];
  }

  // Métricas del dashboard de demo
  static Map<String, dynamic> getDemoMetricas() {
    return {
      'viajes_activos': 12,
      'choferes_en_ruta': 8,
      'vehiculos_activos': 10,
    };
  }

  // Actividad reciente de demo
  static List<Map<String, dynamic>> getDemoActividadReciente() {
    return [
      {
        'icon': 'route',
        'title': 'Nueva ruta creada',
        'subtitle': 'Ruta Los Lagos → Puerto Montt',
        'time': 'Hace 2 horas',
      },
      {
        'icon': 'person_add',
        'title': 'Chofer registrado',
        'subtitle': 'Juan Pérez',
        'time': 'Hace 5 horas',
      },
      {
        'icon': 'directions_bus',
        'title': 'Vehículo asignado',
        'subtitle': 'Patente ABCD-12',
        'time': 'Hace 1 día',
      },
      {
        'icon': 'route',
        'title': 'Viaje completado',
        'subtitle': 'Ruta Río Negro - Osorno',
        'time': 'Hace 2 días',
      },
    ];
  }

  // Posiciones de vehículos para el mapa (simuladas)
  static List<Map<String, dynamic>> getDemoVehiculosEnRuta() {
    return [
      {
        'id': 1,
        'patente': 'ABCD-12',
        'marca': 'Mercedes Benz',
        'modelo': 'Sprinter',
        'latitud': -40.5736,
        'longitud': -73.1435,
      },
      {
        'id': 2,
        'patente': 'EFGH-34',
        'marca': 'Volvo',
        'modelo': 'B8R',
        'latitud': -40.5936,
        'longitud': -73.1235,
      },
      {
        'id': 3,
        'patente': 'IJKL-56',
        'marca': 'Toyota',
        'modelo': 'Coaster',
        'latitud': -40.5536,
        'longitud': -73.1635,
      },
    ];
  }

  // Horarios de demo
  static List<Map<String, dynamic>> getDemoHorarios() {
    return [
      {
        'id': 1,
        'ruta_id': 1,
        'ruta_nombre': 'Ruta Los Lagos - Puerto Montt',
        'patente_bus': 'ABCD-12',
        'chofer_nombre': 'Juan Pérez',
        'hora_salida': '08:00',
        'dias_semana': 'Lun,Mar,Mie,Jue,Vie',
        'estado': 'en_curso',
        'pasajeros': 18,
        'observaciones': 'Servicio normal',
      },
      {
        'id': 2,
        'ruta_id': 2,
        'ruta_nombre': 'Ruta Río Negro - Osorno',
        'patente_bus': 'EFGH-34',
        'chofer_nombre': 'María González',
        'hora_salida': '09:30',
        'dias_semana': 'Lun,Mar,Mie,Jue,Vie,Sab',
        'estado': 'programado',
        'pasajeros': 0,
        'observaciones': 'Por salir',
      },
      {
        'id': 3,
        'ruta_id': 1,
        'ruta_nombre': 'Ruta Los Lagos - Puerto Montt',
        'patente_bus': 'IJKL-56',
        'chofer_nombre': 'Carlos Muñoz',
        'hora_salida': '10:00',
        'dias_semana': 'Lun,Mar,Mie,Jue,Vie',
        'estado': 'programado',
        'pasajeros': 0,
        'observaciones': null,
      },
      {
        'id': 4,
        'ruta_id': 3,
        'ruta_nombre': 'Ruta Rural Sector Norte',
        'patente_bus': 'ABCD-12',
        'chofer_nombre': 'Juan Pérez',
        'hora_salida': '07:00',
        'dias_semana': 'Lun,Mie,Vie',
        'estado': 'completado',
        'pasajeros': 15,
        'observaciones': 'Viaje completado',
      },
      {
        'id': 5,
        'ruta_id': 2,
        'ruta_nombre': 'Ruta Río Negro - Osorno',
        'patente_bus': 'EFGH-34',
        'chofer_nombre': 'María González',
        'hora_salida': '14:00',
        'dias_semana': 'Lun,Mar,Mie,Jue,Vie',
        'estado': 'cancelado',
        'pasajeros': 0,
        'observaciones': 'Cancelado por falla mecánica',
      },
    ];
  }
}
