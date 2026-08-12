import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/business_detail_model.dart';

class BusinessDetailRepo {
  final SupabaseClient _supabase;

  BusinessDetailRepo({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  Future<MemberProfileModel?> fetchCurrentManager(String businessId) async {
    final response = await _supabase
        .from('business_members')
        .select('role, profiles!inner(id, first_name, last_name, role, unique_id)')
        .eq('business_id', businessId)
        .eq('role', 'manager')
        .maybeSingle();

    if (response == null || response['profiles'] == null) {
      return null;
    }

    return MemberProfileModel.fromJson(
      response['profiles'] as Map<String, dynamic>,
    );
  }

  Future<List<MemberProfileModel>> fetchCurrentEmployees(String businessId) async {
    final response = await _supabase
        .from('business_members')
        .select('role, profiles!inner(id, first_name, last_name, role, unique_id)')
        .eq('business_id', businessId)
        .eq('role', 'employee');

    final List list = response as List;
    return list
        .where((item) => item['profiles'] != null)
        .map((item) => MemberProfileModel.fromJson(
              item['profiles'] as Map<String, dynamic>,
            ))
        .toList();
  }

  Future<List<MemberProfileModel>> fetchAvailableManagers({
    required String ownerId,
    required String businessId,
    MemberProfileModel? currentManager,
  }) async {
    final assignedMembers = await _supabase
        .from('business_members')
        .select('user_id');

    final assignedUserIds = (assignedMembers as List)
        .map((m) => m['user_id'] as String)
        .toSet();

    final managersResponse = await _supabase
        .from('profiles')
        .select('id, first_name, last_name, role, unique_id')
        .eq('role', 'manager')
        .eq('created_by', ownerId);

    final List allManagers = managersResponse as List;
    final List<MemberProfileModel> available = [];

    for (final raw in allManagers) {
      final model = MemberProfileModel.fromJson(raw as Map<String, dynamic>);
      if (!assignedUserIds.contains(model.id) ||
          (currentManager != null && model.id == currentManager.id)) {
        available.add(model);
      }
    }

    return available;
  }

  Future<List<MemberProfileModel>> fetchAvailableEmployees({
    required String ownerId,
    required String businessId,
    required List<MemberProfileModel> currentEmployees,
  }) async {
    final assignedMembers = await _supabase
        .from('business_members')
        .select('user_id');

    final assignedUserIds = (assignedMembers as List)
        .map((m) => m['user_id'] as String)
        .toSet();

    final currentEmployeeIds = currentEmployees.map((e) => e.id).toSet();

    final employeesResponse = await _supabase
        .from('profiles')
        .select('id, first_name, last_name, role, unique_id')
        .eq('role', 'employee')
        .eq('created_by', ownerId);

    final List allEmployees = employeesResponse as List;
    final List<MemberProfileModel> available = [];

    for (final raw in allEmployees) {
      final model = MemberProfileModel.fromJson(raw as Map<String, dynamic>);
      if (!assignedUserIds.contains(model.id) || currentEmployeeIds.contains(model.id)) {
        available.add(model);
      }
    }

    return available;
  }

  Future<void> updateBusinessName({
    required String businessId,
    required String name,
  }) async {
    await _supabase
        .from('businesses')
        .update({'name': name})
        .eq('id', businessId);
  }

  Future<void> saveBusinessChanges({
    required String businessId,
    required String? originalName,
    required String? pendingName,
    required MemberProfileModel? originalManager,
    required MemberProfileModel? pendingManager,
    required List<MemberProfileModel> originalEmployees,
    required List<MemberProfileModel> pendingEmployees,
  }) async {
    if (pendingName != null &&
        pendingName.isNotEmpty &&
        pendingName != originalName) {
      await updateBusinessName(
        businessId: businessId,
        name: pendingName.trim(),
      );
    }

    if (originalManager?.id != pendingManager?.id) {
      if (originalManager != null) {
        await _supabase
            .from('business_members')
            .delete()
            .eq('business_id', businessId)
            .eq('role', 'manager');
      }

      if (pendingManager != null) {
        await _supabase.from('business_members').insert({
          'business_id': businessId,
          'user_id': pendingManager.id,
          'role': 'manager',
        });
      }
    }

    final origEmpIds = originalEmployees.map((e) => e.id).toSet();
    final pendEmpIds = pendingEmployees.map((e) => e.id).toSet();

    final removedEmpIds = origEmpIds.difference(pendEmpIds);
    final addedEmps =
        pendingEmployees.where((e) => !origEmpIds.contains(e.id)).toList();

    for (final empId in removedEmpIds) {
      await _supabase
          .from('business_members')
          .delete()
          .eq('business_id', businessId)
          .eq('user_id', empId);
    }

    if (addedEmps.isNotEmpty) {
      final insertRows = addedEmps
          .map((emp) => {
                'business_id': businessId,
                'user_id': emp.id,
                'role': 'employee',
              })
          .toList();

      await _supabase.from('business_members').insert(insertRows);
    }
  }
}

