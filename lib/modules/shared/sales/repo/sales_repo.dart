import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/sales_product_model.dart';
import '../model/sales_history_model.dart';
import '../model/cart_item_model.dart';

class SalesRepo {
  final SupabaseClient _client;

  SalesRepo({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<List<SalesProductModel>> fetchProductsWithStock(String businessId) async {
    final response = await _client
        .from('products')
        .select('*, batches(*)')
        .eq('business_id', businessId);

    final List<dynamic> list = response as List<dynamic>;
    final List<SalesProductModel> products = [];
    for (final item in list) {
      final p = SalesProductModel.fromJson(item as Map<String, dynamic>);
      if (p.totalStockInSellingUnits > 0) {
        products.add(p);
      }
    }
    return products;
  }

  Future<void> recordCartSale({
    required String businessId,
    required List<CartItemModel> items,
    required String soldBy,
  }) async {
    final List<Map<String, dynamic>> batchesToRestore = [];
    final List<String> salesToCleanup = [];

    try {
      for (final item in items) {
        final double unitsPerPack = item.product.unitsPerPack.toDouble();
        double remainingNeeded = item.totalSellingUnits;

        // Fetch batches for this product with quantity_remaining > 0 ordered by purchase_date ASC, created_at ASC
        final response = await _client
            .from('batches')
            .select('*')
            .eq('product_id', item.product.id)
            .gt('quantity_remaining', 0)
            .order('purchase_date', ascending: true)
            .order('created_at', ascending: true);

        final List<dynamic> batchesJson = response as List<dynamic>;

        for (final batch in batchesJson) {
          if (remainingNeeded <= 0) break;

          final String batchId = batch['id'] as String;
          final double qtyRemainingBuying = double.parse(batch['quantity_remaining'].toString());
          final double purchasePrice = double.parse(batch['purchase_price'].toString());
          final double sellingPrice = double.parse(batch['selling_price'].toString());

          final double batchQtyRemainingSelling = qtyRemainingBuying * unitsPerPack;

          double qtySoldFromBatch;
          double newQtyRemainingBuying;

          if (batchQtyRemainingSelling <= remainingNeeded) {
            qtySoldFromBatch = batchQtyRemainingSelling;
            newQtyRemainingBuying = 0.0;
            remainingNeeded -= qtySoldFromBatch;
          } else {
            qtySoldFromBatch = remainingNeeded;
            newQtyRemainingBuying = qtyRemainingBuying - (qtySoldFromBatch / unitsPerPack);
            remainingNeeded = 0.0;
          }

          // Track for potential rollback
          final alreadyTracked = batchesToRestore.any((b) => b['id'] == batchId);
          if (!alreadyTracked) {
            batchesToRestore.add({
              'id': batchId,
              'quantity_remaining': qtyRemainingBuying,
            });
          }

          // Calculate prices per selling unit
          final double sellingPricePerSellingUnit = sellingPrice / unitsPerPack;
          final double purchasePricePerSellingUnit = purchasePrice / unitsPerPack;
          final double totalAmount = qtySoldFromBatch * sellingPricePerSellingUnit;
          final double profit = qtySoldFromBatch * (sellingPricePerSellingUnit - purchasePricePerSellingUnit);

          // Update batch quantity_remaining
          await _client
              .from('batches')
              .update({'quantity_remaining': newQtyRemainingBuying})
              .eq('id', batchId);

          // Insert sale record and fetch its ID for cleanup tracking
          final saleInsertRes = await _client.from('sales').insert({
            'business_id': businessId,
            'product_id': item.product.id,
            'batch_id': batchId,
            'quantity_sold': qtySoldFromBatch,
            'selling_price': sellingPricePerSellingUnit,
            'total_amount': totalAmount,
            'profit': profit,
            'sold_by': soldBy,
            'created_at': DateTime.now().toUtc().toIso8601String(),
          }).select('id').single();

          final String saleId = saleInsertRes['id'] as String;
          salesToCleanup.add(saleId);
        }

        if (remainingNeeded > 0) {
          throw Exception('Not enough stock available for product ${item.product.name}');
        }
      }
    } catch (e) {
      // Rollback inserted sales
      for (final saleId in salesToCleanup) {
        try {
          await _client.from('sales').delete().eq('id', saleId);
        } catch (_) {}
      }
      // Rollback batch quantity changes
      for (final b in batchesToRestore) {
        try {
          await _client
              .from('batches')
              .update({'quantity_remaining': b['quantity_remaining']})
              .eq('id', b['id']);
        } catch (_) {}
      }
      rethrow;
    }
  }

  Future<void> recordSale({
    required String businessId,
    required String productId,
    required double totalSellingUnits,
    required num unitsPerPack,
    required String soldBy,
  }) async {
    // Keep for backward compatibility or direct calls
    final response = await _client
        .from('batches')
        .select('*')
        .eq('product_id', productId)
        .gt('quantity_remaining', 0)
        .order('purchase_date', ascending: true)
        .order('created_at', ascending: true);

    final List<dynamic> batchesJson = response as List<dynamic>;
    double remainingNeeded = totalSellingUnits;

    for (final batch in batchesJson) {
      if (remainingNeeded <= 0) break;

      final String batchId = batch['id'] as String;
      final double qtyRemainingBuying = double.parse(batch['quantity_remaining'].toString());
      final double purchasePrice = double.parse(batch['purchase_price'].toString());
      final double sellingPrice = double.parse(batch['selling_price'].toString());

      final double batchQtyRemainingSelling = qtyRemainingBuying * unitsPerPack;

      double qtySoldFromBatch;
      double newQtyRemainingBuying;

      if (batchQtyRemainingSelling <= remainingNeeded) {
        qtySoldFromBatch = batchQtyRemainingSelling;
        newQtyRemainingBuying = 0.0;
        remainingNeeded -= qtySoldFromBatch;
      } else {
        qtySoldFromBatch = remainingNeeded;
        newQtyRemainingBuying = qtyRemainingBuying - (qtySoldFromBatch / unitsPerPack);
        remainingNeeded = 0.0;
      }

      final double sellingPricePerSellingUnit = sellingPrice / unitsPerPack;
      final double purchasePricePerSellingUnit = purchasePrice / unitsPerPack;
      final double totalAmount = qtySoldFromBatch * sellingPricePerSellingUnit;
      final double profit = qtySoldFromBatch * (sellingPricePerSellingUnit - purchasePricePerSellingUnit);

      await _client
          .from('batches')
          .update({'quantity_remaining': newQtyRemainingBuying})
          .eq('id', batchId);

      await _client.from('sales').insert({
        'business_id': businessId,
        'product_id': productId,
        'batch_id': batchId,
        'quantity_sold': qtySoldFromBatch,
        'selling_price': sellingPricePerSellingUnit,
        'total_amount': totalAmount,
        'profit': profit,
        'sold_by': soldBy,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });
    }

    if (remainingNeeded > 0) {
      throw Exception('Not enough stock available');
    }
  }

  Future<List<SalesHistoryModel>> fetchSalesHistory(String businessId) async {
    final response = await _client
        .from('sales')
        .select('*, products(name, image_url, buying_unit, selling_unit), profiles(first_name, last_name)')
        .eq('business_id', businessId)
        .order('created_at', ascending: false);

    final List<dynamic> list = response as List<dynamic>;
    return list.map((item) => SalesHistoryModel.fromJson(item as Map<String, dynamic>)).toList();
  }
}
