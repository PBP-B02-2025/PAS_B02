import 'package:flutter/material.dart';
import 'review.dart'; 

class ReviewPageExample extends StatelessWidget {
  final int productId;
  final String? currentUser;

  const ReviewPageExample({
    super.key,
    required this.productId,
    this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Reviews'),
      ),
      body: SingleChildScrollView(
        child: ReviewSection(
          productId: productId,
          currentUser: currentUser,
          
          
          onFetchReviews: () async {
            // final response = await request.get('http://abcd.com/reviews/$productId');
            // return (response as List).map((r) => ReviewModel.fromJson(r)).toList();
            
            // Mock data for testing
            await Future.delayed(const Duration(seconds: 1));
            return _getMockReviews();
          },
          
          onAddReview: (description, star) async {
            // final response = await request.post(
            //   'http://abcd.com/reviews/',
            //   {'product_id': productId, 'description': description, 'star': star},
            // );
            // return response['status'] == 'success';
            
            await Future.delayed(const Duration(milliseconds: 500));
            return true; // Return true if successful
          },
          
          onEditReview: (reviewId, description, star) async {
            // final response = await request.put(
            //   'http://abcd.com/reviews/$reviewId/',
            //   {'description': description, 'star': star},
            // );
            // return response['status'] == 'success';
            
            await Future.delayed(const Duration(milliseconds: 500));
            return true;
          },
          
          onDeleteReview: (reviewId) async {
            // final response = await request.delete('http://abcd.com/reviews/$reviewId/');
            // return response['status'] == 'success';
            
            await Future.delayed(const Duration(milliseconds: 500));
            return true;
          },
        ),
      ),
    );
  }

  List<ReviewModel> _getMockReviews() {
    return [
      ReviewModel(
        id: 1,
        author: 'john_doe',
        description: 'Great product! Really exceeded my expectations. The quality is amazing and I would definitely recommend it to others.',
        star: 5,
      ),
      ReviewModel(
        id: 2,
        author: 'jane_smith',
        description: 'Good value for money. Works as expected, though delivery took a bit longer than expected.',
        star: 4,
      ),
      ReviewModel(
        id: 3,
        author: 'mike_wilson',
        description: 'Decent product. Does what it says but nothing extraordinary.',
        star: 3,
      ),
      ReviewModel(
        id: 4,
        author: currentUser ?? 'current_user',
        description: 'This is my review that I can edit or delete!',
        star: 4,
      ),
    ];
  }
}

