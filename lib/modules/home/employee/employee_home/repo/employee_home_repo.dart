import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/low_stock_item_model.dart';
import '../model/recent_sale_model.dart';

class EmployeeHomeRepo {
  final SupabaseClient _client;

  EmployeeHomeRepo({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<String?> fetchEmployeeBusinessId(String userId) async {
    final response = await _client
        .from('business_members')
        .select('business_id')
        .eq('user_id', userId)
        .eq('role', 'employee')
        .maybeSingle();

    if (response != null && response['business_id'] != null) {
      return response['business_id'] as String;
    }
    return null;
  }

  Future<List<LowStockItemModel>> fetchLowStockProducts(String businessId) async {
    final response = await _client
        .from('products')
        .select('*, batches(quantity_remaining)')
        .eq('business_id', businessId)
        .gt('min_stock_threshold', 0);

    final List<dynamic> list = response as List<dynamic>;
    final List<LowStockItemModel> lowStockList = [];

    for (final item in list) {
      final model = LowStockItemModel.fromJson(item as Map<String, dynamic>);
      if (model.quantityRemainingInSellingUnits <= model.minStockThreshold) {
        lowStockList.add(model);
      }
    }

    return lowStockList;
  }

  Future<List<RecentSaleModel>> fetchRecentSales(String businessId) async {
    final response = await _client
        .from('sales')
        .select('*, products(name, image_url, selling_unit), profiles(first_name, last_name)')
        .eq('business_id', businessId)
        .order('created_at', ascending: false)
        .limit(5);

    final List<dynamic> list = response as List<dynamic>;
    return list.map((item) => RecentSaleModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<int> fetchOutOfStockCount(String businessId) async {
    final response = await _client
        .from('products')
        .select('*, batches(quantity_remaining)')
        .eq('business_id', businessId);

    final List<dynamic> list = response as List<dynamic>;
    int count = 0;

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
        count++;
      }
    }

    return count;
  }
}
