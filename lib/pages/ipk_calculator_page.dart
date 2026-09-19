import 'package:flutter/material.dart';
import '../models/mata_kuliah_model.dart';
import '../services/api_service.dart';

class IpkCalculatorPage extends StatelessWidget {
  const IpkCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kalkulator'),
          bottom: const TabBar(
            tabs: [Tab(text: 'IPK'), Tab(text: 'Kalkulator Umum')],
          ),
        ),
        body: const TabBarView(children: [_IpkTab(), _GeneralCalculatorTab()]),
      ),
    );
  }
}

// ================= TAB 1: IPK (dari data mata kuliah) =================
class _IpkTab extends StatefulWidget {
  const _IpkTab();

  @override
  State<_IpkTab> createState() => _IpkTabState();
}

class _IpkTabState extends State<_IpkTab> {
  List<MataKuliah> _mataKuliahList = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final data = await ApiService.getAllMataKuliah();
      setState(() {
        _mataKuliahList = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data. Pastikan server API menyala.';
        _isLoading = false;
      });
    }
  }

  int get _totalSks => _mataKuliahList.fold(0, (sum, mk) => sum + mk.sks);
  double get _totalBobot =>
      _mataKuliahList.fold(0.0, (sum, mk) => sum + (mk.bobot * mk.sks));
  double get _ipk => _totalSks == 0 ? 0.0 : _totalBobot / _totalSks;

  String get _predikat {
    if (_ipk >= 3.5) return 'Cum Laude';
    if (_ipk >= 3.0) return 'Sangat Memuaskan';
    if (_ipk >= 2.5) return 'Memuaskan';
    if (_ipk >= 2.0) return 'Cukup';
    return 'Kurang';
  }

  Color get _warnaIpk {
    if (_ipk >= 3.5) return Colors.green;
    if (_ipk >= 3.0) return Colors.lightGreen;
    if (_ipk >= 2.5) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _loadData, child: const Text('Coba Lagi')),
          ],
        ),
      );
    }

    if (_mataKuliahList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calculate_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text('Belum ada data mata kuliah', style: TextStyle(color: Colors.grey)),
            Text('Tambahkan dulu lewat menu Data Mata Kuliah',
                style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _warnaIpk.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _warnaIpk.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                const Text('IPK Kamu', style: TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                  _ipk.toStringAsFixed(2),
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: _warnaIpk),
                ),
                const SizedBox(height: 4),
                Text(_predikat,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _warnaIpk)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statItem('Total SKS', '$_totalSks'),
                    _statItem('Mata Kuliah', '${_mataKuliahList.length}'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Rincian Perhitungan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ..._mataKuliahList.map((mk) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(mk.namaMatkul),
                  subtitle: Text('${mk.sks} SKS × ${mk.bobot.toStringAsFixed(1)} = ${(mk.sks * mk.bobot).toStringAsFixed(1)}'),
                  trailing: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.red.shade50,
                    child: Text(mk.nilaiHuruf, style: const TextStyle(fontSize: 12, color: Colors.red)),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

// ================= TAB 2: Kalkulator Umum (dari tugas assignment 1) =================
class _GeneralCalculatorTab extends StatefulWidget {
  const _GeneralCalculatorTab();

  @override
  State<_GeneralCalculatorTab> createState() => _GeneralCalculatorTabState();
}

class _GeneralCalculatorTabState extends State<_GeneralCalculatorTab> {
  // --- Aritmatika ---
  final _num1Controller = TextEditingController();
  final _num2Controller = TextEditingController();
  String _arithResult = '';

  void _calculate(String operator) {
    final num1 = double.tryParse(_num1Controller.text);
    final num2 = double.tryParse(_num2Controller.text);
    if (num1 == null || num2 == null) {
      setState(() => _arithResult = 'Masukkan angka yang valid');
      return;
    }
    double res;
    switch (operator) {
      case '+': res = num1 + num2; break;
      case '-': res = num1 - num2; break;
      case '*': res = num1 * num2; break;
      case '/':
        if (num2 == 0) {
          setState(() => _arithResult = 'Tidak bisa dibagi dengan 0');
          return;
        }
        res = num1 / num2;
        break;
      default: res = 0;
    }
    setState(() => _arithResult = 'Hasil: ${res.toStringAsFixed(2)}');
  }

  // --- Ganjil/Genap ---
  final _oddEvenController = TextEditingController();
  String _oddEvenResult = '';

  void _checkOddEven() {
    final number = int.tryParse(_oddEvenController.text);
    if (number == null) {
      setState(() => _oddEvenResult = 'Masukkan bilangan bulat yang valid');
      return;
    }
    setState(() {
      _oddEvenResult = number % 2 == 0 ? '$number adalah bilangan Genap' : '$number adalah bilangan Ganjil';
    });
  }

  // --- Jumlah Total ---
  final _sumFieldController = TextEditingController();
  String _sumResult = '';

  void _sumField() {
    final input = _sumFieldController.text.trim();
    if (input.isEmpty) {
      setState(() => _sumResult = 'Field tidak boleh kosong');
      return;
    }
    final parts = input.split(RegExp(r'[,\s]+'));
    double total = 0;
    int validCount = 0;
    for (final part in parts) {
      final value = double.tryParse(part);
      if (value != null) {
        total += value;
        validCount++;
      }
    }
    if (validCount == 0) {
      setState(() => _sumResult = 'Tidak ada angka valid ditemukan');
      return;
    }
    setState(() => _sumResult = 'Jumlah Total: ${total.toStringAsFixed(2)} ($validCount angka)');
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // --- Kartu Aritmatika ---
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tambah, Kurang, Kali, Bagi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                TextField(
                  controller: _num1Controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Angka 1', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _num2Controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Angka 2', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(onPressed: () => _calculate('+'), child: const Text('+')),
                    ElevatedButton(onPressed: () => _calculate('-'), child: const Text('-')),
                    ElevatedButton(onPressed: () => _calculate('*'), child: const Text('×')),
                    ElevatedButton(onPressed: () => _calculate('/'), child: const Text('÷')),
                  ],
                ),
                if (_arithResult.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(_arithResult, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // --- Kartu Ganjil/Genap ---
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Cek Ganjil / Genap', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                TextField(
                  controller: _oddEvenController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Masukkan bilangan', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: _checkOddEven, child: const Text('Cek')),
                ),
                if (_oddEvenResult.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(_oddEvenResult, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // --- Kartu Jumlah Total ---
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Jumlah Total Angka', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                TextField(
                  controller: _sumFieldController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Masukkan angka (pisah koma/spasi)',
                    hintText: 'contoh: 10, 20, 30',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: _sumField, child: const Text('Hitung Total')),
                ),
                if (_sumResult.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(_sumResult, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}