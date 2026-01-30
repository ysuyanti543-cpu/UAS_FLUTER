import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  // Fungsi untuk membuka link GForm
  Future<void> _launchGForm() async {
    final Uri url = Uri.parse('https://forms.gle/B5dm1FCNnPUPYVW59');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Tidak bisa membuka $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'DEWAN PERWAKILAN RAKYAT\nAspirasi & Pengaduan Rakyat',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            // MENU UNTUK WARGA
            ListTile(
              leading: const Icon(Icons.assignment_outlined),
              title: const Text('Isi Aspirasi (GForm)'),
              subtitle: const Text('Kirim laporan melalui Google Form'),
              onTap: _launchGForm,
            ),
            ListTile(
              leading: const Icon(Icons.send_outlined),
              title: const Text('Kirim Aspirasi'),
              subtitle: const Text('Kirim aspirasi melalui aplikasi'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/submit-aspirasi');
              },
            ),
            const Divider(),
            // MENU UNTUK PETUGAS (ALUR PERSETUJUAN)
            ListTile(
              leading: const Icon(Icons.fact_check_outlined),
              title: const Text('Persetujuan Petugas'),
              subtitle: const Text('Validasi & Setujui Aspirasi'),
              onTap: () {
                // Berpindah ke halaman persetujuan petugas
                Navigator.pushReplacementNamed(context, '/persetujuan-petugas');
              },
            ),
            // Menu Kembali ke Dashboard
            ListTile(
              leading: const Icon(Icons.dashboard_outlined),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pushReplacementNamed(context, '/resident'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Keluar'),
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ),
    );
  }
}