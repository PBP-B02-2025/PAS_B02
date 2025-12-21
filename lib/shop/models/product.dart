class Product {
  final String id;
  final String name;
  final int price;
  final String size;
  final String? brand;
  final String description;
  final String category;
  final String thumbnail;
  final bool isFeatured;
  final String owner; // Tambahkan field ini

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
    required this.owner, // Tambahkan di constructor
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? "",
      price: int.parse(json['price'].toString().split('.')[0]),
      size: json['size'] ?? "",
      brand: json['brand'],
      description: json['description'] ?? "",
      category: json['category'] ?? "",
      thumbnail: (json['thumbnail'] != null && json['thumbnail'] != '')
          ? json['thumbnail']
          : 'https://via.placeholder.com/150',
      isFeatured: json['is_featured'] ?? false,
      owner: json['owner'] ?? "Unknown", // Ambil data owner dari JSON
    );
  }
}