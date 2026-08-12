import 'package:supabase_flutter/supabase_flutter.dart';

class ManagerHomeRepo {
  final SupabaseClient _client;

  ManagerHomeRepo({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<String?> fetchManagerBusinessId(String userId) async {
    final response = await _client
        .from('business_members')
        .select('business_id')
        .eq('user_id', userId)
        .eq('role', 'manager')
        .maybeSingle();

    if (response != null && response['business_id'] != null) {
      return response['business_id'] as String;
    }
    return null;
  }
}
