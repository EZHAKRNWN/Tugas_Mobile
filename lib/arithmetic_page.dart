import 'package:flutter/material.dart';

/// Halaman Kalkulator untuk operasi dasar: Tambah, Kurang, Kali, Bagi.
class ArithmeticPage extends StatefulWidget {
  const ArithmeticPage({super.key});

  @override
  State<ArithmeticPage> createState() => _ArithmeticPageState();
}

class _ArithmeticPageState extends State<ArithmeticPage> {
  // Controller untuk membaca inputan dari kolom angka pertama dan kedua
  final _num1Controller = TextEditingController();
  final _num2Controller = TextEditingController();
  
  // Variabel untuk menampung teks hasil operasi
  String _result = '';

  /// Fungsi untuk melakukan perhitungan berdasarkan operator yang dilempar
  void _calculate(String operator) {
    // Mencoba parsing (mengubah) teks menjadi angka desimal (double)
    final num1 = double.tryParse(_num1Controller.text);
    final num2 = double.tryParse(_num2Controller.text);

    // Jika input bukan angka yang valid, tampilkan peringatan
    if (num1 == null || num2 == null) {
      setState(() => _result = 'Masukkan angka yang valid');
      return;
    }

    double res;
    // Logika perhitungan berdasarkan tombol operator yang ditekan
    switch (operator) {
      case '+':
        res = num1 + num2;
        break;
      case '-':
        res = num1 - num2;
        break;
      case '*':
        res = num1 * num2;
        break;
      case '/':
        if (num2 == 0) {
          setState(() => _result = 'Tidak bisa dibagi dengan 0');
          return;
        }
        res = num1 / num2;
        break;
      default:
        res = 0;
    }

    // Mengubah state untuk memunculkan teks hasil di layar
    setState(() => _result = 'Hasil: ${res.toStringAsFixed(2)}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah, Kurang, Kali, Bagi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _num1Controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Angka 1', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _num2Controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Angka 2', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            // Menggunakan Wrap agar susunan tombol menyesuaikan ukuran layar jika terlalu sempit
            Wrap(
              spacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(onPressed: () => _calculate('+'), child: const Text('+')),
                ElevatedButton(onPressed: () => _calculate('-'), child: const Text('-')),
                ElevatedButton(onPressed: () => _calculate('*'), child: const Text('×')),
                ElevatedButton(onPressed: () => _calculate('/'), child: const Text('÷')),
              ],
            ),
            const SizedBox(height: 24),
            Text(_result, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
