import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../widgets/empty_state_card.dart';
import '../widgets/measurement_detail.dart';

class UserMeasurementPage extends StatefulWidget {
  const UserMeasurementPage({super.key});

  @override
  State<UserMeasurementPage> createState() => _UserMeasurementPageState();
}

class _UserMeasurementPageState extends State<UserMeasurementPage> {
  // Melacak tipe produk yang dipilih: 'clothes' (untuk Shirt) atau 'helmet'
  String selectedType = 'clothes';

  Future<Map<String, dynamic>?> fetchMeasurement(CookieRequest request) async {
    try {
      final response = await request.get('http://localhost:8000/measurement/measurementdata/');
      if (response == null || response['status'] == 'error' || response.isEmpty) {
        return null;
      }
      return response;
    } catch (e) {
      return null;
    }
  }

  // Fungsi baru untuk mengambil rekomendasi produk sesuai filter
  Future<List<dynamic>> fetchRecommendedProducts(CookieRequest request) async {
    try {
      final response = await request.get(
          'http://localhost:8000/measurement/get-products-json/?type=$selectedType');
      if (response != null && response['status'] == 'success') {
        return response['products'] ?? [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  void refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFC9A25B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Size Recommendation",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text("Berikut data ukuran badanmu saat ini.",
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 30),

                  FutureBuilder(
                    future: fetchMeasurement(request),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(color: Colors.black);
                      }

                      if (snapshot.hasData && snapshot.data != null) {
                        return Column(
                          children: [
                            MeasurementDetailCard(
                              data: snapshot.data!,
                              onDelete: refreshPage,
                              onEdit: refreshPage,
                            ),
                            const SizedBox(height: 40),
                            const Divider(),

                            // SEKSI REKOMENDASI PRODUK
                            const SizedBox(height: 20),
                            const Text("Produk yang Direkomendasikan",
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),

                            // TOMBOL TOGGLE (SHIRT / HELM)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildToggleButton("SHIRT", "clothes"),
                                const SizedBox(width: 12),
                                _buildToggleButton("HELM", "helmet"),
                              ],
                            ),
                            const SizedBox(height: 30),

                            // GRID DAFTAR PRODUK
                            FutureBuilder(
                              future: fetchRecommendedProducts(request),
                              builder: (context, prodSnapshot) {
                                if (prodSnapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator(color: Colors.black);
                                }

                                final products = prodSnapshot.data ?? [];

                                if (products.isEmpty) {
                                  return Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(40),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: Text("Tidak ada produk yang sesuai ukuranmu.",
                                          style: TextStyle(color: Colors.grey)),
                                    ),
                                  );
                                }

                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.7,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                  ),
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    final p = products[index];
                                    return _buildProductCard(p);
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      }

                      return EmptyStateCard(onFillNow: refreshPage);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget Button Toggle (Hitam jika aktif, Abu jika tidak)
  Widget _buildToggleButton(String label, String typeValue) {
    bool isActive = selectedType == typeValue;
    return ElevatedButton(
      onPressed: () => setState(() => selectedType = typeValue),
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.black : Colors.grey.shade200,
        foregroundColor: isActive ? Colors.white : Colors.black54,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  // Widget Card Produk sesuai Model Product
  Widget _buildProductCard(dynamic p) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: p['thumbnail'] != null && p['thumbnail'] != ""
                  ? Image.network(p['thumbnail'], fit: BoxFit.cover)
                  : const Icon(Icons.image, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p['name'] ?? "Product",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(p['brand'] ?? "No Brand",
                    style: const TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 4),
                Text("Rp ${p['price']}",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                Text("Size: ${p['size']}",
                    style: const TextStyle(fontSize: 10, color: Colors.blueGrey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}