import 'package:flutter/material.dart';
import '../models/mata_kuliah_model.dart';
import '../services/api_service.dart';

class IpkCalculatorPage extends StatefulWidget {
  const IpkCalculatorPage({super.key});

  @override
  State<IpkCalculatorPage> createState() => _IpkCalculatorPageState();
}

class _IpkCalculatorPageState extends State<IpkCalculatorPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator IPK'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
          // Kartu ringkasan IPK
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
                Text(
                  _predikat,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _warnaIpk),
                ),
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