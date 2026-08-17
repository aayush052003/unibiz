import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../repo/stock_repo.dart';
import '../model/stock_product_model.dart';
import '../model/purchase_history_model.dart';

part 'stock_event.dart';
part 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  final StockRepo repo;

  StockBloc({required this.repo}) : super(const StockState()) {
    on<FetchStockDataRequested>(_onFetchStockDataRequested);
    on<StockSearchQueryChanged>(_onSearchQueryChanged);
    on<RefreshStockRequested>(_onRefreshStockRequested);
  }

  Future<void> _onFetchStockDataRequested(
    FetchStockDataRequested event,
    Emitter<StockState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final results = await Future.wait([
        repo.fetchStock(event.businessId),
        repo.fetchPurchaseHistory(event.businessId),
      ]);

      final products = results[0] as List<StockProductModel>;
      final history = results[1] as List<PurchaseHistoryModel>;

      final filtered = _filterProducts(products, state.searchQuery);

      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        products: products,
        filteredProducts: filtered,
        purchaseHistory: history,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSearchQueryChanged(
    StockSearchQueryChanged event,
    Emitter<StockState> emit,
  ) {
    final filtered = _filterProducts(state.products, event.query);
    emit(state.copyWith(
      searchQuery: event.query,
      filteredProducts: filtered,
    ));
  }

  Future<void> _onRefreshStockRequested(
    RefreshStockRequested event,
    Emitter<StockState> emit,
  ) async {
    try {
      final results = await Future.wait([
        repo.fetchStock(event.businessId),
        repo.fetchPurchaseHistory(event.businessId),
      ]);

      final products = results[0] as List<StockProductModel>;
      final history = results[1] as List<PurchaseHistoryModel>;

      final filtered = _filterProducts(products, state.searchQuery);

      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        products: products,
        filteredProducts: filtered,
        purchaseHistory: history,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  List<StockProductModel> _filterProducts(List<StockProductModel> products, String query) {
    if (query.trim().isEmpty) return products;
    final q = query.trim().toLowerCase();
    return products.where((p) => p.name.toLowerCase().contains(q)).toList();
  }
}
