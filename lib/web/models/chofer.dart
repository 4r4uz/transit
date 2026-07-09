class Chofer {
  final int? id;
  final String nombre;
  final String apellido;
  final String? rut;
  final String? licencia;
  final String? telefono;
  final String? email;
  final String estado;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Chofer({
    this.id,
    required this.nombre,
    required this.apellido,
    this.rut,
    this.licencia,
    this.telefono,
    this.email,
    this.estado = 'activo',
    this.createdAt,
    this.updatedAt,
  });

  factory Chofer.fromJson(Map<String, dynamic> json) {
    return Chofer(
      id: json['id'],
      nombre: json['nombre'] ?? json['first_name'] ?? '',
      apellido: json['apellido'] ?? json['last_name'] ?? '',
      rut: json['rut'],
      licencia: json['licencia'] ?? json['license_number'],
      telefono: json['telefono'] ?? json['phone'],
      email: json['email'] ?? '',
      estado: json['estado'] ?? json['status'] ?? 'activo',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'apellido': apellido,
      if (rut != null) 'rut': rut,
      if (licencia != null) 'licencia': licencia,
      if (telefono != null) 'telefono': telefono,
      if (email != null) 'email': email,
      'estado': estado,
    };
  }

  String get nombreCompleto => '$nombre $apellido';
}