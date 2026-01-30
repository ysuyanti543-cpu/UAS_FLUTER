import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models.dart';

class MockService {
  MockService._internal();
  static final MockService instance = MockService._internal();

  final List<PengajuanLayanan> _pengajuans = [];
  final List<Subdistrict> _subdistricts = [];
  final List<Seller> _sellers = [];
  final List<Layanan> _layanans = [];

  /// ================= INISIALISASI DATA =================
  Future<void> initSampleData() async {
    _pengajuans.clear();
    _subdistricts.clear();
    _sellers.clear();
    _layanans.clear();

    await _loadPengajuans(); // Load data aspirasi dari memori HP

    // 1. Data Wilayah (Untuk Dropdown di Admin & ManageUser)
    _subdistricts.addAll(const [
      Subdistrict(id: 'sd1', name: 'Sekejati'),
      Subdistrict(id: 'sd2', name: 'Megasari'),
    ]);

    // 2. Data Petugas/Anggota Dewan (Untuk AdminPage & SellerPage)
    _sellers.addAll([
      Seller(id: 's1', name: 'Anggota Dewan A', subdistrictId: 'sd1'),
      Seller(id: 's2', name: 'Anggota Dewan B', subdistrictId: 'sd2'),
    ]);

    // 3. Data Layanan (Untuk LayananPage)
    _layanans.addAll([
      Layanan(id: 'l1', nama: 'Infrastruktur', deskripsi: 'Jalan & Jembatan'),
      Layanan(id: 'l2', nama: 'Kesehatan', deskripsi: 'RS & Puskesmas'),
    ]);

    // 4. Data Aspirasi Default (ID '1' untuk simulasi SCAN)
    if (_pengajuans.isEmpty) {
      _pengajuans.add(
        PengajuanLayanan(
          id: '1',
          jenisLayanan: 'Aspirasi Infrastruktur',
          namaPemohon: 'Warga via GForm',
          nik: '320101XXXXXXXX',
          keterangan: 'Jalan rusak depan balai desa.',
          tanggal: DateTime.now(),
          status: StatusPengajuan.diajukan,
        ),
      );
      await _savePengajuans();
    }
  }

  /// ================= GETTER (Ambil Data) =================
  List<Subdistrict> getSubdistricts() => List.unmodifiable(_subdistricts);
  List<Seller> getSellers() => List.unmodifiable(_sellers);
  List<Seller> getAllPetugas() => getSellers(); // Alias untuk ManageUserPage
  List<Layanan> getLayanans() => List.unmodifiable(_layanans);
  List<PengajuanLayanan> getPengajuan() => List.unmodifiable(_pengajuans);

  /// ================= MANAJEMEN PETUGAS (Admin & ManageUser) =================
  void addPetugas(String name, String subdistrictId) {
    final id = 's${_sellers.length + 1}';
    _sellers.add(Seller(id: id, name: name, subdistrictId: subdistrictId));
  }

  void addSeller(String name, String subdistrictId) => addPetugas(name, subdistrictId); // Alias untuk AdminPage

  void updatePetugas(String id, String name, String subdistrictId) {
    final index = _sellers.indexWhere((s) => s.id == id);
    if (index != -1) {
      _sellers[index] = Seller(id: id, name: name, subdistrictId: subdistrictId);
    }
  }

  void deletePetugas(String id) {
    _sellers.removeWhere((s) => s.id == id);
  }

  /// ================= MANAJEMEN LAYANAN (LayananPage) =================
  void addLayanan(String nama, String deskripsi) {
    final id = 'l${_layanans.length + 1}';
    _layanans.add(Layanan(id: id, nama: nama, deskripsi: deskripsi));
  }

  void updateLayanan(String id, String nama, String deskripsi) {
    final index = _layanans.indexWhere((l) => l.id == id);
    if (index != -1) {
      _layanans[index] = Layanan(id: id, nama: nama, deskripsi: deskripsi);
    }
  }

  void deleteLayanan(String id) {
    _layanans.removeWhere((l) => l.id == id);
  }

  /// ================= MANAJEMEN ASPIRASI (Resident & Scanner) =================
  void addPengajuan(String jenis, String nama, String nik, String ket) {
    final id = (_pengajuans.length + 1).toString();
    _pengajuans.add(PengajuanLayanan(
      id: id, jenisLayanan: jenis, namaPemohon: nama, nik: nik, 
      keterangan: ket, tanggal: DateTime.now(), status: StatusPengajuan.diajukan,
    ));
    _savePengajuans();
  }

  void updateStatus(String id, StatusPengajuan status) {
    final index = _pengajuans.indexWhere((p) => p.id == id);
    if (index != -1) {
      final p = _pengajuans[index];
      _pengajuans[index] = PengajuanLayanan(
        id: p.id, jenisLayanan: p.jenisLayanan, namaPemohon: p.namaPemohon, 
        nik: p.nik, keterangan: p.keterangan, tanggal: p.tanggal, status: status,
      );
      _savePengajuans();
    }
  }

  /// ================= PENYIMPANAN LOKAL =================
  Future<void> _loadPengajuans() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('pengajuans');
    if (data != null) {
      final List<dynamic> decoded = json.decode(data);
      _pengajuans.clear();
      for (var item in decoded) {
        _pengajuans.add(PengajuanLayanan(
          id: item['id'],
          jenisLayanan: item['jenisLayanan'],
          namaPemohon: item['namaPemohon'],
          nik: item['nik'] ?? '',
          keterangan: item['keterangan'] ?? '',
          tanggal: DateTime.parse(item['tanggal']),
          status: StatusPengajuan.values.firstWhere(
            (e) => e.toString().split('.').last == item['status'],
            orElse: () => StatusPengajuan.diajukan,
          ),
        ));
      }
    }
  }

  Future<void> _savePengajuans() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> dataJson = _pengajuans.map((p) => {
      'id': p.id, 'jenisLayanan': p.jenisLayanan, 'namaPemohon': p.namaPemohon, 
      'nik': p.nik, 'keterangan': p.keterangan, 'tanggal': p.tanggal.toIso8601String(),
      'status': p.status.toString().split('.').last,
    }).toList();
    await prefs.setString('pengajuans', json.encode(dataJson));
  }
}