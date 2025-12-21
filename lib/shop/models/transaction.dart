class Transaction {
  final String id;
  final String productId;
  final String productName;
  final String productThumbnail;
  final int quantity;
  final int originalProductPrice;
  final int appliedDiscountPercentage;
  final int finalPrice;
  final DateTime purchaseTimestamp;
  final String? usedVoucherCode;

  Transaction({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productThumbnail,
    required this.quantity,
    required this.originalProductPrice,
    required this.appliedDiscountPercentage,
    required this.finalPrice,
    required this.purchaseTimestamp,
    this.usedVoucherCode,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'].toString(),
      productId: json['product_id'].toString(),
      productName: json['product_name'] ?? "",
      productThumbnail: json['product_thumbnail'] ?? "",
      quantity: json['quantity'] ?? 1,
      originalProductPrice: json['original_product_price'] ?? 0,
      appliedDiscountPercentage: json['applied_discount_percentage'] ?? 0,
      finalPrice: json['final_price'] ?? 0,
      purchaseTimestamp: DateTime.parse(json['purchase_timestamp']),
      usedVoucherCode: json['used_voucher_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'voucher_code': usedVoucherCode,
    };
  }
}