class Measurement {
  final int? id;
  final double height;
  final double weight;
  final double? waist;
  final double? hip;
  final double? chest;
  final double headCircumference;
  final String? clothesSize;
  final String? helmetSize;

  Measurement({
    this.id,
    required this.height,
    required this.weight,
    this.waist,
    this.hip,
    this.chest,
    required this.headCircumference,
    this.clothesSize,
    this.helmetSize,
  });

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      id: json['id'],
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

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "height": height,
      "weight": weight,
      "waist": waist,
      "hip": hip,
      "chest": chest,
      "head_circumference": headCircumference,
      "clothes_size": clothesSize,
      "helmet_size": helmetSize,
    };
  }
}