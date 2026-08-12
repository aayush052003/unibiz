part of 'add_expense_bloc.dart';

@immutable
sealed class AddExpenseEvent extends Equatable {
  const AddExpenseEvent();

  @override
  List<Object?> get props => [];
}

final class DescriptionChanged extends AddExpenseEvent {
  final String description;

  const DescriptionChanged(this.description);

  @override
  List<Object?> get props => [description];
}

final class AmountChanged extends AddExpenseEvent {
  final String amount;

  const AmountChanged(this.amount);

  @override
  List<Object?> get props => [amount];
}

final class AddExpenseSubmitted extends AddExpenseEvent {
  final String businessId;

  const AddExpenseSubmitted(this.businessId);

  @override
  List<Object?> get props => [businessId];
}
