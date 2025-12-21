import 'package:flutter/material.dart';
import '../../service/news_service.dart';

class AddNewsPage extends StatefulWidget {
  const AddNewsPage({super.key});

  @override
  State<AddNewsPage> createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _contentController = TextEditingController();
  final _thumbnailController = TextEditingController();

  String _category = 'sports_news';
  bool _isLoading = false;
  bool _isFeatured = false;


  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await NewsService.addNews(
        title: _titleController.text,
        author: _authorController.text,
        content: _contentController.text,
        category: _category,
        thumbnail: _thumbnailController.text.isEmpty
            ? null
            : _thumbnailController.text,
        isFeatured: _isFeatured,
      );

      if (!mounted) return;
      Navigator.pop(context); // balik ke NewsList
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add News')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _thumbnailController,
                decoration:
                    const InputDecoration(labelText: 'Thumbnail URL'),
              ),
              DropdownButtonFormField(
                value: _category,
                items: const [
                  DropdownMenuItem(
                    value: 'sports_news',
                    child: Text('Sports News'),
                  ),
                  DropdownMenuItem(
                    value: 'event',
                    child: Text('Event'),
                  ),
                  DropdownMenuItem(
                    value: 'training_tips',
                    child: Text('Training Tips'),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _category = value!);
                },
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 6,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SwitchListTile(
  title: const Text('Berita Unggulan'),
  subtitle: const Text('Centang jika berita ini adalah berita unggulan'),
  value: _isFeatured,
  onChanged: (value) {
    setState(() {
      _isFeatured = value;
    });
  },
),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
