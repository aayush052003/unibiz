part of 'add_stock_bloc.dart';

@immutable
sealed class AddStockEvent extends Equatable {
  const AddStockEvent();

  @override
  List<Object?> get props => [];
}

class FetchAddStockProductsRequested extends AddStockEvent {
  final String businessId;

  const FetchAddStockProductsRequested(this.businessId);

  @override
  List<Object?> get props => [businessId];
}

class AddStockProductChanged extends AddStockEvent {
  final ProductsModel? product;

  const AddStockProductChanged(this.product);

  @override
  List<Object?> get props => [product];
}

class AddStockQuantityChanged extends AddStockEvent {
  final String quantity;

  const AddStockQuantityChanged(this.quantity);

  @override
  List<Object?> get props => [quantity];
}

class AddStockPurchasePriceChanged extends AddStockEvent {
  final String price;

  const AddStockPurchasePriceChanged(this.price);

  @override
  List<Object?> get props => [price];
}

class AddStockSellingPriceChanged extends AddStockEvent {
  final String price;

  const AddStockSellingPriceChanged(this.price);

  @override
  List<Object?> get props => [price];
}

class AddStockPurchaseDateChanged extends AddStockEvent {
  final DateTime date;

  const AddStockPurchaseDateChanged(this.date);

  @override
  List<Object?> get props => [date];
}

class AddStockSubmitted extends AddStockEvent {
  final String businessId;

  const AddStockSubmitted(this.businessId);

  @override
  List<Object?> get props => [businessId];
}
