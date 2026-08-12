class ProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String role;
  final String? uniqueId;
  final String? pin;
  final String createdAt;

  ProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.uniqueId,
    this.pin,
    required this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      uniqueId: json['unique_id'] as String?,
      pin: json['pin'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'unique_id': uniqueId,
      'pin': pin,
      'created_at': createdAt,
    };
  }
}
