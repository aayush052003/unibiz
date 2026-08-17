part of 'stock_bloc.dart';

@immutable
sealed class StockEvent extends Equatable {
  const StockEvent();

  @override
  List<Object?> get props => [];
}

class FetchStockDataRequested extends StockEvent {
  final String businessId;

  const FetchStockDataRequested(this.businessId);

  @override
  List<Object?> get props => [businessId];
}

class StockSearchQueryChanged extends StockEvent {
  final String query;

  const StockSearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class RefreshStockRequested extends StockEvent {
  final String businessId;

  const RefreshStockRequested(this.businessId);

  @override
  List<Object?> get props => [businessId];
}
