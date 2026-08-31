import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../model/expense_model.dart';
import '../repo/expense_detail_repo.dart';

part 'expense_detail_event.dart';
part 'expense_detail_state.dart';

class ExpenseDetailBloc extends Bloc<ExpenseDetailEvent, ExpenseDetailState> {
  final ExpenseDetailRepo expenseDetailRepo;

  ExpenseDetailBloc({required this.expenseDetailRepo})
      : super(const ExpenseDetailState()) {
    on<FetchExpensesRequested>(_onFetchExpensesRequested);
  }

  Future<void> _onFetchExpensesRequested(
    FetchExpensesRequested event,
    Emitter<ExpenseDetailState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final expenses = await expenseDetailRepo.fetchExpenses(event.businessId);
      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        expenses: expenses,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
