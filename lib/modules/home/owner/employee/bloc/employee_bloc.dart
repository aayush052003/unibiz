import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../model/employee_model.dart';
import '../repo/employee_repo.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepo _employeeRepo;

  EmployeeBloc({required EmployeeRepo employeeRepo})
      : _employeeRepo = employeeRepo,
        super(const EmployeeState()) {
    on<FetchEmployeesRequested>(_onFetchEmployeesRequested);
  }

  Future<void> _onFetchEmployeesRequested(
    FetchEmployeesRequested event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final employees = await _employeeRepo.fetchEmployees(event.ownerId);
      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        employees: employees,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
