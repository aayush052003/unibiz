class BusinessListModel {
  final String id;
  final String name;
  final String? managerName;
  final int employeeCount;

  BusinessListModel({
    required this.id,
    required this.name,
    this.managerName,
    required this.employeeCount,
  });

  factory BusinessListModel.fromJson(Map<String, dynamic> json) {
    String? mgrName;
    int empCount = 0;

    if (json['business_members'] != null) {
      final members = json['business_members'] as List;
      for (final m in members) {
        final role = m['role'] as String?;
        if (role == 'manager' && m['profiles'] != null) {
          final profile = m['profiles'];
          final fName = profile['first_name'] as String? ?? '';
          final lName = profile['last_name'] as String? ?? '';
          mgrName = '$fName $lName'.trim();
        } else if (role == 'employee') {
          empCount++;
        }
      }
    }

    return BusinessListModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      managerName: mgrName != null && mgrName.isNotEmpty ? mgrName : null,
      employeeCount: empCount,
    );
  }
}
