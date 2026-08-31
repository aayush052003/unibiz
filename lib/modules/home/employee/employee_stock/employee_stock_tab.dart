import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../../../../constants/colors.dart';
import '../../../../helper/hive_service.dart';
import '../../../shared/stock/stock_screen.dart';
import 'bloc/employee_stock_bloc.dart';
import 'repo/employee_stock_repo.dart';

class EmployeeStockTab extends StatelessWidget {
  final String? businessId;

  const EmployeeStockTab({super.key, this.businessId});

  @override
  Widget build(BuildContext context) {
    final userId = HiveService.getUserId() ?? '';

    return BlocProvider(
      create: (context) => EmployeeStockBloc(repo: EmployeeStockRepo())
        ..add(FetchEmployeeStockBusinessRequested(userId)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<EmployeeStockBloc, EmployeeStockState>(
            builder: (context, state) {
              if (state.status == FormzSubmissionStatus.inProgress) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (state.status == FormzSubmissionStatus.failure) {
                return Center(
                  child: Text(
                    state.errorMessage ?? 'Failed to load business stock details',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (state.businessId != null) {
                return StockScreen(businessId: state.businessId!);
              }

              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            },
          ),
        ),
      ),
    );
  }
}
