part of 'employee_sales_bloc.dart';

@immutable
sealed class EmployeeSalesEvent extends Equatable {
  const EmployeeSalesEvent();

  @override
  List<Object?> get props => [];
}

class FetchEmployeeSalesBusinessRequested extends EmployeeSalesEvent {
  final String userId;

  const FetchEmployeeSalesBusinessRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}
