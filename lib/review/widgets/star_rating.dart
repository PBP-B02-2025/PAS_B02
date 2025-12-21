import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int rating;
  final int maxRating;
  final double starSize;
  final Color filledColor;
  final Color emptyColor;
  final bool isInteractive;
  final Function(int)? onRatingChanged;

  const StarRating({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.starSize = 24.0,
    this.filledColor = Colors.amber,
    this.emptyColor = Colors.grey,
    this.isInteractive = false,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        final isFilled = index < rating;
        return GestureDetector(
          onTap: isInteractive
              ? () => onRatingChanged?.call(index + 1)
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Icon(
              isFilled ? Icons.star : Icons.star_border,
              color: isFilled ? filledColor : emptyColor,
              size: starSize,
            ),
          ),
        );
      }),
    );
  }
}

/// A variant with half-star support for display purposes
class StarRatingDisplay extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double starSize;
  final Color filledColor;
  final Color halfFilledColor;
  final Color emptyColor;

  const StarRatingDisplay({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.starSize = 20.0,
    this.filledColor = Colors.amber,
    this.halfFilledColor = Colors.amber,
    this.emptyColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        IconData icon;
        Color color;
        
        if (index < rating.floor()) {
          icon = Icons.star;
          color = filledColor;
        } else if (index < rating) {
          icon = Icons.star_half;
          color = halfFilledColor;
        } else {
          icon = Icons.star_border;
          color = emptyColor;
        }
        
        return Icon(icon, color: color, size: starSize);
      }),
    );
  }
}
