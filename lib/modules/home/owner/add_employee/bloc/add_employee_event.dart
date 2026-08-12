part of 'add_employee_bloc.dart';

@immutable
sealed class AddEmployeeEvent extends Equatable {
  const AddEmployeeEvent();

  @override
  List<Object?> get props => [];
}

final class FirstNameChanged extends AddEmployeeEvent {
  final String firstName;

  const FirstNameChanged(this.firstName);

  @override
  List<Object?> get props => [firstName];
}

final class LastNameChanged extends AddEmployeeEvent {
  final String lastName;

  const LastNameChanged(this.lastName);

  @override
  List<Object?> get props => [lastName];
}

final class EmailChanged extends AddEmployeeEvent {
  final String email;

  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

final class RoleChanged extends AddEmployeeEvent {
  final String role;

  const RoleChanged(this.role);

  @override
  List<Object?> get props => [role];
}

final class PinChanged extends AddEmployeeEvent {
  final String pin;

  const PinChanged(this.pin);

  @override
  List<Object?> get props => [pin];
}

final class AddEmployeeSubmitted extends AddEmployeeEvent {
  final String ownerId;

  const AddEmployeeSubmitted(this.ownerId);

  @override
  List<Object?> get props => [ownerId];
}
