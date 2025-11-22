import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/agenda_provider.dart';
import '../../core/models/agenda_model.dart';

/// Example: Cara menggunakan Backend CRUD Agenda
///
/// File ini berisi contoh-contoh penggunaan lengkap untuk:
/// - Create, Read, Update, Delete Agenda
/// - Filter by type (kegiatan/broadcast)
/// - Search
/// - Date range filter
/// - Statistics

class AgendaExamplePage extends StatefulWidget {
  const AgendaExamplePage({super.key});

  @override
  State<AgendaExamplePage> createState() => _AgendaExamplePageState();
}

class _AgendaExamplePageState extends State<AgendaExamplePage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load data saat page dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AgendaProvider>(context, listen: false);
      provider.loadAgenda(); // Load semua agenda
      provider.loadSummary(); // Load statistics
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda Example'),
        actions: [
          // Filter dropdown
          _buildFilterDropdown(),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          _buildSearchBar(),
          // Statistics card
          _buildStatisticsCard(),
          // Agenda list
          Expanded(child: _buildAgendaList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  // ==================== UI COMPONENTS ====================

  Widget _buildFilterDropdown() {
    return Consumer<AgendaProvider>(
      builder: (context, provider, child) {
        return PopupMenuButton<String>(
          initialValue: provider.selectedType,
          onSelected: (value) {
            provider.setFilterType(value);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'Semua', child: Text('Semua')),
            const PopupMenuItem(value: 'kegiatan', child: Text('Kegiatan')),
            const PopupMenuItem(value: 'broadcast', child: Text('Broadcast')),
          ],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(provider.selectedType),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari agenda...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              final provider = Provider.of<AgendaProvider>(context, listen: false);
              provider.clearSearch();
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) async {
          final provider = Provider.of<AgendaProvider>(context, listen: false);
          if (value.isNotEmpty) {
            await provider.searchAgenda(value);
          } else {
            provider.clearSearch();
          }
        },
      ),
    );
  }

  Widget _buildStatisticsCard() {
    return Consumer<AgendaProvider>(
      builder: (context, provider, child) {
        final stats = provider.summary;
        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Total',
                  stats['totalAgenda']?.toString() ?? '0',
                  Icons.event,
                ),
                _buildStatItem(
                  'Kegiatan',
                  stats['totalKegiatan']?.toString() ?? '0',
                  Icons.event_note,
                ),
                _buildStatItem(
                  'Broadcast',
                  stats['totalBroadcast']?.toString() ?? '0',
                  Icons.campaign,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildAgendaList() {
    return Consumer<AgendaProvider>(
      builder: (context, provider, child) {
        // Show loading
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error
        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${provider.error}'),
                ElevatedButton(
                  onPressed: () => provider.refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Show search results or agenda list
        final list = _searchController.text.isNotEmpty
            ? provider.searchResults
            : provider.agendaList;

        if (list.isEmpty) {
          return const Center(child: Text('Tidak ada data'));
        }

        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final agenda = list[index];
            return _buildAgendaCard(agenda);
          },
        );
      },
    );
  }

  Widget _buildAgendaCard(AgendaModel agenda) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(
            agenda.type == 'kegiatan' ? Icons.event : Icons.campaign,
          ),
        ),
        title: Text(agenda.judul),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(agenda.type),
            Text(
              '${agenda.tanggal.day}/${agenda.tanggal.month}/${agenda.tanggal.year}',
            ),
            if (agenda.lokasi != null) Text('📍 ${agenda.lokasi}'),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('Edit'),
              onTap: () => _showEditDialog(agenda),
            ),
            PopupMenuItem(
              child: const Text('Hapus'),
              onTap: () => _deleteAgenda(agenda.id),
            ),
          ],
        ),
        onTap: () => _showDetailDialog(agenda),
      ),
    );
  }

  // ==================== CRUD OPERATIONS ====================

  /// CREATE: Membuat agenda baru
  void _showCreateDialog() {
    final judulController = TextEditingController();
    final deskripsiController = TextEditingController();
    final lokasiController = TextEditingController();
    String selectedType = 'kegiatan';
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Tambah Agenda'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: judulController,
                  decoration: const InputDecoration(labelText: 'Judul'),
                ),
                TextField(
                  controller: deskripsiController,
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                  maxLines: 3,
                ),
                DropdownButtonFormField<String>(
                  initialValue: selectedType,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: const [
                    DropdownMenuItem(value: 'kegiatan', child: Text('Kegiatan')),
                    DropdownMenuItem(value: 'broadcast', child: Text('Broadcast')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedType = value);
                    }
                  },
                ),
                TextField(
                  controller: lokasiController,
                  decoration: const InputDecoration(labelText: 'Lokasi'),
                ),
                ListTile(
                  title: const Text('Tanggal'),
                  subtitle: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() => selectedDate = picked);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Validate
                if (judulController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Judul harus diisi')),
                  );
                  return;
                }

                // Create agenda
                final agenda = AgendaModel(
                  id: '',
                  judul: judulController.text,
                  deskripsi: deskripsiController.text.isEmpty ? null : deskripsiController.text,
                  type: selectedType,
                  tanggal: selectedDate,
                  lokasi: lokasiController.text.isEmpty ? null : lokasiController.text,
                  createdBy: 'currentUserId', // TODO: Get from AuthProvider
                );

                final provider = Provider.of<AgendaProvider>(context, listen: false);
                final success = await provider.createAgenda(agenda);

                if (!context.mounted) return;
                Navigator.pop(context);

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ Agenda berhasil dibuat!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('❌ Gagal: ${provider.error}')),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  /// READ: Menampilkan detail agenda
  void _showDetailDialog(AgendaModel agenda) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(agenda.judul),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Type', agenda.type),
              _buildDetailRow('Tanggal', '${agenda.tanggal.day}/${agenda.tanggal.month}/${agenda.tanggal.year}'),
              if (agenda.lokasi != null) _buildDetailRow('Lokasi', agenda.lokasi!),
              if (agenda.deskripsi != null) _buildDetailRow('Deskripsi', agenda.deskripsi!),
              _buildDetailRow('Dibuat oleh', agenda.createdBy),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  /// UPDATE: Edit agenda
  void _showEditDialog(AgendaModel agenda) {
    final judulController = TextEditingController(text: agenda.judul);
    final deskripsiController = TextEditingController(text: agenda.deskripsi ?? '');
    final lokasiController = TextEditingController(text: agenda.lokasi ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Agenda'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: judulController,
                decoration: const InputDecoration(labelText: 'Judul'),
              ),
              TextField(
                controller: deskripsiController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
              ),
              TextField(
                controller: lokasiController,
                decoration: const InputDecoration(labelText: 'Lokasi'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final provider = Provider.of<AgendaProvider>(context, listen: false);
              final success = await provider.updateAgenda(agenda.id, {
                'judul': judulController.text,
                'deskripsi': deskripsiController.text.isEmpty ? null : deskripsiController.text,
                'lokasi': lokasiController.text.isEmpty ? null : lokasiController.text,
              });

              if (!context.mounted) return;
              Navigator.pop(context);

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ Agenda berhasil diupdate!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('❌ Gagal: ${provider.error}')),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  /// DELETE: Hapus agenda
  Future<void> _deleteAgenda(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin menghapus agenda ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final provider = Provider.of<AgendaProvider>(context, listen: false);
    final success = await provider.deleteAgenda(id);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Agenda berhasil dihapus!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Gagal: ${provider.error}')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

