part of 'products_bloc.dart';

@immutable
sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

class FetchProductsRequested extends ProductsEvent {
  final String businessId;

  const FetchProductsRequested(this.businessId);

  @override
  List<Object?> get props => [businessId];
}
