part of 'employee_out_of_stock_bloc.dart';

@immutable
sealed class EmployeeOutOfStockEvent extends Equatable {
  const EmployeeOutOfStockEvent();

  @override
  List<Object?> get props => [];
}

class FetchEmployeeOutOfStockRequested extends EmployeeOutOfStockEvent {
  final String businessId;

  const FetchEmployeeOutOfStockRequested(this.businessId);

  @override
  List<Object?> get props => [businessId];
}
