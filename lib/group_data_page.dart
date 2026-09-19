import 'package:flutter/material.dart';
import 'main.dart';

class GroupDataPage extends StatelessWidget {
  const GroupDataPage({super.key});

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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: members.length,
        itemBuilder: (context, index) {
          final m = members[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.goldLight,
                child: Text('${index + 1}',
                    style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold)),
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