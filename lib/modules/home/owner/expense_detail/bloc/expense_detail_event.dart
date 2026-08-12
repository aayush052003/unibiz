part of 'expense_detail_bloc.dart';

@immutable
sealed class ExpenseDetailEvent extends Equatable {
  const ExpenseDetailEvent();

  @override
  List<Object?> get props => [];
}

final class FetchExpensesRequested extends ExpenseDetailEvent {
  final String businessId;

  const FetchExpensesRequested(this.businessId);

  @override
  List<Object?> get props => [businessId];
}
