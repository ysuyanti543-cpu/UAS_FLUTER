import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'pengajuan_administrasi_page.dart';

class AdministrasiKependudukanPage extends StatelessWidget {
  static const routeName = '/administrasi-kependudukan';
  const AdministrasiKependudukanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Administrasi Kependudukan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _menuItem(
            context,
            icon: Icons.credit_card,
            title: 'Pengajuan KTP',
          ),
          _menuItem(
            context,
            icon: Icons.group,
            title: 'Pengajuan KK',
          ),
          _menuItem(
            context,
            icon: Icons.home,
            title: 'Surat Domisili',
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PengajuanAdministrasiPage(judul: title),
          ),
        );
      },
    );
  }
}
