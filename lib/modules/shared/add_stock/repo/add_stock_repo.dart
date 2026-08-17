import 'package:supabase_flutter/supabase_flutter.dart';
import '../../products/model/products_model.dart';

class AddStockRepo {
  final SupabaseClient _client;

  AddStockRepo({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<List<ProductsModel>> fetchProducts(String businessId) async {
    final response = await _client
        .from('products')
        .select('*')
        .eq('business_id', businessId)
        .order('name', ascending: true);

    final List<dynamic> list = response as List<dynamic>;
    return list.map((item) => ProductsModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<void> addStockBatch({
    required String productId,
    required String businessId,
    required double quantity,
    required double purchasePrice,
    required double sellingPrice,
    required DateTime purchaseDate,
    required String addedBy,
  }) async {
    await _client.from('batches').insert({
      'product_id': productId,
      'business_id': businessId,
      'supplier_id': null,
      'quantity_remaining': quantity,
      'purchase_price': purchasePrice,
      'selling_price': sellingPrice,
      'purchase_date': purchaseDate.toIso8601String().split('T')[0], // yyyy-MM-dd
      'added_by': addedBy,
    });
  }
}
