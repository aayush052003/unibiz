import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../../../../helper/owner_sign_in/email_input.dart';
import '../../../../helper/owner_sign_in/password_input.dart';
import '../../../../helper/hive_service.dart';
import '../repo/owner_sign_in_repo.dart';

part 'owner_sign_in_event.dart';
part 'owner_sign_in_state.dart';

class OwnerSignInBloc extends Bloc<OwnerSignInEvent, OwnerSignInState> {
  final OwnerSignInRepo _repo;

  OwnerSignInBloc({required OwnerSignInRepo repo})
      : _repo = repo,
        super(const OwnerSignInState()) {
    on<OwnerSignInEmailChanged>(_onEmailChanged);
    on<OwnerSignInPasswordChanged>(_onPasswordChanged);
    on<OwnerSignInSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(OwnerSignInEmailChanged event, Emitter<OwnerSignInState> emit) {
    final email = EmailInput.dirty(event.email);
    emit(state.copyWith(
      email: email,
      status: FormzSubmissionStatus.initial,
    ));
  }

  void _onPasswordChanged(OwnerSignInPasswordChanged event, Emitter<OwnerSignInState> emit) {
    final password = PasswordInput.dirty(event.password);
    emit(state.copyWith(
      password: password,
      status: FormzSubmissionStatus.initial,
    ));
  }

  Future<void> _onSubmitted(OwnerSignInSubmitted event, Emitter<OwnerSignInState> emit) async {
    final email = EmailInput.dirty(state.email.value);
    final password = PasswordInput.dirty(state.password.value);

    emit(state.copyWith(
      email: email,
      password: password,
      status: FormzSubmissionStatus.initial,
    ));

    final isValid = Formz.validate([email, password]);
    if (!isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure, errorMessage: 'Please fill all fields correctly'));
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final profile = await _repo.signInWithOwner(
        email: email.value,
        password: password.value,
      );

      await HiveService.saveSession(
        userId: profile.id,
        firstName: profile.firstName,
        lastName: profile.lastName,
        role: profile.role,
        uniqueId: profile.uniqueId,
      );

      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}
