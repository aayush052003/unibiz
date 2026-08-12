import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import '../../../../helper/hive_service.dart';
import '../../../../route_config/route.gr.dart';
import '../business_list/bloc/business_list_bloc.dart';
import '../business_list/model/business_list_model.dart';
import '../business_list/repo/business_list_repo.dart';

@RoutePage()
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  Widget _buildBusinessCard(BuildContext context, BusinessListModel business) {
    return Card(
      color: AppColors.surface,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () async {
          await context.router.push(
            BusinessDetailRoute(
              businessId: business.id,
              businessName: business.name,
            ),
          );
          if (context.mounted) {
            final ownerId = HiveService.getUserId() ?? '';
            context
                .read<BusinessListBloc>()
                .add(FetchBusinessListRequested(ownerId));
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                business.name,
                style: AppStyles.heading.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Manager: ',
                    style: AppStyles.label.copyWith(fontSize: 14),
                  ),
                  Text(
                    business.managerName ?? 'No Manager Assigned',
                    style: AppStyles.body.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: business.managerName != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Employees: ',
                    style: AppStyles.label.copyWith(fontSize: 14),
                  ),
                  Text(
                    '${business.employeeCount}',
                    style: AppStyles.body.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
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
      create: (context) => BusinessListBloc(businessListRepo: BusinessListRepo())
        ..add(FetchBusinessListRequested(ownerId)),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: Text(
                'Shop',
                style: AppStyles.heading.copyWith(color: Colors.white, fontSize: 18),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () async {
                final refreshed =
                    await context.router.push<bool>(const AddBusinessRoute());
                if (refreshed == true && context.mounted) {
                  context
                      .read<BusinessListBloc>()
                      .add(FetchBusinessListRequested(ownerId));
                }
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
            body: SafeArea(
              child: BlocBuilder<BusinessListBloc, BusinessListState>(
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
                            state.errorMessage ?? 'Failed to load business list',
                            style: AppStyles.body.copyWith(color: AppColors.error),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<BusinessListBloc>()
                                  .add(FetchBusinessListRequested(ownerId));
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
                          "You haven't added any business yet",
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
