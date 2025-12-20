import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ballistic/shop/models/product.dart';
import 'package:ballistic/screens/menu.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  // Ganti 127.0.0.1 jika di Chrome, atau 10.0.2.2 jika di Emulator Android
  final String apiUrl = 'http://127.0.0.1:8000/shop/api/products/';
  
  final Color ballisticGold = const Color(0xFFC9A25B);

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];
  String _selectedCategory = 'All Products';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
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
            _categories = List<String>.from(data['categories']);
          }
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error: $e");
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        // PERBAIKAN 1: Gunakan FittedBox agar judul tidak terpotong di layar kecil
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Ballistic Products'),
        ),
        backgroundColor: ballisticGold,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const MyHomePage()));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProductFormPage()),
          );
        },
        backgroundColor: ballisticGold,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: ballisticGold))
          : Column(
              children: [
                if (_categories.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(category),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey[800],
                              fontSize: 12, // Perkecil font filter dikit
                            ),
                            selected: isSelected,
                            selectedColor: ballisticGold,
                            backgroundColor: Colors.white,
                            onSelected: (bool selected) {
                              if (selected) _filterProducts(category);
                            },
                          ),
                        );
                      },
                    ),
                  ),

                Expanded(
                  child: _filteredProducts.isEmpty
                      ? const Center(child: Text("Tidak ada produk ditemukan"))
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            // PERBAIKAN 2: Ubah rasio jadi 0.55 agar kartu lebih panjang ke bawah
                            childAspectRatio: 0.55, 
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
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

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // PERBAIKAN 3: Kurangi tinggi gambar dari 160 ke 120 agar tidak overflow
              SizedBox(
                height: 120, 
                width: double.infinity,
                child: Image.network(
                  product.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
              if (product.isFeatured)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: ballisticGold,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'FEATURED',
                      style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),

          // Bagian Teks (Flexible agar mengisi sisa ruang)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0), // Padding sedikit diperkecil
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Agar tombol terdorong ke bawah
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.category.toUpperCase(),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14, // Font judul disesuaikan
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Rp ${product.price}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: ballisticGold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        maxLines: 2, // Kurangi baris deskripsi jadi 2
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Tombol View Details
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Detail ${product.name}")),
                    );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ballisticGold,
                  foregroundColor: Colors.white,
                  // Padding tombol diperkecil sedikit agar muat
                  padding: const EdgeInsets.symmetric(vertical: 8), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(0, 36), // Tinggi minimum tombol
                ),
                child: const Text(
                  "View Details",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}