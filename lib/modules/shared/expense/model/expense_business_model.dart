class ExpenseBusinessModel {
  final String id;
  final String name;

  ExpenseBusinessModel({
    required this.id,
    required this.name,
  });

  factory ExpenseBusinessModel.fromJson(Map<String, dynamic> json) {
    return ExpenseBusinessModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}
