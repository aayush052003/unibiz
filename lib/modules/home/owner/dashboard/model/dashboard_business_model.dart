class DashboardBusinessModel {
  final String id;
  final String name;
  final double revenueToday;
  final double profitToday;

  DashboardBusinessModel({
    required this.id,
    required this.name,
    this.revenueToday = 0.0,
    this.profitToday = 0.0,
  });
}
