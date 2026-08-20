class SalesBatchModel {
  final String id;
  final double quantityRemaining; // in buying units
  final double purchasePrice; // per buying unit
  final double sellingPrice; // per buying unit
  final DateTime purchaseDate;
  final DateTime createdAt;

  SalesBatchModel({
    required this.id,
    required this.quantityRemaining,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.purchaseDate,
    required this.createdAt,
  });

  factory SalesBatchModel.fromJson(Map<String, dynamic> json) {
    return SalesBatchModel(
      id: json['id'] as String,
      quantityRemaining: double.tryParse(json['quantity_remaining'].toString()) ?? 0.0,
      purchasePrice: double.tryParse(json['purchase_price'].toString()) ?? 0.0,
      sellingPrice: double.tryParse(json['selling_price'].toString()) ?? 0.0,
      purchaseDate: DateTime.parse(json['purchase_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class SalesProductModel {
  final String id;
  final String businessId;
  final String name;
  final String buyingUnit;
  final String sellingUnit;
  final num unitsPerPack;
  final String? imageUrl;
  final int minStockThreshold;
  final List<SalesBatchModel> batches;

  SalesProductModel({
    required this.id,
    required this.businessId,
    required this.name,
    required this.buyingUnit,
    required this.sellingUnit,
    required this.unitsPerPack,
    this.imageUrl,
    required this.minStockThreshold,
    required this.batches,
  });

  double get totalStockInBuyingUnits {
    double total = 0.0;
    for (final b in batches) {
      total += b.quantityRemaining;
    }
    return total;
  }

  double get totalStockInSellingUnits => totalStockInBuyingUnits * unitsPerPack;

  factory SalesProductModel.fromJson(Map<String, dynamic> json) {
    final batchesList = json['batches'] as List<dynamic>? ?? [];
    final parsedBatches = batchesList
        .map((b) => SalesBatchModel.fromJson(b as Map<String, dynamic>))
        .where((b) => b.quantityRemaining > 0)
        .toList();

    // Sort batches by purchase_date ASC, created_at ASC (oldest first)
    parsedBatches.sort((a, b) {
      final dateCompare = a.purchaseDate.compareTo(b.purchaseDate);
      if (dateCompare != 0) return dateCompare;
      return a.createdAt.compareTo(b.createdAt);
    });

    return SalesProductModel(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      name: json['name'] as String,
      buyingUnit: json['buying_unit'] as String,
      sellingUnit: json['selling_unit'] as String,
      unitsPerPack: json['units_per_pack'] as num,
      imageUrl: json['image_url'] as String?,
      minStockThreshold: json['min_stock_threshold'] as int? ?? 0,
      batches: parsedBatches,
    );
  }
}
