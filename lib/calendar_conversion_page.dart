import 'package:flutter/material.dart';

class CalendarConversionPage extends StatelessWidget {
  const CalendarConversionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kalender Weton & Saka'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Weton Jawa'), Tab(text: 'Kalender Saka Bali')],
          ),
        ),
        body: const TabBarView(children: [_WetonTab(), _SakaTab()]),
      ),
    );
  }
}

// ---------- Weton Jawa ----------
class _WetonTab extends StatefulWidget {
  const _WetonTab();

  @override
  State<_WetonTab> createState() => _WetonTabState();
}

class _WetonTabState extends State<_WetonTab> {
  DateTime _selectedDate = DateTime.now();

  static const List<String> _hari = [
    'Senin', 'Selasa', 'Rabu', 'Kamis', "Jum'at", 'Sabtu', 'Minggu'
  ];
  static const List<String> _pasaran = ['Legi', 'Pahing', 'Pon', 'Wage', 'Kliwon'];
  static const List<String> _wuku = [
    'Sinta', 'Landep', 'Wukir', 'Kurantil', 'Tolu', 'Gumbreg', 'Wariga',
    'Warigadean', 'Julungwangi', 'Sungsang', 'Dungulan', 'Kuningan', 'Langkir',
    'Medangsia', 'Pujut', 'Pahang', 'Krulut', 'Merakih', 'Tambir', 'Medangkungan',
    'Matal', 'Uye', 'Menail', 'Prangbakat', 'Bala', 'Ugu', 'Wayang', 'Kulawu',
    'Dukut', 'Watugunung',
  ];

  // Neptu (nilai) tiap hari dan pasaran, untuk keperluan tampilan tambahan
  static const Map<String, int> _neptuHari = {
    'Senin': 4, 'Selasa': 3, 'Rabu': 7, 'Kamis': 8, "Jum'at": 6, 'Sabtu': 9, 'Minggu': 5,
  };
  static const Map<String, int> _neptuPasaran = {
    'Legi': 5, 'Pahing': 9, 'Pon': 7, 'Wage': 4, 'Kliwon': 8,
  };

  String _pasaranFor(DateTime date) {
    final epoch = DateTime(2022, 1, 10); // Senin Legi (referensi terverifikasi)
    final days = date.difference(epoch).inDays;
    final index = ((days % 5) + 5) % 5;
    return _pasaran[index];
  }

  String _wukuFor(DateTime date) {
    final epoch = DateTime(2021, 8, 29); // Minggu, awal Wuku Sinta (referensi terverifikasi)
    final days = date.difference(epoch).inDays;
    final weekIndex = (days / 7).floor();
    final index = ((weekIndex % 30) + 30) % 30;
    return _wuku[index];
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
    final hariName = _hari[_selectedDate.weekday - 1];
    final pasaranName = _pasaranFor(_selectedDate);
    final wukuName = _wukuFor(_selectedDate);
    final neptu = _neptuHari[hariName]! + _neptuPasaran[pasaranName]!;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.red),
              title: const Text('Tanggal Masehi'),
              subtitle: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
              trailing: TextButton(onPressed: _pickDate, child: const Text('Pilih')),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                const Text('Weton', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                  '$hariName $pasaranName',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                const SizedBox(height: 4),
                Text('Neptu: $neptu', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.event_repeat, color: Colors.red),
              title: const Text('Wuku'),
              subtitle: Text(wukuName),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Kalender Saka Bali ----------
class _SakaTab extends StatefulWidget {
  const _SakaTab();

  @override
  State<_SakaTab> createState() => _SakaTabState();
}

class _SakaTabState extends State<_SakaTab> {
  DateTime _selectedDate = DateTime.now();

  int _toSakaYear(DateTime date) {
    // Tahun Saka = Tahun Masehi - 78, pergantian tahun sekitar Maret (Nyepi).
    // Nyepi berpindah tiap tahun (tergantung fase bulan), jadi ini pendekatan umum.
    if (date.month < 3) return date.year - 79;
    if (date.month == 3 && date.day < 15) return date.year - 79;
    return date.year - 78;
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
    final sakaYear = _toSakaYear(_selectedDate);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.red),
              title: const Text('Tanggal Masehi'),
              subtitle: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
              trailing: TextButton(onPressed: _pickDate, child: const Text('Pilih')),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                const Text('Tahun Saka', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                  '$sakaYear',
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Tahun Saka = Tahun Masehi − 78, pergantian tahun sekitar Nyepi (pertengahan Maret). Tanggal pasti Nyepi bergeser tiap tahun mengikuti fase bulan, jadi hasil di sekitar Maret adalah perkiraan.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}