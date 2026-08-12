class StaffMemberModel {
  final String id;
  final String firstName;
  final String lastName;
  final String role;
  final String uniqueId;

  StaffMemberModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.uniqueId,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory StaffMemberModel.fromJson(Map<String, dynamic> json) {
    return StaffMemberModel(
      id: json['id'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      uniqueId: json['unique_id'] as String? ?? '',
    );
  }
}
