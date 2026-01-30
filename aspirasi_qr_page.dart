import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models.dart';
import '../services/firebase_service.dart';
import '../widgets/app_drawer.dart';

/// GOOGLE FORM BARU (SUDAH DISAMBUNGKAN)
const String googleFormUrl = 'https://forms.gle/rUnsiu4t9KWfSJPD7';

class AspirasiQrPage extends StatefulWidget {
  static const routeName = '/aspirasi-qr';
  final PengajuanLayanan? pengajuan;

  const AspirasiQrPage({super.key, this.pengajuan});

  @override
  State<AspirasiQrPage> createState() => _AspirasiQrPageState();
}

class _AspirasiQrPageState extends State<AspirasiQrPage> {
  PengajuanLayanan? selectedPengajuan;

  @override
  void initState() {
    super.initState();
    selectedPengajuan = widget.pengajuan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('QR Code Aspirasi'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: StreamBuilder<List<PengajuanLayanan>>(
            stream: FirebaseService.instance.streamPengajuan(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              final pengajuanList = snapshot.data ?? [];
              if (pengajuanList.isEmpty) {
                return const Text('Tidak ada data pengajuan');
              }
              // Set selectedPengajuan if not set
              if (selectedPengajuan == null) {
                selectedPengajuan = pengajuanList.last;
              }
              return Column(
                children: [
                  const Text(
                    'QR Code Aspirasi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// DROPDOWN PILIH DATA
                  DropdownButton<PengajuanLayanan>(
                    value: selectedPengajuan,
                    isExpanded: true,
                    hint: const Text('Pilih Pengajuan'),
                    items: pengajuanList.map((p) {
                      return DropdownMenuItem(
                        value: p,
                        child: Text('${p.jenisLayanan} - ${p.namaPemohon}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedPengajuan = value);
                    },
                  ),

                  const SizedBox(height: 20),

                  if (selectedPengajuan != null) ...[
                    /// QR CODE → GOOGLE FORM
                    QrImageView(
                      data: _generateQrData(selectedPengajuan!),
                      size: 220,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      selectedPengajuan!.jenisLayanan,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 16),

                    /// TOMBOL BUKA GOOGLE FORM
                    ElevatedButton.icon(
                      icon: const Icon(Icons.open_in_browser),
                      label: const Text('Buka Google Form'),
                      onPressed: () async {
                        final uri = Uri.parse(googleFormUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                      },
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// QR LANGSUNG MENGARAH KE GOOGLE FORM
  String _generateQrData(PengajuanLayanan p) {
    return '$googleFormUrl'
        '?id=${p.id}'
        '&jenis=${Uri.encodeComponent(p.jenisLayanan)}'
        '&nama=${Uri.encodeComponent(p.namaPemohon)}'
        '&nik=${p.nik}';
  }
}
