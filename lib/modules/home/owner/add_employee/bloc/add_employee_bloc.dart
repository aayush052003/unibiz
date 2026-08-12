import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../../../../../helper/add_employee/first_name_input.dart';
import '../../../../../helper/add_employee/last_name_input.dart';
import '../../../../../helper/add_employee/email_input.dart';
import '../../../../../helper/add_employee/role_input.dart';
import '../../../../../helper/add_employee/pin_input.dart';
import '../repo/add_employee_repo.dart';

part 'add_employee_event.dart';
part 'add_employee_state.dart';

class AddEmployeeBloc extends Bloc<AddEmployeeEvent, AddEmployeeState> {
  final AddEmployeeRepo _addEmployeeRepo;

  AddEmployeeBloc({required AddEmployeeRepo addEmployeeRepo})
      : _addEmployeeRepo = addEmployeeRepo,
        super(const AddEmployeeState()) {
    on<FirstNameChanged>(_onFirstNameChanged);
    on<LastNameChanged>(_onLastNameChanged);
    on<EmailChanged>(_onEmailChanged);
    on<RoleChanged>(_onRoleChanged);
    on<PinChanged>(_onPinChanged);
    on<AddEmployeeSubmitted>(_onAddEmployeeSubmitted);
  }

  void _onFirstNameChanged(
    FirstNameChanged event,
    Emitter<AddEmployeeState> emit,
  ) {
    final firstName = FirstNameInput.dirty(event.firstName);
    emit(state.copyWith(firstName: firstName, status: FormzSubmissionStatus.initial));
  }

  void _onLastNameChanged(
    LastNameChanged event,
    Emitter<AddEmployeeState> emit,
  ) {
    final lastName = LastNameInput.dirty(event.lastName);
    emit(state.copyWith(lastName: lastName, status: FormzSubmissionStatus.initial));
  }

  void _onEmailChanged(
    EmailChanged event,
    Emitter<AddEmployeeState> emit,
  ) {
    final email = EmailInput.dirty(event.email);
    emit(state.copyWith(email: email, status: FormzSubmissionStatus.initial));
  }

  void _onRoleChanged(
    RoleChanged event,
    Emitter<AddEmployeeState> emit,
  ) {
    final role = RoleInput.dirty(event.role);
    emit(state.copyWith(role: role, status: FormzSubmissionStatus.initial));
  }

  void _onPinChanged(
    PinChanged event,
    Emitter<AddEmployeeState> emit,
  ) {
    final pin = PinInput.dirty(event.pin);
    emit(state.copyWith(pin: pin, status: FormzSubmissionStatus.initial));
  }

  Future<void> _onAddEmployeeSubmitted(
    AddEmployeeSubmitted event,
    Emitter<AddEmployeeState> emit,
  ) async {
    final firstName = FirstNameInput.dirty(state.firstName.value);
    final lastName = LastNameInput.dirty(state.lastName.value);
    final email = EmailInput.dirty(state.email.value);
    final role = RoleInput.dirty(state.role.value);
    final pin = PinInput.dirty(state.pin.value);

    final isValid = Formz.validate([firstName, lastName, email, role, pin]);

    emit(state.copyWith(
      firstName: firstName,
      lastName: lastName,
      email: email,
      role: role,
      pin: pin,
    ));

    if (!isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await _addEmployeeRepo.addEmployee(
        firstName: state.firstName.value.trim(),
        lastName: state.lastName.value.trim(),
        email: state.email.value.trim(),
        role: state.role.value.trim(),
        pin: state.pin.value.trim(),
        ownerId: event.ownerId,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
