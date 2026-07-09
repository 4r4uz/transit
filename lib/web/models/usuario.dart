class Usuario {
  final int id;
  final String nombre;
  final String email;
  final String rol;
  final String? token;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.rol,
    this.token,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] ?? json['user_id'] ?? 0,
      nombre: json['nombre'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      rol: json['rol'] ?? json['role'] ?? '',
      token: json['token'] ?? json['access_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'rol': rol,
      if (token != null) 'token': token,
    };
  }

  bool get isAdmin => rol.toLowerCase() == 'admin';
}