import 'package:flutter/material.dart';

class ErrorStateForum extends StatelessWidget {
  final VoidCallback onRetry;

  const ErrorStateForum({super.key, required this.onRetry});

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
        children: [
          const Text(
            "⚠️",
            style: TextStyle(fontSize: 48), // Setara text-5xl
          ),
          const SizedBox(height: 16),
          const Text(
            "Failed to load forum",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF111827), // text-gray-900
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Please try again later.",
            style: TextStyle(color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 16),
          // Tambahkan tombol retry (optional tapi bagus untuk UX)
          TextButton(
            onPressed: onRetry,
            child: const Text("Try Again", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}