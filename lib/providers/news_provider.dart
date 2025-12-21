import 'package:flutter/foundation.dart';
import '../models/news.dart';
import '../service/news_service.dart';

class NewsProvider extends ChangeNotifier {
  List<News> _newsList = [];
  bool _loading = false;

  List<News> get newsList => _newsList;
  bool get loading => _loading;

  Future<void> fetchNews() async {
    _loading = true;
    notifyListeners(); // notify UI untuk loading
    final result = await NewsService.fetchNews();
    _newsList = result;
    _loading = false;
    notifyListeners(); // notify UI untuk update data
  }
}
