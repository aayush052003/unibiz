class ProductsModel {
  final String id;
  final String businessId;
  final String name;
  final String buyingUnit;
  final String sellingUnit;
  final num unitsPerPack;
  final String imageUrl;
  final DateTime createdAt;

  ProductsModel({
    required this.id,
    required this.businessId,
    required this.name,
    required this.buyingUnit,
    required this.sellingUnit,
    required this.unitsPerPack,
    required this.imageUrl,
    required this.createdAt,
  });

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      name: json['name'] as String,
      buyingUnit: json['buying_unit'] as String,
      sellingUnit: json['selling_unit'] as String,
      unitsPerPack: json['units_per_pack'] as num,
      imageUrl: json['image_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
