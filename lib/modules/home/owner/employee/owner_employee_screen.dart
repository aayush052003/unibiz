import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import '../../../../helper/hive_service.dart';
import '../../../../route_config/route.gr.dart';
import 'bloc/employee_bloc.dart';
import 'model/employee_model.dart';
import 'repo/employee_repo.dart';

@RoutePage()
class OwnerEmployeeScreen extends StatelessWidget {
  const OwnerEmployeeScreen({super.key});

  Widget _buildEmployeeCard(EmployeeModel employee) {
    final roleText = employee.role.isNotEmpty
        ? '${employee.role[0].toUpperCase()}${employee.role.substring(1).toLowerCase()}'
        : employee.role;

    return Card(
      color: AppColors.surface,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  employee.fullName,
                  style: AppStyles.heading.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    employee.uniqueId,
                    style: AppStyles.body.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Role: ',
                  style: AppStyles.label.copyWith(fontSize: 14),
                ),
                Text(
                  roleText,
                  style: AppStyles.body.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Business Assigned: ',
                  style: AppStyles.label.copyWith(fontSize: 14),
                ),
                Text(
                  employee.businessName ?? 'Not Assigned',
                  style: AppStyles.body.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: employee.businessName != null
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ownerId = HiveService.getUserId() ?? '';

    return BlocProvider(
      create: (context) => EmployeeBloc(employeeRepo: EmployeeRepo())
        ..add(FetchEmployeesRequested(ownerId)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text(
            'Employee List',
            style: AppStyles.heading.copyWith(color: Colors.white, fontSize: 18),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            backgroundColor: AppColors.primary,
            onPressed: () async {
              final refreshed = await context.router.push<bool>(const AddEmployeeRoute());
              if (refreshed == true && context.mounted) {
                context.read<EmployeeBloc>().add(FetchEmployeesRequested(ownerId));
              }
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<EmployeeBloc, EmployeeState>(
            builder: (context, state) {
              if (state.status == FormzSubmissionStatus.inProgress) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (state.status == FormzSubmissionStatus.failure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.errorMessage ?? 'Failed to load employees',
                        style: AppStyles.body.copyWith(color: AppColors.error),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<EmployeeBloc>()
                              .add(FetchEmployeesRequested(ownerId));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state.employees.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      "You haven't added any manager or employee yet",
                      textAlign: TextAlign.center,
                      style: AppStyles.heading.copyWith(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(24.0),
                itemCount: state.employees.length,
                itemBuilder: (context, index) {
                  return _buildEmployeeCard(state.employees[index]);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
