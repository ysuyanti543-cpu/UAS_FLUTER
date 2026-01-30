import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/mock_service.dart';
import '../models.dart';
import '../widgets/app_drawer.dart';

const String googleFormUrl = 'https://forms.gle/nvJ8rd2jwhDAspSeA';

class SubmitAspirasiPage extends StatefulWidget {
  static const routeName = '/submit-aspirasi';
  const SubmitAspirasiPage({super.key});

  @override
  State<SubmitAspirasiPage> createState() => _SubmitAspirasiPageState();
}

class _SubmitAspirasiPageState extends State<SubmitAspirasiPage> {
  final _formKey = GlobalKey<FormState>();
  final _jenisCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  final _nikCtrl = TextEditingController();
  final _keteranganCtrl = TextEditingController();

  @override
  void dispose() {
    _jenisCtrl.dispose();
    _namaCtrl.dispose();
    _nikCtrl.dispose();
    _keteranganCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kirim Aspirasi')),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _jenisCtrl,
                decoration: const InputDecoration(labelText: 'Jenis Aspirasi'),
                validator: (v) => (v ?? '').isEmpty ? 'Masukkan jenis aspirasi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _namaCtrl,
                decoration: const InputDecoration(labelText: 'Nama Pemohon'),
                validator: (v) => (v ?? '').isEmpty ? 'Masukkan nama' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nikCtrl,
                decoration: const InputDecoration(labelText: 'NIK'),
                validator: (v) => (v ?? '').isEmpty ? 'Masukkan NIK' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _keteranganCtrl,
                decoration: const InputDecoration(labelText: 'Keterangan'),
                validator: (v) => (v ?? '').isEmpty ? 'Masukkan keterangan' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Kirim Aspirasi ke Petugas'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final pengajuan = PengajuanLayanan(
      id: '',
      jenisLayanan: _jenisCtrl.text.trim(),
      namaPemohon: _namaCtrl.text.trim(),
      nik: _nikCtrl.text.trim(),
      keterangan: _keteranganCtrl.text.trim(),
      tanggal: DateTime.now(),
      status: StatusPengajuan.diajukan,
    );

    try {
      MockService.instance.addPengajuan(
        _jenisCtrl.text.trim(),
        _namaCtrl.text.trim(),
        _nikCtrl.text.trim(),
        _keteranganCtrl.text.trim(),
      );

      // Create created object for dialog
      final created = PengajuanLayanan(
        id: '1', // Mock ID since MockService generates it internally
        jenisLayanan: _jenisCtrl.text.trim(),
        namaPemohon: _namaCtrl.text.trim(),
        nik: _nikCtrl.text.trim(),
        keterangan: _keteranganCtrl.text.trim(),
        tanggal: DateTime.now(),
        status: StatusPengajuan.diajukan,
      );

      // Close loading dialog
      Navigator.of(context).pop();

      // Show success dialog with clear next steps
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Aspirasi Berhasil Dibuat!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jenis Aspirasi: ${created.jenisLayanan}'),
              Text('Nama Pemohon: ${created.namaPemohon}'),
              Text('Status: ${_statusText(created.status)}'),
              const SizedBox(height: 16),
              const Text(
                'Langkah selanjutnya:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('1. Petugas akan memproses pengajuan Anda'),
              const Text('2. Anda dapat melihat status pengajuan di halaman persetujuan petugas'),
              const Text('3. Laporan PDF dapat diakses di halaman persetujuan'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Navigate to persetujuan petugas page to see status
                Navigator.of(context).pushReplacementNamed('/persetujuan-petugas');
                // Clear the form
                _clearForm();
              },
              child: const Text('Lihat Status Pengajuan'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuat aspirasi: ${e.toString()}')),
      );
    }
  }

  void _clearForm() {
    _jenisCtrl.clear();
    _namaCtrl.clear();
    _nikCtrl.clear();
    _keteranganCtrl.clear();
  }

  String _statusText(StatusPengajuan s) {
    switch (s) {
      case StatusPengajuan.diajukan:
        return 'Diajukan';
      case StatusPengajuan.diproses:
        return 'Diproses';
      case StatusPengajuan.ditolak:
        return 'Ditolak';
      case StatusPengajuan.selesai:
        return 'Selesai';
    }
  }
}
