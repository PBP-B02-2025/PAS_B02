import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news.dart';

class NewsService {
  static const String baseUrl = 'http://127.0.0.1:8000/news/api/news/';

  static Future<void> incrementViews(String id) async {
    await http.post(
      Uri.parse('http://127.0.0.1:8000/api/news/$id/view/'),
    );
  }

static Future<List<News>> fetchNews({// fetchNews
  String? category,
  bool popularOnly = false,
}) async {
  final queryParams = <String, String>{};

  if (category != null) {
    queryParams['category'] = category;
  }

  if (popularOnly) {
    queryParams['popular'] = 'true';
  }

  final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.map((e) => News.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load news');
  }
}


  static Future<void> addNews({ // addNews
  required String title,
  required String author,
  required String content,
  required String category,
  String? thumbnail,
  required bool isFeatured,
}) async {
  final response = await http.post(
    Uri.parse(baseUrl),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'title': title,
      'author': author,
      'content': content,
      'category': category,
      'thumbnail': thumbnail,
      'is_featured': isFeatured,
      if (thumbnail != null) 'thumbnail': thumbnail,
    }),
  );

  if (response.statusCode != 201 && response.statusCode != 200) {
    throw Exception('Failed to add news');
  }
}
static Future<void> deleteNews(String id) async { // deleteNews
  final response = await http.delete(
    Uri.parse('$baseUrl$id/'),
  );

  if (response.statusCode != 204 && response.statusCode != 200) {
    throw Exception('Failed to delete news');
  }
} // updateNews
static Future<void> updateNews({
  required String id,
  required String title,
  required String author,
  required String content,
  required String category,
  String? thumbnail,
  required bool isFeatured,
}) async {
  final response = await http.put(
    Uri.parse('$baseUrl$id/'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'title': title,
      'author': author,
      'content': content,
      'category': category,
      'thumbnail': thumbnail,
      'is_featured': isFeatured,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update news');
  }
}

}

