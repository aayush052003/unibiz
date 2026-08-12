import 'package:supabase_flutter/supabase_flutter.dart';

class AddProductRepo {
  final SupabaseClient _client;

  AddProductRepo({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<void> addProduct({
    required String businessId,
    required String name,
    required String buyingUnit,
    required String sellingUnit,
    required num unitsPerPack,
    required String imageUrl,
  }) async {
    await _client.from('products').insert({
      'business_id': businessId,
      'name': name,
      'buying_unit': buyingUnit,
      'selling_unit': sellingUnit,
      'units_per_pack': unitsPerPack,
      'image_url': imageUrl,
    });
  }
}
