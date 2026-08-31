import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../../../../constants/colors.dart';
import '../../../../helper/hive_service.dart';
import '../../../shared/sales/sales_screen.dart';
import 'bloc/employee_sales_bloc.dart';
import 'repo/employee_sales_repo.dart';

class EmployeeSalesTab extends StatelessWidget {
  final String? businessId;

  const EmployeeSalesTab({super.key, this.businessId});

  @override
  Widget build(BuildContext context) {
    final userId = HiveService.getUserId() ?? '';

    return BlocProvider(
      create: (context) => EmployeeSalesBloc(repo: EmployeeSalesRepo())
        ..add(FetchEmployeeSalesBusinessRequested(userId)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<EmployeeSalesBloc, EmployeeSalesState>(
            builder: (context, state) {
              if (state.status == FormzSubmissionStatus.inProgress) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (state.status == FormzSubmissionStatus.failure) {
                return Center(
                  child: Text(
                    state.errorMessage ?? 'Failed to load business sales details',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (state.businessId != null) {
                return SharedSalesScreen(businessId: state.businessId!);
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
