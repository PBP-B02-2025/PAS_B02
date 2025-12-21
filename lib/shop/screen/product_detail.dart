import 'package:flutter/foundation.dart' show kIsWeb; // Tambahkan untuk cek environment
import 'package:flutter/material.dart';
import 'package:ballistic/shop/models/product.dart';
import 'package:ballistic/shop/screen/product_form.dart';
import 'package:ballistic/shop/screen/shop.dart';
import 'package:ballistic/utils/user_info.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final Color ballisticGold = const Color(0xFFC9A25B);
  final Color ballisticBlack = const Color(0xFF1A1A1A);
  
  String currentUsername = "";
  bool isOwner = false;

  @override
  void initState() {
    super.initState();
    _checkOwnership();
  }

  Future<void> _checkOwnership() async {
    String username = await UserInfo.getUsername();
    setState(() {
      currentUsername = username;
      isOwner = widget.product.owner == username;
    });
  }

  // --- FUNGSI DELETE PRODUCT ---
  Future<void> _deleteProduct(CookieRequest request) async {
    final String baseUrl = kIsWeb ? "http://localhost:8000" : "http://10.0.2.2:8000";
    final url = "$baseUrl/shop/api/delete/${widget.product.id}/";
    
    try {
      final response = await request.post(url, {}); 
      
      if (mounted) {
        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Produk berhasil dihapus"), backgroundColor: Colors.green)
          );
          // Kembali ke halaman shop dan hapus history navigasi agar tidak bisa back ke produk yang dihapus
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ShopPage()),
              (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal menghapus: ${response['message']}"), backgroundColor: Colors.red)
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red)
        );
      }
    }
  }

  // Dialog konfirmasi hapus
  void _showDeleteConfirmation(CookieRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Produk"),
        content: const Text("Apakah Anda yakin ingin menghapus produk ini? Tindakan ini tidak dapat dibatalkan."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProduct(request);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showPurchaseModal(BuildContext context, CookieRequest request) {
    int quantity = 1;
    final TextEditingController voucherController = TextEditingController();
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20, right: 20, top: 20
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Ringkasan Pesanan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: Image.network(widget.product.thumbnail, width: 50, errorBuilder: (c, e, s) => const Icon(Icons.image)),
                    title: Text(widget.product.name),
                    subtitle: Text(currencyFormatter.format(widget.product.price)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Jumlah"),
                      Row(
                        children: [
                          IconButton(onPressed: () => quantity > 1 ? setModalState(() => quantity--) : null, icon: const Icon(Icons.remove_circle_outline)),
                          Text("$quantity"),
                          IconButton(onPressed: () => setModalState(() => quantity++), icon: const Icon(Icons.add_circle_outline)),
                        ],
                      ),
                    ],
                  ),
                  TextField(
                    controller: voucherController,
                    decoration: const InputDecoration(labelText: "Kode Voucher", prefixIcon: Icon(Icons.discount)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: ballisticBlack, minimumSize: const Size(double.infinity, 50)),
                    onPressed: () async {
                      final String baseUrl = kIsWeb ? "http://localhost:8000" : "http://10.0.2.2:8000";
                      Navigator.pop(context);
                      final response = await request.post("$baseUrl/shop/create-transaction/", {
                        'product_id': widget.product.id,
                        'quantity': quantity.toString(),
                        'voucher_code': voucherController.text,
                      });
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Transaksi Berhasil!"), backgroundColor: Colors.green));
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const ShopPage()));
                      }
                    },
                    child: const Text("Beli Sekarang", style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final priceString = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(widget.product.price);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Produk"),
        backgroundColor: Colors.white,
        foregroundColor: ballisticBlack,
        elevation: 0,
        actions: [
          // Tampilkan tombol edit dan hapus hanya jika user adalah pemilik
          if (isOwner) ...[
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue), 
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProductFormPage(product: widget.product)));
              }
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red), 
              onPressed: () => _showDeleteConfirmation(request)
            ),
          ]
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.product.thumbnail,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(height: 300, color: Colors.grey[200], child: const Icon(Icons.broken_image, size: 50)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.product.category.toUpperCase(), style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      Text("By: ${widget.product.owner}", style: const TextStyle(color: Colors.blueGrey)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(widget.product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(priceString, style: TextStyle(fontSize: 22, color: ballisticGold, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text("Ukuran", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.product.size),
                  const SizedBox(height: 20),
                  const Text("Deskripsi", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.product.description, style: const TextStyle(height: 1.5)),
                  const SizedBox(height: 40),
                  // Jangan tampilkan tombol beli jika pemilik melihat produknya sendiri
                  if (!isOwner) 
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: ballisticBlack, padding: const EdgeInsets.symmetric(vertical: 15)),
                        onPressed: () => _showPurchaseModal(context, request),
                        child: const Text("Tambah ke Keranjang", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}