import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/employee_model.dart';

class EmployeeRepo {
  final SupabaseClient _supabase;

  EmployeeRepo({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  Future<List<EmployeeModel>> fetchEmployees(String ownerId) async {
    final response = await _supabase
        .from('profiles')
        .select('*, business_members(businesses(name))')
        .eq('created_by', ownerId);

    final list = response as List;
    return list.map((json) => EmployeeModel.fromJson(json)).toList();
  }
}
