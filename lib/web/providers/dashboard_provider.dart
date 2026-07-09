import 'package:flutter/foundation.dart';
import '../services/mock_data_service.dart';

class DashboardProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  
  // Métricas del dashboard
  int _viajesActivos = 0;
  int _choferesEnRuta = 0;
  int _vehiculosActivos = 0;
  
  // Recursos
  int _choferesActivos = 0;
  int _choferesInactivos = 0;
  int _vehiculosEnRuta = 0;
  int _vehiculosMantenimiento = 0;
  int _rutasActivas = 0;
  int _rutasInactivas = 0;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  int get viajesActivos => _viajesActivos;
  int get choferesEnRuta => _choferesEnRuta;
  int get vehiculosActivos => _vehiculosActivos;
  
  int get choferesActivos => _choferesActivos;
  int get choferesInactivos => _choferesInactivos;
  int get vehiculosEnRuta => _vehiculosEnRuta;
  int get vehiculosMantenimiento => _vehiculosMantenimiento;
  int get rutasActivas => _rutasActivas;
  int get rutasInactivas => _rutasInactivas;

  Future<void> fetchMetricas() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // TODO: Reemplazar con llamadas reales a los endpoints del backend
      // Por ahora usamos datos mock para demo
      await Future.delayed(Duration(milliseconds: 500));
      
      // Usar datos mock de demo
      final metricas = MockDataService.getDemoMetricas();
      _viajesActivos = metricas['viajes_activos'] ?? 0;
      _choferesEnRuta = metricas['choferes_en_ruta'] ?? 0;
      _vehiculosActivos = metricas['vehiculos_activos'] ?? 0;
      
      // Obtener recursos
      final choferes = MockDataService.getDemoChoferes();
      _choferesActivos = choferes.where((c) => c.estado == 'activo').length;
      _choferesInactivos = choferes.where((c) => c.estado == 'inactivo').length;
      
      final vehiculos = MockDataService.getDemoVehiculos();
      _vehiculosEnRuta = vehiculos.where((v) => v.estado == 'activo').length;
      _vehiculosMantenimiento = vehiculos.where((v) => v.estado == 'mantencion').length;
      
      final rutas = MockDataService.getDemoRutas();
      _rutasActivas = rutas.where((r) => r.estado == 'activa').length;
      _rutasInactivas = rutas.where((r) => r.estado == 'inactiva').length;

      // Ejemplo de cómo sería con API real:
      // final response = await ApiService.get('/dashboard/metricas');
      // _viajesActivos = response['viajes_activos'] ?? 0;
      // _choferesEnRuta = response['choferes_en_ruta'] ?? 0;
      // _vehiculosActivos = response['vehiculos_activos'] ?? 0;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}