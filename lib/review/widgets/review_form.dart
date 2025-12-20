import 'package:flutter/material.dart';
import '../models/review_model.dart';
import 'star_rating.dart';

class ReviewFormDialog extends StatefulWidget {
  final ReviewModel? review; // null for new review, existing for edit
  final Function(String description, int star) onSubmit;

  const ReviewFormDialog({
    super.key,
    this.review,
    required this.onSubmit,
  });

  /// Static method to show the dialog
  static Future<void> show({
    required BuildContext context,
    ReviewModel? review,
    required Function(String description, int star) onSubmit,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ReviewFormDialog(
        review: review,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<ReviewFormDialog> createState() => _ReviewFormDialogState();
}

class _ReviewFormDialogState extends State<ReviewFormDialog> {
  late TextEditingController _descriptionController;
  late int _selectedStar;
  final _formKey = GlobalKey<FormState>();

  bool get isEditing => widget.review != null;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: widget.review?.description ?? '',
    );
    _selectedStar = widget.review?.star ?? 5;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Edit Review' : 'Add Review'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Star Rating Input
              const Text(
                'Rating',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: StarRating(
                  rating: _selectedStar,
                  starSize: 36,
                  isInteractive: true,
                  onRatingChanged: (rating) {
                    setState(() => _selectedStar = rating);
                  },
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  _getStarLabel(_selectedStar),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Description Input
              const Text(
                'Your Review',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your review here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your review';
                  }
                  if (value.trim().length < 10) {
                    return 'Review must be at least 10 characters';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          child: Text(isEditing ? 'Update' : 'Submit'),
        ),
      ],
    );
  }

  String _getStarLabel(int star) {
    switch (star) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _descriptionController.text.trim(),
        _selectedStar,
      );
      Navigator.of(context).pop();
    }
  }
}

/// Inline review form widget (not a dialog)
/// Can be embedded directly in a page
class ReviewFormInline extends StatefulWidget {
  final ReviewModel? review;
  final Function(String description, int star) onSubmit;
  final VoidCallback? onCancel;

  const ReviewFormInline({
    super.key,
    this.review,
    required this.onSubmit,
    this.onCancel,
  });

  @override
  State<ReviewFormInline> createState() => _ReviewFormInlineState();
}

class _ReviewFormInlineState extends State<ReviewFormInline> {
  late TextEditingController _descriptionController;
  late int _selectedStar;
  final _formKey = GlobalKey<FormState>();

  bool get isEditing => widget.review != null;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: widget.review?.description ?? '',
    );
    _selectedStar = widget.review?.star ?? 5;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Edit Your Review' : 'Write a Review',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Star Rating
              Row(
                children: [
                  const Text('Rating: '),
                  StarRating(
                    rating: _selectedStar,
                    starSize: 32,
                    isInteractive: true,
                    onRatingChanged: (rating) {
                      setState(() => _selectedStar = rating);
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Your Review',
                  hintText: 'Share your experience...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your review';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.onCancel != null)
                    TextButton(
                      onPressed: widget.onCancel,
                      child: const Text('Cancel'),
                    ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onSubmit(
                          _descriptionController.text.trim(),
                          _selectedStar,
                        );
                      }
                    },
                    child: Text(isEditing ? 'Update' : 'Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
