import 'package:flutter/material.dart';
import 'package:jawara/core/services/firestore_service.dart';
import 'package:jawara/core/models/warga_model.dart';

class WargaProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  List<WargaModel> _wargaList = [];
  WargaModel? _selectedWarga;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<WargaModel> get wargaList => _wargaList;
  WargaModel? get selectedWarga => _selectedWarga;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load all warga
  Future<void> loadWarga() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _firestoreService.getCollection(
        collection: 'warga',
        orderBy: 'nama',
      );
      _wargaList = data.map((e) => WargaModel.fromMap(e, e['id'])).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add warga
  Future<bool> addWarga(WargaModel warga) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestoreService.createDocument(
        collection: 'warga',
        data: warga.toMap(),
      );
      await loadWarga();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update warga
  Future<bool> updateWarga(String id, WargaModel warga) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestoreService.updateDocument(
        collection: 'warga',
        docId: id,
        data: warga.toMap(),
      );
      await loadWarga();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete warga
  Future<bool> deleteWarga(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestoreService.deleteDocument(
        collection: 'warga',
        docId: id,
      );
      await loadWarga();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Select warga
  void selectWarga(WargaModel warga) {
    _selectedWarga = warga;
    notifyListeners();
  }

  // Search warga
  Future<void> searchWarga(String query) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _firestoreService.searchWarga(query);
      _wargaList = data.map((e) => WargaModel.fromMap(e, e['id'])).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear selection
  void clearSelection() {
    _selectedWarga = null;
    notifyListeners();
  }
}
