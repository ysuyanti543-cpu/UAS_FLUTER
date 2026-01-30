import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:qr/qr.dart';
import 'package:image/image.dart' as img;
import '../services/firebase_service.dart';
import '../widgets/app_drawer.dart';
import '../models.dart';

class AspirasiReportPage extends StatelessWidget {
  static const routeName = '/laporan-aspirasi';
  const AspirasiReportPage({super.key});

  Future<Uint8List> _buildPdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    final snapshot = await FirebaseService.instance.streamPengajuan().first;
    final data = snapshot;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('Laporan Aspirasi')),
          pw.SizedBox(height: 8),
          pw.Text(
            'Catatan: Data lengkap aspirasi tersimpan di Google Form. Data di bawah adalah data awal yang dikirim dari aplikasi.',
            style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic),
          ),
          pw.SizedBox(height: 8),
          if (data.isEmpty)
            pw.Text('Tidak ada data pengajuan')
          else
            pw.Table.fromTextArray(
              headers: ['ID', 'Jenis', 'Pemohon', 'NIK', 'Keterangan Awal', 'Tanggal', 'Status'],
              data: data
                  .map((p) => [
                        p.id,
                        p.jenisLayanan,
                        p.namaPemohon,
                        p.nik,
                        p.keterangan.length > 50 ? '${p.keterangan.substring(0, 50)}...' : p.keterangan,
                        p.tanggal.toString().split(' ')[0], // Only date part
                        p.status.toString().split('.').last,
                      ])
                  .toList(),
            ),
          pw.SizedBox(height: 16),
          pw.Text(
            'Link Google Form untuk data lengkap: https://forms.gle/nvJ8rd2jwhDAspSeA',
            style: pw.TextStyle(fontSize: 10, color: PdfColors.blue),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Laporan Aspirasi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Generate & Print PDF',
            onPressed: () async {
              try {
                await Printing.layoutPdf(onLayout: (format) => _buildPdf(format));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error generating PDF: ${e.toString()}')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.assignment),
            tooltip: 'Kelola Persetujuan Petugas',
            onPressed: () => Navigator.of(context).pushNamed('/persetujuan-petugas'),
          ),
        ],
      ),
      body: StreamBuilder<List<PengajuanLayanan>>(
        stream: FirebaseService.instance.streamPengajuan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error?.toString() ?? 'Unknown error'}'));
          }
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data pengajuan aspirasi',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final p = data[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              p.jenisLayanan,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _statusBadge(p.status),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Pemohon: ${p.namaPemohon}'),
                      Text('NIK: ${p.nik}'),
                      Text('Tanggal: ${p.tanggal.toString().split(' ')[0]}'),
                      const SizedBox(height: 8),
                      Text(
                        'Keterangan: ${p.keterangan}',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _statusBadge(StatusPengajuan status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        _statusText(status),
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
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

  Color _statusColor(StatusPengajuan s) {
    switch (s) {
      case StatusPengajuan.diajukan:
        return Colors.orange;
      case StatusPengajuan.diproses:
        return Colors.blue;
      case StatusPengajuan.ditolak:
        return Colors.red;
      case StatusPengajuan.selesai:
        return Colors.green;
    }
  }
}
