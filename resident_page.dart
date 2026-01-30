import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qr/qr.dart';
import 'package:image/image.dart' as img;
import '../services/mock_service.dart';
import '../models.dart';
import '../widgets/app_drawer.dart';
// Jika file ini merah, pastikan path-nya benar atau hapus jika tidak pakai scanner lagi
import 'aspirasi_qr_scanner_page.dart';

class ResidentPage extends StatefulWidget {
  static const routeName = '/resident';
  const ResidentPage({super.key});

  @override
  State<ResidentPage> createState() => _ResidentPageState();
}

class _ResidentPageState extends State<ResidentPage> {
  @override
  Widget build(BuildContext context) {
    // Memanggil data dari MockService
    final pengajuan = MockService.instance.getPengajuan();

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Dashboard Warga'),
      ),
      body: pengajuan.isEmpty
          ? const Center(
              child: Text('Belum ada pengajuan aspirasi'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pengajuan.length,
              itemBuilder: (context, index) {
                final p = pengajuan[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.jenisLayanan,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Pemohon: ${p.namaPemohon}'),
                        const SizedBox(height: 8),
                        _statusBadge(p.status),
                        if (p.status == StatusPengajuan.diproses) ...[
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.qr_code),
                            label: const Text('Lihat QR'),
                            onPressed: () => _showQrDialog(context, p),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/submit-aspirasi');
        },
      ),
    );
  }

  // Widget untuk menampilkan status dengan warna
  Widget _statusBadge(StatusPengajuan status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        _statusText(status),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _statusText(StatusPengajuan status) {
    switch (status) {
      case StatusPengajuan.diajukan: return 'Diajukan';
      case StatusPengajuan.diproses: return 'Diproses';
      case StatusPengajuan.ditolak: return 'Ditolak';
      case StatusPengajuan.selesai: return 'Selesai';
    }
  }

  Color _statusColor(StatusPengajuan status) {
    switch (status) {
      case StatusPengajuan.diajukan: return Colors.orange;
      case StatusPengajuan.diproses: return Colors.blue;
      case StatusPengajuan.ditolak: return Colors.red;
      case StatusPengajuan.selesai: return Colors.green;
    }
  }

  void _showQrDialog(BuildContext context, PengajuanLayanan p) {
    const String googleFormUrl = 'https://forms.gle/nvJ8rd2jwhDAspSeA';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('QR Google Form Aspirasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.memory(_generateQrImage(p, googleFormUrl)),
            const SizedBox(height: 8),
            const Text(
              'Scan QR untuk membuka Google Form',
              textAlign: TextAlign.center,
            ),
          ],
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

  Uint8List _generateQrImage(PengajuanLayanan p, String googleFormUrl) {
    final url = '$googleFormUrl?id=${p.id}&source=flutter';
    final qr = QrCode(4, QrErrorCorrectLevel.L)..addData(url);
    final qrImage = QrImage(qr);
    final image = img.Image(width: 200, height: 200);
    for (int y = 0; y < 200; y++) {
      for (int x = 0; x < 200; x++) {
        final dark = qrImage.isDark(y * qr.moduleCount ~/ 200, x * qr.moduleCount ~/ 200);
        image.setPixel(x, y, dark ? img.ColorRgb8(0, 0, 0) : img.ColorRgb8(255, 255, 255));
      }
    }
    return Uint8List.fromList(img.encodePng(image));
  }
}
