import 'package:flutter/foundation.dart';
import '../models/agenda_model.dart';
import '../services/agenda_service.dart';

/// Provider untuk mengelola state Agenda (Kegiatan & Broadcast)
class AgendaProvider with ChangeNotifier {
  final AgendaService _service = AgendaService();

  List<AgendaModel> _agendaList = [];
  List<AgendaModel> _kegiatanList = [];
  List<AgendaModel> _broadcastList = [];
  List<AgendaModel> _upcomingList = [];
  List<AgendaModel> _pastList = [];
  List<AgendaModel> _searchResults = [];

  bool _isLoading = false;
  String? _error;
  String _selectedType = 'Semua'; // 'Semua', 'kegiatan', 'broadcast'

  Map<String, dynamic> _summary = {};

  // Getters
  List<AgendaModel> get agendaList => _agendaList;
  List<AgendaModel> get kegiatanList => _kegiatanList;
  List<AgendaModel> get broadcastList => _broadcastList;
  List<AgendaModel> get upcomingList => _upcomingList;
  List<AgendaModel> get pastList => _pastList;
  List<AgendaModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedType => _selectedType;
  Map<String, dynamic> get summary => _summary;

  Stream<List<AgendaModel>>? _agendaStream;

  // ==================== LOAD DATA ====================

  /// Load agenda berdasarkan filter
  void loadAgenda({String? type}) {
    _selectedType = type ?? 'Semua';

    if (_selectedType == 'Semua') {
      _agendaStream = _service.getAgendaStream();
    } else {
      _agendaStream = _service.getAgendaByTypeStream(_selectedType);
    }

    _agendaStream!.listen(
      (agendaList) {
        _agendaList = agendaList;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        debugPrint('❌ Error loading agenda: $error');
        notifyListeners();
      },
    );
  }

  /// Load kegiatan only
  void loadKegiatan() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _service.getAgendaByTypeStream('kegiatan').listen(
      (list) {
        _kegiatanList = list;
        _isLoading = false;
        _error = null;
        notifyListeners();
        debugPrint('✅ Loaded ${list.length} kegiatan');
      },
      onError: (error) {
        _error = error.toString();
        _isLoading = false;
        notifyListeners();
        debugPrint('❌ Error loading kegiatan: $error');
      },
    );
  }

  /// Load broadcast only
  void loadBroadcast() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _service.getAgendaByTypeStream('broadcast').listen(
      (list) {
        _broadcastList = list;
        _isLoading = false;
        _error = null;
        notifyListeners();
        debugPrint('✅ Loaded ${list.length} broadcast');
      },
      onError: (error) {
        _error = error.toString();
        _isLoading = false;
        notifyListeners();
        debugPrint('❌ Error loading broadcast: $error');
      },
    );
  }

  /// Load upcoming agenda
  void loadUpcomingAgenda({int limit = 10}) {
    _service.getUpcomingAgendaStream(limit: limit).listen(
      (list) {
        _upcomingList = list;
        notifyListeners();
      },
      onError: (error) {
        debugPrint('❌ Error loading upcoming agenda: $error');
      },
    );
  }

  /// Load past agenda
  void loadPastAgenda({int limit = 10}) {
    _service.getPastAgendaStream(limit: limit).listen(
      (list) {
        _pastList = list;
        notifyListeners();
      },
      onError: (error) {
        debugPrint('❌ Error loading past agenda: $error');
      },
    );
  }

  /// Load agenda by date range
  void loadAgendaByDateRange(DateTime startDate, DateTime endDate, {String? type}) {
    _service.getAgendaByDateRangeStream(startDate, endDate, type: type).listen(
      (list) {
        _agendaList = list;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        debugPrint('❌ Error loading agenda by date range: $error');
        notifyListeners();
      },
    );
  }

  /// Load summary statistics
  Future<void> loadSummary() async {
    try {
      _summary = await _service.getAgendaSummary();
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading summary: $e');
    }
  }

  // ==================== CREATE ====================

  /// Create agenda
  Future<bool> createAgenda(AgendaModel agenda) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _service.createAgenda(agenda);

      // Reload summary setelah create
      await loadSummary();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('❌ Error creating agenda: $e');
      return false;
    }
  }

  // ==================== READ ====================

  /// Get agenda by ID
  Future<AgendaModel?> getAgendaById(String id) async {
    try {
      return await _service.getAgendaById(id);
    } catch (e) {
      debugPrint('❌ Error getting agenda by ID: $e');
      return null;
    }
  }

  /// Search agenda
  Future<void> searchAgenda(String keyword, {String? type}) async {
    try {
      _isLoading = true;
      notifyListeners();

      _searchResults = await _service.searchAgenda(keyword, type: type);

      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('❌ Error searching agenda: $e');
    }
  }

  /// Clear search results
  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }

  // ==================== UPDATE ====================

  /// Update agenda
  Future<bool> updateAgenda(String id, Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _service.updateAgenda(id, data);

      // Reload summary setelah update
      await loadSummary();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('❌ Error updating agenda: $e');
      return false;
    }
  }

  // ==================== DELETE ====================

  /// Delete agenda (HARD DELETE - data benar-benar terhapus dari Firestore)
  Future<bool> deleteAgenda(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _service.deleteAgenda(id);

      // Reload summary setelah delete
      await loadSummary();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('❌ Error deleting agenda: $e');
      return false;
    }
  }

  /// Soft delete agenda (data masih ada di Firestore tapi tidak ditampilkan)
  Future<bool> softDeleteAgenda(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _service.softDeleteAgenda(id);

      // Reload summary setelah delete
      await loadSummary();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('❌ Error soft deleting agenda: $e');
      return false;
    }
  }

  // ==================== UTILITY ====================

  /// Set filter type
  void setFilterType(String type) {
    _selectedType = type;
    loadAgenda(type: type);
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Refresh all data
  Future<void> refresh() async {
    loadAgenda(type: _selectedType);
    await loadSummary();
  }

  @override
  void dispose() {
    _agendaStream = null;
    super.dispose();
  }
}

