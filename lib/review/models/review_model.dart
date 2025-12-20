/// Review Model
/// 
/// This model represents a review with author, description, and star rating.
/// 
/// Usage:
/// ```dart
/// import 'package:your_app/review/models/review_model.dart';
/// ```

class ReviewModel {
  final int? id;
  final String author;
  final String description;
  final int star; // 0-5 rating

  ReviewModel({
    this.id,
    required this.author,
    required this.description,
    required this.star,
  });

  /// Factory constructor to create a ReviewModel from JSON
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      star: json['star'] ?? 0,
    );
  }

  /// Convert ReviewModel to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'description': description,
      'star': star,
    };
  }

  /// Create a copy with modified fields
  ReviewModel copyWith({
    int? id,
    String? author,
    String? description,
    int? star,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      author: author ?? this.author,
      description: description ?? this.description,
      star: star ?? this.star,
    );
  }
}
