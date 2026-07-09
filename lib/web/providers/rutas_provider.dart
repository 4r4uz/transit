import 'package:flutter/foundation.dart';
import '../models/ruta.dart';
import '../services/api_service.dart';
import '../services/mock_data_service.dart';
import '../config/api_config.dart';

class RutasProvider extends ChangeNotifier {
  List<Ruta> _rutas = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Ruta> get rutas => _rutas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRutas() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        final response = await ApiService.get(ApiConfig.rutas);
        
        // El backend puede retornar una lista directamente o un objeto con campo 'data' o 'rutas'
        List<dynamic> data;
        if (response is List) {
          data = response;
        } else if (response is Map) {
          data = response['data'] ?? response['rutas'] ?? [];
        } else {
          data = [];
        }

        _rutas = data.map((json) => Ruta.fromJson(json)).toList();
      } catch (apiError) {
        // Si falla la API, usar datos mock
        if (kDebugMode) {
          print('API no disponible, usando datos mock para rutas: $apiError');
        }
        await Future.delayed(Duration(milliseconds: 300));
        _rutas = MockDataService.getDemoRutas();
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Ruta?> createRuta(Ruta ruta) async {
    try {
      _errorMessage = null;
      
      try {
        final response = await ApiService.post(ApiConfig.rutas, ruta.toJson());
        final nuevaRuta = Ruta.fromJson(response);
        _rutas.add(nuevaRuta);
        notifyListeners();
        return nuevaRuta;
      } catch (apiError) {
        // Modo demo: simular creación
        if (kDebugMode) {
          print('API no disponible, simulando creación de ruta: $apiError');
        }
        await Future.delayed(Duration(milliseconds: 300));
        final nuevaRuta = Ruta(
          id: DateTime.now().millisecondsSinceEpoch,
          nombre: ruta.nombre,
          descripcion: ruta.descripcion,
          origen: ruta.origen,
          destino: ruta.destino,
          estado: ruta.estado,
        );
        _rutas.add(nuevaRuta);
        notifyListeners();
        return nuevaRuta;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  Future<Ruta?> updateRuta(Ruta ruta) async {
    try {
      _errorMessage = null;
      
      try {
        final endpoint = '${ApiConfig.rutas}/${ruta.id}';
        final response = await ApiService.put(endpoint, ruta.toJson());
        final rutaActualizada = Ruta.fromJson(response);
        
        final index = _rutas.indexWhere((r) => r.id == ruta.id);
        if (index != -1) {
          _rutas[index] = rutaActualizada;
          notifyListeners();
        }
        return rutaActualizada;
      } catch (apiError) {
        // Modo demo: simular actualización
        if (kDebugMode) {
          print('API no disponible, simulando actualización de ruta: $apiError');
        }
        await Future.delayed(Duration(milliseconds: 300));
        final index = _rutas.indexWhere((r) => r.id == ruta.id);
        if (index != -1) {
          _rutas[index] = ruta;
          notifyListeners();
        }
        return ruta;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteRuta(int id) async {
    try {
      _errorMessage = null;
      
      try {
        final endpoint = '${ApiConfig.rutas}/$id';
        await ApiService.delete(endpoint);
      } catch (apiError) {
        // Modo demo: simular eliminación
        if (kDebugMode) {
          print('API no disponible, simulando eliminación de ruta: $apiError');
        }
        await Future.delayed(Duration(milliseconds: 300));
      }
      
      _rutas.removeWhere((r) => r.id == id);
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