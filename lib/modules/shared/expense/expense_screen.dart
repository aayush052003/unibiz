import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import '../../../../helper/hive_service.dart';
import '../../../../route_config/route.gr.dart';
import 'bloc/expense_bloc.dart';
import 'model/expense_business_model.dart';
import 'repo/expense_repo.dart';

@RoutePage()
class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  Widget _buildBusinessCard(BuildContext context, ExpenseBusinessModel business) {
    return Card(
      color: AppColors.surface,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          context.router.push(
            ExpenseDetailRoute(
              businessId: business.id,
              businessName: business.name,
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                business.name,
                style: AppStyles.heading.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ownerId = HiveService.getUserId() ?? '';

    return BlocProvider(
      create: (context) => ExpenseBloc(expenseRepo: ExpenseRepo())
        ..add(FetchExpenseBusinessesRequested(ownerId)),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: Text(
                'Expense',
                style: AppStyles.heading.copyWith(color: Colors.white, fontSize: 18),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
            ),
            body: SafeArea(
              child: BlocBuilder<ExpenseBloc, ExpenseState>(
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
                            state.errorMessage ?? 'Failed to load businesses',
                            style: AppStyles.body.copyWith(color: AppColors.error),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<ExpenseBloc>()
                                  .add(FetchExpenseBusinessesRequested(ownerId));
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

                  if (state.businesses.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          "No businesses found",
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
                    itemCount: state.businesses.length,
                    itemBuilder: (context, index) {
                      return _buildBusinessCard(context, state.businesses[index]);
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
