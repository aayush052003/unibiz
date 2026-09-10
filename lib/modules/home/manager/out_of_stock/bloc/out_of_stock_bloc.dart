import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../model/out_of_stock_product_model.dart';
import '../repo/out_of_stock_repo.dart';

part 'out_of_stock_event.dart';
part 'out_of_stock_state.dart';

class OutOfStockBloc extends Bloc<OutOfStockEvent, OutOfStockState> {
  final ManagerOutOfStockRepo repo;

  OutOfStockBloc({required this.repo}) : super(const OutOfStockState()) {
    on<FetchOutOfStockProductsRequested>(_onFetchProducts);
  }

  Future<void> _onFetchProducts(
    FetchOutOfStockProductsRequested event,
    Emitter<OutOfStockState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final products = await repo.fetchOutOfStockProducts(event.businessId);
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
