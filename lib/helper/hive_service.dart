import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String _sessionBoxName = 'session_box';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyFirstName = 'first_name';
  static const String _keyLastName = 'last_name';
  static const String _keyRole = 'role';
  static const String _keyUniqueId = 'unique_id';

  static Box? _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_sessionBoxName);
  }

  static bool isLoggedIn() {
    return _box?.get(_keyIsLoggedIn, defaultValue: false) ?? false;
  }

  static Future<void> saveSession({
    required String userId,
    required String firstName,
    required String lastName,
    required String role,
    String? uniqueId,
  }) async {
    await _box?.putAll({
      _keyIsLoggedIn: true,
      _keyUserId: userId,
      _keyFirstName: firstName,
      _keyLastName: lastName,
      _keyRole: role,
      _keyUniqueId: uniqueId,
    });
  }

  static Future<void> clearSession() async {
    await _box?.clear();
  }

  static String? getUserId() => _box?.get(_keyUserId);
  static String? getFirstName() => _box?.get(_keyFirstName);
  static String? getLastName() => _box?.get(_keyLastName);
  static String? getRole() => _box?.get(_keyRole);
  static String? getUniqueId() => _box?.get(_keyUniqueId);
}
