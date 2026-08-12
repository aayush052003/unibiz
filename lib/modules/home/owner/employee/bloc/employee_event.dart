part of 'employee_bloc.dart';

@immutable
sealed class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object?> get props => [];
}

final class FetchEmployeesRequested extends EmployeeEvent {
  final String ownerId;

  const FetchEmployeesRequested(this.ownerId);

  @override
  List<Object?> get props => [ownerId];
}
