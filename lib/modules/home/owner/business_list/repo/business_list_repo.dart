import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/business_list_model.dart';

class BusinessListRepo {
  final SupabaseClient _supabase;

  BusinessListRepo({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  Future<List<BusinessListModel>> fetchBusinesses(String ownerId) async {
    final response = await _supabase
        .from('businesses')
        .select('*, business_members(*, profiles(first_name, last_name))')
        .eq('owner_id', ownerId);

    final list = response as List;
    return list.map((json) => BusinessListModel.fromJson(json)).toList();
  }
}
