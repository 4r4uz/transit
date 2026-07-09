import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/vehiculo.dart';
import '../services/mock_data_service.dart';

class MapaProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  final List<Vehiculo> _vehiculosEnRuta = [];
  Timer? _pollingTimer;
  bool _isPolling = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Vehiculo> get vehiculosEnRuta => _vehiculosEnRuta;
  bool get isPolling => _isPolling;

  MapaProvider() {
    // Iniciar polling automáticamente
    startPolling();
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }

  Future<void> fetchVehiculosEnRuta() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // TODO: Reemplazar con endpoint real de tracking/posiciones
      // Por ahora usamos datos mock para demo
      await Future.delayed(Duration(milliseconds: 500));
      
      // Usar datos mock de demo
      final vehiculosData = MockDataService.getDemoVehiculosEnRuta();
      _vehiculosEnRuta.clear();
      _vehiculosEnRuta.addAll(vehiculosData.map((json) => Vehiculo.fromJson(json)));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  void startPolling() {
    if (_isPolling) return;
    
    _isPolling = true;
    fetchVehiculosEnRuta(); // Primera carga
    
    // Polling cada 10 segundos
    _pollingTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      fetchVehiculosEnRuta();
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _isPolling = false;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}