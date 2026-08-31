import 'package:supabase_flutter/supabase_flutter.dart';

class AddExpenseRepo {
  final SupabaseClient _supabase;

  AddExpenseRepo({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  Future<void> addExpense({
    required String businessId,
    required String description,
    required double amount,
    required String addedBy,
  }) async {
    await _supabase.from('expenses').insert({
      'business_id': businessId,
      'description': description,
      'amount': amount,
      'added_by': addedBy,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}
