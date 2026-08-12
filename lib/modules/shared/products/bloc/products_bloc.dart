import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../model/products_model.dart';
import '../repo/products_repo.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepo productsRepo;

  ProductsBloc({required this.productsRepo}) : super(const ProductsState()) {
    on<FetchProductsRequested>(_onFetchProductsRequested);
  }

  Future<void> _onFetchProductsRequested(
    FetchProductsRequested event,
    Emitter<ProductsState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final products = await productsRepo.fetchProducts(event.businessId);
      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        products: products,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
