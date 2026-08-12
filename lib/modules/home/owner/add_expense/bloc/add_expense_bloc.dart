import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../../../../../helper/add_expense/expense_amount_input.dart';
import '../../../../../helper/add_expense/expense_description_input.dart';
import '../../../../../helper/hive_service.dart';
import '../repo/add_expense_repo.dart';

part 'add_expense_event.dart';
part 'add_expense_state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  final AddExpenseRepo addExpenseRepo;

  AddExpenseBloc({required this.addExpenseRepo}) : super(const AddExpenseState()) {
    on<DescriptionChanged>(_onDescriptionChanged);
    on<AmountChanged>(_onAmountChanged);
    on<AddExpenseSubmitted>(_onAddExpenseSubmitted);
  }

  void _onDescriptionChanged(
    DescriptionChanged event,
    Emitter<AddExpenseState> emit,
  ) {
    final description = ExpenseDescriptionInput.dirty(event.description);
    emit(state.copyWith(
      description: description,
      isValid: Formz.validate([description, state.amount]),
    ));
  }

  void _onAmountChanged(
    AmountChanged event,
    Emitter<AddExpenseState> emit,
  ) {
    final amount = ExpenseAmountInput.dirty(event.amount);
    emit(state.copyWith(
      amount: amount,
      isValid: Formz.validate([state.description, amount]),
    ));
  }

  Future<void> _onAddExpenseSubmitted(
    AddExpenseSubmitted event,
    Emitter<AddExpenseState> emit,
  ) async {
    final description = ExpenseDescriptionInput.dirty(state.description.value);
    final amount = ExpenseAmountInput.dirty(state.amount.value);

    final isValid = Formz.validate([description, amount]);
    emit(state.copyWith(
      description: description,
      amount: amount,
      isValid: isValid,
    ));

    if (!isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final userId = HiveService.getUserId() ?? '';
      final parsedAmount = double.parse(state.amount.value.trim());

      await addExpenseRepo.addExpense(
        businessId: event.businessId,
        description: state.description.value.trim(),
        amount: parsedAmount,
        addedBy: userId,
      );

      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
