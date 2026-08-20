part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final FormzSubmissionStatus status;
  final bool hasBusinesses;
  final List<DashboardBusinessModel> businesses;
  final double totalRevenueToday;
  final double totalProfitToday;
  final String? errorMessage;

  const DashboardState({
    this.status = FormzSubmissionStatus.initial,
    this.hasBusinesses = false,
    this.businesses = const [],
    this.totalRevenueToday = 0.0,
    this.totalProfitToday = 0.0,
    this.errorMessage,
  });

  DashboardState copyWith({
    FormzSubmissionStatus? status,
    bool? hasBusinesses,
    List<DashboardBusinessModel>? businesses,
    double? totalRevenueToday,
    double? totalProfitToday,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      hasBusinesses: hasBusinesses ?? this.hasBusinesses,
      businesses: businesses ?? this.businesses,
      totalRevenueToday: totalRevenueToday ?? this.totalRevenueToday,
      totalProfitToday: totalProfitToday ?? this.totalProfitToday,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        hasBusinesses,
        businesses,
        totalRevenueToday,
        totalProfitToday,
        errorMessage,
      ];
}
