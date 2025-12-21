// (Imports sama seperti sebelumnya)
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:ballistic/shop/models/product.dart';
import 'package:ballistic/shop/screen/product_form.dart';
import 'package:ballistic/shop/screen/shop.dart';
import 'package:ballistic/utils/user_info.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ballistic/review/review.dart';


// ... (Class ProductDetailPage definition & initState sama) ...
class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // Warna sesuai tema Ballistic
  final Color ballisticGold = const Color(0xFFC9A25B);
  final Color ballisticBlack = const Color(0xFF1A1A1A);
  
  bool isOwner = false;
  String currentUsername = "";

  @override
  void initState() {
    super.initState();
    _checkOwnership();
  }

  Future<void> _checkOwnership() async {
    String username = await UserInfo.getUsername();
    if (mounted) {
      setState(() {
        currentUsername = username;
        isOwner = widget.product.owner == username;
      });
    }
  }

  String getBaseUrl() {
    return kIsWeb ? "http://localhost:8000" : "http://10.0.2.2:8000";
  }

  // ... (Fungsi _deleteProduct & _showOwnerMenu TETAP SAMA, tidak perlu diubah) ...
  Future<void> _deleteProduct(CookieRequest request) async {
      // (Kode delete sama seperti sebelumnya)
      final url = "${getBaseUrl()}/shop/api/delete/${widget.product.id}/";
      try {
        final response = await request.post(url, {});
        if (response['status'] == 'success') {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Produk berhasil dihapus"), backgroundColor: Colors.green));
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const ShopPage()), (route) => false);
          }
        } else {
           if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? "Gagal menghapus"), backgroundColor: Colors.red));
        }
      } catch (e) {
        if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
      }
  }

  void _showOwnerMenu(BuildContext context, CookieRequest request) {
    // (Kode menu owner sama seperti sebelumnya)
     showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Edit Produk'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (c) => ProductFormPage(product: widget.product)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Hapus Produk', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Konfirmasi Hapus"),
                    content: const Text("Yakin ingin menghapus produk ini?"),
                    actions: [
                      TextButton(onPressed: ()=>Navigator.pop(ctx), child: const Text("Batal")),
                      TextButton(onPressed: () { Navigator.pop(ctx); _deleteProduct(request); }, child: const Text("Hapus", style: TextStyle(color: Colors.red))),
                    ],
                  )
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- MODAL TRANSAKSI (UPDATED) ---
  void _showPurchaseModal(BuildContext context, CookieRequest request) {
    int quantity = 1;
    final TextEditingController voucherController = TextEditingController();
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          int total = widget.product.price * quantity;
          
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              left: 24, right: 24, top: 24
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 20),
                
                const Text("Konfirmasi Pesanan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                
                // Info Produk
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.product.thumbnail,
                        width: 60, height: 60, fit: BoxFit.cover,
                        errorBuilder: (c,e,s) => Container(width: 60, height: 60, color: Colors.grey[200]),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(formatter.format(widget.product.price), style: TextStyle(color: ballisticGold, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ],
                ),
                
                const Divider(height: 30),

                // Quantity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Jumlah", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 18),
                            onPressed: () => quantity > 1 ? setModalState(() => quantity--) : null,
                            color: quantity > 1 ? Colors.black : Colors.grey,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text("$quantity", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 18),
                            onPressed: () => setModalState(() => quantity++),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),

                // Voucher Input (LEBIH RAPI)
                TextField(
                  controller: voucherController,
                  decoration: InputDecoration(
                    labelText: "Kode Voucher (Opsional)",
                    prefixIcon: const Icon(Icons.confirmation_number_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    helperText: "Masukkan kode voucher aktif untuk dapat diskon",
                  ),
                ),

                const SizedBox(height: 24),

                // Total Price
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Estimasi Total", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(formatter.format(total), style: TextStyle(color: ballisticBlack, fontWeight: FontWeight.w900, fontSize: 18)),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ballisticBlack,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      Navigator.pop(ctx);
                      
                      showDialog(context: context, barrierDismissible: false, builder: (c) => const Center(child: CircularProgressIndicator()));

                      final res = await request.post("${getBaseUrl()}/shop/create-transaction/", {
                        'product_id': widget.product.id,
                        'quantity': quantity.toString(),
                        'voucher_code': voucherController.text,
                      });

                      if (context.mounted) Navigator.pop(context);

                      if (res['status'] == 'success') {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Transaksi Berhasil!"), backgroundColor: Colors.green));
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const ShopPage()));
                        }
                      } else {
                        // DISINI ERROR DARI BACKEND DITAMPILKAN
                        // Contoh: "Voucher tidak aktif" atau "Kode voucher salah"
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  const Icon(Icons.error_outline, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(res['message'] ?? "Gagal")),
                                ],
                              ),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            )
                          );
                        }
                      }
                    },
                    child: const Text("BAYAR SEKARANG", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ... (Widget Build & Helper tetap sama seperti kode sebelumnya) ...
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.8),
              child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
            ),
            actions: [
               if (isOwner) 
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  child: IconButton(icon: const Icon(Icons.more_horiz, color: Colors.black), onPressed: () => _showOwnerMenu(context, request)),
                ),
              const SizedBox(width: 16),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.product.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, error, stackTrace) => Container(color: Colors.grey[200], child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey)),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black26, Colors.transparent], stops: [0.0, 0.3]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: ballisticGold.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                        child: Text(widget.product.category.toUpperCase(), style: TextStyle(color: ballisticGold, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                      if (widget.product.brand != null && widget.product.brand!.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(20)),
                          child: Text(widget.product.brand!, style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500, fontSize: 12)),
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(widget.product.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 1.2)),
                  const SizedBox(height: 8),
                  Text(formatter.format(widget.product.price), style: TextStyle(fontSize: 22, color: ballisticBlack, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: _buildInfoItem(Icons.storefront_outlined, "Seller", widget.product.owner)),
                      Container(width: 1, height: 40, color: Colors.grey[300]),
                      Expanded(child: _buildInfoItem(Icons.straighten_outlined, "Size", widget.product.size)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(widget.product.description, style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.6)),

                  const SizedBox(height: 32),

                  // ========== REVIEW SECTION ==========
                  ReviewSection(
                    productId: widget.product.id,
                    currentUser: currentUsername,
                    
                    // Fetch reviews for this product
                    // Django URL: GET /review/product/<uuid:product_id>/
                    onFetchReviews: (productId) async {
                      try {
                        final response = await request.get(
                          '${getBaseUrl()}/review/product/$productId/'
                        );
                        
                        // Debug: print response to see what Django returns
                        debugPrint('Fetch reviews response: $response');
                        
                        List<ReviewModel> reviews = [];
                        
                        // Handle case where response is null or error
                        if (response == null) {
                          return reviews;
                        }
                        
                        // Handle case where response is a List directly
                        if (response is List) {
                          for (var r in response) {
                            if (r != null) {
                              reviews.add(ReviewModel.fromJson(r));
                            }
                          }
                        } 
                        // Handle case where response is a Map with 'reviews' key
                        else if (response is Map) {
                          if (response['reviews'] != null) {
                            for (var r in response['reviews']) {
                              if (r != null) {
                                reviews.add(ReviewModel.fromJson(r));
                              }
                            }
                          }
                          // If success is true but no reviews, just return empty list
                        }
                        return reviews;
                      } catch (e) {
                        debugPrint('Error fetching reviews: $e');
                        // Return empty list on error (including 404)
                        return <ReviewModel>[];
                      }
                    },
                    
                    // Add review for this product
                    // Django URL: POST /review/add-review/<uuid:product_id>/
                    onAddReview: (productId, description, star) async {
                      try {
                        final response = await request.post(
                          '${getBaseUrl()}/review/add-review/$productId/',
                          {
                            'comment': description,  // Django uses 'comment'
                            'star': star.toString(),
                          },
                        );
                        debugPrint('Add review response: $response');
                        return response['success'] == true;
                      } catch (e) {
                        debugPrint('Error adding review: $e');
                        return false;
                      }
                    },
                    
                    // Edit review
                    // Django URL: POST /review/<uuid:id>/edit/
                    onEditReview: (reviewId, description, star) async {
                      try {
                        final response = await request.post(
                          '${getBaseUrl()}/review/$reviewId/edit/',
                          {
                            'comment': description,  // Django uses 'comment'
                            'star': star.toString(),
                          },
                        );
                        debugPrint('Edit review response: $response');
                        return response['success'] == true;
                      } catch (e) {
                        debugPrint('Error editing review: $e');
                        return false;
                      }
                    },
                    
                    // Delete review
                    // Django URL: POST /review/<uuid:id>/delete/
                    onDeleteReview: (reviewId) async {
                      try {
                        final response = await request.post(
                          '${getBaseUrl()}/review/$reviewId/delete/',
                          {},
                        );
                        debugPrint('Delete review response: $response');
                        return response['success'] == true;
                      } catch (e) {
                        debugPrint('Error deleting review: $e');
                        return false;
                      }
                    },
                  ),
                  // ========== END REVIEW SECTION ==========
                  const SizedBox(height: 100), 
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: !isOwner 
        ? Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: () => _showPurchaseModal(context, request),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ballisticBlack,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.shopping_bag_outlined),
                    SizedBox(width: 10),
                    Text("BELI SEKARANG", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          )
        : null,
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(children: [
        Icon(icon, color: Colors.grey, size: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ]);
  }
}