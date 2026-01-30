import 'package:cloud_firestore/cloud_firestore.dart';

class Subdistrict {
  final String id;
  final String name;

  const Subdistrict({
    required this.id,
    required this.name,
  });
}

class Seller {
  final String id;
  final String name;
  final String subdistrictId;

  const Seller({
    required this.id,
    required this.name,
    required this.subdistrictId,
  });
}

class Resident {
  final String id;
  final String name;
  final String subdistrictId;

  const Resident({
    required this.id,
    required this.name,
    required this.subdistrictId,
  });
}

class Admin {
  final String id;
  final String name;

  const Admin({
    required this.id,
    required this.name,
  });
}

class Layanan {
  final String id;
  String nama;
  String deskripsi;

  Layanan({
    required this.id,
    required this.nama,
    required this.deskripsi,
  });
}

// Simple enum to represent user roles used across UI widgets
enum UserRole { admin, seller, resident }

enum StatusPengajuan {
  diajukan,
  diproses,
  ditolak,
  selesai,
}

class PengajuanLayanan {
  final String id;
  final String jenisLayanan;
  final String namaPemohon;
  final String nik;
  final String keterangan;
  final DateTime tanggal;
  final StatusPengajuan status;

  PengajuanLayanan({
    required this.id,
    required this.jenisLayanan,
    required this.namaPemohon,
    required this.nik,
    required this.keterangan,
    required this.tanggal,
    required this.status,
  });
}
