import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ballistic/shop/screen/shop.dart';
import 'package:ballistic/shop/models/product.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product; // Jika null = Add, jika ada = Edit

  const ProductFormPage({super.key, this.product});

  @override
  // PERBAIKAN: Nama di sini harus sama dengan nama kelas State di bawah
  State<ProductFormPage> createState() => _ProductFormPageState(); 
}

// PERBAIKAN: Mengganti _ProductFlowPageState menjadi _ProductFormPageState
class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Inisialisasi variabel form
  late String _name;
  late int _price;
  late String _description;
  late String _category; 
  late String _size;
  late String _brand;
  late String _thumbnail;

  final Color ballisticGold = const Color(0xFFC9A25B);
  List<String> categories = ['Shoes', 'Shirt', 'Water Bottle', 'Helmet'];

  @override
  void initState() {
    super.initState();
    // Jika widget.product tidak null, isi form dengan data produk tersebut (MODE EDIT)
    _name = widget.product?.name ?? "";
    _price = widget.product?.price ?? 0;
    _description = widget.product?.description ?? "";
    _category = widget.product?.category ?? "Shoes";
    _size = widget.product?.size ?? "";
    _brand = widget.product?.brand ?? "";
    _thumbnail = widget.product?.thumbnail ?? "";
  }

  String getBaseUrl() {
    return kIsWeb ? "http://localhost:8000" : "http://10.0.2.2:8000";
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    bool isEdit = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Product' : 'Add New Product'),
        backgroundColor: ballisticGold,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: "Product Name", border: OutlineInputBorder()),
                onChanged: (v) => _name = v,
                validator: (v) => (v == null || v.isEmpty) ? "Field required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _price == 0 ? "" : _price.toString(),
                decoration: const InputDecoration(labelText: "Price", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                onChanged: (v) => _price = int.tryParse(v) ?? 0,
                validator: (v) => (v == null || v.isEmpty) ? "Field required" : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: categories.contains(_category) ? _category : categories[0],
                decoration: const InputDecoration(labelText: "Category", border: OutlineInputBorder()),
                items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _brand,
                decoration: const InputDecoration(labelText: "Brand", border: OutlineInputBorder()),
                onChanged: (v) => _brand = v,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _size,
                decoration: const InputDecoration(labelText: "Size", border: OutlineInputBorder()),
                onChanged: (v) => _size = v,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _thumbnail,
                decoration: const InputDecoration(labelText: "Image URL", border: OutlineInputBorder()),
                onChanged: (v) => _thumbnail = v,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _description,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder()),
                onChanged: (v) => _description = v,
                validator: (v) => (v == null || v.isEmpty) ? "Field required" : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: ballisticGold, padding: const EdgeInsets.symmetric(vertical: 16)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Tentukan URL: Jika edit gunakan ID produk, jika add gunakan endpoint create
                      final String url = isEdit 
                        ? "${getBaseUrl()}/shop/api/edit/${widget.product!.id}/" 
                        : "${getBaseUrl()}/shop/api/create/";
                      
                      final response = await request.postJson(
                        url, 
                        jsonEncode(<String, dynamic>{
                          'name': _name,
                          'price': _price,
                          'description': _description,
                          'category': _category,
                          'brand': _brand,
                          'size': _size,
                          'thumbnail': _thumbnail,
                        }),
                      );

                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isEdit ? "Update sukses!" : "Simpan sukses!")));
                          Navigator.pushAndRemoveUntil(
                            context, 
                            MaterialPageRoute(builder: (context) => const ShopPage()),
                            (route) => false
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: ${response['message']}")));
                        }
                      }
                    }
                  },
                  child: Text(isEdit ? "Update Product" : "Save Product", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}