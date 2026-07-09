import 'package:flutter/foundation.dart';
import '../models/vehiculo.dart';
import '../services/api_service.dart';
import '../services/mock_data_service.dart';
import '../config/api_config.dart';

class VehiculosProvider extends ChangeNotifier {
  List<Vehiculo> _vehiculos = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Vehiculo> get vehiculos => _vehiculos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchVehiculos() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        final response = await ApiService.get(ApiConfig.vehiculos);
        
        List<dynamic> data;
        if (response is List) {
          data = response;
        } else if (response is Map) {
          data = response['data'] ?? response['vehiculos'] ?? [];
        } else {
          data = [];
        }

        _vehiculos = data.map((json) => Vehiculo.fromJson(json)).toList();
      } catch (apiError) {
        // Si falla la API, usar datos mock
        if (kDebugMode) {
          print('API no disponible, usando datos mock para vehículos: $apiError');
        }
        await Future.delayed(Duration(milliseconds: 300));
        _vehiculos = MockDataService.getDemoVehiculos();
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Vehiculo?> createVehiculo(Vehiculo vehiculo) async {
    try {
      _errorMessage = null;
      
      try {
        final response = await ApiService.post(ApiConfig.vehiculos, vehiculo.toJson());
        final nuevoVehiculo = Vehiculo.fromJson(response);
        _vehiculos.add(nuevoVehiculo);
        notifyListeners();
        return nuevoVehiculo;
      } catch (apiError) {
        // Modo demo: simular creación
        if (kDebugMode) {
          print('API no disponible, simulando creación de vehículo: $apiError');
        }
        await Future.delayed(Duration(milliseconds: 300));
        final nuevoVehiculo = Vehiculo(
          id: DateTime.now().millisecondsSinceEpoch,
          patente: vehiculo.patente,
          marca: vehiculo.marca,
          modelo: vehiculo.modelo,
          anio: vehiculo.anio,
          color: vehiculo.color,
          capacidad: vehiculo.capacidad,
          tipo: vehiculo.tipo,
          estado: vehiculo.estado,
        );
        _vehiculos.add(nuevoVehiculo);
        notifyListeners();
        return nuevoVehiculo;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  Future<Vehiculo?> updateVehiculo(Vehiculo vehiculo) async {
    try {
      _errorMessage = null;
      
      try {
        final endpoint = '${ApiConfig.vehiculos}/${vehiculo.id}';
        final response = await ApiService.put(endpoint, vehiculo.toJson());
        final vehiculoActualizado = Vehiculo.fromJson(response);
        
        final index = _vehiculos.indexWhere((v) => v.id == vehiculo.id);
        if (index != -1) {
          _vehiculos[index] = vehiculoActualizado;
          notifyListeners();
        }
        return vehiculoActualizado;
      } catch (apiError) {
        // Modo demo: simular actualización
        if (kDebugMode) {
          print('API no disponible, simulando actualización de vehículo: $apiError');
        }
        await Future.delayed(Duration(milliseconds: 300));
        final index = _vehiculos.indexWhere((v) => v.id == vehiculo.id);
        if (index != -1) {
          _vehiculos[index] = vehiculo;
          notifyListeners();
        }
        return vehiculo;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteVehiculo(int id) async {
    try {
      _errorMessage = null;
      
      try {
        final endpoint = '${ApiConfig.vehiculos}/$id';
        await ApiService.delete(endpoint);
      } catch (apiError) {
        // Modo demo: simular eliminación
        if (kDebugMode) {
          print('API no disponible, simulando eliminación de vehículo: $apiError');
        }
        await Future.delayed(Duration(milliseconds: 300));
      }
      
      _vehiculos.removeWhere((v) => v.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}