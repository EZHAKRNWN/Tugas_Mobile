import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
import 'group_data_page.dart';
import 'pages/ipk_calculator_page.dart';
import 'pages/grade_crud_page.dart';
import 'date_conversion_page.dart';
import 'calendar_conversion_page.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  static const _menuItems = [
    _MenuData(icon: Icons.groups_outlined, title: 'Daftar Anggota', subtitle: 'Data kelompok'),
    _MenuData(icon: Icons.calculate_outlined, title: 'Kalkulator', subtitle: 'IPK & kalkulator umum'),
    _MenuData(icon: Icons.school_outlined, title: 'Data Mata Kuliah', subtitle: 'Kelola nilai (CRUD)'),
    _MenuData(icon: Icons.calendar_month_outlined, title: 'Konversi Tanggal', subtitle: 'Hijriah & hitung umur'),
    _MenuData(icon: Icons.event_note_outlined, title: 'Kalender Weton & Saka', subtitle: 'Kalender Jawa & Bali'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selamat Datang',
                          style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600)),
                      Text('Nilai Akademik',
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ],
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(color: AppColors.navy, shape: BoxShape.circle),
                    child: const Icon(Icons.school_outlined, color: AppColors.gold, size: 22),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < _menuItems.length; i++) ...[
                        _MenuCard(
                          data: _menuItems[i],
                          onTap: () => _navigate(context, i),
                        ),
                        if (i != _menuItems.length - 1) const SizedBox(height: 14),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigate(BuildContext context, int index) {
    final pages = [
      const GroupDataPage(),
      const IpkCalculatorPage(),
      const GradeCrudPage(),
      const DateConversionPage(),
      const CalendarConversionPage(),
    ];
    Navigator.push(context, MaterialPageRoute(builder: (_) => pages[index]));
  }
}

class _MenuData {
  final IconData icon;
  final String title;
  final String subtitle;
  const _MenuData({required this.icon, required this.title, required this.subtitle});
}

class _MenuCard extends StatelessWidget {
  final _MenuData data;
  final VoidCallback onTap;

  const _MenuCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.goldLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(data.icon, color: AppColors.navy, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.title,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.textDark)),
                    const SizedBox(height: 2),
                    Text(data.subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}