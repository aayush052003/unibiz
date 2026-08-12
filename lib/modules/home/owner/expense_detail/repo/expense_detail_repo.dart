import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/expense_model.dart';

class ExpenseDetailRepo {
  final SupabaseClient _supabase;

  ExpenseDetailRepo({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  Future<List<ExpenseModel>> fetchExpenses(String businessId) async {
    final response = await _supabase
        .from('expenses')
        .select('*, profiles(first_name, last_name, role)')
        .eq('business_id', businessId)
        .order('created_at', ascending: false);

    final data = response as List<dynamic>;
    return data
        .map((json) => ExpenseModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
