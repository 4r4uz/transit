import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/horario.dart';
import '../services/mock_data_service.dart';

class HorariosProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  final List<Horario> _horarios = [];
  Timer? _pollingTimer;
  bool _isPolling = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Horario> get horarios => List.unmodifiable(_horarios);
  bool get isPolling => _isPolling;

  HorariosProvider() {
    // Iniciar polling automáticamente
    startPolling();
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }

  Future<void> fetchHorarios() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // TODO: Reemplazar con endpoint real de horarios
      // Por ahora usamos datos mock para demo
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Usar datos mock de demo
      final horariosData = MockDataService.getDemoHorarios();
      _horarios.clear();
      _horarios.addAll(horariosData.map((json) => Horario.fromJson(json)));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addHorario(Horario horario) async {
    try {
      _errorMessage = null;
      notifyListeners();

      // TODO: Reemplazar con llamada real al endpoint POST
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Simulación: agregar con ID generado
      final nuevoHorario = Horario(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        rutaId: horario.rutaId,
        rutaNombre: horario.rutaNombre,
        patenteBus: horario.patenteBus,
        choferNombre: horario.choferNombre,
        horaSalida: horario.horaSalida,
        diasSemana: horario.diasSemana,
        estado: horario.estado,
        pasajeros: horario.pasajeros,
        observaciones: horario.observaciones,
      );
      
      _horarios.add(nuevoHorario);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> updateHorario(Horario horario) async {
    try {
      _errorMessage = null;
      notifyListeners();

      // TODO: Reemplazar con llamada real al endpoint PUT
      await Future.delayed(const Duration(milliseconds: 300));
      
      final index = _horarios.indexWhere((h) => h.id == horario.id);
      if (index != -1) {
        _horarios[index] = horario;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> deleteHorario(int id) async {
    try {
      _errorMessage = null;
      notifyListeners();

      // TODO: Reemplazar con llamada real al endpoint DELETE
      await Future.delayed(const Duration(milliseconds: 300));
      
      _horarios.removeWhere((h) => h.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  void startPolling() {
    if (_isPolling) return;
    
    _isPolling = true;
    fetchHorarios(); // Primera carga
    
    // Polling cada 30 segundos
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      fetchHorarios();
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