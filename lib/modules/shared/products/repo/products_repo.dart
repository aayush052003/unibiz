import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/products_model.dart';

class ProductsRepo {
  final SupabaseClient _client;

  ProductsRepo({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<List<ProductsModel>> fetchProducts(String businessId) async {
    final response = await _client
        .from('products')
        .select()
        .eq('business_id', businessId)
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .map((json) => ProductsModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
