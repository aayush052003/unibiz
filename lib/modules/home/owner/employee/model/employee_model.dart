class EmployeeModel {
  final String id;
  final String firstName;
  final String lastName;
  final String role;
  final String uniqueId;
  final String? businessName;

  EmployeeModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.uniqueId,
    this.businessName,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    String? bName;
    if (json['business_members'] != null &&
        (json['business_members'] as List).isNotEmpty) {
      final bMember = (json['business_members'] as List).first;
      if (bMember['businesses'] != null) {
        bName = bMember['businesses']['name'] as String?;
      }
    }

    return EmployeeModel(
      id: json['id'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      uniqueId: json['unique_id'] as String? ?? '',
      businessName: bName,
    );
  }
}
