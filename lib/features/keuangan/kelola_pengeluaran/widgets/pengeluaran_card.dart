import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/pengeluaran_model.dart';

class PengeluaranCard extends StatelessWidget {
  final PengeluaranModel pengeluaran;
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onVerify;
  final VoidCallback? onReject;
  final String? currentUserRole;

  const PengeluaranCard({
    super.key,
    required this.pengeluaran,
    required this.isExpanded,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.onVerify,
    this.onReject,
    this.currentUserRole,
  });

  Color get _categoryColor {
    switch (pengeluaran.category.toLowerCase()) {
      case 'operasional':
        return const Color(0xFFEB5757);
      case 'infrastruktur':
        return const Color(0xFFF59E0B);
      case 'utilitas':
        return const Color(0xFF3B82F6);
      case 'kegiatan':
        return const Color(0xFF8B5CF6);
      case 'administrasi':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData get _categoryIcon {
    switch (pengeluaran.category.toLowerCase()) {
      case 'operasional':
        return Icons.business_center_rounded;
      case 'infrastruktur':
        return Icons.construction_rounded;
      case 'utilitas':
        return Icons.electrical_services_rounded;
      case 'kegiatan':
        return Icons.event_rounded;
      case 'administrasi':
        return Icons.description_rounded;
      default:
        return Icons.attach_money_rounded;
    }
  }

  Color get _statusColor {
    switch (pengeluaran.status) {
      case 'Terverifikasi':
        return const Color(0xFF10B981);
      case 'Menunggu':
        return const Color(0xFFF59E0B);
      case 'Ditolak':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isExpanded ? _categoryColor.withValues(alpha: 0.3) : const Color(0xFFE8EAF2),
          width: isExpanded ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isExpanded ? _categoryColor.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.04),
            blurRadius: isExpanded ? 20 : 10,
            offset: Offset(0, isExpanded ? 8 : 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _categoryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _categoryColor.withValues(alpha: 0.3)),
                    ),
                    child: Icon(_categoryIcon, color: _categoryColor, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pengeluaran.name,
                          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: _categoryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: _categoryColor.withValues(alpha: 0.2)),
                              ),
                              child: Text(
                                pengeluaran.category,
                                style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: _categoryColor),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: _statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: _statusColor.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                pengeluaran.status,
                                style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: _statusColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currencyFormat.format(pengeluaran.nominal),
                          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w800, color: _categoryColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dateFormat.format(pengeluaran.tanggal),
                          style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF9CA3AF), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: _categoryColor,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) _buildExpandedContent(context),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context) {
    final isAdmin = currentUserRole == 'Admin';
    final isBendahara = currentUserRole == 'Bendahara';
    final isPending = pengeluaran.status == 'Menunggu';
    final canVerify = (isAdmin || isBendahara) && isPending;

    // Debug logging
    debugPrint('🎨 PengeluaranCard Debug:');
    debugPrint('   - currentUserRole: $currentUserRole');
    debugPrint('   - isAdmin: $isAdmin');
    debugPrint('   - isBendahara: $isBendahara');
    debugPrint('   - status: ${pengeluaran.status}');
    debugPrint('   - isPending: $isPending');
    debugPrint('   - canVerify: $canVerify');
    debugPrint('   - onVerify != null: ${onVerify != null}');
    debugPrint('   - onReject != null: ${onReject != null}');

    return Container(
      decoration: BoxDecoration(
        color: _categoryColor.withValues(alpha: 0.03),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pengeluaran.deskripsi != null) ...[
            _buildDetailRow('Deskripsi', pengeluaran.deskripsi!),
            const SizedBox(height: 12),
          ],
          if (pengeluaran.penerima != null) ...[
            _buildDetailRow('Penerima', pengeluaran.penerima!),
            const SizedBox(height: 12),
          ],
          _buildDetailRow('Dilaporkan oleh', pengeluaran.createdBy),
          const SizedBox(height: 16),

          // TOMBOL VERIFIKASI/TOLAK - PRIORITAS UTAMA untuk status Menunggu
          if (isPending && (isAdmin || isBendahara)) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.pending_actions, color: const Color(0xFFF59E0B), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Menunggu verifikasi ${isAdmin ? 'Admin' : 'Bendahara'}',
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFFF59E0B)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (onVerify != null)
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.check_circle_rounded,
                      label: 'Verifikasi',
                      color: const Color(0xFF10B981),
                      onTap: () {
                        debugPrint('🎯 Verifikasi button tapped!');
                        onVerify!();
                      },
                    ),
                  ),
                if (onVerify != null && onReject != null) const SizedBox(width: 8),
                if (onReject != null)
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.cancel_rounded,
                      label: 'Tolak',
                      color: const Color(0xFFEF4444),
                      onTap: () {
                        debugPrint('🎯 Tolak button tapped!');
                        onReject!();
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // TOMBOL EDIT/HAPUS untuk Bendahara
          if (isBendahara && (onEdit != null || onDelete != null)) ...[
            Row(
              children: [
                if (onEdit != null)
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.edit_rounded,
                      label: 'Edit',
                      color: const Color(0xFF2988EA),
                      onTap: onEdit!,
                    ),
                  ),
                if (onEdit != null && onDelete != null) const SizedBox(width: 8),
                if (onDelete != null)
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.delete_rounded,
                      label: 'Hapus',
                      color: const Color(0xFFEF4444),
                      onTap: onDelete!,
                    ),
                  ),
              ],
            ),
          ],

          // INFO untuk Admin pada status Terverifikasi/Ditolak
          if (isAdmin && !isPending) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _statusColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(_statusColor == const Color(0xFF10B981) ? Icons.check_circle : Icons.cancel,
                       color: _statusColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    pengeluaran.status == 'Terverifikasi'
                        ? 'Pengeluaran sudah diverifikasi'
                        : 'Pengeluaran ditolak',
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: _statusColor),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF6B7280)),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF1F2937), height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
      ),
    );
  }
}

