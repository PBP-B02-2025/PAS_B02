import 'package:flutter/material.dart';

class EmptyStateForum extends StatelessWidget {
  final VoidCallback onActionPressed;

  const EmptyStateForum({super.key, required this.onActionPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(48),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.forum_outlined, 
            size: 64, 
            color: Color(0xFF9CA3AF),
          ),
          
          const SizedBox(height: 16),

          // Judul
          const Text(
            "No discussions yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Start a new topic and share your thoughts with the community!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),

          const SizedBox(height: 24),

          ElevatedButton.icon(
            onPressed: onActionPressed,
            icon: const Icon(Icons.add, size: 18),
            label: const Text("Add Forum"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}