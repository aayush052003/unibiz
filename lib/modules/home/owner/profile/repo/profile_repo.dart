import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/profile_model.dart';

class ProfileRepo {
  final SupabaseClient _supabase;

  ProfileRepo({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  Future<ProfileModel> fetchProfile(String userId) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    return ProfileModel.fromJson(response);
  }
}
