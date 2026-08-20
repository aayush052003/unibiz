import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/styles.dart';
import '../../../../../helper/hive_service.dart';
import '../../../../../route_config/route.gr.dart';
import '../../../../../widgets/empty_business_state.dart';
import 'bloc/dashboard_bloc.dart';
import 'model/dashboard_business_model.dart';
import 'repo/dashboard_repo.dart';

@RoutePage()
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with RouteAware {
  DashboardBloc? _dashboardBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshData();
  }

  void _refreshData() {
    final ownerId = HiveService.getUserId();
    if (ownerId != null && ownerId.isNotEmpty && _dashboardBloc != null) {
      _dashboardBloc!.add(FetchDashboardRequested(ownerId));
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  String _formatAmount(double amount) {
    if (amount == 0) return '₹0';
    return '₹${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}';
  }

  Widget _buildTopSummaryCard(DashboardState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Overview",
            style: AppStyles.heading.copyWith(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Revenue Today',
                      style: AppStyles.label.copyWith(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatAmount(state.totalRevenueToday),
                      style: AppStyles.heading.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profit Today',
                      style: AppStyles.label.copyWith(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatAmount(state.totalProfitToday),
                      style: AppStyles.heading.copyWith(
                        color: AppColors.secondary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessCard(DashboardBusinessModel business) {
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
            Text(
              business.name,
              style: AppStyles.heading.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Revenue Today',
                      style: AppStyles.label.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatAmount(business.revenueToday),
                      style: AppStyles.body.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profit Today',
                      style: AppStyles.label.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatAmount(business.profitToday),
                      style: AppStyles.body.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
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
    final firstName = HiveService.getFirstName() ?? '';
    final lastName = HiveService.getLastName() ?? '';
    final ownerId = HiveService.getUserId() ?? '';

    return BlocProvider(
      create: (context) {
        final bloc = DashboardBloc(dashboardRepo: DashboardRepo())
          ..add(FetchDashboardRequested(ownerId));
        _dashboardBloc = bloc;
        return bloc;
      },
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_getGreeting()},',
                          style: AppStyles.label.copyWith(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$firstName $lastName'.trim(),
                          style: AppStyles.heading.copyWith(
                            fontSize: 22,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  Expanded(
                    child: BlocBuilder<DashboardBloc, DashboardState>(
                      builder: (context, state) {
                        if (state.status == FormzSubmissionStatus.inProgress) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          );
                        }
                        if (state.status == FormzSubmissionStatus.failure) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.errorMessage ?? 'Failed to load dashboard',
                                  style: AppStyles.body.copyWith(color: AppColors.error),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<DashboardBloc>()
                                        .add(FetchDashboardRequested(ownerId));
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
                        if (!state.hasBusinesses) {
                          return EmptyBusinessState(
                            onAddBusiness: () async {
                              final refreshed = await context.router
                                  .push<bool>(const AddBusinessRoute());
                              if (refreshed == true && context.mounted) {
                                context
                                    .read<DashboardBloc>()
                                    .add(FetchDashboardRequested(ownerId));
                              }
                            },
                          );
                        }

                        return Column(
                          children: [
                            // Top Section — fixed, not scrollable
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: _buildTopSummaryCard(state),
                            ),
                            // Bottom Section — scrollable business list
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                itemCount: state.businesses.length,
                                itemBuilder: (context, index) {
                                  return _buildBusinessCard(
                                      state.businesses[index]);
                                },
                              ),
                            ),
                          ],
                        );
                      },
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
