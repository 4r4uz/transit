class Ruta {
  final int? id;
  final String nombre;
  final String descripcion;
  final String origen;
  final String destino;
  final double? latitudOrigen;
  final double? longitudOrigen;
  final double? latitudDestino;
  final double? longitudDestino;
  final String estado;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Ruta({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.origen,
    required this.destino,
    this.latitudOrigen,
    this.longitudOrigen,
    this.latitudDestino,
    this.longitudDestino,
    this.estado = 'activa',
    this.createdAt,
    this.updatedAt,
  });

  factory Ruta.fromJson(Map<String, dynamic> json) {
    return Ruta(
      id: json['id'],
      nombre: json['nombre'] ?? json['name'] ?? '',
      descripcion: json['descripcion'] ?? json['description'] ?? '',
      origen: json['origen'] ?? json['origin'] ?? '',
      destino: json['destino'] ?? json['destination'] ?? '',
      latitudOrigen: json['latitud_origen']?.toDouble() ?? json['origin_lat']?.toDouble(),
      longitudOrigen: json['longitud_origen']?.toDouble() ?? json['origin_lng']?.toDouble(),
      latitudDestino: json['latitud_destino']?.toDouble() ?? json['destination_lat']?.toDouble(),
      longitudDestino: json['longitud_destino']?.toDouble() ?? json['destination_lng']?.toDouble(),
      estado: json['estado'] ?? json['status'] ?? 'activa',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'origen': origen,
      'destino': destino,
      if (latitudOrigen != null) 'latitud_origen': latitudOrigen,
      if (longitudOrigen != null) 'longitud_origen': longitudOrigen,
      if (latitudDestino != null) 'latitud_destino': latitudDestino,
      if (longitudDestino != null) 'longitud_destino': longitudDestino,
      'estado': estado,
    };
  }
}