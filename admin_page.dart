import 'package:flutter/material.dart';
import '../models.dart';
import '../services/mock_service.dart';
import 'resident_page.dart';
// import 'available_sellers.dart';
import '../widgets/app_drawer.dart';
import 'seller_page.dart';

class AdminPage extends StatefulWidget {
  static const routeName = '/admin';
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _currentIndex = 2;

  final TextEditingController _newPetugasController =
      TextEditingController();

  String? _selectedKelurahanId;

  @override
  void initState() {
    super.initState();
    final kelurahan = MockService.instance.getSubdistricts();
    if (kelurahan.isNotEmpty) {
      _selectedKelurahanId = kelurahan.first.id;
    }
  }

  @override
  void dispose() {
    _newPetugasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kelurahan = MockService.instance.getSubdistricts();
    final petugas = MockService.instance.getSellers();

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        elevation: 0,
        title: const Text('Admin'),
        centerTitle: true,
        flexibleSpace: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withAlpha((0.9 * 255).round())
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _headerSummary(petugas.length),
          Expanded(child: _dataPetugas(petugas, kelurahan)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: (index) {
          if (index == _currentIndex) return;

          setState(() => _currentIndex = index);

          if (index == 0) {
            Navigator.pushReplacementNamed(
                context, ResidentPage.routeName);
          } else if (index == 1) {
            Navigator.pushReplacementNamed(
                context, SellerPage.routeName);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city_outlined),
            label: 'Kelurahan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            label: 'Petugas',
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _headerSummary(int total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3949AB), Color(0xFF5C6BC0)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                 color: Colors.white.withAlpha((0.2 * 255).round()),
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.store, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Data Anggota Dewan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$total terdaftar',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= LIST + FORM =================
  Widget _dataPetugas(
    List<Seller> petugas,
    List<Subdistrict> kelurahan,
  ) {
    final dropdownValue = kelurahan.any(
            (k) => k.id == _selectedKelurahanId)
        ? _selectedKelurahanId
        : null;

    return Column(
      children: [
        // ===== LIST =====
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: petugas.length,
            itemBuilder: (context, index) {
              final p = petugas[index];

              Subdistrict? k;
              if (kelurahan.isNotEmpty) {
                k = kelurahan.firstWhere(
                  (e) => e.id == p.subdistrictId,
                  orElse: () => kelurahan.first,
                );
              }

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF5C6BC0),
                    child:
                        Icon(Icons.store, color: Colors.white),
                  ),
                  title: Text(
                    p.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    k == null
                        ? 'Kelurahan tidak ditemukan'
                        : 'Kelurahan ${k.name}',
                  ),
                ),
              );
            },
          ),
        ),

        // ===== FORM =====
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
             BoxShadow(
               color: Colors.black.withAlpha((0.08 * 255).round()),
                blurRadius: 8,
              ),
            ],
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Tambah Petugas / UMKM',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _newPetugasController,
                decoration: const InputDecoration(
                  labelText: 'Nama Petugas',
                  prefixIcon:
                      Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
               initialValue: dropdownValue,
                items: kelurahan
                    .map((k) => DropdownMenuItem(
                          value: k.id,
                          child: Text(k.name),
                        ))
                    .toList(),
                onChanged: (v) =>
                    setState(() => _selectedKelurahanId = v),
                decoration: const InputDecoration(
                  labelText: 'Kelurahan',
                  prefixIcon:
                      Icon(Icons.apartment),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF3949AB),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  final name =
                      _newPetugasController.text.trim();
                  if (name.isEmpty ||
                      _selectedKelurahanId == null) {
                    return;
                  }

                  MockService.instance.addSeller(
                      name, _selectedKelurahanId!);

                  _newPetugasController.clear();
                  setState(() {});
                },
                child: const Text(
                  'SIMPAN',
                  style:
                      TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
