import 'package:flutter/material.dart';
import 'models/review_model.dart';
import 'widgets/review_list.dart';
import 'widgets/review_form.dart';

class ReviewSection extends StatefulWidget {
  final int productId;
  final String? currentUser;
  final Future<List<ReviewModel>> Function() onFetchReviews;
  final Future<bool> Function(String description, int star)? onAddReview;
  final Future<bool> Function(int reviewId, String description, int star)? onEditReview;
  final Future<bool> Function(int reviewId)? onDeleteReview;

  const ReviewSection({
    super.key,
    required this.productId,
    this.currentUser,
    required this.onFetchReviews,
    this.onAddReview,
    this.onEditReview,
    this.onDeleteReview,
  });

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  List<ReviewModel> _reviews = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final reviews = await widget.onFetchReviews();
      setState(() {
        _reviews = reviews;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load reviews: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleAddReview(String description, int star) async {
    if (widget.onAddReview == null) return;

    try {
      final success = await widget.onAddReview!(description, star);
      if (success) {
        _showSnackBar('Review added successfully!');
        _loadReviews(); // Refresh the list
      } else {
        _showSnackBar('Failed to add review', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error: $e', isError: true);
    }
  }

  Future<void> _handleEditReview(ReviewModel review) async {
    if (widget.onEditReview == null || review.id == null) return;

    await ReviewFormDialog.show(
      context: context,
      review: review,
      onSubmit: (description, star) async {
        try {
          final success = await widget.onEditReview!(
            review.id!,
            description,
            star,
          );
          if (success) {
            _showSnackBar('Review updated successfully!');
            _loadReviews();
          } else {
            _showSnackBar('Failed to update review', isError: true);
          }
        } catch (e) {
          _showSnackBar('Error: $e', isError: true);
        }
      },
    );
  }

  Future<void> _handleDeleteReview(ReviewModel review) async {
    if (widget.onDeleteReview == null || review.id == null) return;

    try {
      final success = await widget.onDeleteReview!(review.id!);
      if (success) {
        _showSnackBar('Review deleted successfully!');
        _loadReviews();
      } else {
        _showSnackBar('Failed to delete review', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  void _showAddReviewDialog() {
    ReviewFormDialog.show(
      context: context,
      onSubmit: _handleAddReview,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.currentUser != null && widget.onAddReview != null)
                ElevatedButton.icon(
                  onPressed: _showAddReviewDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Review'),
                ),
            ],
          ),
        ),

        // Content
        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_error != null)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadReviews,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          )
        else
          ReviewListWidget(
            reviews: _reviews,
            currentUser: widget.currentUser,
            onEdit: _handleEditReview,
            onDelete: _handleDeleteReview,
          ),
      ],
    );
  }
}
