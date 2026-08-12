import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/staff_member_model.dart';

class AddBusinessRepo {
  final SupabaseClient _supabase;

  AddBusinessRepo({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  Future<List<StaffMemberModel>> fetchUnassignedManagers(String ownerId) async {
    // Query business_members to get assigned user_ids
    final assignedMembersResponse = await _supabase
        .from('business_members')
        .select('user_id');

    final assignedIds = (assignedMembersResponse as List)
        .map((item) => item['user_id'] as String)
        .toList();

    var query = _supabase
        .from('profiles')
        .select('*')
        .eq('role', 'manager')
        .eq('created_by', ownerId);

    if (assignedIds.isNotEmpty) {
      final response = await query.not('id', 'in', assignedIds);
      final list = response as List;
      return list.map((json) => StaffMemberModel.fromJson(json)).toList();
    } else {
      final response = await query;
      final list = response as List;
      return list.map((json) => StaffMemberModel.fromJson(json)).toList();
    }
  }

  Future<List<StaffMemberModel>> fetchUnassignedEmployees(String ownerId) async {
    final assignedMembersResponse = await _supabase
        .from('business_members')
        .select('user_id');

    final assignedIds = (assignedMembersResponse as List)
        .map((item) => item['user_id'] as String)
        .toList();

    var query = _supabase
        .from('profiles')
        .select('*')
        .eq('role', 'employee')
        .eq('created_by', ownerId);

    if (assignedIds.isNotEmpty) {
      final response = await query.not('id', 'in', assignedIds);
      final list = response as List;
      return list.map((json) => StaffMemberModel.fromJson(json)).toList();
    } else {
      final response = await query;
      final list = response as List;
      return list.map((json) => StaffMemberModel.fromJson(json)).toList();
    }
  }

  Future<void> createBusiness({
    required String name,
    required String ownerId,
    String? selectedManagerId,
    List<String> selectedEmployeeIds = const [],
  }) async {
    // 1. Insert business
    final businessResponse = await _supabase
        .from('businesses')
        .insert({
          'owner_id': ownerId,
          'name': name,
        })
        .select('id')
        .single();

    final businessId = businessResponse['id'] as String;

    // 2. Insert manager if selected
    if (selectedManagerId != null && selectedManagerId.isNotEmpty) {
      await _supabase.from('business_members').insert({
        'business_id': businessId,
        'user_id': selectedManagerId,
        'role': 'manager',
      });
    }

    // 3. Insert employees if selected
    if (selectedEmployeeIds.isNotEmpty) {
      final employeeInserts = selectedEmployeeIds.map((empId) => {
        'business_id': businessId,
        'user_id': empId,
        'role': 'employee',
      }).toList();

      await _supabase.from('business_members').insert(employeeInserts);
    }
  }
}
