import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/profile_model.dart';

class OwnerSignUpRepo {
  final SupabaseClient _client;

  OwnerSignUpRepo({SupabaseClient? client}) : _client = client ?? Supabase.instance.client;

  Future<ProfileModel> signUpWithOwner({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final AuthResponse response = await _client.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Sign up failed: User is null');
    }

    final String userId = response.user!.id;

    final data = await _client.from('profiles').insert({
      'id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'role': 'owner',
    }).select().single();

    return ProfileModel.fromJson(data);
  }
}
