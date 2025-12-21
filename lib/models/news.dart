class News {
  final String id;
  final String title;
  final String author;
  final String content;
  final String category;
  final String? thumbnail;
  final int newsViews;
  final bool isFeatured;
  final DateTime createdAt;

  News({
    required this.id,
    required this.title,
    required this.author,
    required this.content,
    required this.category,
    this.thumbnail,
    required this.newsViews,
    required this.isFeatured,
    required this.createdAt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      content: json['content'],
      category: json['category'],
      thumbnail: json['thumbnail'],
      newsViews: json['news_views'],
      isFeatured: json['is_featured'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
