import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/profile_model.dart';

class OwnerSignInRepo {
  final SupabaseClient _client;

  OwnerSignInRepo({SupabaseClient? client}) : _client = client ?? Supabase.instance.client;

  Future<ProfileModel> signInWithOwner({
    required String email,
    required String password,
  }) async {
    final AuthResponse response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Sign in failed: User is null');
    }

    final data = await _client
        .from('profiles')
        .select()
        .eq('id', response.user!.id)
        .single();

    return ProfileModel.fromJson(data);
  }
}
