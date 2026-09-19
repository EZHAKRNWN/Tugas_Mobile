class MataKuliah {
  final int? id;
  final String namaMatkul;
  final int sks;
  final String nilaiHuruf;

  MataKuliah({
    this.id,
    required this.namaMatkul,
    required this.sks,
    required this.nilaiHuruf,
  });

  factory MataKuliah.fromJson(Map<String, dynamic> json) {
    return MataKuliah(
      id: json['id'],
      namaMatkul: json['nama_matkul'],
      sks: json['sks'],
      nilaiHuruf: json['nilai_huruf'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_matkul': namaMatkul,
      'sks': sks,
      'nilai_huruf': nilaiHuruf,
    };
  }

  // Konversi nilai huruf ke bobot angka (standar umum)
  double get bobot {
    switch (nilaiHuruf) {
      case 'A':
        return 4.0;
      case 'AB':
        return 3.5;
      case 'B':
        return 3.0;
      case 'BC':
        return 2.5;
      case 'C':
        return 2.0;
      case 'D':
        return 1.0;
      case 'E':
        return 0.0;
      default:
        return 0.0;
    }
  }
}