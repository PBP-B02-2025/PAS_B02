import 'package:ballistic/widgets/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../widgets/empty_state_card.dart';
import '../widgets/measurement_detail.dart';
import 'package:ballistic/features/user_measurement/models/measurement_model.dart';
import 'package:ballistic/shop/models/product.dart';
import 'package:ballistic/shop/screen/product_detail.dart';

class UserMeasurementPage extends StatefulWidget {
  const UserMeasurementPage({super.key});

  @override
  State<UserMeasurementPage> createState() => _UserMeasurementPageState();
}

class _UserMeasurementPageState extends State<UserMeasurementPage> {
  String selectedType = 'clothes';

  Future<Measurement?> fetchMeasurement(CookieRequest request) async {
    try {
      final response = await request.get('https://jovian-felix-ballistic.pbp.cs.ui.ac.id/measurement/measurementdata/');
      if (response == null || response['status'] == 'error' || response.isEmpty) {
        return null;
      }
      return Measurement.fromJson(response);
    } catch (e) {
      return null;
    }
  }


  Future<List<Product>> fetchRecommendedProducts(CookieRequest request) async {
    try {
      final response = await request.get(
          'https://jovian-felix-ballistic.pbp.cs.ui.ac.id/measurement/get-products-json/?type=$selectedType');
      if (response != null && response['status'] == 'success') {
        List<Product> products = [];
        for (var item in response['products']) {
          products.add(Product.fromJson(item));
        }
        return products;
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
      drawer: LeftDrawer(),
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

                  FutureBuilder<Measurement?>(
                    future: fetchMeasurement(request),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(40.0),
                          child: CircularProgressIndicator(color: Color(0xFFC9A25B)),
                        );
                      }

                      if (snapshot.hasData && snapshot.data != null) {
                        final measurement = snapshot.data!;

                        return Column(
                          children: [
                            MeasurementDetailCard(
                              data: measurement.toJson(),
                              onDelete: refreshPage,
                              onEdit: refreshPage,
                            ),
                            const SizedBox(height: 40),
                            const Divider(),
                            const SizedBox(height: 20),
                            const Text("Produk yang Direkomendasikan",
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildToggleButton("SHIRT", "clothes"),
                                const SizedBox(width: 12),
                                _buildToggleButton("HELM", "helmet"),
                              ],
                            ),
                            const SizedBox(height: 30),

                            FutureBuilder<List<Product>>(
                              future: fetchRecommendedProducts(request),
                              builder: (context, prodSnapshot) {
                                if (prodSnapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator(color: Colors.black);
                                }

                                final products = prodSnapshot.data ?? [];

                                if (products.isEmpty) {
                                  return _buildEmptyProductsView();
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
                                    return _buildProductCard(products[index]);
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

  Widget _buildEmptyProductsView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text("Tidak ada produk yang sesuai ukuranmu.",
            style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildProductCard(Product p) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(product: p),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
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
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.network(
                    p.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(p.brand ?? "No Brand",
                      style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  const SizedBox(height: 4),
                  Text("Rp ${p.price}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  Text("Size: ${p.size}",
                      style: const TextStyle(fontSize: 10, color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}