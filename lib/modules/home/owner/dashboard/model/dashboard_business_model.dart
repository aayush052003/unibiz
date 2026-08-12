class DashboardBusinessModel {
  final String id;
  final String name;
  final double incomeToday;
  final double expenseToday;

  DashboardBusinessModel({
    required this.id,
    required this.name,
    this.incomeToday = 0.0,
    this.expenseToday = 0.0,
  });

  double get profitToday => incomeToday - expenseToday;
}
