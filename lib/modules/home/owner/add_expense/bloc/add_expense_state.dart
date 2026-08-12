part of 'add_expense_bloc.dart';

class AddExpenseState extends Equatable {
  final FormzSubmissionStatus status;
  final ExpenseDescriptionInput description;
  final ExpenseAmountInput amount;
  final bool isValid;
  final String? errorMessage;

  const AddExpenseState({
    this.status = FormzSubmissionStatus.initial,
    this.description = const ExpenseDescriptionInput.pure(),
    this.amount = const ExpenseAmountInput.pure(),
    this.isValid = false,
    this.errorMessage,
  });

  AddExpenseState copyWith({
    FormzSubmissionStatus? status,
    ExpenseDescriptionInput? description,
    ExpenseAmountInput? amount,
    bool? isValid,
    String? errorMessage,
  }) {
    return AddExpenseState(
      status: status ?? this.status,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, description, amount, isValid, errorMessage];
}
