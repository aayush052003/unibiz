part of 'owner_sign_in_bloc.dart';

@immutable
sealed class OwnerSignInEvent extends Equatable {
  const OwnerSignInEvent();

  @override
  List<Object?> get props => [];
}

class OwnerSignInEmailChanged extends OwnerSignInEvent {
  final String email;
  const OwnerSignInEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class OwnerSignInPasswordChanged extends OwnerSignInEvent {
  final String password;
  const OwnerSignInPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class OwnerSignInSubmitted extends OwnerSignInEvent {
  const OwnerSignInSubmitted();
}
