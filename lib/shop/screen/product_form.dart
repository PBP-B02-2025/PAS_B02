import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ballistic/shop/screen/shop.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Variabel untuk menyimpan input user
  String _name = "";
  int _price = 0;
  String _description = "";
  String _category = "Shoes"; // Default Value
  String _size = "";
  String _brand = "";
  String _thumbnail = "";

  // Warna tema (Gold)
  final Color ballisticGold = const Color(0xFFC9A25B);

  // Daftar Kategori (Sesuaikan dengan CATEGORY_CHOICES di Django models.py kamu)
  List<String> categories = ['Shoes', 'Shirt', 'Water Bottle', 'Helmet'];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
        backgroundColor: ballisticGold,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- NAMA PRODUK ---
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Product Name",
                  hintText: "Enter product name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                onChanged: (String? value) => setState(() => _name = value!),
                validator: (String? value) {
                  if (value == null || value.isEmpty) return "Name cannot be empty!";
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // --- HARGA ---
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Price",
                  hintText: "Enter price (number only)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                keyboardType: TextInputType.number,
                onChanged: (String? value) => setState(() => _price = int.tryParse(value!) ?? 0),
                validator: (String? value) {
                  if (value == null || value.isEmpty) return "Price cannot be empty!";
                  if (int.tryParse(value) == null) return "Price must be a number!";
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // --- KATEGORI (Dropdown) ---
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) => setState(() => _category = newValue!),
              ),
              const SizedBox(height: 12),

              // --- BRAND ---
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Brand",
                  hintText: "e.g. Adidas, Nike",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                onChanged: (String? value) => setState(() => _brand = value!),
              ),
              const SizedBox(height: 12),

              // --- SIZE ---
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Size",
                  hintText: "e.g. 42, L, 500ml",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                onChanged: (String? value) => setState(() => _size = value!),
              ),
              const SizedBox(height: 12),

              // --- THUMBNAIL URL ---
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Image URL",
                  hintText: "http://example.com/image.jpg",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                onChanged: (String? value) => setState(() => _thumbnail = value!),
              ),
              const SizedBox(height: 12),

              // --- DESKRIPSI ---
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Description",
                  hintText: "Product description...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                maxLines: 3,
                onChanged: (String? value) => setState(() => _description = value!),
                validator: (String? value) {
                  if (value == null || value.isEmpty) return "Description cannot be empty!";
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // --- TOMBOL SAVE ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ballisticGold,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // URL Endpoint (Ganti 127.0.0.1 dengan 10.0.2.2 jika pakai Emulator)
                      // Karena ini POST request authentication, kita pakai package pbp_django_auth
                      final response = await request.post(
                        "http://127.0.0.1:8000/shop/add-product-ajax/", 
                        {
                          'name': _name,
                          'price': _price.toString(),
                          'description': _description,
                          'category': _category,
                          'brand': _brand,
                          'size': _size,
                          'thumbnail': _thumbnail,
                          'is_featured': 'false', 
                        }
                      );

                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Produk berhasil disimpan!")),
                          );
                          // Kembali ke halaman Shop dan refresh
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const ShopPage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Gagal: ${response['message']}")),
                          );
                        }
                      }
                    }
                  },
                  child: const Text(
                    "Save Product",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}