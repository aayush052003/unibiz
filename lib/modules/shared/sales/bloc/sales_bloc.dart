import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../../../../helper/hive_service.dart';
import '../repo/sales_repo.dart';
import '../model/sales_product_model.dart';
import '../model/sales_history_model.dart';
import '../model/cart_item_model.dart';

part 'sales_event.dart';
part 'sales_state.dart';

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  final SalesRepo repo;

  SalesBloc({required this.repo}) : super(const SalesState()) {
    on<FetchSalesDataRequested>(_onFetchSalesDataRequested);
    on<SalesProductChanged>(_onProductChanged);
    on<SalesBuyingQtyChanged>(_onBuyingQtyChanged);
    on<SalesSellingQtyChanged>(_onSellingQtyChanged);
    on<SalesSubmitted>(_onSubmitted);
    on<RefreshSalesRequested>(_onRefreshSalesRequested);
    on<AddToCartRequested>(_onAddToCart);
    on<RemoveFromCartRequested>(_onRemoveFromCart);
    on<ConfirmSaleRequested>(_onConfirmSale);
  }

  Future<void> _onFetchSalesDataRequested(
    FetchSalesDataRequested event,
    Emitter<SalesState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final results = await Future.wait([
        repo.fetchProductsWithStock(event.businessId),
        repo.fetchSalesHistory(event.businessId),
      ]);

      final products = results[0] as List<SalesProductModel>;
      final history = results[1] as List<SalesHistoryModel>;

      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        products: products,
        salesHistory: history,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onProductChanged(
    SalesProductChanged event,
    Emitter<SalesState> emit,
  ) {
    emit(state.copyWith(
      selectedProduct: event.product,
      buyingQtyStr: '',
      sellingQtyStr: '',
      clearProduct: event.product == null,
    ));
  }

  void _onBuyingQtyChanged(
    SalesBuyingQtyChanged event,
    Emitter<SalesState> emit,
  ) {
    emit(state.copyWith(buyingQtyStr: event.query));
  }

  void _onSellingQtyChanged(
    SalesSellingQtyChanged event,
    Emitter<SalesState> emit,
  ) {
    emit(state.copyWith(sellingQtyStr: event.query));
  }

  Future<void> _onSubmitted(
    SalesSubmitted event,
    Emitter<SalesState> emit,
  ) async {
    // Keep for backward compatibility or delegate to confirm sale
    add(ConfirmSaleRequested(event.businessId));
  }

  void _onAddToCart(
    AddToCartRequested event,
    Emitter<SalesState> emit,
  ) {
    final selected = state.selectedProduct;
    if (selected == null) {
      emit(state.copyWith(errorMessage: 'Please select a product'));
      return;
    }

    if (!state.isQuantityValid) {
      emit(state.copyWith(errorMessage: 'Quantity must be greater than 0'));
      return;
    }

    if (!state.isStockAvailable) {
      emit(state.copyWith(errorMessage: 'Not enough stock available'));
      return;
    }

    final list = List<CartItemModel>.from(state.cartItems);
    final idx = list.indexWhere((item) => item.product.id == selected.id);

    if (idx != -1) {
      // Merge quantities
      final existing = list[idx];
      final newBuying = existing.buyingQty + state.buyingQuantity;
      final newSelling = existing.sellingQty + state.sellingQuantity;
      
      final updatedItem = CartItemModel(
        product: selected,
        buyingQty: newBuying,
        sellingQty: newSelling,
      );

      if (updatedItem.totalSellingUnits > selected.totalStockInSellingUnits) {
        emit(state.copyWith(errorMessage: 'Cannot add more than available stock'));
        return;
      }

      list[idx] = updatedItem;
    } else {
      list.add(CartItemModel(
        product: selected,
        buyingQty: state.buyingQuantity,
        sellingQty: state.sellingQuantity,
      ));
    }

    emit(state.copyWith(
      cartItems: list,
      clearProduct: true,
      successMessage: 'Product added to cart!',
    ));
  }

  void _onRemoveFromCart(
    RemoveFromCartRequested event,
    Emitter<SalesState> emit,
  ) {
    final list = List<CartItemModel>.from(state.cartItems);
    list.removeWhere((item) => item.product.id == event.productId);
    emit(state.copyWith(cartItems: list));
  }

  Future<void> _onConfirmSale(
    ConfirmSaleRequested event,
    Emitter<SalesState> emit,
  ) async {
    if (state.cartItems.isEmpty) {
      emit(state.copyWith(errorMessage: 'Cart is empty'));
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final soldBy = HiveService.getUserId() ?? '';

      // Validate actual database stock is sufficient for all cart items one final time
      final latestProducts = await repo.fetchProductsWithStock(event.businessId);
      for (final item in state.cartItems) {
        final dbProduct = latestProducts.firstWhere(
          (p) => p.id == item.product.id,
          orElse: () => throw Exception('Product ${item.product.name} is out of stock in database'),
        );
        if (dbProduct.totalStockInSellingUnits < item.totalSellingUnits) {
          throw Exception('Insufficient stock for ${item.product.name}. Database: ${dbProduct.totalStockInSellingUnits.toStringAsFixed(dbProduct.totalStockInSellingUnits % 1 == 0 ? 0 : 1)} available.');
        }
      }
      
      // Perform database updates
      await repo.recordCartSale(
        businessId: event.businessId,
        items: state.cartItems,
        soldBy: soldBy,
      );

      // On success, refresh the products and history list, and clear fields
      final results = await Future.wait([
        repo.fetchProductsWithStock(event.businessId),
        repo.fetchSalesHistory(event.businessId),
      ]);

      final products = results[0] as List<SalesProductModel>;
      final history = results[1] as List<SalesHistoryModel>;

      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        products: products,
        salesHistory: history,
        cartItems: [],
        clearProduct: true,
        successMessage: 'Sale completed successfully',
      ));
    } catch (e) {
      try {
        final products = await repo.fetchProductsWithStock(event.businessId);
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          products: products,
          errorMessage: e.toString(),
        ));
      } catch (_) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  Future<void> _onRefreshSalesRequested(
    RefreshSalesRequested event,
    Emitter<SalesState> emit,
  ) async {
    try {
      final results = await Future.wait([
        repo.fetchProductsWithStock(event.businessId),
        repo.fetchSalesHistory(event.businessId),
      ]);

      final products = results[0] as List<SalesProductModel>;
      final history = results[1] as List<SalesHistoryModel>;

      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        products: products,
        salesHistory: history,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
