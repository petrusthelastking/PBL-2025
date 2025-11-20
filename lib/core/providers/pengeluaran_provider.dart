// filepath: lib/core/providers/pengeluaran_provider.dart
import 'package:flutter/foundation.dart';
import '../models/pengeluaran_model.dart';
import '../services/pengeluaran_service.dart';

/// Provider untuk mengelola state Pengeluaran
class PengeluaranProvider with ChangeNotifier {
  final PengeluaranService _service = PengeluaranService();

  List<PengeluaranModel> _pengeluaranList = [];
  List<PengeluaranModel> _menungguList = [];
  List<PengeluaranModel> _terverifikasiList = [];
  List<PengeluaranModel> _ditolakList = [];

  double _totalTerverifikasi = 0;
  Map<String, dynamic> _summary = {};
  bool _isLoading = false;
  String? _error;
  String _selectedStatus = 'Semua'; // 'Semua', 'Menunggu', 'Terverifikasi', 'Ditolak'
  String _selectedCategory = 'Semua'; // 'Semua', 'Operasional', 'Infrastruktur', dll

  // Getters
  List<PengeluaranModel> get pengeluaranList => _pengeluaranList;
  List<PengeluaranModel> get menungguList => _menungguList;
  List<PengeluaranModel> get terverifikasiList => _terverifikasiList;
  List<PengeluaranModel> get ditolakList => _ditolakList;
  double get totalTerverifikasi => _totalTerverifikasi;
  Map<String, dynamic> get summary => _summary;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedStatus => _selectedStatus;
  String get selectedCategory => _selectedCategory;

  Stream<List<PengeluaranModel>>? _pengeluaranStream;

  /// Load pengeluaran berdasarkan status
  void loadPengeluaran({String? status}) {
    _selectedStatus = status ?? 'Semua';

    if (_selectedStatus == 'Semua') {
      _pengeluaranStream = _service.getPengeluaranStream();
    } else {
      _pengeluaranStream = _service.getPengeluaranByStatusStream(_selectedStatus);
    }

    _pengeluaranStream!.listen(
      (pengeluaranList) {
        _pengeluaranList = pengeluaranList;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        debugPrint('❌ Error loading pengeluaran: $error');
        notifyListeners();
      },
    );
  }

  /// Load pengeluaran by status
  void loadByStatus(String status) {
    _service.getPengeluaranByStatusStream(status).listen(
      (list) {
        switch (status) {
          case 'Menunggu':
            _menungguList = list;
            break;
          case 'Terverifikasi':
            _terverifikasiList = list;
            break;
          case 'Ditolak':
            _ditolakList = list;
            break;
        }
        notifyListeners();
      },
      onError: (error) {
        debugPrint('❌ Error loading pengeluaran by status: $error');
      },
    );
  }

  /// Load pengeluaran by category
  void loadByCategory(String category) {
    _selectedCategory = category;
    if (category == 'Semua') {
      loadPengeluaran();
    } else {
      _pengeluaranStream = _service.getPengeluaranByCategoryStream(category);
      _pengeluaranStream!.listen(
        (pengeluaranList) {
          _pengeluaranList = pengeluaranList;
          _error = null;
          notifyListeners();
        },
        onError: (error) {
          _error = error.toString();
          debugPrint('❌ Error loading pengeluaran by category: $error');
          notifyListeners();
        },
      );
    }
  }

  /// Load pengeluaran by date range
  void loadByDateRange(DateTime startDate, DateTime endDate) {
    _pengeluaranStream = _service.getPengeluaranByDateRangeStream(startDate, endDate);
    _pengeluaranStream!.listen(
      (pengeluaranList) {
        _pengeluaranList = pengeluaranList;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        debugPrint('❌ Error loading pengeluaran by date range: $error');
        notifyListeners();
      },
    );
  }

  /// Load total terverifikasi
  Future<void> loadTotalTerverifikasi() async {
    try {
      _totalTerverifikasi = await _service.getTotalPengeluaranTerverifikasi();
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading total terverifikasi: $e');
    }
  }

  /// Load summary statistics
  Future<void> loadSummary() async {
    try {
      _summary = await _service.getPengeluaranSummary();
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading summary: $e');
    }
  }

  /// Create pengeluaran
  Future<bool> createPengeluaran(PengeluaranModel pengeluaran) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _service.createPengeluaran(pengeluaran);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      debugPrint('❌ Error creating pengeluaran: $e');
      notifyListeners();
      return false;
    }
  }

  /// Update pengeluaran
  Future<bool> updatePengeluaran(String id, Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _service.updatePengeluaran(id, data);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      debugPrint('❌ Error updating pengeluaran: $e');
      notifyListeners();
      return false;
    }
  }

  /// Verifikasi pengeluaran
  Future<bool> verifikasiPengeluaran(String id, bool approved) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _service.verifikasiPengeluaran(id, approved);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      debugPrint('❌ Error verifying pengeluaran: $e');
      notifyListeners();
      return false;
    }
  }

  /// Delete pengeluaran
  Future<bool> deletePengeluaran(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _service.deletePengeluaran(id);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      debugPrint('❌ Error deleting pengeluaran: $e');
      notifyListeners();
      return false;
    }
  }

  /// Get pengeluaran by ID
  Future<PengeluaranModel?> getPengeluaranById(String id) async {
    try {
      return await _service.getPengeluaranById(id);
    } catch (e) {
      debugPrint('❌ Error getting pengeluaran by id: $e');
      return null;
    }
  }

  /// Get total by category
  Future<double> getTotalByCategory(String category) async {
    try {
      return await _service.getTotalPengeluaranByCategory(category);
    } catch (e) {
      debugPrint('❌ Error getting total by category: $e');
      return 0;
    }
  }

  /// Get total by date range
  Future<double> getTotalByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      return await _service.getTotalPengeluaranByDateRange(startDate, endDate);
    } catch (e) {
      debugPrint('❌ Error getting total by date range: $e');
      return 0;
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Refresh data
  void refresh() {
    loadPengeluaran(status: _selectedStatus);
    loadTotalTerverifikasi();
    loadSummary();
  }
}

