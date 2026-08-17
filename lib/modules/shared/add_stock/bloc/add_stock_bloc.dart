import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../../../../helper/hive_service.dart';
import '../../products/model/products_model.dart';
import '../repo/add_stock_repo.dart';

part 'add_stock_event.dart';
part 'add_stock_state.dart';

class AddStockBloc extends Bloc<AddStockEvent, AddStockState> {
  final AddStockRepo repo;

  AddStockBloc({required this.repo}) : super(AddStockState()) {
    on<FetchAddStockProductsRequested>(_onFetchProducts);
    on<AddStockProductChanged>(_onProductChanged);
    on<AddStockQuantityChanged>(_onQuantityChanged);
    on<AddStockPurchasePriceChanged>(_onPurchasePriceChanged);
    on<AddStockSellingPriceChanged>(_onSellingPriceChanged);
    on<AddStockPurchaseDateChanged>(_onPurchaseDateChanged);
    on<AddStockSubmitted>(_onSubmitted);
  }

  Future<void> _onFetchProducts(
    FetchAddStockProductsRequested event,
    Emitter<AddStockState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final products = await repo.fetchProducts(event.businessId);
      emit(state.copyWith(
        status: FormzSubmissionStatus.initial,
        products: products,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onProductChanged(
    AddStockProductChanged event,
    Emitter<AddStockState> emit,
  ) {
    emit(state.copyWith(
      selectedProduct: event.product,
      clearSelectedProduct: event.product == null,
      productError: null,
    ));
  }

  void _onQuantityChanged(
    AddStockQuantityChanged event,
    Emitter<AddStockState> emit,
  ) {
    emit(state.copyWith(
      quantity: event.quantity,
      quantityError: null,
    ));
  }

  void _onPurchasePriceChanged(
    AddStockPurchasePriceChanged event,
    Emitter<AddStockState> emit,
  ) {
    emit(state.copyWith(
      purchasePrice: event.price,
      purchasePriceError: null,
    ));
  }

  void _onSellingPriceChanged(
    AddStockSellingPriceChanged event,
    Emitter<AddStockState> emit,
  ) {
    emit(state.copyWith(
      sellingPrice: event.price,
      sellingPriceError: null,
    ));
  }

  void _onPurchaseDateChanged(
    AddStockPurchaseDateChanged event,
    Emitter<AddStockState> emit,
  ) {
    emit(state.copyWith(
      purchaseDate: event.date,
    ));
  }

  Future<void> _onSubmitted(
    AddStockSubmitted event,
    Emitter<AddStockState> emit,
  ) async {
    bool hasError = false;
    String? productErr;
    String? quantityErr;
    String? purchasePriceErr;
    String? sellingPriceErr;

    if (state.selectedProduct == null) {
      productErr = 'Product is required';
      hasError = true;
    }

    final qty = double.tryParse(state.quantity.trim());
    if (qty == null || qty <= 0) {
      quantityErr = 'Quantity must be greater than 0';
      hasError = true;
    }

    final pPrice = double.tryParse(state.purchasePrice.trim());
    if (pPrice == null || pPrice <= 0) {
      purchasePriceErr = 'Purchase price must be greater than 0';
      hasError = true;
    }

    final sPrice = double.tryParse(state.sellingPrice.trim());
    if (sPrice == null || sPrice <= 0) {
      sellingPriceErr = 'Selling price must be greater than 0';
      hasError = true;
    }

    if (hasError) {
      emit(state.copyWith(
        productError: productErr,
        quantityError: quantityErr,
        purchasePriceError: purchasePriceErr,
        sellingPriceError: sellingPriceErr,
      ));
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final addedBy = HiveService.getUserId() ?? '';
      await repo.addStockBatch(
        productId: state.selectedProduct!.id,
        businessId: event.businessId,
        quantity: qty!,
        purchasePrice: pPrice!,
        sellingPrice: sPrice!,
        purchaseDate: state.purchaseDate,
        addedBy: addedBy,
      );

      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
