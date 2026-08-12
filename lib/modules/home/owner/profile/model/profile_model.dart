class ProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String role;

  ProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );
  }
}
