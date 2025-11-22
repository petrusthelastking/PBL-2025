import 'package:flutter/foundation.dart';
import '../models/laporan_keuangan_detail_model.dart';
import '../services/laporan_keuangan_detail_service.dart';

/// Provider untuk Detail Laporan Keuangan
class LaporanKeuanganDetailProvider with ChangeNotifier {
  final LaporanKeuanganDetailService _service = LaporanKeuanganDetailService();

  List<LaporanKeuanganDetail> _transaksiList = [];
  Map<String, dynamic> _summary = {};
  bool _isLoading = false;
  String? _error;

  // Filter state
  String _filterType = 'all'; // 'all', 'iuran', 'pemasukan_lain', 'pengeluaran'
  DateTime? _startDate;
  DateTime? _endDate;

  // Getters
  List<LaporanKeuanganDetail> get transaksiList => _transaksiList;
  Map<String, dynamic> get summary => _summary;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get filterType => _filterType;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  // Filtered list berdasarkan filter yang aktif
  List<LaporanKeuanganDetail> get filteredTransaksiList {
    if (_filterType == 'all') {
      return _transaksiList;
    }
    return _transaksiList.where((t) => t.type == _filterType).toList();
  }

  /// Load semua transaksi
  Future<void> loadAllTransaksi({int limit = 50}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _transaksiList = await _service.getAllTransaksi(limit: limit);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('❌ Error loading transaksi: $e');
    }
  }

  /// Load transaksi dengan filter tanggal
  Future<void> loadTransaksiByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      _startDate = startDate;
      _endDate = endDate;
      notifyListeners();

      _transaksiList = await _service.getTransaksiByDateRange(
        startDate: startDate,
        endDate: endDate,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('❌ Error loading transaksi by date range: $e');
    }
  }

  /// Load summary keuangan
  Future<void> loadSummary() async {
    try {
      _summary = await _service.getSummary();
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading summary: $e');
    }
  }

  /// Set filter type
  void setFilterType(String type) {
    _filterType = type;
    notifyListeners();
  }

  /// Clear filter
  void clearFilter() {
    _filterType = 'all';
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }

  /// Refresh data
  Future<void> refresh() async {
    await loadAllTransaksi();
    await loadSummary();
  }

  /// Get statistics
  Map<String, int> get statistics {
    return {
      'total': _transaksiList.length,
      'iuran': _transaksiList.where((t) => t.type == 'iuran').length,
      'pemasukan_lain': _transaksiList.where((t) => t.type == 'pemasukan_lain').length,
      'pengeluaran': _transaksiList.where((t) => t.type == 'pengeluaran').length,
    };
  }
}

