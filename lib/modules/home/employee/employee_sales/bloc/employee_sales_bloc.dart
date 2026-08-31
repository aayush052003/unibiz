import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../repo/employee_sales_repo.dart';

part 'employee_sales_event.dart';
part 'employee_sales_state.dart';

class EmployeeSalesBloc extends Bloc<EmployeeSalesEvent, EmployeeSalesState> {
  final EmployeeSalesRepo repo;

  EmployeeSalesBloc({required this.repo}) : super(const EmployeeSalesState()) {
    on<FetchEmployeeSalesBusinessRequested>(_onFetchBusiness);
  }

  Future<void> _onFetchBusiness(
    FetchEmployeeSalesBusinessRequested event,
    Emitter<EmployeeSalesState> emit,
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
