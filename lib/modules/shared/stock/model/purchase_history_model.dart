class PurchaseHistoryModel {
  final String id;
  final String productId;
  final String productName;
  final String? productImageUrl;
  final String buyingUnit;
  final double quantityAdded; // quantity_remaining initially inserted represents the added amount, or let's use the field directly
  final double purchasePrice;
  final double sellingPrice;
  final DateTime purchaseDate;
  final String addedByName;
  final DateTime createdAt;

  PurchaseHistoryModel({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImageUrl,
    required this.buyingUnit,
    required this.quantityAdded,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.purchaseDate,
    required this.addedByName,
    required this.createdAt,
  });

  factory PurchaseHistoryModel.fromJson(Map<String, dynamic> json) {
    final product = json['products'] as Map<String, dynamic>? ?? {};
    final profile = json['profiles'] as Map<String, dynamic>? ?? {};

    final firstName = profile['first_name'] as String? ?? '';
    final lastName = profile['last_name'] as String? ?? '';
    final fullName = '$firstName $lastName'.trim();

    return PurchaseHistoryModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      productName: product['name'] as String? ?? 'Unknown Product',
      productImageUrl: product['image_url'] as String?,
      buyingUnit: product['buying_unit'] as String? ?? '',
      quantityAdded: double.tryParse(json['quantity_remaining'].toString()) ?? 0.0,
      purchasePrice: double.tryParse(json['purchase_price'].toString()) ?? 0.0,
      sellingPrice: double.tryParse(json['selling_price'].toString()) ?? 0.0,
      purchaseDate: DateTime.parse(json['purchase_date'] as String),
      addedByName: fullName.isNotEmpty ? fullName : 'Unknown',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
