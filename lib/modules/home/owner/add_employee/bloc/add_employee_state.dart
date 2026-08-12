part of 'add_employee_bloc.dart';

class AddEmployeeState extends Equatable {
  final FirstNameInput firstName;
  final LastNameInput lastName;
  final EmailInput email;
  final RoleInput role;
  final PinInput pin;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  const AddEmployeeState({
    this.firstName = const FirstNameInput.pure(),
    this.lastName = const LastNameInput.pure(),
    this.email = const EmailInput.pure(),
    this.role = const RoleInput.pure(),
    this.pin = const PinInput.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  bool get isValid => Formz.validate([firstName, lastName, email, role, pin]);

  AddEmployeeState copyWith({
    FirstNameInput? firstName,
    LastNameInput? lastName,
    EmailInput? email,
    RoleInput? role,
    PinInput? pin,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return AddEmployeeState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      role: role ?? this.role,
      pin: pin ?? this.pin,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        role,
        pin,
        status,
        errorMessage,
      ];
}
