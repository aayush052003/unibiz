class StockProductModel {
  final String id;
  final String businessId;
  final String name;
  final String buyingUnit;
  final String sellingUnit;
  final num unitsPerPack;
  final String? imageUrl;
  final int minStockThreshold;
  final double quantityRemainingInBuyingUnits;

  StockProductModel({
    required this.id,
    required this.businessId,
    required this.name,
    required this.buyingUnit,
    required this.sellingUnit,
    required this.unitsPerPack,
    this.imageUrl,
    required this.minStockThreshold,
    required this.quantityRemainingInBuyingUnits,
  });

  double get quantityRemainingInSellingUnits =>
      quantityRemainingInBuyingUnits * unitsPerPack;

  factory StockProductModel.fromJson(Map<String, dynamic> json) {
    final quantityRemaining = json['quantity_remaining'];
    double qty = 0.0;
    if (quantityRemaining != null) {
      qty = double.tryParse(quantityRemaining.toString()) ?? 0.0;
    }

    return StockProductModel(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      name: json['name'] as String,
      buyingUnit: json['buying_unit'] as String,
      sellingUnit: json['selling_unit'] as String,
      unitsPerPack: json['units_per_pack'] as num,
      imageUrl: json['image_url'] as String?,
      minStockThreshold: json['min_stock_threshold'] as int? ?? 0,
      quantityRemainingInBuyingUnits: qty,
    );
  }
}
