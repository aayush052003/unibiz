part of 'out_of_stock_bloc.dart';

class OutOfStockState extends Equatable {
  final FormzSubmissionStatus status;
  final List<OutOfStockProductModel> products;
  final String? errorMessage;

  const OutOfStockState({
    this.status = FormzSubmissionStatus.initial,
    this.products = const [],
    this.errorMessage,
  });

  OutOfStockState copyWith({
    FormzSubmissionStatus? status,
    List<OutOfStockProductModel>? products,
    String? errorMessage,
  }) {
    return OutOfStockState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, products, errorMessage];
}
