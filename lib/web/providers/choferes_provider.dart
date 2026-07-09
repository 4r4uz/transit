import 'package:flutter/foundation.dart';
import '../models/chofer.dart';
import '../services/api_service.dart';
import '../services/mock_data_service.dart';
import '../config/api_config.dart';

class ChoferesProvider extends ChangeNotifier {
  List<Chofer> _choferes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Chofer> get choferes => _choferes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchChoferes() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        final response = await ApiService.get(ApiConfig.choferes);
        
        List<dynamic> data;
        if (response is List) {
          data = response;
        } else if (response is Map) {
          data = response['data'] ?? response['choferes'] ?? [];
        } else {
          data = [];
        }

        _choferes = data.map((json) => Chofer.fromJson(json)).toList();
      } catch (apiError) {
        // Si falla la API, usar datos mock
        if (kDebugMode) {
          print('API no disponible, usando datos mock para choferes: $apiError');
        }
        await Future.delayed(Duration(milliseconds: 300));
        _choferes = MockDataService.getDemoChoferes();
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Chofer?> createChofer(Chofer chofer) async {
    try {
      _errorMessage = null;
      
      try {
        final response = await ApiService.post(ApiConfig.choferes, chofer.toJson());
        final nuevoChofer = Chofer.fromJson(response);
        _choferes.add(nuevoChofer);
        notifyListeners();
        return nuevoChofer;
      } catch (apiError) {
        // Modo demo: simular creación
        if (kDebugMode) {
          print('API no disponible, simulando creación de chofer: $apiError');
        }
        await Future.delayed(Duration(milliseconds: 300));
        final nuevoChofer = Chofer(
          id: DateTime.now().millisecondsSinceEpoch,
          nombre: chofer.nombre,
          apellido: chofer.apellido,
          rut: chofer.rut,
          licencia: chofer.licencia,
          telefono: chofer.telefono,
          email: chofer.email,
          estado: chofer.estado,
        );
        _choferes.add(nuevoChofer);
        notifyListeners();
        return nuevoChofer;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  Future<Chofer?> updateChofer(Chofer chofer) async {
    try {
      _errorMessage = null;
      
      try {
        final endpoint = '${ApiConfig.choferes}/${chofer.id}';
        final response = await ApiService.put(endpoint, chofer.toJson());
        final choferActualizado = Chofer.fromJson(response);
        
        final index = _choferes.indexWhere((c) => c.id == chofer.id);
        if (index != -1) {
          _choferes[index] = choferActualizado;
          notifyListeners();
        }
        return choferActualizado;
      } catch (apiError) {
        // Modo demo: simular actualización
        if (kDebugMode) {
          print('API no disponible, simulando actualización de chofer: $apiError');
        }
        await Future.delayed(Duration(milliseconds: 300));
        final index = _choferes.indexWhere((c) => c.id == chofer.id);
        if (index != -1) {
          _choferes[index] = chofer;
          notifyListeners();
        }
        return chofer;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteChofer(int id) async {
    try {
      _errorMessage = null;
      
      try {
        final endpoint = '${ApiConfig.choferes}/$id';
        await ApiService.delete(endpoint);
      } catch (apiError) {
        // Modo demo: simular eliminación
        if (kDebugMode) {
          print('API no disponible, simulando eliminación de chofer: $apiError');
        }
        await Future.delayed(Duration(milliseconds: 300));
      }
      
      _choferes.removeWhere((c) => c.id == id);
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