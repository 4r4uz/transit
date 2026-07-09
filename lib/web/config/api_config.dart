class ApiConfig {
  // TODO: Confirmar URL base del backend FastAPI con el equipo
  // Por defecto asume localhost para desarrollo local
  static const String baseUrl = 'http://localhost:8000/api/v1';
  
  // Endpoints de autenticación
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';
  
  // Endpoints de gestión (ajustar según endpoints reales del backend)
  static const String rutas = '/rutas';
  static const String choferes = '/choferes';
  static const String vehiculos = '/vehiculos';
  static const String viajes = '/viajes';
  static const String tracking = '/tracking';
  
  // Timeout para requests
  static const Duration timeout = Duration(seconds: 30);
}