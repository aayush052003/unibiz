import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../model/employee_out_of_stock_model.dart';
import '../repo/employee_out_of_stock_repo.dart';

part 'employee_out_of_stock_event.dart';
part 'employee_out_of_stock_state.dart';

class EmployeeOutOfStockBloc extends Bloc<EmployeeOutOfStockEvent, EmployeeOutOfStockState> {
  final EmployeeOutOfStockRepo repo;

  EmployeeOutOfStockBloc({required this.repo}) : super(const EmployeeOutOfStockState()) {
    on<FetchEmployeeOutOfStockRequested>(_onFetchProducts);
  }

  Future<void> _onFetchProducts(
    FetchEmployeeOutOfStockRequested event,
    Emitter<EmployeeOutOfStockState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final products = await repo.fetchOutOfStockProducts(event.businessId);
      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        products: products,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
