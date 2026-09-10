part of 'out_of_stock_bloc.dart';

@immutable
sealed class OutOfStockEvent extends Equatable {
  const OutOfStockEvent();

  @override
  List<Object?> get props => [];
}

class FetchOutOfStockProductsRequested extends OutOfStockEvent {
  final String businessId;

  const FetchOutOfStockProductsRequested(this.businessId);

  @override
  List<Object?> get props => [businessId];
}
