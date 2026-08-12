import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../../../../helper/owner_sign_up/first_name_input.dart';
import '../../../../helper/owner_sign_up/last_name_input.dart';
import '../../../../helper/owner_sign_up/email_input.dart';
import '../../../../helper/owner_sign_up/password_input.dart';
import '../../../../helper/owner_sign_up/confirm_password_input.dart';
import '../../../../helper/hive_service.dart';
import '../repo/owner_sign_up_repo.dart';

part 'owner_sign_up_event.dart';
part 'owner_sign_up_state.dart';

class OwnerSignUpBloc extends Bloc<OwnerSignUpEvent, OwnerSignUpState> {
  final OwnerSignUpRepo _repo;

  OwnerSignUpBloc({required OwnerSignUpRepo repo})
      : _repo = repo,
        super(const OwnerSignUpState()) {
    on<OwnerSignUpFirstNameChanged>(_onFirstNameChanged);
    on<OwnerSignUpLastNameChanged>(_onLastNameChanged);
    on<OwnerSignUpEmailChanged>(_onEmailChanged);
    on<OwnerSignUpPasswordChanged>(_onPasswordChanged);
    on<OwnerSignUpConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<OwnerSignUpSubmitted>(_onSubmitted);
  }

  void _onFirstNameChanged(OwnerSignUpFirstNameChanged event, Emitter<OwnerSignUpState> emit) {
    final firstName = FirstNameInput.dirty(event.firstName);
    emit(state.copyWith(
      firstName: firstName,
      status: FormzSubmissionStatus.initial,
    ));
  }

  void _onLastNameChanged(OwnerSignUpLastNameChanged event, Emitter<OwnerSignUpState> emit) {
    final lastName = LastNameInput.dirty(event.lastName);
    emit(state.copyWith(
      lastName: lastName,
      status: FormzSubmissionStatus.initial,
    ));
  }

  void _onEmailChanged(OwnerSignUpEmailChanged event, Emitter<OwnerSignUpState> emit) {
    final email = EmailInput.dirty(event.email);
    emit(state.copyWith(
      email: email,
      status: FormzSubmissionStatus.initial,
    ));
  }

  void _onPasswordChanged(OwnerSignUpPasswordChanged event, Emitter<OwnerSignUpState> emit) {
    final password = PasswordInput.dirty(event.password);
    final confirmPassword = ConfirmPasswordInput.dirty(
      password: password.value,
      value: state.confirmPassword.value,
    );
    emit(state.copyWith(
      password: password,
      confirmPassword: confirmPassword,
      status: FormzSubmissionStatus.initial,
    ));
  }

  void _onConfirmPasswordChanged(OwnerSignUpConfirmPasswordChanged event, Emitter<OwnerSignUpState> emit) {
    final confirmPassword = ConfirmPasswordInput.dirty(
      password: state.password.value,
      value: event.confirmPassword,
    );
    emit(state.copyWith(
      confirmPassword: confirmPassword,
      status: FormzSubmissionStatus.initial,
    ));
  }

  Future<void> _onSubmitted(OwnerSignUpSubmitted event, Emitter<OwnerSignUpState> emit) async {
    final firstName = FirstNameInput.dirty(state.firstName.value);
    final lastName = LastNameInput.dirty(state.lastName.value);
    final email = EmailInput.dirty(state.email.value);
    final password = PasswordInput.dirty(state.password.value);
    final confirmPassword = ConfirmPasswordInput.dirty(
      password: password.value,
      value: state.confirmPassword.value,
    );

    emit(state.copyWith(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      status: FormzSubmissionStatus.initial,
    ));

    final isValid = Formz.validate([
      firstName,
      lastName,
      email,
      password,
      confirmPassword,
    ]);

    if (!isValid) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Please fill all fields correctly',
      ));
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final profile = await _repo.signUpWithOwner(
        email: email.value,
        password: password.value,
        firstName: firstName.value,
        lastName: lastName.value,
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
