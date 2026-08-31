import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/expense_business_model.dart';

class ExpenseRepo {
  final SupabaseClient _supabase;

  ExpenseRepo({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  Future<List<ExpenseBusinessModel>> fetchBusinesses(String ownerId) async {
    final response = await _supabase
        .from('businesses')
        .select('id, name')
        .eq('owner_id', ownerId)
        .order('created_at', ascending: false);

    final data = response as List<dynamic>;
    return data
        .map((json) => ExpenseBusinessModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
