import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bcrypt/bcrypt.dart';
import '../model/profile_model.dart';

class StaffSignInRepo {
  final SupabaseClient _client;

  StaffSignInRepo({SupabaseClient? client}) : _client = client ?? Supabase.instance.client;

  Future<ProfileModel> signInWithStaff({
    required String uniqueId,
    required String pin,
  }) async {
    final data = await _client
        .from('profiles')
        .select()
        .eq('unique_id', uniqueId)
        .maybeSingle();

    if (data == null) {
      throw Exception('Invalid Unique ID or PIN');
    }

    final String? hash = data['pin'] as String?;
    if (hash == null || !BCrypt.checkpw(pin, hash)) {
      throw Exception('Invalid Unique ID or PIN');
    }

    return ProfileModel.fromJson(data);
  }
}
