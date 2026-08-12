import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../model/business_list_model.dart';
import '../repo/business_list_repo.dart';

part 'business_list_event.dart';
part 'business_list_state.dart';

class BusinessListBloc extends Bloc<BusinessListEvent, BusinessListState> {
  final BusinessListRepo _businessListRepo;

  BusinessListBloc({required BusinessListRepo businessListRepo})
      : _businessListRepo = businessListRepo,
        super(const BusinessListState()) {
    on<FetchBusinessListRequested>(_onFetchBusinessListRequested);
  }

  Future<void> _onFetchBusinessListRequested(
    FetchBusinessListRequested event,
    Emitter<BusinessListState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final businesses = await _businessListRepo.fetchBusinesses(event.ownerId);
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
