class Vehiculo {
  final int? id;
  final String patente;
  final String marca;
  final String modelo;
  final int? anio;
  final String? color;
  final int? capacidad;
  final String? tipo;
  final String estado;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Vehiculo({
    this.id,
    required this.patente,
    required this.marca,
    required this.modelo,
    this.anio,
    this.color,
    this.capacidad,
    this.tipo,
    this.estado = 'activo',
    this.createdAt,
    this.updatedAt,
  });

  factory Vehiculo.fromJson(Map<String, dynamic> json) {
    return Vehiculo(
      id: json['id'],
      patente: json['patente'] ?? json['plate'] ?? json['license_plate'] ?? '',
      marca: json['marca'] ?? json['brand'] ?? '',
      modelo: json['modelo'] ?? json['model'] ?? '',
      anio: json['anio'] ?? json['year'],
      color: json['color'],
      capacidad: json['capacidad'] ?? json['capacity'],
      tipo: json['tipo'] ?? json['type'],
      estado: json['estado'] ?? json['status'] ?? 'activo',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'patente': patente,
      'marca': marca,
      'modelo': modelo,
      if (anio != null) 'anio': anio,
      if (color != null) 'color': color,
      if (capacidad != null) 'capacidad': capacidad,
      if (tipo != null) 'tipo': tipo,
      'estado': estado,
    };
  }
}