import 'package:flutter/material.dart';
import '../models.dart';
import '../services/mock_service.dart';
import '../widgets/app_drawer.dart';

class ManageUserPage extends StatefulWidget {
  static const routeName = '/manage-user';
  const ManageUserPage({super.key});

  @override
  State<ManageUserPage> createState() => _ManageUserPageState();
}

class _ManageUserPageState extends State<ManageUserPage> {
  @override
  Widget build(BuildContext context) {
    final petugas = MockService.instance.getAllPetugas();
    final kelurahan = MockService.instance.getSubdistricts();

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Manajemen Petugas'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _formPetugas(),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: petugas.length,
        itemBuilder: (context, index) {
          final p = petugas[index];
          final namaKelurahan = kelurahan
              .firstWhere((k) => k.id == p.subdistrictId, orElse: () => Subdistrict(id: '-', name: '-'))
              .name;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(p.name),
              subtitle: Text('Kelurahan: $namaKelurahan'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _formPetugas(petugas: p),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        MockService.instance.deletePetugas(p.id);
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _formPetugas({Seller? petugas}) {
    final nameCtrl = TextEditingController(text: petugas?.name);
    String? selectedKelurahan = petugas?.subdistrictId;

    final kelurahan = MockService.instance.getSubdistricts();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(petugas == null ? 'Tambah Petugas' : 'Edit Petugas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nama Petugas'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedKelurahan,
              items: kelurahan
                  .map(
                    (k) => DropdownMenuItem(
                      value: k.id,
                      child: Text(k.name),
                    ),
                  )
                  .toList(),
              onChanged: (v) => selectedKelurahan = v,
              decoration: const InputDecoration(labelText: 'Kelurahan'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (petugas == null) {
                  MockService.instance.addPetugas(
                    nameCtrl.text,
                    selectedKelurahan!,
                  );
                } else {
                  MockService.instance.updatePetugas(
                    petugas.id,
                    nameCtrl.text,
                    selectedKelurahan!,
                  );
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
