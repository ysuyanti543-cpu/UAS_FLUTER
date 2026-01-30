import 'package:flutter/material.dart';
import '../services/mock_service.dart';
import 'admin_page.dart';
// import 'available_sellers.dart';
import 'seller_page.dart';
import 'resident_page.dart';
import '../widgets/app_drawer.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  String _role = 'Resident';
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
  Widget build(BuildContext context) {
    final kelurahan = MockService.instance.getSubdistricts();

    return Scaffold(
      drawer: const AppDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withAlpha((0.85 * 255).round()),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/images/bandung.png',
                      height: 90,
                    ),
                    const SizedBox(height: 16),

                        const Text(
                          'Layanan Aspirasi Masyarakat',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),
                        const Text(
                          'Silakan masuk untuk mengirim aspirasi atau mengelola pelaporan',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 24),

                    /// Nama
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Pengguna',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Role Buttons
                    const Text(
                      'Pilih Peran Pengguna',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => setState(() => _role = 'Admin'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _role == 'Admin'
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.grey,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Admin Kelurahan'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => setState(() => _role = 'Seller'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _role == 'Seller'
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.grey,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Anggota Dewan'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => setState(() => _role = 'Resident'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _role == 'Resident'
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.grey,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Warga'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// Kelurahan (bukan Admin)
                      if (_role != 'Admin')
                      DropdownButtonFormField<String>(
                        initialValue: _selectedKelurahanId,
                        decoration: InputDecoration(
                          labelText: 'Pilih Kelurahan',
                          prefixIcon: const Icon(Icons.location_city),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: kelurahan
                            .map(
                              (k) => DropdownMenuItem(
                                value: k.id,
                                child: Text(k.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() => _selectedKelurahanId = value);
                        },
                      ),

                    const SizedBox(height: 24),

                    /// Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        final username = _usernameController.text.trim();

                        final args = {
                          'username': username.isEmpty ? 'Pengguna' : username,
                          'kelurahanId': _selectedKelurahanId,
                        };

                        if (_role == 'Admin') {
                          Navigator.pushReplacementNamed(
                            context,
                            AdminPage.routeName,
                            arguments: args,
                          );
                        } else if (_role == 'Seller') {
                          Navigator.pushReplacementNamed(
                            context,
                            SellerPage.routeName,
                            arguments: args,
                          );
                        } else {
                          Navigator.pushReplacementNamed(
                            context,
                            ResidentPage.routeName,
                            arguments: args,
                          );
                        }
                      },
                      child: const Text(
                        'MASUK',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
