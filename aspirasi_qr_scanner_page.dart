import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/firebase_service.dart';
import '../models.dart';

class AspirasiQrScannerPage extends StatefulWidget {
  const AspirasiQrScannerPage({super.key});

  @override
  State<AspirasiQrScannerPage> createState() => _AspirasiQrScannerPageState();
}

class _AspirasiQrScannerPageState extends State<AspirasiQrScannerPage> {
  bool _isDone = false;

  void _processScan(String code) async {
    if (_isDone) return;
    _isDone = true;

    try {
      // Mengubah status dokumen di Firebase berdasarkan ID hasil scan
      await FirebaseService.instance.updateStatus(code, StatusPengajuan.diproses);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil! Data telah diupdate.'), backgroundColor: Colors.green),
      );
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ID Tidak Valid: $e'), backgroundColor: Colors.red),
      );
      _isDone = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Aspirasi')),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
            _processScan(barcodes.first.rawValue!);
          }
        },
      ),
    );
  }
}