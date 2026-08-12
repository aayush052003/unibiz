import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/owner_products_model.dart';

class OwnerProductsRepo {
  final SupabaseClient _client;

  OwnerProductsRepo({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<List<OwnerProductsModel>> fetchOwnerBusinesses(String ownerId) async {
    final businessesResponse = await _client
        .from('businesses')
        .select()
        .eq('owner_id', ownerId)
        .order('created_at', ascending: false);

    final businessesList = businessesResponse as List<dynamic>;
    if (businessesList.isEmpty) return [];

    final List<OwnerProductsModel> result = [];

    for (final business in businessesList) {
      final businessId = business['id'] as String;

      final managerMemberResponse = await _client
          .from('business_members')
          .select('user_id')
          .eq('business_id', businessId)
          .eq('role', 'manager')
          .maybeSingle();

      String? managerName;
      if (managerMemberResponse != null && managerMemberResponse['user_id'] != null) {
        final userId = managerMemberResponse['user_id'] as String;
        final profileResponse = await _client
            .from('profiles')
            .select('first_name, last_name')
            .eq('id', userId)
            .maybeSingle();

        if (profileResponse != null) {
          final fName = profileResponse['first_name'] ?? '';
          final lName = profileResponse['last_name'] ?? '';
          managerName = '$fName $lName'.trim();
        }
      }

      result.add(OwnerProductsModel.fromJson(
        businessJson: business as Map<String, dynamic>,
        managerName: managerName?.isNotEmpty == true ? managerName : null,
      ));
    }

    return result;
  }
}
