class SalesHistoryModel {
  final String id;
  final String productId;
  final String productName;
  final String? productImageUrl;
  final String sellingUnit;
  final double quantitySold;
  final double sellingPrice;
  final double totalAmount;
  final double profit;
  final String soldByName;
  final DateTime createdAt;

  SalesHistoryModel({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImageUrl,
    required this.sellingUnit,
    required this.quantitySold,
    required this.sellingPrice,
    required this.totalAmount,
    required this.profit,
    required this.soldByName,
    required this.createdAt,
  });

  factory SalesHistoryModel.fromJson(Map<String, dynamic> json) {
    final product = json['products'] as Map<String, dynamic>? ?? {};
    final profile = json['profiles'] as Map<String, dynamic>? ?? {};

    final firstName = profile['first_name'] as String? ?? '';
    final lastName = profile['last_name'] as String? ?? '';
    final fullName = '$firstName $lastName'.trim();

    return SalesHistoryModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      productName: product['name'] as String? ?? 'Unknown Product',
      productImageUrl: product['image_url'] as String?,
      sellingUnit: product['selling_unit'] as String? ?? '',
      quantitySold: double.tryParse(json['quantity_sold'].toString()) ?? 0.0,
      sellingPrice: double.tryParse(json['selling_price'].toString()) ?? 0.0,
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      profit: double.tryParse(json['profit'].toString()) ?? 0.0,
      soldByName: fullName.isNotEmpty ? fullName : 'Unknown',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
