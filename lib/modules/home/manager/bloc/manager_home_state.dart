part of 'manager_home_bloc.dart';

class ManagerHomeState extends Equatable {
  final FormzSubmissionStatus status;
  final String? businessId;
  final List<LowStockItemModel> lowStockItems;
  final List<RecentSaleModel> recentSales;
  final int outOfStockCount;
  final String? errorMessage;

  const ManagerHomeState({
    this.status = FormzSubmissionStatus.initial,
    this.businessId,
    this.lowStockItems = const [],
    this.recentSales = const [],
    this.outOfStockCount = 0,
    this.errorMessage,
  });

  ManagerHomeState copyWith({
    FormzSubmissionStatus? status,
    String? businessId,
    List<LowStockItemModel>? lowStockItems,
    List<RecentSaleModel>? recentSales,
    int? outOfStockCount,
    String? errorMessage,
  }) {
    return ManagerHomeState(
      status: status ?? this.status,
      businessId: businessId ?? this.businessId,
      lowStockItems: lowStockItems ?? this.lowStockItems,
      recentSales: recentSales ?? this.recentSales,
      outOfStockCount: outOfStockCount ?? this.outOfStockCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        businessId,
        lowStockItems,
        recentSales,
        outOfStockCount,
        errorMessage,
      ];
}
