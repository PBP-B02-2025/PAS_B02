import 'user_model.dart';

class ReviewModel {
  final String? id;           // UUID string from Django
  final User author;          // User object of the reviewer
  final String description;   // Review content/comment (Django uses 'comment')
  final int star;             // 0-5 rating
  final String productId;     // ID of the product being reviewed

  ReviewModel({
    this.id,
    required this.author,
    required this.description,
    required this.star,
    required this.productId,
  });

  /// Factory constructor to match Django API response:
  /// {
  ///   'id': 'uuid-string',
  ///   'comment': 'review text',
  ///   'star': 5,
  ///   'user': 'username',
  ///   'product_id': 'uuid-string' (optional)
  /// }
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString(),
      // Django returns 'user' as username string
      author: json['user'] is Map
          ? User.fromJson(json['user'])
          : User(username: json['user'] ?? json['author'] ?? ''),
      // Django uses 'comment', Flutter UI uses 'description'
      description: json['comment'] ?? json['description'] ?? '',
      star: json['star'] ?? json['rating'] ?? 0,
      // Handle product_id
      productId: (json['product_id'] ?? json['product'] ?? '').toString(),
    );
  }

  /// Convert ReviewModel to JSON for API requests (POST/PUT)
  /// Django expects 'comment' not 'description'
  Map<String, dynamic> toJson() {
    return {
      'comment': description,
      'star': star,
    };
  }

  /// Create a copy with modified fields
  ReviewModel copyWith({
    String? id,
    User? author,
    String? description,
    int? star,
    String? productId,
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