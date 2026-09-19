import 'package:flutter/material.dart';
import 'group_data_page.dart';
import 'pages/ipk_calculator_page.dart';
import 'pages/grade_crud_page.dart';
import 'date_conversion_page.dart';
import 'calendar_conversion_page.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Utama'), automaticallyImplyLeading: false),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _menuButton(context, icon: Icons.groups, label: 'Daftar Anggota', page: const GroupDataPage()),
              const SizedBox(height: 14),
              _menuButton(context, icon: Icons.calculate, label: 'Kalkulator IPK', page: const IpkCalculatorPage()),
              const SizedBox(height: 14),
              _menuButton(context, icon: Icons.school, label: 'Data Mata Kuliah', page: const GradeCrudPage()),
              const SizedBox(height: 14),
              _menuButton(context, icon: Icons.calendar_month, label: 'Konversi Tanggal', page: const DateConversionPage()),
              const SizedBox(height: 14),
              _menuButton(context, icon: Icons.event_note, label: 'Kalender Weton & Saka', page: const CalendarConversionPage()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuButton(BuildContext context,
      {required IconData icon, required String label, required Widget page}) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
        icon: Icon(icon),
        label: Align(alignment: Alignment.centerLeft, child: Text(label)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}