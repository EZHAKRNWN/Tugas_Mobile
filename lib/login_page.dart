import 'package:flutter/material.dart';
import '../services/session_service.dart';
import 'home_shell.dart';

/// Halaman Login yang digunakan sebagai pintu masuk pengguna.
/// Di sini terdapat form untuk mengisi Username dan Password.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk membaca inputan teks dari TextField username dan password
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // GlobalKey untuk melakukan validasi Form
  final _formKey = GlobalKey<FormState>();

  // Variabel untuk menyimpan pesan error jika login gagal
  String? _errorMessage;

  // Kredensial contoh — silakan sesuaikan dengan kebutuhan
  final String _validUsername = 'admin';
  final String _validPassword = '12345';

  /// Fungsi untuk menangani proses login saat tombol ditekan
  void _login() async {
    // Memeriksa apakah semua TextFormField sudah terisi (valid)
    if (_formKey.currentState!.validate()) {
      // Mencocokkan input dengan kredensial yang valid
      if (_usernameController.text == _validUsername &&
          _passwordController.text == _validPassword) {
        setState(() => _errorMessage = null);

        // Simpan session supaya user tetap login walau app ditutup
        await SessionService.login(_usernameController.text);

        // Pindah ke HomeShell (halaman utama + bottom nav) jika berhasil login
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeShell()),
          );
        }
      } else {
        // Menampilkan error jika kredensial tidak cocok
        setState(() => _errorMessage = 'Username atau password salah');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calculate, size: 80, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Kalkulator PAM',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Username wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Password wajib diisi' : null,
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Masuk', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}