import 'package:cloud_firestore/cloud_firestore.dart';

enum TipeTransaksi {
  pemasukanIuran,
  pemasukanLain,
  pengeluaran,
}

class LaporanKeuanganDetail {
  final String id;
  final String kategori; // Nama iuran / kategori pemasukan / kategori pengeluaran
  final double nominal;
  final DateTime tanggal;
  final TipeTransaksi tipe;
  final String? keterangan;
  final String? verifikator;
  final String? metodePembayaran;

  // Khusus untuk pemasukan iuran
  final String? nikPembayar;
  final String? namaPembayar;

  // Khusus untuk pemasukan lain
  final String? sumberDana;

  // Khusus untuk pengeluaran
  final String? namaPenerima;
  final String? noRekening;

  LaporanKeuanganDetail({
    required this.id,
    required this.kategori,
    required this.nominal,
    required this.tanggal,
    required this.tipe,
    this.keterangan,
    this.verifikator,
    this.metodePembayaran,
    this.nikPembayar,
    this.namaPembayar,
    this.sumberDana,
    this.namaPenerima,
    this.noRekening,
  });

  // Getter untuk label tipe
  String get typeLabel {
    switch (tipe) {
      case TipeTransaksi.pemasukanIuran:
        return 'Pemasukan dari Iuran';
      case TipeTransaksi.pemasukanLain:
        return 'Pemasukan Lainnya';
      case TipeTransaksi.pengeluaran:
        return 'Pengeluaran';
    }
  }

  // Factory constructor dari Firestore - Pemasukan Iuran
  factory LaporanKeuanganDetail.fromFirestoreIuran(
    DocumentSnapshot doc,
    String namaIuran,
  ) {
    final data = doc.data() as Map<String, dynamic>;
    return LaporanKeuanganDetail(
      id: doc.id,
      kategori: namaIuran,
      nominal: (data['nominal'] ?? 0).toDouble(),
      tanggal: (data['tanggal_pembayaran'] as Timestamp).toDate(),
      tipe: TipeTransaksi.pemasukanIuran,
      keterangan: data['keterangan'],
      verifikator: data['verifikator'],
      metodePembayaran: data['metode_pembayaran'],
      nikPembayar: data['nik'],
      namaPembayar: data['nama_pembayar'],
    );
  }

  // Factory constructor dari Firestore - Pemasukan Lain
  factory LaporanKeuanganDetail.fromFirestorePemasukanLain(
    DocumentSnapshot doc,
  ) {
    final data = doc.data() as Map<String, dynamic>;
    return LaporanKeuanganDetail(
      id: doc.id,
      kategori: data['kategori'] ?? 'Pemasukan Lain',
      nominal: (data['nominal'] ?? 0).toDouble(),
      tanggal: (data['tanggal'] as Timestamp).toDate(),
      tipe: TipeTransaksi.pemasukanLain,
      keterangan: data['keterangan'],
      verifikator: data['verifikator'],
      metodePembayaran: data['metode_pembayaran'],
      sumberDana: data['sumber_dana'],
    );
  }

  // Factory constructor dari Firestore - Pengeluaran
  factory LaporanKeuanganDetail.fromFirestorePengeluaran(
    DocumentSnapshot doc,
  ) {
    final data = doc.data() as Map<String, dynamic>;
    return LaporanKeuanganDetail(
      id: doc.id,
      kategori: data['kategori'] ?? 'Pengeluaran',
      nominal: (data['nominal'] ?? 0).toDouble(),
      tanggal: (data['tanggal'] as Timestamp).toDate(),
      tipe: TipeTransaksi.pengeluaran,
      keterangan: data['keterangan'],
      verifikator: data['verifikator'],
      metodePembayaran: data['metode_pembayaran'],
      namaPenerima: data['nama_penerima'],
      noRekening: data['no_rekening'],
    );
  }
}

