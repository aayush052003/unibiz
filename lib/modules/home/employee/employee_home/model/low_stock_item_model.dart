class LowStockItemModel {
  final String id;
  final String name;
  final String? imageUrl;
  final double quantityRemainingInSellingUnits;
  final String sellingUnit;
  final int minStockThreshold;

  LowStockItemModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.quantityRemainingInSellingUnits,
    required this.sellingUnit,
    required this.minStockThreshold,
  });

  factory LowStockItemModel.fromJson(Map<String, dynamic> json) {
    final batches = json['batches'] as List<dynamic>? ?? [];
    double totalQtyBuying = 0.0;
    for (final b in batches) {
      if (b['quantity_remaining'] != null) {
        totalQtyBuying += double.tryParse(b['quantity_remaining'].toString()) ?? 0.0;
      }
    }
    final num unitsPerPack = (json['units_per_pack'] as num?) ?? 1;
    final double qtySelling = totalQtyBuying * unitsPerPack;

    return LowStockItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
      quantityRemainingInSellingUnits: qtySelling,
      sellingUnit: json['selling_unit'] as String? ?? '',
      minStockThreshold: (json['min_stock_threshold'] as num?)?.toInt() ?? 0,
    );
  }
}
