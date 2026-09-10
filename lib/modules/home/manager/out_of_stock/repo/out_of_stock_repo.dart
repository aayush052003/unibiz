import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/out_of_stock_product_model.dart';

class ManagerOutOfStockRepo {
  final SupabaseClient _client;

  ManagerOutOfStockRepo({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<List<OutOfStockProductModel>> fetchOutOfStockProducts(String businessId) async {
    final response = await _client
        .from('products')
        .select('*, batches(quantity_remaining)')
        .eq('business_id', businessId);

    final List<dynamic> list = response as List<dynamic>;
    final List<OutOfStockProductModel> outOfStockProducts = [];

    for (final item in list) {
      final batches = item['batches'] as List<dynamic>? ?? [];
      double totalQtyBuying = 0.0;
      for (final b in batches) {
        if (b['quantity_remaining'] != null) {
          totalQtyBuying += double.tryParse(b['quantity_remaining'].toString()) ?? 0.0;
        }
      }
      final num unitsPerPack = (item['units_per_pack'] as num?) ?? 1;
      final double totalQtySelling = totalQtyBuying * unitsPerPack;

      if (totalQtySelling == 0) {
        outOfStockProducts.add(OutOfStockProductModel.fromJson(item as Map<String, dynamic>));
      }
    }

    return outOfStockProducts;
  }
}
