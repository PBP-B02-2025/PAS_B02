import 'package:ballistic/models/news.dart';
import 'package:ballistic/service/news_service.dart';
import 'package:flutter/material.dart';
class NewsDetailPage extends StatefulWidget {
  final News news;
  const NewsDetailPage({super.key, required this.news});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
int currentViews = 0;

@override
void initState() {
  super.initState();
  currentViews = widget.news.newsViews;
  
  NewsService.incrementViews(widget.news.id.toString()).then((_) {
    if (mounted) {
      setState(() {
        currentViews++; 
      });
    }
  });
}

  @override
  Widget build(BuildContext context) {
    final news = widget.news;
    return Scaffold( // Scaffold untuk struktur halaman
      appBar: AppBar(
        title: const Text('News Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Thumbnail
            if (news.thumbnail != null && news.thumbnail!.isNotEmpty)
              Image.network(
                news.thumbnail!,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 220,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.image_not_supported, size: 48),
                ),
              ),
            // Konten Berita
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Title
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),
              // Author dan Views
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'by ${news.author}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.visibility, size: 16),
                          const SizedBox(width: 4),
                          Text('$currentViews views'),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    news.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
