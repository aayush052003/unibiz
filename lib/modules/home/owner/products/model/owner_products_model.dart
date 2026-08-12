class OwnerProductsModel {
  final String id;
  final String name;
  final String? managerName;

  OwnerProductsModel({
    required this.id,
    required this.name,
    this.managerName,
  });

  factory OwnerProductsModel.fromJson({
    required Map<String, dynamic> businessJson,
    String? managerName,
  }) {
    return OwnerProductsModel(
      id: businessJson['id'] as String,
      name: businessJson['name'] as String,
      managerName: managerName,
    );
  }
}
