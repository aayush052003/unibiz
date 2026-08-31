import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../repo/employee_home_repo.dart';

part 'employee_home_event.dart';
part 'employee_home_state.dart';

class EmployeeHomeBloc extends Bloc<EmployeeHomeEvent, EmployeeHomeState> {
  final EmployeeHomeRepo repo;

  EmployeeHomeBloc({required this.repo}) : super(const EmployeeHomeState()) {
    on<FetchEmployeeBusinessRequested>(_onFetchBusiness);
  }

  Future<void> _onFetchBusiness(
    FetchEmployeeBusinessRequested event,
    Emitter<EmployeeHomeState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final businessId = await repo.fetchEmployeeBusinessId(event.userId);
      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        businessId: businessId,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
