part of 'owner_forgot_password_bloc.dart';

class OwnerForgotPasswordState extends Equatable {
  final EmailInput email;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  const OwnerForgotPasswordState({
    this.email = const EmailInput.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  OwnerForgotPasswordState copyWith({
    EmailInput? email,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return OwnerForgotPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, status, errorMessage];
}
