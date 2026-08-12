import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../../../../helper/staff_sign_in/unique_id_input.dart';
import '../../../../helper/staff_sign_in/pin_input.dart';
import '../../../../helper/hive_service.dart';
import '../repo/staff_sign_in_repo.dart';

part 'staff_sign_in_event.dart';
part 'staff_sign_in_state.dart';

class StaffSignInBloc extends Bloc<StaffSignInEvent, StaffSignInState> {
  final StaffSignInRepo _repo;

  StaffSignInBloc({required StaffSignInRepo repo})
      : _repo = repo,
        super(const StaffSignInState()) {
    on<StaffSignInUniqueIdChanged>(_onUniqueIdChanged);
    on<StaffSignInPinChanged>(_onPinChanged);
    on<StaffSignInSubmitted>(_onSubmitted);
  }

  void _onUniqueIdChanged(StaffSignInUniqueIdChanged event, Emitter<StaffSignInState> emit) {
    final uniqueId = UniqueIdInput.dirty(event.uniqueId);
    emit(state.copyWith(
      uniqueId: uniqueId,
      status: FormzSubmissionStatus.initial,
    ));
  }

  void _onPinChanged(StaffSignInPinChanged event, Emitter<StaffSignInState> emit) {
    final pin = PinInput.dirty(event.pin);
    emit(state.copyWith(
      pin: pin,
      status: FormzSubmissionStatus.initial,
    ));
  }

  Future<void> _onSubmitted(StaffSignInSubmitted event, Emitter<StaffSignInState> emit) async {
    final uniqueId = UniqueIdInput.dirty(state.uniqueId.value);
    final pin = PinInput.dirty(state.pin.value);

    emit(state.copyWith(
      uniqueId: uniqueId,
      pin: pin,
      status: FormzSubmissionStatus.initial,
    ));

    final isValid = Formz.validate([uniqueId, pin]);
    if (!isValid) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Please fill all fields correctly',
      ));
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final profile = await _repo.signInWithStaff(
        uniqueId: uniqueId.value,
        pin: pin.value,
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
