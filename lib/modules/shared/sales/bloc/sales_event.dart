part of 'sales_bloc.dart';

@immutable
sealed class SalesEvent extends Equatable {
  const SalesEvent();

  @override
  List<Object?> get props => [];
}

class FetchSalesDataRequested extends SalesEvent {
  final String businessId;

  const FetchSalesDataRequested(this.businessId);

  @override
  List<Object?> get props => [businessId];
}

class SalesProductChanged extends SalesEvent {
  final SalesProductModel? product;

  const SalesProductChanged(this.product);

  @override
  List<Object?> get props => [product];
}

class SalesBuyingQtyChanged extends SalesEvent {
  final String query;

  const SalesBuyingQtyChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class SalesSellingQtyChanged extends SalesEvent {
  final String query;

  const SalesSellingQtyChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class SalesSubmitted extends SalesEvent {
  final String businessId;

  const SalesSubmitted(this.businessId);

  @override
  List<Object?> get props => [businessId];
}

class RefreshSalesRequested extends SalesEvent {
  final String businessId;

  const RefreshSalesRequested(this.businessId);

  @override
  List<Object?> get props => [businessId];
}

class AddToCartRequested extends SalesEvent {
  const AddToCartRequested();
}

class RemoveFromCartRequested extends SalesEvent {
  final String productId;

  const RemoveFromCartRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ConfirmSaleRequested extends SalesEvent {
  final String businessId;

  const ConfirmSaleRequested(this.businessId);

  @override
  List<Object?> get props => [businessId];
}
