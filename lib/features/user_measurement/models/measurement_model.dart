class Measurement {
  final int? id; // Tambahkan ID untuk referensi database
  final double height;
  final double weight;
  final double? waist;
  final double? hip;
  final double? chest;
  final double headCircumference;
  final String? clothesSize;
  final String? helmetSize;

  Measurement({
    this.id, // ID opsional karena saat create pertama kali belum ada ID
    required this.height,
    required this.weight,
    this.waist,
    this.hip,
    this.chest,
    required this.headCircumference,
    this.clothesSize,
    this.helmetSize,
  });

  // Untuk mengubah JSON dari Django menjadi Object Flutter
  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      id: json['id'], // Ambil ID dari backend
      height: json['height']?.toDouble() ?? 0.0,
      weight: json['weight']?.toDouble() ?? 0.0,
      waist: json['waist']?.toDouble(),
      hip: json['hip']?.toDouble(),
      chest: json['chest']?.toDouble(),
      headCircumference: json['head_circumference']?.toDouble() ?? 0.0,
      clothesSize: json['clothes_size'],
      helmetSize: json['helmet_size'],
    );
  }

  // PENTING: Untuk mengubah Object Flutter menjadi JSON saat POST ke Django
  Map<String, dynamic> toJson() {
    return {
      "height": height,
      "weight": weight,
      "waist": waist,
      "hip": hip,
      "chest": chest,
      "head_circumference": headCircumference,
      // clothesSize dan helmetSize biasanya dihitung di backend,
      // tapi boleh disertakan jika perlu.
    };
  }
}