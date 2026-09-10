import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../../data/model/owner_data_model.dart';
import '../model/business_data_detail_model.dart';
import '../repo/business_data_detail_repo.dart';

part 'business_data_detail_event.dart';
part 'business_data_detail_state.dart';

class BusinessDataDetailBloc
    extends Bloc<BusinessDataDetailEvent, BusinessDataDetailState> {
  final BusinessDataDetailRepo _repo;

  BusinessDataDetailBloc({required BusinessDataDetailRepo repo})
      : _repo = repo,
        super(const BusinessDataDetailState()) {
    on<FetchBusinessDataDetailRequested>(_onFetchDetailRequested);
    on<BusinessDataDetailTabChanged>(_onTabChanged);
  }

  Future<void> _onFetchDetailRequested(
    FetchBusinessDataDetailRequested event,
    Emitter<BusinessDataDetailState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final detailData = await _repo.fetchDetailData(
        businessId: event.businessId,
        periodType: event.periodType,
        selectedDate: event.selectedDate,
        selectedMonth: event.selectedMonth,
        selectedYear: event.selectedYear,
      );

      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        businessName: detailData.businessName,
        summaryCards: detailData.summaryCards,
        sales: detailData.sales,
        expenses: detailData.expenses,
        periodSummaries: detailData.periodSummaries,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onTabChanged(
    BusinessDataDetailTabChanged event,
    Emitter<BusinessDataDetailState> emit,
  ) {
    emit(state.copyWith(activeTabIndex: event.tabIndex));
  }
}
