part of 'expense_bloc.dart';

class ExpenseState extends Equatable {
  final FormzSubmissionStatus status;
  final List<ExpenseBusinessModel> businesses;
  final String? errorMessage;

  const ExpenseState({
    this.status = FormzSubmissionStatus.initial,
    this.businesses = const [],
    this.errorMessage,
  });

  ExpenseState copyWith({
    FormzSubmissionStatus? status,
    List<ExpenseBusinessModel>? businesses,
    String? errorMessage,
  }) {
    return ExpenseState(
      status: status ?? this.status,
      businesses: businesses ?? this.businesses,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, businesses, errorMessage];
}
