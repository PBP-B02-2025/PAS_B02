class ReviewModel {
  final int? id;
  final String author;          // User object of the reviewer
  final String description;   // Review content/comment
  final int star;             // 0-5 rating
  final int productId;        // ID of the product being reviewed

  ReviewModel({
    this.id,
    required this.author,
    required this.description,
    required this.star,
    required this.productId,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      // Handle both nested user object or direct username string
      author: json['user'] is Map
          ? ReviewModel.fromJson(json['user'])
          : json['author'] ?? json['user'] ?? '',
      description: json['description'] ?? json['comment'] ?? '',
      star: json['star'] ?? json['rating'] ?? 0,
      // Handle both nested product object or direct product_id
      productId: json['product'] is Map 
          ? json['product']['id'] ?? 0 
          : json['product_id'] ?? json['product'] ?? 0,
    );
  }

  /// Convert ReviewModel to JSON for API requests (POST/PUT)
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'star': star,
      'product_id': productId,
    };
  }

  /// Create a copy with modified fields
  ReviewModel copyWith({
    int? id,
    String? author,
    String? description,
    int? star,
    int? productId,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      author: author ?? this.author,
      description: description ?? this.description,
      star: star ?? this.star,
      productId: productId ?? this.productId,
    );
  }
}