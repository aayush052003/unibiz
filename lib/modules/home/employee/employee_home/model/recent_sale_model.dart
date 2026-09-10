class RecentSaleModel {
  final String id;
  final String productName;
  final String? productImageUrl;
  final double quantitySold;
  final String sellingUnit;
  final double totalAmount;
  final String soldByName;
  final DateTime createdAt;

  RecentSaleModel({
    required this.id,
    required this.productName,
    this.productImageUrl,
    required this.quantitySold,
    required this.sellingUnit,
    required this.totalAmount,
    required this.soldByName,
    required this.createdAt,
  });

  factory RecentSaleModel.fromJson(Map<String, dynamic> json) {
    final product = json['products'] as Map<String, dynamic>? ?? {};
    final profile = json['profiles'] as Map<String, dynamic>? ?? {};
    final firstName = profile['first_name'] as String? ?? '';
    final lastName = profile['last_name'] as String? ?? '';
    final fullName = '$firstName $lastName'.trim();

    return RecentSaleModel(
      id: json['id'] as String,
      productName: product['name'] as String? ?? 'Unknown Product',
      productImageUrl: product['image_url'] as String?,
      sellingUnit: product['selling_unit'] as String? ?? '',
      quantitySold: (json['quantity_sold'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      soldByName: fullName.isNotEmpty ? fullName : 'Unknown',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
