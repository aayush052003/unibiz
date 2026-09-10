import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/owner_data_model.dart';

class OwnerDataRepo {
  final SupabaseClient _supabase;

  OwnerDataRepo({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// Fetch Top Summary for the current year across all owner businesses
  Future<OwnerDataTopSummaryModel> fetchCurrentYearTopSummary(String ownerId) async {
    final businessResponse = await _supabase
        .from('businesses')
        .select('id')
        .eq('owner_id', ownerId);

    final businessList = businessResponse as List;
    if (businessList.isEmpty) {
      return const OwnerDataTopSummaryModel();
    }

    final businessIds = businessList.map((b) => b['id'] as String).toList();
    final currentYear = DateTime.now().year;
    final startOfYear = DateTime.utc(currentYear, 1, 1).toIso8601String();
    final endOfYear = DateTime.utc(currentYear, 12, 31, 23, 59, 59, 999).toIso8601String();

    // 1. Gross Profit across all owner businesses for current year
    final salesResponse = await _supabase
        .from('sales')
        .select('profit')
        .inFilter('business_id', businessIds)
        .gte('created_at', startOfYear)
        .lte('created_at', endOfYear);

    double totalGrossProfit = 0.0;
    for (final s in salesResponse as List) {
      final profit = (s['profit'] as num?)?.toDouble() ?? 0.0;
      totalGrossProfit += profit;
    }

    // 2. Expenses across all owner businesses for current year
    final expensesResponse = await _supabase
        .from('expenses')
        .select('amount')
        .inFilter('business_id', businessIds)
        .gte('created_at', startOfYear)
        .lte('created_at', endOfYear);

    double totalExpenses = 0.0;
    for (final e in expensesResponse as List) {
      final amt = (e['amount'] as num?)?.toDouble() ?? 0.0;
      totalExpenses += amt;
    }

    return OwnerDataTopSummaryModel(
      grossProfit: totalGrossProfit,
      expenses: totalExpenses,
      netProfit: totalGrossProfit - totalExpenses,
    );
  }

  /// Fetch business reports for the specified period filter
  Future<List<BusinessReportModel>> fetchBusinessReports({
    required String ownerId,
    required PeriodType periodType,
    required DateTime selectedDate,
    required int selectedMonth,
    required int selectedYear,
  }) async {
    final businessesResponse = await _supabase
        .from('businesses')
        .select('id, name')
        .eq('owner_id', ownerId)
        .order('created_at', ascending: true);

    final businessList = businessesResponse as List;
    if (businessList.isEmpty) return [];

    final businessIds = businessList.map((b) => b['id'] as String).toList();

    // Calculate start and end UTC timestamps based on period type
    late final String startIso;
    late final String endIso;

    switch (periodType) {
      case PeriodType.day:
        final start = DateTime.utc(selectedDate.year, selectedDate.month, selectedDate.day);
        final end = DateTime.utc(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59, 999);
        startIso = start.toIso8601String();
        endIso = end.toIso8601String();
        break;
      case PeriodType.month:
        final start = DateTime.utc(selectedYear, selectedMonth, 1);
        final lastDay = DateTime.utc(selectedYear, selectedMonth + 1, 0).day;
        final end = DateTime.utc(selectedYear, selectedMonth, lastDay, 23, 59, 59, 999);
        startIso = start.toIso8601String();
        endIso = end.toIso8601String();
        break;
      case PeriodType.year:
        final start = DateTime.utc(selectedYear, 1, 1);
        final end = DateTime.utc(selectedYear, 12, 31, 23, 59, 59, 999);
        startIso = start.toIso8601String();
        endIso = end.toIso8601String();
        break;
    }

    // Fetch sales for period
    final salesResponse = await _supabase
        .from('sales')
        .select('business_id, profit')
        .inFilter('business_id', businessIds)
        .gte('created_at', startIso)
        .lte('created_at', endIso);

    final Map<String, double> grossProfitMap = {};
    for (final s in salesResponse as List) {
      final bId = s['business_id'] as String;
      final profit = (s['profit'] as num?)?.toDouble() ?? 0.0;
      grossProfitMap[bId] = (grossProfitMap[bId] ?? 0.0) + profit;
    }

    // Fetch expenses for period
    final expensesResponse = await _supabase
        .from('expenses')
        .select('business_id, amount')
        .inFilter('business_id', businessIds)
        .gte('created_at', startIso)
        .lte('created_at', endIso);

    final Map<String, double> expensesMap = {};
    for (final e in expensesResponse as List) {
      final bId = e['business_id'] as String;
      final amt = (e['amount'] as num?)?.toDouble() ?? 0.0;
      expensesMap[bId] = (expensesMap[bId] ?? 0.0) + amt;
    }

    // Fetch managers for all businesses
    final membersResponse = await _supabase
        .from('business_members')
        .select('business_id, profiles(first_name, last_name)')
        .inFilter('business_id', businessIds)
        .eq('role', 'manager');

    final Map<String, String> managerMap = {};
    for (final m in membersResponse as List) {
      final bId = m['business_id'] as String;
      final profile = m['profiles'] as Map<String, dynamic>?;
      if (profile != null) {
        final fName = profile['first_name'] as String? ?? '';
        final lName = profile['last_name'] as String? ?? '';
        final fullName = '$fName $lName'.trim();
        if (fullName.isNotEmpty) {
          managerMap[bId] = fullName;
        }
      }
    }

    final List<BusinessReportModel> reports = [];
    for (final b in businessList) {
      final bId = b['id'] as String;
      reports.add(BusinessReportModel.fromJson(
        businessJson: b as Map<String, dynamic>,
        managerName: managerMap[bId],
        grossProfit: grossProfitMap[bId] ?? 0.0,
        expenses: expensesMap[bId] ?? 0.0,
      ));
    }

    return reports;
  }
}
