import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import '../../../../helper/hive_service.dart';
import '../../../../route_config/route.gr.dart';
import '../products/bloc/owner_products_bloc.dart';
import '../products/model/owner_products_model.dart';
import '../products/repo/owner_products_repo.dart';

@RoutePage()
class SalesScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const SalesScreen({
    super.key,
    this.onBack,
  });

  Widget _buildBusinessCard(BuildContext context, OwnerProductsModel business) {
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
            SharedSalesRoute(businessId: business.id),
          );
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
      create: (context) => OwnerProductsBloc(repo: OwnerProductsRepo())
        ..add(FetchOwnerProductsBusinessesRequested(ownerId)),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: Text(
                'Select Business for Sales',
                style: AppStyles.heading.copyWith(color: Colors.white, fontSize: 18),
              ),
              leading: onBack != null
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: onBack,
                    )
                  : (context.router.canPop()
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => context.router.maybePop(),
                        )
                      : null),
              elevation: 0,
            ),
            body: SafeArea(
              child: BlocBuilder<OwnerProductsBloc, OwnerProductsState>(
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
                                  .read<OwnerProductsBloc>()
                                  .add(FetchOwnerProductsBusinessesRequested(ownerId));
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No businesses added yet",
                              textAlign: TextAlign.center,
                              style: AppStyles.heading.copyWith(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.router.push(const AddBusinessRoute());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Add Business',
                                style: AppStyles.buttonText,
                              ),
                            ),
                          ],
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
