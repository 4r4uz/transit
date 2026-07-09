import 'package:flutter/foundation.dart';
import '../services/mock_data_service.dart';

class DashboardProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  
  // Métricas del dashboard
  int _viajesActivos = 0;
  int _choferesEnRuta = 0;
  int _vehiculosActivos = 0;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  int get viajesActivos => _viajesActivos;
  int get choferesEnRuta => _choferesEnRuta;
  int get vehiculosActivos => _vehiculosActivos;

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