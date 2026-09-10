import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/model/owner_data_model.dart';
import '../model/business_data_detail_model.dart';

class BusinessDataDetailData {
  final String businessName;
  final BusinessSummaryCardsModel summaryCards;
  final List<DetailSaleItemModel> sales;
  final List<DetailExpenseItemModel> expenses;
  final List<PeriodSummaryRowModel> periodSummaries;

  BusinessDataDetailData({
    required this.businessName,
    required this.summaryCards,
    this.sales = const [],
    this.expenses = const [],
    this.periodSummaries = const [],
  });
}

class BusinessDataDetailRepo {
  final SupabaseClient _supabase;

  BusinessDataDetailRepo({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  static const List<String> _fullMonths = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  Future<BusinessDataDetailData> fetchDetailData({
    required String businessId,
    required PeriodType periodType,
    required DateTime selectedDate,
    required int selectedMonth,
    required int selectedYear,
  }) async {
    // 1. Fetch Business Name
    final businessResponse = await _supabase
        .from('businesses')
        .select('name')
        .eq('id', businessId)
        .single();
    final businessName = (businessResponse['name'] as String?) ?? 'Business Details';

    // 2. Compute date range in UTC/ISO
    late final DateTime rangeStart;
    late final DateTime rangeEnd;

    switch (periodType) {
      case PeriodType.day:
        rangeStart = DateTime.utc(selectedDate.year, selectedDate.month, selectedDate.day);
        rangeEnd = DateTime.utc(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59, 999);
        break;
      case PeriodType.month:
        rangeStart = DateTime.utc(selectedYear, selectedMonth, 1);
        final lastDay = DateTime.utc(selectedYear, selectedMonth + 1, 0).day;
        rangeEnd = DateTime.utc(selectedYear, selectedMonth, lastDay, 23, 59, 59, 999);
        break;
      case PeriodType.year:
        rangeStart = DateTime.utc(selectedYear, 1, 1);
        rangeEnd = DateTime.utc(selectedYear, 12, 31, 23, 59, 59, 999);
        break;
    }

    final startIso = rangeStart.toIso8601String();
    final endIso = rangeEnd.toIso8601String();

    if (periodType == PeriodType.day) {
      // Day View: Fetch full sales and full expenses for that day
      final salesResponse = await _supabase
          .from('sales')
          .select('*, products(name, image_url, selling_unit), profiles(first_name, last_name)')
          .eq('business_id', businessId)
          .gte('created_at', startIso)
          .lte('created_at', endIso)
          .order('created_at', ascending: false);

      final salesList = (salesResponse as List)
          .map((item) => DetailSaleItemModel.fromJson(item as Map<String, dynamic>))
          .toList();

      final expensesResponse = await _supabase
          .from('expenses')
          .select('*, profiles(first_name, last_name)')
          .eq('business_id', businessId)
          .gte('created_at', startIso)
          .lte('created_at', endIso)
          .order('created_at', ascending: false);

      final expensesList = (expensesResponse as List)
          .map((item) => DetailExpenseItemModel.fromJson(item as Map<String, dynamic>))
          .toList();

      double dayGrossProfit = 0.0;
      for (final s in salesList) {
        dayGrossProfit += s.profit;
      }

      double dayExpenses = 0.0;
      for (final e in expensesList) {
        dayExpenses += e.amount;
      }

      return BusinessDataDetailData(
        businessName: businessName,
        summaryCards: BusinessSummaryCardsModel(
          grossProfit: dayGrossProfit,
          expenses: dayExpenses,
          netProfit: dayGrossProfit - dayExpenses,
        ),
        sales: salesList,
        expenses: expensesList,
      );
    } else if (periodType == PeriodType.month) {
      // Month View: Day-wise breakdown of gross profit and expenses
      final salesResponse = await _supabase
          .from('sales')
          .select('profit, created_at')
          .eq('business_id', businessId)
          .gte('created_at', startIso)
          .lte('created_at', endIso);

      final expensesResponse = await _supabase
          .from('expenses')
          .select('amount, created_at')
          .eq('business_id', businessId)
          .gte('created_at', startIso)
          .lte('created_at', endIso);

      final Map<int, double> dayProfitMap = {};
      final Map<int, double> dayExpenseMap = {};
      double totalGrossProfit = 0.0;
      double totalExpenses = 0.0;

      for (final s in salesResponse as List) {
        final profit = (s['profit'] as num?)?.toDouble() ?? 0.0;
        final createdAt = DateTime.parse(s['created_at'] as String).toLocal();
        dayProfitMap[createdAt.day] = (dayProfitMap[createdAt.day] ?? 0.0) + profit;
        totalGrossProfit += profit;
      }

      for (final e in expensesResponse as List) {
        final amt = (e['amount'] as num?)?.toDouble() ?? 0.0;
        final createdAt = DateTime.parse(e['created_at'] as String).toLocal();
        dayExpenseMap[createdAt.day] = (dayExpenseMap[createdAt.day] ?? 0.0) + amt;
        totalExpenses += amt;
      }

      final activeDays = {...dayProfitMap.keys, ...dayExpenseMap.keys}.toList()
        ..sort((a, b) => b.compareTo(a)); // Newest date first

      final List<PeriodSummaryRowModel> periodSummaries = [];
      final monthNameShort = _months[selectedMonth - 1];

      for (final day in activeDays) {
        final profit = dayProfitMap[day] ?? 0.0;
        final expense = dayExpenseMap[day] ?? 0.0;
        periodSummaries.add(PeriodSummaryRowModel(
          label: '$day $monthNameShort',
          date: DateTime(selectedYear, selectedMonth, day),
          grossProfit: profit,
          expenses: expense,
        ));
      }

      return BusinessDataDetailData(
        businessName: businessName,
        summaryCards: BusinessSummaryCardsModel(
          grossProfit: totalGrossProfit,
          expenses: totalExpenses,
          netProfit: totalGrossProfit - totalExpenses,
        ),
        periodSummaries: periodSummaries,
      );
    } else {
      // Year View: Month-wise breakdown of gross profit and expenses
      final salesResponse = await _supabase
          .from('sales')
          .select('profit, created_at')
          .eq('business_id', businessId)
          .gte('created_at', startIso)
          .lte('created_at', endIso);

      final expensesResponse = await _supabase
          .from('expenses')
          .select('amount, created_at')
          .eq('business_id', businessId)
          .gte('created_at', startIso)
          .lte('created_at', endIso);

      final Map<int, double> monthProfitMap = {};
      final Map<int, double> monthExpenseMap = {};
      double totalGrossProfit = 0.0;
      double totalExpenses = 0.0;

      for (final s in salesResponse as List) {
        final profit = (s['profit'] as num?)?.toDouble() ?? 0.0;
        final createdAt = DateTime.parse(s['created_at'] as String).toLocal();
        monthProfitMap[createdAt.month] = (monthProfitMap[createdAt.month] ?? 0.0) + profit;
        totalGrossProfit += profit;
      }

      for (final e in expensesResponse as List) {
        final amt = (e['amount'] as num?)?.toDouble() ?? 0.0;
        final createdAt = DateTime.parse(e['created_at'] as String).toLocal();
        monthExpenseMap[createdAt.month] = (monthExpenseMap[createdAt.month] ?? 0.0) + amt;
        totalExpenses += amt;
      }

      final activeMonths = {...monthProfitMap.keys, ...monthExpenseMap.keys}.toList()
        ..sort((a, b) => b.compareTo(a)); // Newest month first

      final List<PeriodSummaryRowModel> periodSummaries = [];
      for (final m in activeMonths) {
        final profit = monthProfitMap[m] ?? 0.0;
        final expense = monthExpenseMap[m] ?? 0.0;
        final monthFullName = _fullMonths[m - 1];
        periodSummaries.add(PeriodSummaryRowModel(
          label: '$monthFullName $selectedYear',
          date: DateTime(selectedYear, m, 1),
          grossProfit: profit,
          expenses: expense,
        ));
      }

      return BusinessDataDetailData(
        businessName: businessName,
        summaryCards: BusinessSummaryCardsModel(
          grossProfit: totalGrossProfit,
          expenses: totalExpenses,
          netProfit: totalGrossProfit - totalExpenses,
        ),
        periodSummaries: periodSummaries,
      );
    }
  }
}
