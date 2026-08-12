import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import '../../../../helper/hive_service.dart';
import 'bloc/business_detail_bloc.dart';
import 'model/business_detail_model.dart';
import 'repo/business_detail_repo.dart';

@RoutePage()
class BusinessDetailScreen extends StatelessWidget {
  final String businessId;
  final String businessName;

  const BusinessDetailScreen({
    super.key,
    required this.businessId,
    required this.businessName,
  });

  void _openAssignManagerBottomSheet(
    BuildContext context,
    BusinessDetailRepo repo,
    MemberProfileModel? currentManager,
  ) async {
    final ownerId = HiveService.getUserId() ?? '';
    final bloc = context.read<BusinessDetailBloc>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (bottomSheetContext) {
        return FutureBuilder<List<MemberProfileModel>>(
          future: repo.fetchAvailableManagers(
            ownerId: ownerId,
            businessId: businessId,
            currentManager: currentManager,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 250,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            }

            if (snapshot.hasError) {
              return SizedBox(
                height: 250,
                child: Center(
                  child: Text(
                    'Error loading managers: ${snapshot.error}',
                    style: AppStyles.body.copyWith(color: AppColors.error),
                  ),
                ),
              );
            }

            final managers = snapshot.data ?? [];
            if (managers.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'No managers available, create one first',
                      textAlign: TextAlign.center,
                      style: AppStyles.heading.copyWith(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Manager',
                    style: AppStyles.heading.copyWith(
                      fontSize: 18,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: managers.length,
                      itemBuilder: (context, index) {
                        final mgr = managers[index];
                        final isSelected = currentManager?.id == mgr.id;

                        return ListTile(
                          title: Text(mgr.fullName, style: AppStyles.heading.copyWith(fontSize: 16)),
                          subtitle: Text(
                            mgr.uniqueId != null ? 'ID: ${mgr.uniqueId}' : '',
                            style: AppStyles.label,
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle, color: AppColors.primary)
                              : null,
                          onTap: () {
                            bloc.add(ManagerAssigned(mgr));
                            Navigator.pop(bottomSheetContext);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openAddEmployeeBottomSheet(
    BuildContext context,
    BusinessDetailRepo repo,
    List<MemberProfileModel> currentEmployees,
  ) async {
    final ownerId = HiveService.getUserId() ?? '';
    final bloc = context.read<BusinessDetailBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return FutureBuilder<List<MemberProfileModel>>(
              future: repo.fetchAvailableEmployees(
                ownerId: ownerId,
                businessId: businessId,
                currentEmployees: currentEmployees,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return SizedBox(
                    height: 300,
                    child: Center(
                      child: Text(
                        'Error loading employees: ${snapshot.error}',
                        style: AppStyles.body.copyWith(color: AppColors.error),
                      ),
                    ),
                  );
                }

                final employees = snapshot.data ?? [];
                if (employees.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'No employees available, create one first',
                          textAlign: TextAlign.center,
                          style: AppStyles.heading.copyWith(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                }

                final selectedMap = <String, MemberProfileModel>{};
                for (final emp in currentEmployees) {
                  selectedMap[emp.id] = emp;
                }

                return Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: StatefulBuilder(
                    builder: (context, setInnerState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Employees',
                            style: AppStyles.heading.copyWith(
                              fontSize: 18,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView.builder(
                              itemCount: employees.length,
                              itemBuilder: (context, index) {
                                final emp = employees[index];
                                final isChecked = selectedMap.containsKey(emp.id);

                                return CheckboxListTile(
                                  activeColor: AppColors.primary,
                                  title: Text(emp.fullName,
                                      style: AppStyles.heading.copyWith(fontSize: 16)),
                                  subtitle: Text(
                                    emp.uniqueId != null ? 'ID: ${emp.uniqueId}' : '',
                                    style: AppStyles.label,
                                  ),
                                  value: isChecked,
                                  onChanged: (val) {
                                    setInnerState(() {
                                      if (val == true) {
                                        selectedMap[emp.id] = emp;
                                      } else {
                                        selectedMap.remove(emp.id);
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () {
                                bloc.add(EmployeesUpdated(selectedMap.values.toList()));
                                Navigator.pop(bottomSheetContext);
                              },
                              child: Text(
                                'Confirm',
                                style: AppStyles.buttonText.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = BusinessDetailRepo();

    return BlocProvider(
      create: (context) => BusinessDetailBloc(
        repo: repo,
        businessId: businessId,
      )
        ..add(InitialBusinessNameSet(businessName))
        ..add(const FetchBusinessDetailRequested()),
      child: BlocConsumer<BusinessDetailBloc, BusinessDetailState>(
        listener: (context, state) {
          if (state.saveStatus == FormzSubmissionStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Changes saved successfully'),
                backgroundColor: Colors.green,
              ),
            );
            context.router.maybePop(true);
          } else if (state.saveStatus == FormzSubmissionStatus.failure ||
              state.status == FormzSubmissionStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final bloc = context.read<BusinessDetailBloc>();

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: Text(
                'Business Detail',
                style: AppStyles.heading.copyWith(color: Colors.white, fontSize: 18),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
            ),

            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: state.status == FormzSubmissionStatus.inProgress
                        ? const Center(
                            child: CircularProgressIndicator(color: AppColors.primary),
                          )
                        : ListView(
                            padding: const EdgeInsets.all(24.0),
                            children: [
                              // BUSINESS NAME SECTION
                              Text(
                                'Business Name',
                                style: AppStyles.heading.copyWith(
                                  fontSize: 18,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                initialValue: state.businessNameInput.value.isEmpty
                                    ? businessName
                                    : state.businessNameInput.value,
                                onChanged: (value) {
                                  bloc.add(BusinessNameChanged(value));
                                },
                                decoration: InputDecoration(
                                  labelText: 'Business Name',
                                  hintText: 'Enter business name',
                                  errorText: state.businessNameInput.displayError != null
                                      ? 'Business name cannot be empty'
                                      : null,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: AppColors.textSecondary),
                                  ),

                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                  ),
                                  fillColor: AppColors.surface,
                                  filled: true,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // MANAGER SECTION
                              Text(
                                'Manager',
                                style: AppStyles.heading.copyWith(
                                  fontSize: 18,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Card(
                                color: AppColors.surface,
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: state.isManagerChanged
                                      ? const BorderSide(color: AppColors.secondary, width: 2)
                                      : BorderSide.none,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (state.pendingManager != null) ...[
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    state.pendingManager!.fullName,
                                                    style: AppStyles.heading.copyWith(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  if (state.pendingManager!.uniqueId != null)
                                                    Text(
                                                      'ID: ${state.pendingManager!.uniqueId}',
                                                      style: AppStyles.label,
                                                    ),
                                                ],
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                bloc.add(const ManagerRemoved());
                                              },
                                              child: Text(
                                                'Remove',
                                                style: AppStyles.body.copyWith(
                                                  color: AppColors.error,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ] else ...[
                                        Text(
                                          'No Manager Assigned',
                                          style: AppStyles.body.copyWith(
                                            color: AppColors.textSecondary,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: double.infinity,
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(color: AppColors.primary),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () {
                                            _openAssignManagerBottomSheet(
                                              context,
                                              repo,
                                              state.pendingManager,
                                            );
                                          },
                                          child: Text(
                                            'Assign Manager',
                                            style: AppStyles.body.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // EMPLOYEES SECTION
                              Text(
                                'Employees',
                                style: AppStyles.heading.copyWith(
                                  fontSize: 18,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 12),

                              if (state.pendingEmployees.isEmpty)
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'No employees assigned yet',
                                    style: AppStyles.body.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              else
                                ...state.pendingEmployees.map((emp) {
                                  final isAdded = !state.originalEmployees
                                      .any((e) => e.id == emp.id);

                                  return Card(
                                    color: AppColors.surface,
                                    elevation: 1,
                                    margin: const EdgeInsets.only(bottom: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: isAdded
                                          ? const BorderSide(color: AppColors.secondary, width: 2)
                                          : BorderSide.none,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 12.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  emp.fullName,
                                                  style: AppStyles.heading.copyWith(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                if (emp.uniqueId != null)
                                                  Text(
                                                    'ID: ${emp.uniqueId}',
                                                    style: AppStyles.label,
                                                  ),
                                              ],
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              bloc.add(EmployeeRemoved(emp.id));
                                            },
                                            child: Text(
                                              'Remove',
                                              style: AppStyles.body.copyWith(
                                                color: AppColors.error,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),

                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.primary),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    _openAddEmployeeBottomSheet(
                                      context,
                                      repo,
                                      state.pendingEmployees,
                                    );
                                  },
                                  child: Text(
                                    'Add Employee',
                                    style: AppStyles.body.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),

                  // SAVE BUTTON AT BOTTOM
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: state.saveStatus == FormzSubmissionStatus.inProgress
                            ? null
                            : () {
                                bloc.add(const SaveChangesRequested());
                              },
                        child: state.saveStatus == FormzSubmissionStatus.inProgress
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'Save',
                                style: AppStyles.buttonText.copyWith(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

