import 'package:flutter/material.dart';
import '../main.dart';
import '../models/mata_kuliah_model.dart';
import '../services/api_service.dart';

class GradeCrudPage extends StatefulWidget {
  const GradeCrudPage({super.key});

  @override
  State<GradeCrudPage> createState() => _GradeCrudPageState();
}

class _GradeCrudPageState extends State<GradeCrudPage> {
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

  Color _warnaNilai(String nilai) {
    switch (nilai) {
      case 'A':
        return Colors.green;
      case 'AB':
        return Colors.lightGreen;
      case 'B':
        return Colors.blue;
      case 'BC':
        return Colors.orange;
      case 'C':
        return Colors.deepOrange;
      default:
        return Colors.red;
    }
  }

  void _showFormDialog({MataKuliah? existing}) {
    final namaController = TextEditingController(text: existing?.namaMatkul ?? '');
    final sksController = TextEditingController(text: existing?.sks.toString() ?? '');
    String nilaiDipilih = existing?.nilaiHuruf ?? 'A';
    final formKey = GlobalKey<FormState>();
    final isEdit = existing != null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEdit ? 'Edit Mata Kuliah' : 'Tambah Mata Kuliah'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: namaController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Mata Kuliah',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          (value == null || value.isEmpty) ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: sksController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'SKS',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final n = int.tryParse(value ?? '');
                        if (n == null || n < 1 || n > 6) return 'SKS harus 1-6';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: nilaiDipilih,
                      decoration: const InputDecoration(
                        labelText: 'Nilai Huruf',
                        border: OutlineInputBorder(),
                      ),
                      items: ['A', 'AB', 'B', 'BC', 'C', 'D', 'E']
                          .map((n) => DropdownMenuItem(value: n, child: Text(n)))
                          .toList(),
                      onChanged: (value) {
                        setDialogState(() => nilaiDipilih = value!);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;

                    final data = MataKuliah(
                      id: existing?.id,
                      namaMatkul: namaController.text,
                      sks: int.parse(sksController.text),
                      nilaiHuruf: nilaiDipilih,
                    );

                    try {
                      if (isEdit) {
                        await ApiService.updateMataKuliah(existing.id!, data);
                      } else {
                        await ApiService.createMataKuliah(data);
                      }
                      if (context.mounted) Navigator.pop(context);
                      _loadData();
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gagal menyimpan data')),
                        );
                      }
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(MataKuliah mataKuliah) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Data?'),
        content: Text('Yakin ingin menghapus "${mataKuliah.namaMatkul}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await ApiService.deleteMataKuliah(mataKuliah.id!);
                if (context.mounted) Navigator.pop(context);
                _loadData();
              } catch (e) {
                if (context.mounted) Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gagal menghapus data')),
                );
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Mata Kuliah'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        backgroundColor: AppColors.navy,
        child: const Icon(Icons.add, color: Colors.white),
      ),
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
            Icon(Icons.school_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text('Belum ada data mata kuliah', style: TextStyle(color: Colors.grey)),
            Text('Tekan tombol + untuk menambah', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _mataKuliahList.length,
        itemBuilder: (context, index) {
          final mk = _mataKuliahList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: _warnaNilai(mk.nilaiHuruf).withValues(alpha: 0.15),
                    child: Text(
                      mk.nilaiHuruf,
                      style: TextStyle(
                        color: _warnaNilai(mk.nilaiHuruf),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mk.namaMatkul,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${mk.sks} SKS · Bobot ${mk.bobot.toStringAsFixed(1)}',
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.navy, size: 20),
                    onPressed: () => _showFormDialog(existing: mk),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                    onPressed: () => _confirmDelete(mk),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}