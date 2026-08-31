part of 'employee_stock_bloc.dart';

@immutable
sealed class EmployeeStockEvent extends Equatable {
  const EmployeeStockEvent();

  @override
  List<Object?> get props => [];
}

class FetchEmployeeStockBusinessRequested extends EmployeeStockEvent {
  final String userId;

  const FetchEmployeeStockBusinessRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}
