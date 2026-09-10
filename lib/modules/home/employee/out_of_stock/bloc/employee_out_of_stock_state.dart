part of 'employee_out_of_stock_bloc.dart';

class EmployeeOutOfStockState extends Equatable {
  final FormzSubmissionStatus status;
  final List<EmployeeOutOfStockProductModel> products;
  final String? errorMessage;

  const EmployeeOutOfStockState({
    this.status = FormzSubmissionStatus.initial,
    this.products = const [],
    this.errorMessage,
  });

  EmployeeOutOfStockState copyWith({
    FormzSubmissionStatus? status,
    List<EmployeeOutOfStockProductModel>? products,
    String? errorMessage,
  }) {
    return EmployeeOutOfStockState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, products, errorMessage];
}
