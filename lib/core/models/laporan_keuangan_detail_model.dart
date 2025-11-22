import 'package:cloud_firestore/cloud_firestore.dart';

/// Model untuk Detail Laporan Keuangan
/// Menggabungkan data dari jenis_iuran, pemasukan_lain, dan pengeluaran
class LaporanKeuanganDetail {
  final String id;
  final String type; // 'iuran', 'pemasukan_lain', 'pengeluaran'
  final String kategori;
  final double nominal;
  final DateTime tanggal;
  final String? keterangan;
  final String? verifikator;
  final String? metodePembayaran;

  // Additional info untuk pemasukan
  final String? nikPembayar; // Untuk iuran
  final String? sumberDana;  // Untuk pemasukan_lain

  // Additional info untuk pengeluaran
  final String? namaPenerima;
  final String? noRekening;

  LaporanKeuanganDetail({
    required this.id,
    required this.type,
    required this.kategori,
    required this.nominal,
    required this.tanggal,
    this.keterangan,
    this.verifikator,
    this.metodePembayaran,
    this.nikPembayar,
    this.sumberDana,
    this.namaPenerima,
    this.noRekening,
  });

  /// Factory untuk create dari Iuran
  factory LaporanKeuanganDetail.fromIuran(
    DocumentSnapshot doc,
    String jenisIuranNama,
  ) {
    final data = doc.data() as Map<String, dynamic>;

    return LaporanKeuanganDetail(
      id: doc.id,
      type: 'iuran',
      kategori: 'Pemasukan dari Iuran: $jenisIuranNama',
      nominal: (data['nominal'] ?? 0).toDouble(),
      tanggal: (data['tanggal_pembayaran'] as Timestamp).toDate(),
      keterangan: data['keterangan'],
      verifikator: data['verifikator'],
      metodePembayaran: data['metode_pembayaran'],
      nikPembayar: data['nik'],
    );
  }

  /// Factory untuk create dari Pemasukan Lain
  factory LaporanKeuanganDetail.fromPemasukanLain(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return LaporanKeuanganDetail(
      id: doc.id,
      type: 'pemasukan_lain',
      kategori: 'Pemasukan Lainnya: ${data['kategori'] ?? 'Tidak Diketahui'}',
      nominal: (data['nominal'] ?? 0).toDouble(),
      tanggal: (data['tanggal'] as Timestamp).toDate(),
      keterangan: data['keterangan'],
      verifikator: data['verifikator'],
      metodePembayaran: data['metode_pembayaran'],
      sumberDana: data['sumber_dana'],
    );
  }

  /// Factory untuk create dari Pengeluaran
  factory LaporanKeuanganDetail.fromPengeluaran(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return LaporanKeuanganDetail(
      id: doc.id,
      type: 'pengeluaran',
      kategori: 'Pengeluaran: ${data['kategori'] ?? 'Tidak Diketahui'}',
      nominal: (data['nominal'] ?? 0).toDouble(),
      tanggal: (data['tanggal'] as Timestamp).toDate(),
      keterangan: data['keterangan'],
      verifikator: data['verifikator'],
      metodePembayaran: data['metode_pembayaran'],
      namaPenerima: data['nama_penerima'],
      noRekening: data['no_rekening'],
    );
  }

  /// Untuk sorting (terbaru dulu)
  static int compareByDate(LaporanKeuanganDetail a, LaporanKeuanganDetail b) {
    return b.tanggal.compareTo(a.tanggal);
  }

  /// Check apakah pemasukan atau pengeluaran
  bool get isPemasukan => type == 'iuran' || type == 'pemasukan_lain';
  bool get isPengeluaran => type == 'pengeluaran';

  /// Get icon berdasarkan type
  String get iconType {
    switch (type) {
      case 'iuran':
        return 'iuran';
      case 'pemasukan_lain':
        return 'pemasukan';
      case 'pengeluaran':
        return 'pengeluaran';
      default:
        return 'unknown';
    }
  }

  /// Get label yang lebih readable
  String get typeLabel {
    switch (type) {
      case 'iuran':
        return 'Iuran';
      case 'pemasukan_lain':
        return 'Pemasukan Lain';
      case 'pengeluaran':
        return 'Pengeluaran';
      default:
        return 'Tidak Diketahui';
    }
  }
}

