import 'dart:math';
import 'package:bcrypt/bcrypt.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AddEmployeeRepo {
  final SupabaseClient _supabase;

  AddEmployeeRepo({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  String _generateRandom4Digits() {
    final random = Random();
    final number = random.nextInt(10000);
    return number.toString().padLeft(4, '0');
  }

  Future<String> generateUniqueId(String role) async {
    final prefix = role.toLowerCase() == 'manager' ? 'MAN' : 'EMP';
    while (true) {
      final candidate = '$prefix${_generateRandom4Digits()}';
      final response = await _supabase
          .from('profiles')
          .select('id')
          .eq('unique_id', candidate)
          .maybeSingle();

      if (response == null) {
        return candidate;
      }
    }
  }

  Future<void> addEmployee({
    required String firstName,
    required String lastName,
    required String email,
    required String role,
    required String pin,
    required String ownerId,
  }) async {
    // 1. Generate unique ID
    final uniqueId = await generateUniqueId(role);

    // 2. Create user in Supabase Auth using email & random UUID password
    final randomPassword = const Uuid().v4();
    final AuthResponse authResponse = await _supabase.auth.signUp(
      email: email,
      password: randomPassword,
    );

    final authUserId = authResponse.user?.id;
    if (authUserId == null) {
      throw Exception('Failed to create user account');
    }

    // 3. Hash PIN using bcrypt
    final hashedPin = BCrypt.hashpw(pin, BCrypt.gensalt());

    // 4. Insert into profiles table
    await _supabase.from('profiles').insert({
      'id': authUserId,
      'first_name': firstName,
      'last_name': lastName,
      'role': role.toLowerCase(),
      'unique_id': uniqueId,
      'pin': hashedPin,
      'created_by': ownerId,
    });
  }
}
