import 'package:flutter/material.dart';
import '../services/mock_service.dart';
import '../models.dart';
import '../widgets/app_drawer.dart';

class LayananPage extends StatefulWidget {
  static const routeName = '/layanan';
  const LayananPage({super.key});

  @override
  State<LayananPage> createState() => _LayananPageState();
}

class _LayananPageState extends State<LayananPage> {
  @override
  Widget build(BuildContext context) {
    final layanan = MockService.instance.getLayanans();

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Data Aspirasi')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add),
        onPressed: () => _formLayanan(),
        tooltip: 'Tambah Aspirasi',
      ),
      body: ListView.builder(
        itemCount: layanan.length,
        itemBuilder: (context, index) {
          final item = layanan[index];
          return Card(
            child: ListTile(
              title: Text(item.nama),
              subtitle: Text(item.deskripsi),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _formLayanan(layanan: item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        MockService.instance.deleteLayanan(item.id);
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

  void _formLayanan({Layanan? layanan}) {
    final namaCtrl = TextEditingController(text: layanan?.nama);
    final deskCtrl = TextEditingController(text: layanan?.deskripsi);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(layanan == null ? 'Tambah Layanan' : 'Edit Layanan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: namaCtrl, decoration: const InputDecoration(labelText: 'Nama')),
            TextField(controller: deskCtrl, decoration: const InputDecoration(labelText: 'Deskripsi')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (layanan == null) {
                  MockService.instance.addLayanan(namaCtrl.text, deskCtrl.text);
                } else {
                  MockService.instance.updateLayanan(
                    layanan.id,
                    namaCtrl.text,
                    deskCtrl.text,
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
