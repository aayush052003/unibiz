import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../model/dashboard_business_model.dart';
import '../repo/dashboard_repo.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepo _dashboardRepo;

  DashboardBloc({required DashboardRepo dashboardRepo})
      : _dashboardRepo = dashboardRepo,
        super(const DashboardState()) {
    on<FetchDashboardRequested>(_onFetchDashboardRequested);
  }

  Future<void> _onFetchDashboardRequested(
    FetchDashboardRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final dashboardData = await _dashboardRepo.fetchDashboardData(event.ownerId);
      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        hasBusinesses: dashboardData.hasBusinesses,
        businesses: dashboardData.businesses,
        totalRevenueToday: dashboardData.totalRevenueToday,
        totalProfitToday: dashboardData.totalProfitToday,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
