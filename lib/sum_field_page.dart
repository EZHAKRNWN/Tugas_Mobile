import 'package:flutter/material.dart';

/// Halaman untuk menjumlahkan semua angka yang diketik dalam satu kolom panjang.
class SumFieldPage extends StatefulWidget {
  const SumFieldPage({super.key});

  @override
  State<SumFieldPage> createState() => _SumFieldPageState();
}

class _SumFieldPageState extends State<SumFieldPage> {
  // Controller untuk inputan berformat panjang (multiline)
  final _fieldController = TextEditingController();
  
  // Variabel teks penampung hasil
  String _result = '';

  /// Fungsi untuk menjumlahkan isi di dalam TextField
  void _sumField() {
    final input = _fieldController.text.trim();
    if (input.isEmpty) {
      setState(() => _result = 'Field tidak boleh kosong');
      return;
    }

    // Memecah teks masukan (input) berdasarkan koma atau spasi
    // RegExp r'[,\s]+' mendeteksi 1 atau lebih koma/spasi sebagai pemisah
    final parts = input.split(RegExp(r'[,\s]+'));
    double total = 0;
    int validCount = 0;

    // Melakukan perulangan (loop) pada tiap potongan teks
    for (final part in parts) {
      // Mengubah potongan teks menjadi angka desimal
      final value = double.tryParse(part);
      if (value != null) {
        total += value; // Jika valid, tambahkan ke total
        validCount++;    // Hitung berapa banyak angka yang berhasil dijumlahkan
      }
    }

    // Jika tidak ada angka yang dapat dibaca sama sekali
    if (validCount == 0) {
      setState(() => _result = 'Tidak ada angka valid ditemukan');
      return;
    }

    // Tampilkan hasil akhir
    setState(() => _result = 'Jumlah Total: ${total.toStringAsFixed(2)} ($validCount angka)');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jumlah Total Angka')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _fieldController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Masukkan angka (pisahkan dengan koma atau spasi)',
                hintText: 'contoh: 10, 20, 30',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _sumField, child: const Text('Hitung Total')),
            ),
            const SizedBox(height: 24),
            Text(_result, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
