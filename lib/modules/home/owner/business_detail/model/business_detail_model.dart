class MemberProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String role;
  final String? uniqueId;

  MemberProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.uniqueId,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory MemberProfileModel.fromJson(Map<String, dynamic> json) {
    return MemberProfileModel(
      id: json['id'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      uniqueId: json['unique_id'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberProfileModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
