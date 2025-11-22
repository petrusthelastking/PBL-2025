import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'tambah_broadcast_page.dart';
import 'edit_broadcast_page.dart';
import '../kegiatan/kegiatan_page.dart';
import '../../../core/providers/agenda_provider.dart';

class BroadcastPage extends StatefulWidget {
  const BroadcastPage({super.key});

  @override
  State<BroadcastPage> createState() => _BroadcastPageState();
}

class _BroadcastPageState extends State<BroadcastPage> {
  @override
  void initState() {
    super.initState();
    // Load broadcast data saat page dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AgendaProvider>(context, listen: false);
      provider.loadKegiatan();
      provider.loadBroadcast();
      provider.loadSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Header dengan gradient modern & stats
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2988EA), Color(0xFF1E6FBA), Color(0xFF2563EB)],
                stops: [0.0, 0.5, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2988EA).withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  spreadRadius: -5,
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      children: [
                        // Back button dengan glass morphism
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              borderRadius: BorderRadius.circular(14),
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Title
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.campaign_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "Kelola Agenda",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.8,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Kelola kegiatan & broadcast warga",
                                style: GoogleFonts.poppins(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Tab Cards dengan design modern & animasi
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                    child: Consumer<AgendaProvider>(
                      builder: (context, provider, child) {
                        final summary = provider.summary;
                        final kegiatanCount = summary['totalKegiatan']?.toString() ?? '0';
                        final broadcastCount = summary['totalBroadcast']?.toString() ?? '0';

                        return Row(
                          children: [
                            Expanded(
                              child: _ModernTabCard(
                                title: "Kegiatan",
                                icon: Icons.event_note_rounded,
                                count: kegiatanCount,
                                isActive: false,
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AgendaPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _ModernTabCard(
                                title: "Broadcast",
                                icon: Icons.campaign_rounded,
                                count: broadcastCount,
                                isActive: true,
                                onTap: () {
                                  // Sudah di halaman ini
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Daftar Broadcast
          const Expanded(
            child: DaftarBroadcastList(),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 4),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2988EA), Color(0xFF1E6FBA)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2988EA).withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: -4,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TambahBroadcastPage()),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Tambah',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Modern Tab Card untuk Kegiatan & Broadcast dengan animasi
class _ModernTabCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final String count;
  final bool isActive;
  final VoidCallback onTap;

  const _ModernTabCard({
    required this.title,
    required this.icon,
    required this.count,
    required this.onTap,
    this.isActive = false,
  });

  @override
  State<_ModernTabCard> createState() => _ModernTabCardState();
}

class _ModernTabCardState extends State<_ModernTabCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: widget.isActive
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFF8FAFF),
                      Color(0xFFEFF6FF),
                    ],
                  )
                : null,
            color: widget.isActive ? null : Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isActive
                  ? Colors.white.withValues(alpha: 0.9)
                  : Colors.white.withValues(alpha: 0.25),
              width: widget.isActive ? 2 : 1.5,
            ),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: -2,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon dengan background gradient
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  gradient: widget.isActive
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF2988EA), Color(0xFF1E6FBA)],
                        )
                      : null,
                  color: widget.isActive
                      ? null
                      : Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: widget.isActive
                      ? [
                          BoxShadow(
                            color: const Color(0xFF2988EA).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  widget.icon,
                  color: widget.isActive
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.95),
                  size: 26,
                ),
              ),
              const SizedBox(height: 16),
              // Title dengan animasi
              Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: widget.isActive
                      ? const Color(0xFF1F2937)
                      : Colors.white,
                  letterSpacing: 0.3,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              // Count dengan style menarik
              Row(
                children: [
                  Text(
                    widget.count,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: widget.isActive
                          ? const Color(0xFF2988EA)
                          : Colors.white,
                      height: 1,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isActive
                          ? const Color(0xFF2988EA).withValues(alpha: 0.12)
                          : Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Data',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: widget.isActive
                            ? const Color(0xFF2988EA)
                            : Colors.white.withValues(alpha: 0.9),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Daftar item broadcast
class DaftarBroadcastList extends StatefulWidget {
  const DaftarBroadcastList({super.key});

  @override
  State<DaftarBroadcastList> createState() => _DaftarBroadcastListState();
}

class _DaftarBroadcastListState extends State<DaftarBroadcastList> {
  final Map<String, bool> _expandedMap = {};

  @override
  void initState() {
    super.initState();
    // Load broadcast saat widget diinisialisasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AgendaProvider>(context, listen: false).loadBroadcast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2988EA).withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section dengan gradient subtle
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white.withValues(alpha: 0.95),
                ],
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title dengan icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF2988EA), Color(0xFF1E6FBA)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2988EA).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.campaign_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      "Daftar Broadcast",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1F2937),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Search & Filter modern dengan shadow
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2988EA).withValues(alpha: 0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                              spreadRadius: -4,
                            ),
                          ],
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Cari broadcast...",
                            hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF9CA3AF),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Container(
                              padding: const EdgeInsets.all(12),
                              child: const Icon(
                                Icons.search_rounded,
                                color: Color(0xFF2988EA),
                                size: 22,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: const Color(0xFFE5E7EB).withValues(alpha: 0.5),
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: const Color(0xFFE5E7EB).withValues(alpha: 0.5),
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF2988EA),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          onChanged: (value) {
                            // TODO: Implement search
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Filter button dengan gradient
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF2988EA), Color(0xFF1E6FBA)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2988EA).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // TODO: Implement date filter
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            child: const Icon(
                              Icons.tune_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<AgendaProvider>(
              builder: (context, provider, child) {
                // Loading state
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2988EA)),
                    ),
                  );
                }

                // Error state
                if (provider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Terjadi kesalahan',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            provider.error!,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF6B7280),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final broadcastList = provider.broadcastList;

                // Empty state
                if (broadcastList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.campaign_outlined,
                          size: 64,
                          color: const Color(0xFF2988EA).withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada broadcast',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'Tambah broadcast baru dengan tombol + di bawah',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF6B7280),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Data list dengan padding yang lebih baik
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  itemCount: broadcastList.length,
                  itemBuilder: (context, index) {
                    final broadcast = broadcastList[index];
                    final isExpanded = _expandedMap[broadcast.id] ?? false;

                    final String title = broadcast.judul;
                    final String date = DateFormat('dd MMMM yyyy', 'id_ID').format(broadcast.tanggal);
                    final String isiPesan = broadcast.deskripsi ?? '-';

                    return GestureDetector(
                      onTap: () => setState(
                        () => _expandedMap[broadcast.id] = !isExpanded,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isExpanded
                                ? const Color(0xFF2988EA).withValues(alpha: 0.3)
                                : const Color(0xFFE5E7EB).withValues(alpha: 0.6),
                            width: isExpanded ? 1.5 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isExpanded
                                  ? const Color(0xFF2988EA).withValues(alpha: 0.12)
                                  : const Color(0xFF000000).withValues(alpha: 0.04),
                              blurRadius: isExpanded ? 20 : 12,
                              offset: Offset(0, isExpanded ? 8 : 4),
                              spreadRadius: isExpanded ? -2 : -4,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Icon dengan gradient background
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Color(0xFF2988EA), Color(0xFF1E6FBA)],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF2988EA).withValues(alpha: 0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.campaign_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: const Color(0xFF1F2937),
                                          letterSpacing: -0.3,
                                          height: 1.3,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      // Badge tanggal dengan design modern
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2988EA).withValues(alpha: 0.08),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: const Color(0xFF2988EA).withValues(alpha: 0.15),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.schedule_rounded,
                                              size: 13,
                                              color: Color(0xFF2988EA),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              date,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF2988EA),
                                                letterSpacing: 0.2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Expand icon dengan background
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isExpanded
                                        ? const Color(0xFF2988EA).withValues(alpha: 0.1)
                                        : const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: AnimatedRotation(
                                    turns: isExpanded ? 0.5 : 0,
                                    duration: const Duration(milliseconds: 300),
                                    child: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: isExpanded
                                          ? const Color(0xFF2988EA)
                                          : const Color(0xFF6B7280),
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (isExpanded) ...[
                              const SizedBox(height: 16),
                              // Divider dengan gradient
                              Container(
                                height: 1.5,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      const Color(0xFF2988EA).withValues(alpha: 0.2),
                                      const Color(0xFF2988EA).withValues(alpha: 0.15),
                                      const Color(0xFF2988EA).withValues(alpha: 0.2),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              // Info cards dengan background
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFFE5E7EB).withValues(alpha: 0.6),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    _DetailRow(
                                      icon: Icons.message_rounded,
                                      label: "Isi Pesan",
                                      value: isiPesan,
                                    ),
                                    const SizedBox(height: 14),
                                    _DetailRow(
                                      icon: Icons.person_rounded,
                                      label: "Dibuat oleh",
                                      value: broadcast.createdBy.isNotEmpty
                                          ? broadcast.createdBy
                                          : 'Admin',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Action buttons dengan design modern
                              Row(
                                children: [
                                  // Edit button dengan gradient
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [Color(0xFF2988EA), Color(0xFF1E6FBA)],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF2988EA).withValues(alpha: 0.25),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditBroadcastPage(
                                                  broadcast: broadcast,
                                                ),
                                              ),
                                            );
                                          },
                                          borderRadius: BorderRadius.circular(12),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 16,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.edit_rounded,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Edit',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Delete button
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEF2F2),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () async {
                                            final confirmed = await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                title: Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: const Icon(
                                                        Icons.delete_rounded,
                                                        color: Color(0xFFEF4444),
                                                        size: 24,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Text(
                                                      'Hapus Broadcast',
                                                      style: GoogleFonts.poppins(
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                content: Text(
                                                  'Apakah Anda yakin ingin menghapus broadcast "$title"?',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: const Color(0xFF6B7280),
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, false),
                                                    child: Text(
                                                      'Batal',
                                                      style: GoogleFonts.poppins(
                                                        fontWeight: FontWeight.w600,
                                                        color: const Color(0xFF6B7280),
                                                      ),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () => Navigator.pop(context, true),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: const Color(0xFFEF4444),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      elevation: 0,
                                                    ),
                                                    child: Text(
                                                      'Hapus',
                                                      style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );

                                            if (confirmed == true && context.mounted) {
                                              try {
                                                await Provider.of<AgendaProvider>(
                                                  context,
                                                  listen: false,
                                                ).deleteAgenda(broadcast.id);

                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Broadcast berhasil dihapus',
                                                        style: GoogleFonts.poppins(),
                                                      ),
                                                      backgroundColor: Colors.green,
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Gagal menghapus broadcast: $e',
                                                        style: GoogleFonts.poppins(),
                                                      ),
                                                      backgroundColor: Colors.red,
                                                    ),
                                                  );
                                                }
                                              }
                                            }
                                          },
                                          borderRadius: BorderRadius.circular(12),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 16,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.delete_rounded,
                                                  size: 18,
                                                  color: Color(0xFFEF4444),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Hapus',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(0xFFEF4444),
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget helper untuk menampilkan detail dengan icon
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2988EA).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: const Color(0xFF2988EA),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6B7280),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Legacy widget - keep for backward compatibility
class _DetailColumn extends StatelessWidget {
  final String label;
  final String value;

  const _DetailColumn({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF7A7C89),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

