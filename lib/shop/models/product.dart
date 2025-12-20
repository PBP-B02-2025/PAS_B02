class Product {
  final String id;
  final String name;
  final int price;
  final String size;
  final String? brand; // Bisa null karena di Django null=True
  final String description;
  final String category;
  final String thumbnail;
  final bool isFeatured;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.size,
    this.brand,
    required this.description,
    required this.category,
    required this.thumbnail,
    required this.isFeatured,
  });

  // Factory untuk mengubah JSON dari Django menjadi Object Dart
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'],
      // Konversi aman ke int, baik datanya string maupun number
      price: int.parse(json['price'].toString().split('.')[0]), // Ambil angka sebelum koma jika ada desimal
      size: json['size'],
      brand: json['brand'],
      description: json['description'],
      category: json['category'],
      thumbnail: (json['thumbnail'] != null && json['thumbnail'] != '')
          ? json['thumbnail']
          : 'https://via.placeholder.com/150',
      isFeatured: json['is_featured'] ?? false,
    );
  }
}