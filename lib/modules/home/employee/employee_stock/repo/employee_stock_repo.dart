import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeStockRepo {
  final SupabaseClient _client;

  EmployeeStockRepo({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<String?> fetchEmployeeBusinessId(String userId) async {
    final response = await _client
        .from('business_members')
        .select('business_id')
        .eq('user_id', userId)
        .eq('role', 'employee')
        .maybeSingle();

    if (response != null && response['business_id'] != null) {
      return response['business_id'] as String;
    }
    return null;
  }
}
