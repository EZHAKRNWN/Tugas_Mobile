import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mata_kuliah_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // GET semua data
  static Future<List<MataKuliah>> getAllMataKuliah() async {
    final response = await http.get(Uri.parse('$baseUrl/mata-kuliah'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => MataKuliah.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data mata kuliah');
    }
  }

  // POST tambah data baru
  static Future<MataKuliah> createMataKuliah(MataKuliah mataKuliah) async {
    final response = await http.post(
      Uri.parse('$baseUrl/mata-kuliah'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode(mataKuliah.toJson()),
    );

    if (response.statusCode == 201) {
      return MataKuliah.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal menambah data mata kuliah');
    }
  }

  // PUT update data
  static Future<MataKuliah> updateMataKuliah(int id, MataKuliah mataKuliah) async {
    final response = await http.put(
      Uri.parse('$baseUrl/mata-kuliah/$id'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode(mataKuliah.toJson()),
    );

    if (response.statusCode == 200) {
      return MataKuliah.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal mengubah data mata kuliah');
    }
  }

  // DELETE hapus data
  static Future<void> deleteMataKuliah(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/mata-kuliah/$id'));

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus data mata kuliah');
    }
  }
}