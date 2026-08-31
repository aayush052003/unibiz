import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../repo/employee_stock_repo.dart';

part 'employee_stock_event.dart';
part 'employee_stock_state.dart';

class EmployeeStockBloc extends Bloc<EmployeeStockEvent, EmployeeStockState> {
  final EmployeeStockRepo repo;

  EmployeeStockBloc({required this.repo}) : super(const EmployeeStockState()) {
    on<FetchEmployeeStockBusinessRequested>(_onFetchBusiness);
  }

  Future<void> _onFetchBusiness(
    FetchEmployeeStockBusinessRequested event,
    Emitter<EmployeeStockState> emit,
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
