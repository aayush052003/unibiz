import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/dashboard_business_model.dart';

class DashboardData {
  final bool hasBusinesses;
  final List<DashboardBusinessModel> businesses;
  final double totalIncomeToday;
  final double totalExpenseToday;

  DashboardData({
    required this.hasBusinesses,
    this.businesses = const [],
    this.totalIncomeToday = 0.0,
    this.totalExpenseToday = 0.0,
  });

  double get totalProfitToday => totalIncomeToday - totalExpenseToday;
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
        .select('business_id, total_amount')
        .inFilter('business_id', businessIds)
        .gte('created_at', startOfDay)
        .lte('created_at', endOfDay);

    // 3. Fetch expenses for today across owner's businesses
    final expensesResponse = await _supabase
        .from('expenses')
        .select('business_id, amount')
        .inFilter('business_id', businessIds)
        .gte('created_at', startOfDay)
        .lte('created_at', endOfDay);

    final salesList = salesResponse as List;
    final expensesList = expensesResponse as List;

    // Map to aggregate income & expense per business
    final Map<String, double> incomeMap = {};
    final Map<String, double> expenseMap = {};

    double grandTotalIncome = 0.0;
    double grandTotalExpense = 0.0;

    for (final sale in salesList) {
      final bId = sale['business_id'] as String;
      final amount = (sale['total_amount'] as num?)?.toDouble() ?? 0.0;
      incomeMap[bId] = (incomeMap[bId] ?? 0.0) + amount;
      grandTotalIncome += amount;
    }

    for (final expense in expensesList) {
      final bId = expense['business_id'] as String;
      final amount = (expense['amount'] as num?)?.toDouble() ?? 0.0;
      expenseMap[bId] = (expenseMap[bId] ?? 0.0) + amount;
      grandTotalExpense += amount;
    }

    final List<DashboardBusinessModel> dashboardBusinesses = businessList.map((b) {
      final bId = b['id'] as String;
      final bName = b['name'] as String;
      return DashboardBusinessModel(
        id: bId,
        name: bName,
        incomeToday: incomeMap[bId] ?? 0.0,
        expenseToday: expenseMap[bId] ?? 0.0,
      );
    }).toList();

    return DashboardData(
      hasBusinesses: true,
      businesses: dashboardBusinesses,
      totalIncomeToday: grandTotalIncome,
      totalExpenseToday: grandTotalExpense,
    );
  }
}
