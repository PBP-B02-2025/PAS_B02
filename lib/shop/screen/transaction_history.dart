import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; 
import 'package:ballistic/shop/models/transaction.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final Color ballisticGold = const Color(0xFFC9A25B);
  final Color ballisticBlack = const Color(0xFF1A1A1A);

  Future<List<Transaction>> fetchHistory(CookieRequest request) async {
    await initializeDateFormatting('id_ID', null);

    final String baseUrl = kIsWeb ? "https://jovian-felix-ballistic.pbp.cs.ui.ac.id" : "http://10.0.2.2:8000";
    final response = await request.get("$baseUrl/shop/api/history/");

    List<Transaction> listHistory = [];
    for (var d in response) {
      if (d != null) {
        listHistory.add(Transaction.fromJson(d));
      }
    }
    return listHistory;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text(
          "Riwayat Pesanan",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFFC9A25B),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder(
        future: fetchHistory(request),
        builder: (context, AsyncSnapshot<List<Transaction>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: ballisticGold));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          } else if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          } else {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              itemCount: snapshot.data!.length,
              separatorBuilder: (ctx, index) => const SizedBox(height: 24),
              itemBuilder: (_, index) => _buildCreativeCard(snapshot.data![index]),
            );
          }
        },
      ),
    );
  }

  Widget _buildCreativeCard(Transaction transaction) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    
    final localDate = transaction.purchaseTimestamp.toLocal();
    final dateString = DateFormat('EEEE, d MMM yyyy', 'id_ID').format(localDate);
    final timeString = DateFormat('HH:mm').format(localDate);

    bool hasVoucher = transaction.appliedDiscountPercentage > 0;
    
    // Hitung Total Awal (Sebelum Diskon) untuk ditampilkan
    int totalOriginal = transaction.originalProductPrice * transaction.quantity;

    return Column(
      children: [
        // --- BODY CARD ---
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(20),
              bottom: hasVoucher ? Radius.zero : const Radius.circular(20)
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header: Tanggal & Status
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateString,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
                        ),
                        Text(
                          "$timeString WIB",
                          style: TextStyle(fontSize: 11, color: Colors.grey[400], fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, size: 14, color: Colors.green),
                          const SizedBox(width: 4),
                          Text(
                            "BERHASIL",
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green[700]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const Divider(height: 1, thickness: 0.5),

              // Detail Produk
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 80, height: 80,
                          color: Colors.grey[100],
                          child: Image.network(
                            transaction.productThumbnail,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Icon(Icons.shopping_bag_outlined, color: Colors.grey[300], size: 30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Info Teks
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 1.2),
                          ),
                          const SizedBox(height: 8),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Harga Satuan
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Harga Satuan", style: TextStyle(fontSize: 10, color: Colors.grey)),
                                  Text(
                                    "@ ${formatter.format(transaction.originalProductPrice)}",
                                    style: TextStyle(color: ballisticBlack, fontSize: 13, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              
                              // Badge Quantity
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: ballisticBlack,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "x${transaction.quantity}",
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // --- VOUCHER & TOTAL SECTION ---
        if (hasVoucher)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E6), // Background kupon
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              border: Border.all(color: ballisticGold.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                // Bagian Kiri: Info Voucher
                Icon(Icons.discount, size: 20, color: ballisticGold),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "VOUCHER APPLIED",
                        style: TextStyle(fontSize: 10, color: ballisticGold, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                      Text(
                        "${transaction.usedVoucherCode} (-${transaction.appliedDiscountPercentage}%)",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown[700], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                
                // Bagian Kanan: Perhitungan Total
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Tampilkan Total Awal (Dicoret)
                    Text(
                      formatter.format(totalOriginal),
                      style: TextStyle(
                        fontSize: 12, 
                        color: Colors.red.withOpacity(0.6), 
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.red.withOpacity(0.6)
                      ),
                    ),
                    // Tampilkan Total Akhir (Bold)
                    Text(
                      formatter.format(transaction.finalPrice),
                      style: TextStyle(color: ballisticBlack, fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          )
        else 
        // --- TOTAL BIASA (JIKA TANPA VOUCHER) ---
          Container(
             decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 5))],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Belanja", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87)),
                Text(
                  formatter.format(transaction.finalPrice),
                  style: TextStyle(color: ballisticBlack, fontWeight: FontWeight.w900, fontSize: 18),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(
            "Belum Ada Transaksi",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
          ),
          const SizedBox(height: 8),
          Text(
            "Yuk, mulai belanja koleksi favoritmu!",
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}