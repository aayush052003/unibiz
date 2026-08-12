part of 'products_bloc.dart';

class ProductsState extends Equatable {
  final FormzSubmissionStatus status;
  final List<ProductsModel> products;
  final String? errorMessage;

  const ProductsState({
    this.status = FormzSubmissionStatus.initial,
    this.products = const [],
    this.errorMessage,
  });

  ProductsState copyWith({
    FormzSubmissionStatus? status,
    List<ProductsModel>? products,
    String? errorMessage,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, products, errorMessage];
}
