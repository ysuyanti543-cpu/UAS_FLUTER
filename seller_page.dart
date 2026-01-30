import 'package:flutter/material.dart';

import '../models.dart';
import '../services/mock_service.dart';
import '../widgets/app_drawer.dart';

class SellerPage extends StatelessWidget {
  static const routeName = '/seller';
  const SellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sellers = MockService.instance.getSellers();
    final subdistricts = MockService.instance.getSubdistricts();

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Data Petugas / UMKM')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sellers.length,
        itemBuilder: (context, index) {
          final s = sellers[index];
          final sd = subdistricts.firstWhere(
            (e) => e.id == s.subdistrictId,
            orElse: () => subdistricts.isNotEmpty
                ? subdistricts.first
                : Subdistrict(id: '-', name: '-'),
          );

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF5C6BC0),
                child: Icon(Icons.store, color: Colors.white),
              ),
              title: Text(s.name),
              subtitle: Text('Kelurahan ${sd.name}'),
            ),
          );
        },
      ),
    );
  }
}
