import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/stock_product_model.dart';
import '../model/purchase_history_model.dart';

class StockRepo {
  final SupabaseClient _client;

  StockRepo({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<List<StockProductModel>> fetchStock(String businessId) async {
    final response = await _client
        .from('products')
        .select('*, batches(quantity_remaining)')
        .eq('business_id', businessId);

    final List<dynamic> list = response as List<dynamic>;
    return list.map((item) {
      final batches = item['batches'] as List<dynamic>? ?? [];
      double totalQty = 0.0;
      for (final b in batches) {
        if (b['quantity_remaining'] != null) {
          totalQty += double.tryParse(b['quantity_remaining'].toString()) ?? 0.0;
        }
      }
      final map = Map<String, dynamic>.from(item);
      map['quantity_remaining'] = totalQty;
      return StockProductModel.fromJson(map);
    }).toList();
  }

  Future<List<PurchaseHistoryModel>> fetchPurchaseHistory(String businessId) async {
    final response = await _client
        .from('batches')
        .select('*, products(name, image_url, buying_unit), profiles(first_name, last_name)')
        .eq('business_id', businessId)
        .order('purchase_date', ascending: false)
        .order('created_at', ascending: false);

    final List<dynamic> list = response as List<dynamic>;
    return list.map((item) => PurchaseHistoryModel.fromJson(item as Map<String, dynamic>)).toList();
  }
}
