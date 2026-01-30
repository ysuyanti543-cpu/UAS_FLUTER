import 'package:cloud_firestore/cloud_firestore.dart';
import '../models.dart';

class FirebaseService {
  FirebaseService._internal();
  static final FirebaseService instance = FirebaseService._internal();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fungsi untuk menyimpan aspirasi baru dari halaman Submit
  Future<String> tambahPengajuan(PengajuanLayanan p) async {
    final docRef = await _db.collection('pengajuans').add({
      'jenisLayanan': p.jenisLayanan,
      'namaPemohon': p.namaPemohon,
      'nik': p.nik,
      'keterangan': p.keterangan,
      'tanggal': Timestamp.fromDate(p.tanggal),
      'status': 'diajukan',
    });
    return docRef.id;
  }

  // Fungsi stream agar halaman Persetujuan update otomatis (Real-time)
  Stream<List<PengajuanLayanan>> streamPengajuan() {
    return _db.collection('pengajuans')
        .orderBy('tanggal', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return PengajuanLayanan(
                id: doc.id,
                jenisLayanan: data['jenisLayanan'] ?? '',
                namaPemohon: data['namaPemohon'] ?? '',
                nik: data['nik'] ?? '',
                keterangan: data['keterangan'] ?? '',
                tanggal: (data['tanggal'] as Timestamp).toDate(),
                status: StatusPengajuan.values.firstWhere(
                  (e) => e.name == data['status'],
                  orElse: () => StatusPengajuan.diajukan,
                ),
              );
            }).toList());
  }

  Future<void> updateStatus(String id, StatusPengajuan status) async {
    await _db.collection('pengajuans').doc(id).update({'status': status.name});
  }
}