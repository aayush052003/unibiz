import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../model/owner_products_model.dart';
import '../repo/owner_products_repo.dart';

part 'owner_products_event.dart';
part 'owner_products_state.dart';

class OwnerProductsBloc extends Bloc<OwnerProductsEvent, OwnerProductsState> {
  final OwnerProductsRepo repo;

  OwnerProductsBloc({required this.repo}) : super(const OwnerProductsState()) {
    on<FetchOwnerProductsBusinessesRequested>(_onFetchBusinesses);
  }

  Future<void> _onFetchBusinesses(
    FetchOwnerProductsBusinessesRequested event,
    Emitter<OwnerProductsState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final businesses = await repo.fetchOwnerBusinesses(event.ownerId);
      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        businesses: businesses,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
