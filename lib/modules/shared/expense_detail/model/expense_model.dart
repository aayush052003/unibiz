class ExpenseModel {
  final String id;
  final String businessId;
  final String description;
  final double amount;
  final String addedBy;
  final String addedByName;
  final String addedByRole;
  final DateTime createdAt;

  ExpenseModel({
    required this.id,
    required this.businessId,
    required this.description,
    required this.amount,
    required this.addedBy,
    required this.addedByName,
    required this.addedByRole,
    required this.createdAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    String name = 'Unknown';
    String role = 'employee';

    if (json['profiles'] != null && json['profiles'] is Map) {
      final profile = json['profiles'] as Map<String, dynamic>;
      final fName = profile['first_name'] as String? ?? '';
      final lName = profile['last_name'] as String? ?? '';
      final fullName = '$fName $lName'.trim();
      if (fullName.isNotEmpty) {
        name = fullName;
      }
      if (profile['role'] != null) {
        role = profile['role'] as String;
      }
    }

    final amtRaw = json['amount'];
    final double parsedAmount = amtRaw is num ? amtRaw.toDouble() : double.tryParse(amtRaw.toString()) ?? 0.0;

    return ExpenseModel(
      id: json['id'] as String? ?? '',
      businessId: json['business_id'] as String? ?? '',
      description: json['description'] as String? ?? '',
      amount: parsedAmount,
      addedBy: json['added_by'] as String? ?? '',
      addedByName: name,
      addedByRole: role,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
