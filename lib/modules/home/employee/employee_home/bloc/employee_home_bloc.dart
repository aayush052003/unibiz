import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../model/low_stock_item_model.dart';
import '../model/recent_sale_model.dart';
import '../repo/employee_home_repo.dart';

part 'employee_home_event.dart';
part 'employee_home_state.dart';

class EmployeeHomeBloc extends Bloc<EmployeeHomeEvent, EmployeeHomeState> {
  final EmployeeHomeRepo repo;

  EmployeeHomeBloc({required this.repo}) : super(const EmployeeHomeState()) {
    on<FetchEmployeeBusinessRequested>(_onFetchBusiness);
    on<RefreshEmployeeHomeRequested>(_onRefresh);
  }

  Future<void> _onFetchBusiness(
    FetchEmployeeBusinessRequested event,
    Emitter<EmployeeHomeState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    await _loadDashboardData(event.userId, emit);
  }

  Future<void> _onRefresh(
    RefreshEmployeeHomeRequested event,
    Emitter<EmployeeHomeState> emit,
  ) async {
    await _loadDashboardData(event.userId, emit);
  }

  Future<void> _loadDashboardData(
    String userId,
    Emitter<EmployeeHomeState> emit,
  ) async {
    try {
      final businessId = await repo.fetchEmployeeBusinessId(userId);
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
