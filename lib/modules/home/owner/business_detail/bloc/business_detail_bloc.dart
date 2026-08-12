import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../../../../../helper/add_business/business_name_input.dart';
import '../model/business_detail_model.dart';
import '../repo/business_detail_repo.dart';



part 'business_detail_event.dart';
part 'business_detail_state.dart';

class BusinessDetailBloc
    extends Bloc<BusinessDetailEvent, BusinessDetailState> {
  final BusinessDetailRepo _repo;
  final String _businessId;

  BusinessDetailBloc({
    required BusinessDetailRepo repo,
    required String businessId,
  })  : _repo = repo,
        _businessId = businessId,
        super(const BusinessDetailState()) {
    on<InitialBusinessNameSet>(_onInitialBusinessNameSet);
    on<BusinessNameChanged>(_onBusinessNameChanged);
    on<FetchBusinessDetailRequested>(_onFetchRequested);
    on<ManagerAssigned>(_onManagerAssigned);
    on<ManagerRemoved>(_onManagerRemoved);
    on<EmployeesUpdated>(_onEmployeesUpdated);
    on<EmployeeRemoved>(_onEmployeeRemoved);
    on<SaveChangesRequested>(_onSaveChangesRequested);
  }

  void _onInitialBusinessNameSet(
    InitialBusinessNameSet event,
    Emitter<BusinessDetailState> emit,
  ) {
    if (state.originalBusinessName.isEmpty) {
      emit(state.copyWith(
        originalBusinessName: event.name,
        businessNameInput: BusinessNameInput.dirty(event.name),
      ));
    }
  }

  void _onBusinessNameChanged(
    BusinessNameChanged event,
    Emitter<BusinessDetailState> emit,
  ) {
    final input = BusinessNameInput.dirty(event.name);
    emit(state.copyWith(businessNameInput: input));
  }


  Future<void> _onFetchRequested(
    FetchBusinessDetailRequested event,
    Emitter<BusinessDetailState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final manager = await _repo.fetchCurrentManager(_businessId);
      final employees = await _repo.fetchCurrentEmployees(_businessId);

      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        originalManager: manager,
        pendingManager: manager,
        originalEmployees: employees,
        pendingEmployees: employees,
        hasManager: manager != null,
        clearManager: manager == null,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onManagerAssigned(
    ManagerAssigned event,
    Emitter<BusinessDetailState> emit,
  ) {
    emit(state.copyWith(
      pendingManager: event.manager,
      hasManager: true,
    ));
  }

  void _onManagerRemoved(
    ManagerRemoved event,
    Emitter<BusinessDetailState> emit,
  ) {
    emit(state.copyWith(
      clearManager: true,
    ));
  }

  void _onEmployeesUpdated(
    EmployeesUpdated event,
    Emitter<BusinessDetailState> emit,
  ) {
    emit(state.copyWith(
      pendingEmployees: event.employees,
    ));
  }

  void _onEmployeeRemoved(
    EmployeeRemoved event,
    Emitter<BusinessDetailState> emit,
  ) {
    final updatedList =
        state.pendingEmployees.where((e) => e.id != event.employeeId).toList();
    emit(state.copyWith(
      pendingEmployees: updatedList,
    ));
  }

  Future<void> _onSaveChangesRequested(
    SaveChangesRequested event,
    Emitter<BusinessDetailState> emit,
  ) async {
    if (state.saveStatus == FormzSubmissionStatus.inProgress) return;

    final nameInput = BusinessNameInput.dirty(state.businessNameInput.value);
    if (!nameInput.isValid) {
      emit(state.copyWith(
        businessNameInput: nameInput,
        saveStatus: FormzSubmissionStatus.failure,
        errorMessage: 'Business name cannot be empty',
      ));
      return;
    }

    emit(state.copyWith(
      businessNameInput: nameInput,
      saveStatus: FormzSubmissionStatus.inProgress,
    ));

    try {
      final updatedName = state.businessNameInput.value.trim();

      await _repo.saveBusinessChanges(
        businessId: _businessId,
        originalName: state.originalBusinessName,
        pendingName: updatedName,
        originalManager: state.originalManager,
        pendingManager: state.pendingManager,
        originalEmployees: state.originalEmployees,
        pendingEmployees: state.pendingEmployees,
      );

      final manager = await _repo.fetchCurrentManager(_businessId);
      final employees = await _repo.fetchCurrentEmployees(_businessId);

      emit(state.copyWith(
        saveStatus: FormzSubmissionStatus.success,
        status: FormzSubmissionStatus.success,
        originalBusinessName: updatedName,
        businessNameInput: BusinessNameInput.pure(),
        originalManager: manager,
        pendingManager: manager,
        originalEmployees: employees,
        pendingEmployees: employees,
        hasManager: manager != null,
        clearManager: manager == null,
      ));
    } catch (e) {
      emit(state.copyWith(
        saveStatus: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

}

