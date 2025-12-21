import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ballistic/features/user_measurement/widgets/measurement_form_page.dart';

class MeasurementDetailCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const MeasurementDetailCard({
    super.key,
    required this.data,
    required this.onDelete,
    required this.onEdit,
  });

  bool _hasValue(dynamic v) {
    if (v == null) return false;
    if (v is num) return v != 0;
    if (v is String) return v.trim().isNotEmpty && v != "0";
    return true;
  }

  Future<void> _deleteData(BuildContext context, CookieRequest request) async {
    final response = await request.post(
      'https://jovian-felix-ballistic.pbp.cs.ui.ac.id/measurement/delete/',
      {},
    );

    if (response['status'] == 'success') {
      onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Data Pengukuran Tubuh",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Divider(height: 30),

        _buildSectionLabel("Ukuran Dasar"),
        _buildOutlineBox(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _richText("Tinggi", "${data['height']} cm"),
              _richText("Berat", "${data['weight']} kg"),
              _richText("Kepala", "${data['head_circumference']} cm"),
            ],
          ),
        ),

        const SizedBox(height: 24),
        if (_hasValue(data['waist']) ||
            _hasValue(data['hip']) ||
            _hasValue(data['chest'])) ...[
          _buildSectionLabel("Ukuran Tambahan"),
          Row(
            children: [
              if (_hasValue(data['waist']))
                Expanded(
                  child: _buildSmallStatBox(
                    "PINGGANG",
                    "${data['waist']} cm",
                  ),
                ),
              if (_hasValue(data['hip'])) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSmallStatBox(
                    "PINGGUL",
                    "${data['hip']} cm",
                  ),
                ),
              ],
              if (_hasValue(data['chest'])) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSmallStatBox(
                    "DADA",
                    "${data['chest']} cm",
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),
        ],

        _buildSectionLabel("Rekomendasi Ukuran"),
        Row(
          children: [
            Expanded(
              child: _buildRecommendationBox(
                "UKURAN PAKAIAN",
                data['clothes_size'] ?? "-",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRecommendationBox(
                "UKURAN HELM",
                data['helmet_size'] ?? "-",
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MeasurementFormPage(existingData: data),
                    ),
                  );
                  if (result == true) onEdit();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  "Ubah Data Ukuran",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Hapus Data"),
                      content: const Text(
                        "Apakah Anda yakin ingin menghapus data ukuran ini?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text("Batal"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _deleteData(context, request);
                          },
                          child: const Text(
                            "Hapus",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  "Hapus Data",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  Widget _buildOutlineBox(Widget child) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8),
    ),
    child: child,
  );

  Widget _richText(String label, String value) => RichText(
    text: TextSpan(
      style: const TextStyle(color: Colors.black, fontSize: 14),
      children: [
        TextSpan(
          text: "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(text: value),
      ],
    ),
  );

  Widget _buildSmallStatBox(String label, String value) => Container(
    padding: const EdgeInsets.symmetric(vertical: 15),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    ),
  );

  Widget _buildRecommendationBox(String label, String size) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFFF9F9F9),
      border: Border.all(color: Colors.grey.shade200),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            size,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "(Dihitung berdasarkan data)",
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    ),
  );
}
