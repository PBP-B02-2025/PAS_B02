import 'package:flutter/material.dart';

class Review extends StatefulWidget{
  const Review({super.key});

  @override
  State<Review> createState() => _ReviewState();

}

class _ReviewState extends State<Review> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('Review Title'),
            subtitle: Text('Review Subtitle'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Review content goes here.'),
          ),
        ],
      ),
    );
  }
}