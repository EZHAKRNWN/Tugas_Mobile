import 'package:flutter/material.dart';
import 'services/session_service.dart';
import 'login_page.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bantuan'), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Cara Penggunaan Aplikasi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _helpItem('1. Daftar Anggota', 'Menampilkan data anggota kelompok.'),
          _helpItem('2. Kalkulator IPK', 'Menghitung IPK otomatis dari data mata kuliah.'),
          _helpItem('3. Data Mata Kuliah', 'Tambah, ubah, hapus data mata kuliah (CRUD).'),
          _helpItem('4. Konversi Tanggal', 'Konversi Masehi ke Hijriah dan hitung umur.'),
          _helpItem('5. Kalender Weton & Saka', 'Konversi ke weton Jawa dan kalender Saka Bali.'),
          _helpItem('6. Stopwatch', 'Stopwatch sederhana untuk menghitung waktu.'),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await SessionService.logout();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Logout', style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _helpItem(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}