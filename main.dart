import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/admin_page.dart';
import 'pages/resident_page.dart';
import 'pages/available_sellers.dart'; // Pastikan class di dalam file ini namanya LayananPage
import 'pages/seller_page.dart';
import 'pages/administrasi_page.dart';
import 'pages/administrasi_kependudukan_page.dart';
import 'pages/manage_user_page.dart';
import 'pages/persetujuan_petugas_page.dart';
import 'pages/aspirasi_report_page.dart';
import 'pages/submit_aspirasi_page.dart';
import 'pages/aspirasi_qr_scanner_page.dart';

import 'services/mock_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );

  // Inisialisasi data sampel
  await MockService.instance.initSampleData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aspirasi DPR',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB71C1C),
          primary: const Color(0xFFB71C1C),
          secondary: const Color(0xFFFFD700),
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFB71C1C),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (c) => const LoginPage(),
        '/admin': (c) => const AdminPage(),
        '/seller': (c) => const SellerPage(),
        '/resident': (c) => const ResidentPage(),
        '/manage-user': (c) => const ManageUserPage(),
        '/layanan': (c) => const LayananPage(), // Pastikan LayananPage terdefinisi di available_sellers.dart
        '/administrasi': (c) => const AdministrasiPage(),
        '/administrasi-kependudukan': (c) => const AdministrasiKependudukanPage(),
        '/persetujuan-petugas': (c) => const PersetujuanPetugasPage(),
        '/laporan-aspirasi': (c) => const AspirasiReportPage(),
        '/submit-aspirasi': (c) => const SubmitAspirasiPage(),
        '/aspirasi-qr-scan': (c) => const AspirasiQrScannerPage(),
      },
    );
  }
}