import 'package:flutter/material.dart';

/// Halaman untuk menampilkan daftar anggota kelompok.
class GroupDataPage extends StatelessWidget {
  const GroupDataPage({super.key});

  // Data statis berisi nama dan NIM anggota kelompok.
  // Anda dapat menggantinya sesuai data kelompok Anda.
  final List<Map<String, String>> members = const [
    {'nama': 'Hanggara Winasis', 'nim': '124240125'},
    {'nama': 'Agustya Ezha Kurniawan', 'nim': '124240142'},
    {'nama': 'Juan Titisan Rahamusa', 'nim': '124240142'},
    {'nama': 'Mohamad Safii', 'nim': '124240153'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Kelompok')),
      // Menggunakan ListView.builder untuk merender daftar secara efisien
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: members.length,
        itemBuilder: (context, index) {
          final m = members[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
              ),
              title: Text(m['nama']!),
              subtitle: Text(m['nim']!),
            ),
          );
        },
      ),
    );
  }
}
