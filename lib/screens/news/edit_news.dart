import 'package:flutter/material.dart';
import '../../models/news.dart';
import '../../service/news_service.dart';

class EditNewsPage extends StatefulWidget {
  final News news;
  const EditNewsPage({super.key, required this.news});

  @override
  State<EditNewsPage> createState() => _EditNewsPageState();
}

class _EditNewsPageState extends State<EditNewsPage> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _contentController;
  late TextEditingController _thumbnailController;

  late String _category;
  late bool _isFeatured;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.news.title);
    _authorController = TextEditingController(text: widget.news.author);
    _contentController = TextEditingController(text: widget.news.content);
    _thumbnailController =
        TextEditingController(text: widget.news.thumbnail ?? '');

    _category = widget.news.category;
    _isFeatured = widget.news.isFeatured;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await NewsService.updateNews(
        id: widget.news.id,
        title: _titleController.text,
        author: _authorController.text,
        content: _contentController.text,
        category: _category,
        thumbnail:
            _thumbnailController.text.isEmpty ? null : _thumbnailController.text,
        isFeatured: _isFeatured,
      );

      Navigator.pop(context, true); // ⬅️ kasih tanda berhasil
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update news')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit News')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
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
                decoration: const InputDecoration(labelText: 'Thumbnail URL'),
              ),
              DropdownButtonFormField(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: const [
                  DropdownMenuItem(
                      value: 'sports_news', child: Text('Sports News')),
                  DropdownMenuItem(value: 'event', child: Text('Event')),
                  DropdownMenuItem(
                      value: 'training_tips', child: Text('Training Tips')),
                ],
                onChanged: (value) {
                  setState(() => _category = value!);
                },
              ),
              SwitchListTile(
                title: const Text('Mark as Popular'),
                value: _isFeatured,
                onChanged: (v) => setState(() => _isFeatured = v),
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 6,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
