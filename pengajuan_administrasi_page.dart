import 'package:flutter/material.dart';
import '../models.dart';
import '../services/mock_service.dart';
import '../widgets/app_drawer.dart';

class PengajuanAdministrasiPage extends StatefulWidget {
  final String judul;
  const PengajuanAdministrasiPage({super.key, required this.judul});

  @override
  State<PengajuanAdministrasiPage> createState() =>
      _PengajuanAdministrasiPageState();
}

class _PengajuanAdministrasiPageState
    extends State<PengajuanAdministrasiPage> {

  final _namaCtrl = TextEditingController();
  final _nikCtrl = TextEditingController();
  final _ketCtrl = TextEditingController();

  StatusPengajuan status = StatusPengajuan.diajukan;

  String get statusText {
    switch (status) {
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

  Color get statusColor {
    switch (status) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: Text(widget.judul)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // STATUS
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: statusColor),
                  const SizedBox(width: 8),
                  Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _namaCtrl,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nikCtrl,
              decoration: const InputDecoration(
                labelText: 'NIK',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ketCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Keterangan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                MockService.instance.addPengajuan(
                  widget.judul,
                  _namaCtrl.text,
                  _nikCtrl.text,
                  _ketCtrl.text,
                );

                setState(() {
                  status = StatusPengajuan.diajukan;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pengajuan berhasil dikirim'),
                  ),
                );

                Navigator.pop(context);
              },
              child: const Text('Kirim Pengajuan'),
            ),

            const SizedBox(height: 12),

            // SIMULASI ADMIN (UNTUK DEMO / UAS)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        status = StatusPengajuan.selesai;
                      });
                    },
                    child: const Text('Setujui'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        status = StatusPengajuan.ditolak;
                      });
                    },
                    child: const Text('Tolak'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
