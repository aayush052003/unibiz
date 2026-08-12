import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import '../../../../helper/hive_service.dart';
import '../../../../helper/add_business/business_name_input.dart';
import 'bloc/add_business_bloc.dart';
import 'repo/add_business_repo.dart';

@RoutePage()
class AddBusinessScreen extends StatelessWidget {
  const AddBusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ownerId = HiveService.getUserId() ?? '';

    return BlocProvider(
      create: (context) => AddBusinessBloc(addBusinessRepo: AddBusinessRepo())
        ..add(LoadStaffRequested(ownerId)),
      child: BlocConsumer<AddBusinessBloc, AddBusinessState>(
        listener: (context, state) {
          if (state.submitStatus == FormzSubmissionStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Business created successfully'),
                backgroundColor: AppColors.success,
              ),
            );
            context.router.maybePop(true);
          } else if (state.submitStatus == FormzSubmissionStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Failed to create business'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isSubmitting = state.submitStatus == FormzSubmissionStatus.inProgress;
          final isLoading = state.loadStatus == FormzSubmissionStatus.inProgress;

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: Text(
                'Add Business',
                style: AppStyles.heading.copyWith(color: Colors.white, fontSize: 18),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
            ),
            body: SafeArea(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Business Name Field
                          TextFormField(
                            onChanged: (value) => context
                                .read<AddBusinessBloc>()
                                .add(BusinessNameChanged(value)),
                            decoration: AppStyles.inputDecoration(
                              hintText: 'Enter business name',
                              labelText: 'Business Name',
                            ).copyWith(
                              errorText: state.businessName.displayError ==
                                      BusinessNameValidationError.empty
                                  ? 'Business name is required'
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Assign Manager Field
                          Text(
                            'Assign Manager',
                            style: AppStyles.label.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (state.managers.isEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: AppColors.textSecondary
                                        .withOpacity(0.5)),
                              ),
                              child: Text(
                                'No managers available',
                                style: AppStyles.body.copyWith(
                                    color: AppColors.textSecondary),
                              ),
                            )
                          else
                            DropdownButtonFormField<String?>(
                              value: state.selectedManagerId,
                              decoration: AppStyles.inputDecoration(
                                hintText: 'Select manager',
                                labelText: 'Manager',
                              ),
                              items: [
                                const DropdownMenuItem<String?>(
                                  value: null,
                                  child: Text('No Manager'),
                                ),
                                ...state.managers.map(
                                  (manager) => DropdownMenuItem<String?>(
                                    value: manager.id,
                                    child: Text(manager.fullName),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                context
                                    .read<AddBusinessBloc>()
                                    .add(ManagerSelected(value));
                              },
                            ),
                          const SizedBox(height: 20),

                          // Assign Employees Field
                          Text(
                            'Assign Employees',
                            style: AppStyles.label.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (state.employees.isEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: AppColors.textSecondary
                                        .withOpacity(0.5)),
                              ),
                              child: Text(
                                'No employees available',
                                style: AppStyles.body.copyWith(
                                    color: AppColors.textSecondary),
                              ),
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: state.employees.map((employee) {
                                    final isSelected = state.selectedEmployeeIds
                                        .contains(employee.id);
                                    return FilterChip(
                                      selected: isSelected,
                                      label: Text(employee.fullName),
                                      labelStyle: AppStyles.body.copyWith(
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.textPrimary,
                                        fontSize: 14,
                                      ),
                                      selectedColor: AppColors.primary,
                                      backgroundColor: AppColors.surface,
                                      checkmarkColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.textSecondary
                                                  .withOpacity(0.5),
                                        ),
                                      ),
                                      onSelected: (_) {
                                        context
                                            .read<AddBusinessBloc>()
                                            .add(EmployeeToggled(employee.id));
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          const SizedBox(height: 32),

                          // Submit Button
                          ElevatedButton(
                            onPressed: isSubmitting
                                ? null
                                : () {
                                    context
                                        .read<AddBusinessBloc>()
                                        .add(AddBusinessSubmitted(ownerId));
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Create Business',
                                    style: AppStyles.buttonText.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
