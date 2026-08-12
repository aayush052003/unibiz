import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../../../../../helper/add_business/business_name_input.dart';
import '../model/staff_member_model.dart';
import '../repo/add_business_repo.dart';

part 'add_business_event.dart';
part 'add_business_state.dart';

class AddBusinessBloc extends Bloc<AddBusinessEvent, AddBusinessState> {
  final AddBusinessRepo _addBusinessRepo;

  AddBusinessBloc({required AddBusinessRepo addBusinessRepo})
      : _addBusinessRepo = addBusinessRepo,
        super(const AddBusinessState()) {
    on<LoadStaffRequested>(_onLoadStaffRequested);
    on<BusinessNameChanged>(_onBusinessNameChanged);
    on<ManagerSelected>(_onManagerSelected);
    on<EmployeeToggled>(_onEmployeeToggled);
    on<AddBusinessSubmitted>(_onAddBusinessSubmitted);
  }

  Future<void> _onLoadStaffRequested(
    LoadStaffRequested event,
    Emitter<AddBusinessState> emit,
  ) async {
    emit(state.copyWith(loadStatus: FormzSubmissionStatus.inProgress));
    try {
      final managers = await _addBusinessRepo.fetchUnassignedManagers(event.ownerId);
      final employees = await _addBusinessRepo.fetchUnassignedEmployees(event.ownerId);

      emit(state.copyWith(
        loadStatus: FormzSubmissionStatus.success,
        managers: managers,
        employees: employees,
      ));
    } catch (e) {
      emit(state.copyWith(
        loadStatus: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onBusinessNameChanged(
    BusinessNameChanged event,
    Emitter<AddBusinessState> emit,
  ) {
    final businessName = BusinessNameInput.dirty(event.name);
    emit(state.copyWith(
      businessName: businessName,
      submitStatus: FormzSubmissionStatus.initial,
    ));
  }

  void _onManagerSelected(
    ManagerSelected event,
    Emitter<AddBusinessState> emit,
  ) {
    if (event.managerId == null || event.managerId!.isEmpty) {
      emit(state.copyWith(
        clearSelectedManager: true,
        submitStatus: FormzSubmissionStatus.initial,
      ));
    } else {
      emit(state.copyWith(
        selectedManagerId: event.managerId,
        submitStatus: FormzSubmissionStatus.initial,
      ));
    }
  }

  void _onEmployeeToggled(
    EmployeeToggled event,
    Emitter<AddBusinessState> emit,
  ) {
    final currentSelected = List<String>.from(state.selectedEmployeeIds);
    if (currentSelected.contains(event.employeeId)) {
      currentSelected.remove(event.employeeId);
    } else {
      currentSelected.add(event.employeeId);
    }
    emit(state.copyWith(
      selectedEmployeeIds: currentSelected,
      submitStatus: FormzSubmissionStatus.initial,
    ));
  }

  Future<void> _onAddBusinessSubmitted(
    AddBusinessSubmitted event,
    Emitter<AddBusinessState> emit,
  ) async {
    final businessName = BusinessNameInput.dirty(state.businessName.value);
    final isValid = Formz.validate([businessName]);

    emit(state.copyWith(businessName: businessName));

    if (!isValid) return;

    emit(state.copyWith(submitStatus: FormzSubmissionStatus.inProgress));

    try {
      await _addBusinessRepo.createBusiness(
        name: state.businessName.value.trim(),
        ownerId: event.ownerId,
        selectedManagerId: state.selectedManagerId,
        selectedEmployeeIds: state.selectedEmployeeIds,
      );
      emit(state.copyWith(submitStatus: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        submitStatus: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
