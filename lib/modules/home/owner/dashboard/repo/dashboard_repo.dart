import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/dashboard_business_model.dart';

class DashboardData {
  final bool hasBusinesses;
  final List<DashboardBusinessModel> businesses;
  final double totalRevenueToday;
  final double totalProfitToday;

  DashboardData({
    required this.hasBusinesses,
    this.businesses = const [],
    this.totalRevenueToday = 0.0,
    this.totalProfitToday = 0.0,
  });
}

class DashboardRepo {
  final SupabaseClient _supabase;

  DashboardRepo({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  Future<DashboardData> fetchDashboardData(String ownerId) async {
    // 1. Fetch businesses for this owner
    final businessResponse = await _supabase
        .from('businesses')
        .select('id, name')
        .eq('owner_id', ownerId);

    final businessList = businessResponse as List;
    if (businessList.isEmpty) {
      return DashboardData(hasBusinesses: false);
    }

    final businessIds = businessList.map((b) => b['id'] as String).toList();

    // Today's start and end timestamps in ISO format
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day).toIso8601String();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999).toIso8601String();

    // 2. Fetch sales for today across owner's businesses
    final salesResponse = await _supabase
        .from('sales')
        .select('business_id, total_amount, profit')
        .inFilter('business_id', businessIds)
        .gte('created_at', startOfDay)
        .lte('created_at', endOfDay);

    final salesList = salesResponse as List;

    // Map to aggregate revenue & profit per business
    final Map<String, double> revenueMap = {};
    final Map<String, double> profitMap = {};

    double grandTotalRevenue = 0.0;
    double grandTotalProfit = 0.0;

    for (final sale in salesList) {
      final bId = sale['business_id'] as String;
      final amount = (sale['total_amount'] as num?)?.toDouble() ?? 0.0;
      final profit = (sale['profit'] as num?)?.toDouble() ?? 0.0;
      revenueMap[bId] = (revenueMap[bId] ?? 0.0) + amount;
      profitMap[bId] = (profitMap[bId] ?? 0.0) + profit;
      grandTotalRevenue += amount;
      grandTotalProfit += profit;
    }

    final List<DashboardBusinessModel> dashboardBusinesses = businessList.map((b) {
      final bId = b['id'] as String;
      final bName = b['name'] as String;
      return DashboardBusinessModel(
        id: bId,
        name: bName,
        revenueToday: revenueMap[bId] ?? 0.0,
        profitToday: profitMap[bId] ?? 0.0,
      );
    }).toList();

    return DashboardData(
      hasBusinesses: true,
      businesses: dashboardBusinesses,
      totalRevenueToday: grandTotalRevenue,
      totalProfitToday: grandTotalProfit,
    );
  }
}
