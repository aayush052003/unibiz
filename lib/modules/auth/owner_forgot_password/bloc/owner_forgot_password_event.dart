part of 'owner_forgot_password_bloc.dart';

@immutable
sealed class OwnerForgotPasswordEvent extends Equatable {
  const OwnerForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

class OwnerForgotPasswordEmailChanged extends OwnerForgotPasswordEvent {
  final String email;
  const OwnerForgotPasswordEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class OwnerForgotPasswordSubmitted extends OwnerForgotPasswordEvent {
  const OwnerForgotPasswordSubmitted();
}
