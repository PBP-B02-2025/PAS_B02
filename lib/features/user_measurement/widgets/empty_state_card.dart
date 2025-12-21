import 'package:flutter/material.dart';
// Import form kamu agar bisa berpindah halaman
import 'package:ballistic/features/user_measurement/widgets/measurement_form_page.dart';

class EmptyStateCard extends StatelessWidget {
  final VoidCallback onFillNow;
  const EmptyStateCard({super.key, required this.onFillNow});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Icon(Icons.assignment_outlined, size: 50, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("Data ukuran badan belum ditemukan.", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MeasurementFormPage()),
              );
              if (result == true) {
                onFillNow();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: const Text("Isi Sekarang", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}