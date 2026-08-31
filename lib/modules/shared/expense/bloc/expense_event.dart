part of 'expense_bloc.dart';

@immutable
sealed class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

final class FetchExpenseBusinessesRequested extends ExpenseEvent {
  final String ownerId;

  const FetchExpenseBusinessesRequested(this.ownerId);

  @override
  List<Object?> get props => [ownerId];
}
