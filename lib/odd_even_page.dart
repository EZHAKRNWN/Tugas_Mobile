import 'package:flutter/material.dart';

/// Halaman untuk mengecek apakah sebuah bilangan bulat bernilai Ganjil atau Genap.
class OddEvenPage extends StatefulWidget {
  const OddEvenPage({super.key});

  @override
  State<OddEvenPage> createState() => _OddEvenPageState();
}

class _OddEvenPageState extends State<OddEvenPage> {
  // Controller untuk membaca inputan bilangan dari pengguna
  final _numberController = TextEditingController();
  
  // Variabel penampung teks hasil cek
  String _result = '';

  /// Fungsi untuk memproses cek bilangan
  void _check() {
    // Mengambil input teks dan mengubahnya menjadi bilangan bulat (integer)
    final number = _numberController.text.trim();
    
    // Jika input bukan angka yang valid (contoh: huruf atau desimal), beri peringatan
    if (number.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(number)) {
      setState(() => _result = 'Masukkan bilangan bulat yang valid');
      return;
    }
    
    // Cek digit paling akhir dari string input untuk menentukan ganjil/genap
    final lastDigit = int.parse(number[number.length - 1]);
    final isEven = lastDigit % 2 == 0;
    
    setState(() {
      _result = isEven ? '$number adalah bilangan Genap' : '$number adalah bilangan Ganjil';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cek Ganjil / Genap')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Masukkan bilangan', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _check, child: const Text('Cek')),
            ),
            const SizedBox(height: 24),
            Text(_result, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
