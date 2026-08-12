part of 'add_business_bloc.dart';

@immutable
sealed class AddBusinessEvent extends Equatable {
  const AddBusinessEvent();

  @override
  List<Object?> get props => [];
}

final class LoadStaffRequested extends AddBusinessEvent {
  final String ownerId;

  const LoadStaffRequested(this.ownerId);

  @override
  List<Object?> get props => [ownerId];
}

final class BusinessNameChanged extends AddBusinessEvent {
  final String name;

  const BusinessNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

final class ManagerSelected extends AddBusinessEvent {
  final String? managerId;

  const ManagerSelected(this.managerId);

  @override
  List<Object?> get props => [managerId];
}

final class EmployeeToggled extends AddBusinessEvent {
  final String employeeId;

  const EmployeeToggled(this.employeeId);

  @override
  List<Object?> get props => [employeeId];
}

final class AddBusinessSubmitted extends AddBusinessEvent {
  final String ownerId;

  const AddBusinessSubmitted(this.ownerId);

  @override
  List<Object?> get props => [ownerId];
}
