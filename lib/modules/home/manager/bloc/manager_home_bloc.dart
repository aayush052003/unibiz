import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../model/low_stock_item_model.dart';
import '../model/recent_sale_model.dart';
import '../repo/manager_home_repo.dart';

part 'manager_home_event.dart';
part 'manager_home_state.dart';

class ManagerHomeBloc extends Bloc<ManagerHomeEvent, ManagerHomeState> {
  final ManagerHomeRepo repo;

  ManagerHomeBloc({required this.repo}) : super(const ManagerHomeState()) {
    on<FetchManagerBusinessRequested>(_onFetchBusiness);
    on<RefreshManagerHomeRequested>(_onRefresh);
  }

  Future<void> _onFetchBusiness(
    FetchManagerBusinessRequested event,
    Emitter<ManagerHomeState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    await _loadDashboardData(event.userId, emit);
  }

  Future<void> _onRefresh(
    RefreshManagerHomeRequested event,
    Emitter<ManagerHomeState> emit,
  ) async {
    await _loadDashboardData(event.userId, emit);
  }

  Future<void> _loadDashboardData(
    String userId,
    Emitter<ManagerHomeState> emit,
  ) async {
    try {
      final businessId = await repo.fetchManagerBusinessId(userId);
      if (businessId == null) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.success,
          businessId: null,
          lowStockItems: [],
          recentSales: [],
          outOfStockCount: 0,
        ));
        return;
      }

      final results = await Future.wait([
        repo.fetchLowStockProducts(businessId),
        repo.fetchRecentSales(businessId),
        repo.fetchOutOfStockCount(businessId),
      ]);

      final lowStock = results[0] as List<LowStockItemModel>;
      final recentSales = results[1] as List<RecentSaleModel>;
      final outOfStockCount = results[2] as int;

      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        businessId: businessId,
        lowStockItems: lowStock,
        recentSales: recentSales,
        outOfStockCount: outOfStockCount,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
