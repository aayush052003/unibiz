part of 'owner_sign_up_bloc.dart';

@immutable
sealed class OwnerSignUpEvent extends Equatable {
  const OwnerSignUpEvent();

  @override
  List<Object?> get props => [];
}

class OwnerSignUpFirstNameChanged extends OwnerSignUpEvent {
  final String firstName;
  const OwnerSignUpFirstNameChanged(this.firstName);

  @override
  List<Object?> get props => [firstName];
}

class OwnerSignUpLastNameChanged extends OwnerSignUpEvent {
  final String lastName;
  const OwnerSignUpLastNameChanged(this.lastName);

  @override
  List<Object?> get props => [lastName];
}

class OwnerSignUpEmailChanged extends OwnerSignUpEvent {
  final String email;
  const OwnerSignUpEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class OwnerSignUpPasswordChanged extends OwnerSignUpEvent {
  final String password;
  const OwnerSignUpPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class OwnerSignUpConfirmPasswordChanged extends OwnerSignUpEvent {
  final String confirmPassword;
  const OwnerSignUpConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

class OwnerSignUpSubmitted extends OwnerSignUpEvent {
  const OwnerSignUpSubmitted();
}
