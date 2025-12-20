import 'package:flutter/material.dart';
import '../models/review_model.dart';
import 'review_card.dart';
import 'star_rating.dart';

class ReviewListWidget extends StatelessWidget {
  final List<ReviewModel> reviews;
  final String? currentUser;
  final Function(ReviewModel)? onEdit;
  final Function(ReviewModel)? onDelete;
  final bool showSummary;
  final bool showActions;

  const ReviewListWidget({
    super.key,
    required this.reviews,
    this.currentUser,
    this.onEdit,
    this.onDelete,
    this.showSummary = true,
    this.showActions = true,
  });

  double get averageRating {
    if (reviews.isEmpty) return 0;
    final total = reviews.fold<int>(0, (sum, r) => sum + r.star);
    return total / reviews.length;
  }

  Map<int, int> get ratingDistribution {
    final dist = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final review in reviews) {
      dist[review.star] = (dist[review.star] ?? 0) + 1;
    }
    return dist;
  }

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.rate_review_outlined,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No Reviews Yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Be the first to share your experience!',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Summary Header
        if (showSummary) _buildSummaryHeader(context),
        
        // Reviews List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            return ReviewCard(
              review: reviews[index],
              currentUser: currentUser,
              onEdit: onEdit,
              onDelete: onDelete,
              showActions: showActions,
            );
          },
        ),
      ],
    );
  }

  Widget _buildSummaryHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Average Rating
          Column(
            children: [
              Text(
                averageRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              StarRatingDisplay(
                rating: averageRating,
                starSize: 16,
              ),
              const SizedBox(height: 4),
              Text(
                '${reviews.length} review${reviews.length != 1 ? 's' : ''}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          
          const SizedBox(width: 24),
          
          // Rating Distribution
          Expanded(
            child: Column(
              children: List.generate(5, (index) {
                final star = 5 - index;
                final count = ratingDistribution[star] ?? 0;
                final percentage = reviews.isNotEmpty 
                    ? count / reviews.length 
                    : 0.0;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        '$star',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percentage,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.amber,
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 24,
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
