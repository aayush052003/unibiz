import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../model/expense_business_model.dart';
import '../repo/expense_repo.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepo expenseRepo;

  ExpenseBloc({required this.expenseRepo}) : super(const ExpenseState()) {
    on<FetchExpenseBusinessesRequested>(_onFetchExpenseBusinessesRequested);
  }

  Future<void> _onFetchExpenseBusinessesRequested(
    FetchExpenseBusinessesRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final businesses = await expenseRepo.fetchBusinesses(event.ownerId);
      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        businesses: businesses,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
