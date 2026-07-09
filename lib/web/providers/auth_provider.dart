import 'package:flutter/foundation.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';
import '../services/mock_data_service.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  Usuario? _usuario;
  String? _errorMessage;

  AuthStatus get status => _status;
  Usuario? get usuario => _usuario;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isAdmin => _usuario?.isAdmin ?? false;

  AuthProvider() {
    init();
  }

  Future<void> init() async {
    await ApiService.init();
    await checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final token = await ApiService.getToken();
      if (token != null) {
        final usuario = await ApiService.getMe();
        _usuario = usuario;
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      notifyListeners();

      // Intentar login con API real primero
      try {
        final usuario = await ApiService.login(email, password);
        
        // Verificar que el usuario tenga rol admin
        if (!usuario.isAdmin) {
          _errorMessage = 'Acceso denegado: se requiere rol de administrador';
          _status = AuthStatus.error;
          notifyListeners();
          return false;
        }

        await ApiService.setToken(usuario.token);
        _usuario = usuario;
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } catch (apiError) {
        // Si falla la API, usar modo demo
        if (kDebugMode) {
          print('API no disponible, usando modo demo: $apiError');
        }
        
        // Verificar credenciales de demo
        if (email == MockDataService.demoEmail && password == MockDataService.demoPassword) {
          await Future.delayed(Duration(milliseconds: 500)); // Simular delay de red
          final usuario = MockDataService.getDemoUser();
          await ApiService.setToken(usuario.token);
          _usuario = usuario;
          _status = AuthStatus.authenticated;
          notifyListeners();
          return true;
        } else {
          _errorMessage = 'Credenciales incorrectas';
          _status = AuthStatus.error;
          notifyListeners();
          return false;
        }
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await ApiService.delete(ApiConfig.logout);
    } catch (e) {
      // Ignorar errores en logout
    } finally {
      await ApiService.clearToken();
      _usuario = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}