import 'package:flutter/material.dart';
import 'main.dart';
import 'services/session_service.dart';
import 'login_page.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  static const _items = [
    _HelpItem(icon: Icons.groups_outlined, title: 'Daftar Anggota', desc: 'Menampilkan data anggota kelompok.'),
    _HelpItem(icon: Icons.calculate_outlined, title: 'Kalkulator', desc: 'IPK otomatis dari data mata kuliah, dan kalkulator umum (tambah/kurang/kali/bagi, ganjil-genap, jumlah total).'),
    _HelpItem(icon: Icons.school_outlined, title: 'Data Mata Kuliah', desc: 'Tambah, ubah, hapus data mata kuliah (CRUD).'),
    _HelpItem(icon: Icons.calendar_month_outlined, title: 'Konversi Tanggal', desc: 'Konversi Masehi ke Hijriah dan hitung umur.'),
    _HelpItem(icon: Icons.event_note_outlined, title: 'Kalender Weton & Saka', desc: 'Konversi ke weton Jawa dan kalender Saka Bali.'),
    _HelpItem(icon: Icons.timer_outlined, title: 'Stopwatch', desc: 'Stopwatch dengan fitur lap.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bantuan'), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Cara Penggunaan Aplikasi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 16),
          ..._items.map((item) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.goldLight, borderRadius: BorderRadius.circular(10)),
                    child: Icon(item.icon, color: AppColors.navy, size: 20),
                  ),
                  title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(item.desc, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                ),
              )),
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
}

class _HelpItem {
  final IconData icon;
  final String title;
  final String desc;
  const _HelpItem({required this.icon, required this.title, required this.desc});
}