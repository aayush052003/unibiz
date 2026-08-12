part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final FormzSubmissionStatus status;
  final bool hasBusinesses;
  final List<DashboardBusinessModel> businesses;
  final double totalIncomeToday;
  final double totalExpenseToday;
  final String? errorMessage;

  const DashboardState({
    this.status = FormzSubmissionStatus.initial,
    this.hasBusinesses = false,
    this.businesses = const [],
    this.totalIncomeToday = 0.0,
    this.totalExpenseToday = 0.0,
    this.errorMessage,
  });

  double get totalProfitToday => totalIncomeToday - totalExpenseToday;

  DashboardState copyWith({
    FormzSubmissionStatus? status,
    bool? hasBusinesses,
    List<DashboardBusinessModel>? businesses,
    double? totalIncomeToday,
    double? totalExpenseToday,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      hasBusinesses: hasBusinesses ?? this.hasBusinesses,
      businesses: businesses ?? this.businesses,
      totalIncomeToday: totalIncomeToday ?? this.totalIncomeToday,
      totalExpenseToday: totalExpenseToday ?? this.totalExpenseToday,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        hasBusinesses,
        businesses,
        totalIncomeToday,
        totalExpenseToday,
        errorMessage,
      ];
}
