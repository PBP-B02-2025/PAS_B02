import 'package:flutter/material.dart';
import 'review.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProductReviewPage extends StatelessWidget {
  final int productId;
  final String? productName;
  final String? currentUser;

  const ProductReviewPage({
    super.key,
    required this.productId,
    this.productName,
    this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(productName != null 
            ? 'Reviews - $productName' 
            : 'Product Reviews'),
      ),
      body: SingleChildScrollView(
        child: ReviewSection(
          productId: productId,  // <-- Reviews are fetched for THIS product
          currentUser: currentUser,
          
          //fetch reviews
          onFetchReviews: (productId) async {
            // GET reviews filtered by product_id
            final response = await request.get(
              'http://localhost:8000/review/json/?product_id=$productId'
            );
            
            List<ReviewModel> reviews = [];
            for (var r in response) {
              if (r != null) {
                reviews.add(ReviewModel.fromJson(r));
              }
            }
            return reviews;
          },
          
          //add review
          onAddReview: (productId, description, star) async {
            final response = await request.post(
              'http://localhost:8000/review/add/',
              {
                'product_id': productId.toString(),  // <-- Links to this product
                'description': description,
                'star': star.toString(),
              },
            );
            return response['status'] == 'success';
          },
          
          //edit review
          onEditReview: (reviewId, description, star) async {
            final response = await request.post(
              'http://localhost:8000/review/edit/$reviewId/',
              {
                'description': description,
                'star': star.toString(),
              },
            );
            return response['status'] == 'success';
          },
          
          // delete review
          onDeleteReview: (reviewId) async {
            final response = await request.post(
              'http://localhost:8000/review/delete/$reviewId/',
              {},
            );
            return response['status'] == 'success';
          },
        ),
      ),
    );
  }
}
