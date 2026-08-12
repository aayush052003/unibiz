import 'package:supabase_flutter/supabase_flutter.dart';

class OwnerForgotPasswordRepo {
  final SupabaseClient _client;

  OwnerForgotPasswordRepo({SupabaseClient? client}) : _client = client ?? Supabase.instance.client;

  Future<void> resetPassword({required String email}) async {
    // We trigger the reset password. Even if this fails, we will handle the result
    // gracefully in our UI / BLoC to prevent revealing if the email exists.
    await _client.auth.resetPasswordForEmail(email);
  }
}
