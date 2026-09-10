class EmployeeOutOfStockProductModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String sellingUnit;

  EmployeeOutOfStockProductModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.sellingUnit,
  });

  factory EmployeeOutOfStockProductModel.fromJson(Map<String, dynamic> json) {
    return EmployeeOutOfStockProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
      sellingUnit: json['selling_unit'] as String? ?? '',
    );
  }
}
