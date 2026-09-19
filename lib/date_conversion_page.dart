import 'package:flutter/material.dart';
import 'main.dart';

class DateConversionPage extends StatelessWidget {
  const DateConversionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Konversi Tanggal'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Kalender Hijriah'),
              Tab(text: 'Hitung Umur'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_HijriTab(), _AgeTab()],
        ),
      ),
    );
  }
}

// ---------- Konversi Hijriah ----------
class _HijriTab extends StatefulWidget {
  const _HijriTab();

  @override
  State<_HijriTab> createState() => _HijriTabState();
}

class _HijriTabState extends State<_HijriTab> {
  DateTime _selectedDate = DateTime.now();

  static const List<String> _hijriMonths = [
    'Muharram', 'Safar', 'Rabiul Awal', 'Rabiul Akhir', 'Jumadil Awal',
    'Jumadil Akhir', 'Rajab', "Sya'ban", 'Ramadhan', 'Syawal',
    "Dzulqa'dah", 'Dzulhijjah',
  ];

  int _toJulianDayNumber(DateTime date) {
    final y = date.year;
    final m = date.month;
    final d = date.day;
    final a = (14 - m) ~/ 12;
    final y2 = y + 4800 - a;
    final m2 = m + 12 * a - 3;
    return d + ((153 * m2 + 2) ~/ 5) + 365 * y2 + (y2 ~/ 4) - (y2 ~/ 100) + (y2 ~/ 400) - 32045;
  }

  Map<String, int> _toHijri(DateTime date) {
    final jdn = _toJulianDayNumber(date);
    var l = jdn - 1948440 + 10632;
    final n = (l - 1) ~/ 10631;
    l = l - 10631 * n + 354;
    final j = (((10985 - l) ~/ 5316) * ((50 * l) ~/ 17719)) + ((l ~/ 5670) * ((43 * l) ~/ 15238));
    l = l - (((30 - j) ~/ 15) * ((17719 * j) ~/ 50)) - ((j ~/ 16) * ((15238 * j) ~/ 43)) + 29;
    final month = (24 * l) ~/ 709;
    final day = l - ((709 * month) ~/ 24);
    final year = 30 * n + j - 30;
    return {'day': day, 'month': month, 'year': year};
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final hijri = _toHijri(_selectedDate);
    final monthName = _hijriMonths[hijri['month']! - 1];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today, color: AppColors.gold),
              title: const Text('Tanggal Masehi'),
              subtitle: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
              trailing: TextButton(onPressed: _pickDate, child: const Text('Pilih')),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.goldLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('Tanggal Hijriah', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                  '${hijri['day']} $monthName ${hijri['year']} H',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.navy),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Menggunakan kalender Hijriah tabular (algoritma Kuwaiti). Bisa berbeda 1 hari dari hasil rukyat/hilal resmi.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ---------- Hitung Umur ----------
class _AgeTab extends StatefulWidget {
  const _AgeTab();

  @override
  State<_AgeTab> createState() => _AgeTabState();
}

class _AgeTabState extends State<_AgeTab> {
  DateTime? _birthDate;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Map<String, int> _calculateAge(DateTime birth, DateTime now) {
    int years = now.year - birth.year;
    int months = now.month - birth.month;
    int days = now.day - birth.day;

    if (days < 0) {
      months -= 1;
      final prevMonth = DateTime(now.year, now.month, 0);
      days += prevMonth.day;
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }
    return {'years': years, 'months': months, 'days': days};
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final age = _birthDate != null ? _calculateAge(_birthDate!, now) : null;
    final diff = _birthDate != null ? now.difference(_birthDate!) : null;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.cake_outlined, color: AppColors.gold),
              title: const Text('Tanggal Lahir'),
              subtitle: Text(_birthDate == null
                  ? 'Belum dipilih'
                  : '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}'),
              trailing: TextButton(onPressed: _pickDate, child: const Text('Pilih')),
            ),
          ),
          const SizedBox(height: 20),
          if (age != null && diff != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.goldLight, borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ageBox('${age['years']}', 'Tahun'),
                  _ageBox('${age['months']}', 'Bulan'),
                  _ageBox('${age['days']}', 'Hari'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  _detailRow('Total Hari', '${diff.inDays} hari'),
                  _detailRow('Total Jam', '${diff.inHours} jam'),
                  _detailRow('Total Menit', '${diff.inMinutes} menit'),
                  _detailRow('Total Detik', '${diff.inSeconds} detik'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _ageBox(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.navy)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value, style: const TextStyle(fontWeight: FontWeight.w600))],
      ),
    );
  }
}