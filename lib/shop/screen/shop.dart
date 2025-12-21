import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ballistic/shop/models/product.dart';
import 'package:ballistic/screens/menu.dart';
import 'package:ballistic/shop/screen/product_form.dart';
import 'package:ballistic/shop/screen/product_detail.dart';
import 'package:ballistic/utils/user_info.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  // Gunakan localhost jika di Chrome, atau 10.0.2.2 jika di Emulator Android
  String get apiUrl => kIsWeb 
      ? 'https://jovian-felix-ballistic.pbp.cs.ui.ac.id/shop/api/products/'
      : 'http://10.0.2.2:8000/shop/api/products/';
  
  final Color ballisticGold = const Color(0xFFC9A25B);
  final Color ballisticBlack = const Color(0xFF1A1A1A);

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];
  String _selectedCategory = 'All Products';
  bool _isLoading = true;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdmin();
    fetchProducts();
  }

  Future<void> _checkAdmin() async {
    bool isAdmin = await UserInfo.isSuperuser();
    bool isStaff = await UserInfo.isStaff();
    if (mounted) {
      setState(() {
        _isAdmin = isAdmin || isStaff;
      });
    }
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Product> loadedProducts = [];
        for (var item in data['products']) {
          loadedProducts.add(Product.fromJson(item));
        }

        setState(() {
          _allProducts = loadedProducts;
          _filteredProducts = _allProducts;
          if (data['categories'] != null) {
             _categories = [];
             for(var cat in data['categories']){
               _categories.add(cat[0]); 
             }
             _categories.insert(0, 'All Products');
          }
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Error fetching products: $e");
    }
  }

  void _filterProducts(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'All Products') {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts.where((p) => p.category == category).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan jumlah kolom berdasarkan lebar layar (Responsive)
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 1200 ? 4 : (screenWidth > 800 ? 3 : 2);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text(
          'BALLISTIC SHOP',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.white),
        ),
        backgroundColor: const Color(0xFFC9A25B),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const MyHomePage()));
          },
        ),
      ),
      floatingActionButton: !_isAdmin ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProductFormPage()),
          );
        },
        backgroundColor: ballisticGold,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Product", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ) : null,
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: ballisticGold))
          : Column(
              children: [
                // Category Filter Bar
                if (_categories.isNotEmpty)
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: FilterChip(
                            label: Text(category),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : ballisticBlack,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              if (selected) _filterProducts(category);
                            },
                            selectedColor: ballisticGold,
                            backgroundColor: Colors.white,
                            checkmarkColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: isSelected ? ballisticGold : Colors.grey.shade300),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // Product Grid
                Expanded(
                  child: _filteredProducts.isEmpty
                      ? _buildEmptyState()
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: 0.65, 
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            return _buildProductCard(_filteredProducts[index]);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            "No products found",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailPage(product: product)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey.shade100,
                      child: Image.network(
                        product.thumbnail,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, error, stackTrace) => const Center(
                          child: Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  if (product.isFeatured)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: ballisticBlack,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'FEATURED',
                          style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content Section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.category.toUpperCase(),
                          style: TextStyle(color: ballisticGold, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, height: 1.2),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rp ${product.price}",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: ballisticBlack),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: ballisticBlack),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "View Details",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}