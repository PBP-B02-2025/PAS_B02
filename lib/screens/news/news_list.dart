import 'package:ballistic/auth/user_session.dart';
import 'package:flutter/material.dart';
import '../../models/news.dart';
import '../../service/news_service.dart';
import 'news_detail.dart';
import 'add_news.dart';
import 'edit_news.dart';
import 'package:ballistic/widgets/left_drawer.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  late Future<List<News>> _newsFuture;
  String _selectedCategory = 'all';
  bool _popularOnly = false;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  void _loadNews() {
    _newsFuture = NewsService.fetchNews(
      category: _selectedCategory == 'all' ? null : _selectedCategory,
      popularOnly: _popularOnly,
    );
  }

  void _refreshNews() {
    setState(() {
      _loadNews();
    });
  }

  void _confirmDelete(News news) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete News'),
        content: const Text('Are you sure you want to delete this news?'),
        actions: [
            TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await NewsService.deleteNews(news.id);
              _refreshNews();

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('News berhasil dihapus'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       drawer: const LeftDrawer(),
      appBar: AppBar(
        title: const Text('News'),
        automaticallyImplyLeading: false,
          leading: Builder(
    builder: (context) => IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    ),
  ),

        actions: [
            IconButton(
              icon: Icon(
                Icons.local_fire_department,
                color: _popularOnly ? Colors.orange : null,
              ),
              onPressed: () {
                setState(() {
                  _popularOnly = !_popularOnly;
                  _loadNews();
                });
              },
            ),
          // FILTER CATEGORY
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _selectedCategory = value;
                _loadNews();
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'all', child: Text('All')),
              PopupMenuItem(value: 'sports_news', child: Text('Sports')),
              PopupMenuItem(value: 'event', child: Text('Event')),
              PopupMenuItem(value: 'training_tips', child: Text('Training Tips')),
            ],
          ),

          //  ADD
          if (UserSession.isAdmin)
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddNewsPage()),
              );
              _refreshNews();
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('News berhasil ditambahkan'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            
          ),

          // REFRESH
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshNews,
          ),
        ],
      ),
      body: FutureBuilder<List<News>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final news = snapshot.data;
          if (news == null || news.isEmpty) {
            return const Center(child: Text('Belum ada news'));
          }

          return ListView.builder(
            itemCount: news.length,
            itemBuilder: (context, index) {
              final newsItem = news[index];

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NewsDetailPage(news: newsItem),
                    ),
                  );
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🖼 THUMBNAIL
                      if (newsItem.thumbnail != null &&
                          newsItem.thumbnail!.isNotEmpty)
                        Image.network(
                          newsItem.thumbnail!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _noImage(),
                        )
                      else
                        _noImage(),

                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              newsItem.title,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _formatCategory(newsItem.category),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Text(
                              'by ${newsItem.author}',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              newsItem.content.length > 100
                                  ? '${newsItem.content.substring(0, 100)}...'
                                  : newsItem.content,
                            ),
                            const SizedBox(height: 12),

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.visibility, size: 16),
                                    const SizedBox(width: 4),
                                    Text('${newsItem.newsViews} views'),
                                  ],
                                ),
                                Row( // edit dan delete 
                                  children: [
                                    if (UserSession.isAdmin) ...[
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => EditNewsPage(news: newsItem),
                                            ),
                                          );
                                          if (result == true) {
                                            _refreshNews();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('News berhasil diupdate'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      IconButton( //tombol delete
                                        icon: const Icon(Icons.delete,
                                            size: 18, color: Colors.red),
                                        onPressed: () => _confirmDelete(newsItem),
                                      ),
                                    ],

                                    if (newsItem.isFeatured) //buat popular
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          'POPULAR',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                  ],
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _noImage() {
    return Container(
      height: 180,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 40),
      ),
    );
  }
}
String _formatCategory(String category) {
  switch (category) {
    case 'sports_news':
      return 'Sports';
    case 'event':
      return 'Event';
    case 'training_tips':
      return 'Training Tips';
    default:
      return category;
  }
}
