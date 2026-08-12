import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../../../../helper/owner_forgot_password/email_input.dart';
import '../repo/owner_forgot_password_repo.dart';

part 'owner_forgot_password_event.dart';
part 'owner_forgot_password_state.dart';

class OwnerForgotPasswordBloc extends Bloc<OwnerForgotPasswordEvent, OwnerForgotPasswordState> {
  final OwnerForgotPasswordRepo _repo;

  OwnerForgotPasswordBloc({required OwnerForgotPasswordRepo repo})
      : _repo = repo,
        super(const OwnerForgotPasswordState()) {
    on<OwnerForgotPasswordEmailChanged>(_onEmailChanged);
    on<OwnerForgotPasswordSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(OwnerForgotPasswordEmailChanged event, Emitter<OwnerForgotPasswordState> emit) {
    final email = EmailInput.dirty(event.email);
    emit(state.copyWith(
      email: email,
      status: FormzSubmissionStatus.initial,
    ));
  }

  Future<void> _onSubmitted(OwnerForgotPasswordSubmitted event, Emitter<OwnerForgotPasswordState> emit) async {
    final email = EmailInput.dirty(state.email.value);

    emit(state.copyWith(
      email: email,
      status: FormzSubmissionStatus.initial,
    ));

    final isValid = Formz.validate([email]);
    if (!isValid) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Please enter a valid email address',
      ));
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await _repo.resetPassword(email: email.value);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      // Always succeed to avoid exposing registered emails
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    }
  }
}
