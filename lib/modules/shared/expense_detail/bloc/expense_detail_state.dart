part of 'expense_detail_bloc.dart';

class ExpenseDetailState extends Equatable {
  final FormzSubmissionStatus status;
  final List<ExpenseModel> expenses;
  final String? errorMessage;

  const ExpenseDetailState({
    this.status = FormzSubmissionStatus.initial,
    this.expenses = const [],
    this.errorMessage,
  });

  ExpenseDetailState copyWith({
    FormzSubmissionStatus? status,
    List<ExpenseModel>? expenses,
    String? errorMessage,
  }) {
    return ExpenseDetailState(
      status: status ?? this.status,
      expenses: expenses ?? this.expenses,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, expenses, errorMessage];
}
