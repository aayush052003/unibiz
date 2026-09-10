import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import '../../../../helper/hive_service.dart';
import '../../../../route_config/route.gr.dart';
import '../bloc/manager_home_bloc.dart';
import '../repo/manager_home_repo.dart';
import 'manager_home_tab.dart';
import '../manager_sales/manager_sales_tab.dart';
import '../manager_stock/manager_stock_tab.dart';
import '../manager_products/manager_products_tab.dart';
import '../manager_manage/manager_manage_tab.dart';

@RoutePage()
class ManagerHomeScreen extends StatefulWidget {
  const ManagerHomeScreen({super.key});

  @override
  State<ManagerHomeScreen> createState() => _ManagerHomeScreenState();
}

class _ManagerHomeScreenState extends State<ManagerHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userId = HiveService.getUserId() ?? '';

    return BlocProvider(
      create: (context) => ManagerHomeBloc(repo: ManagerHomeRepo())
        ..add(FetchManagerBusinessRequested(userId)),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: BlocBuilder<ManagerHomeBloc, ManagerHomeState>(
            builder: (context, state) {
              if (state.status == FormzSubmissionStatus.inProgress && state.businessId == null) {
                return const SafeArea(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              }

              if (state.status == FormzSubmissionStatus.failure && state.businessId == null) {
                return SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.errorMessage ?? 'Failed to load manager assignment',
                            textAlign: TextAlign.center,
                            style: AppStyles.body.copyWith(color: AppColors.error),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<ManagerHomeBloc>()
                                  .add(FetchManagerBusinessRequested(userId));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              if (state.businessId == null) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 64,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'You have not been assigned to any business yet.\nContact your owner.',
                          textAlign: TextAlign.center,
                          style: AppStyles.heading.copyWith(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () async {
                            await HiveService.clearSession();
                            if (context.mounted) {
                              context.router
                                  .replaceAll([const RoleSelectionRoute()]);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Sign Out',
                            style: AppStyles.buttonText.copyWith(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final businessId = state.businessId!;

              return IndexedStack(
                index: _currentIndex,
                children: [
                  const ManagerHomeTab(),
                  ManagerSalesTab(
                    key: ValueKey(_currentIndex == 1 ? DateTime.now() : 'manager_sales'),
                    businessId: businessId,
                  ),
                  ManagerStockTab(
                    key: ValueKey(_currentIndex == 2 ? DateTime.now() : 'manager_stock'),
                    businessId: businessId,
                  ),
                  ManagerProductsTab(
                    key: ValueKey(_currentIndex == 3 ? DateTime.now() : 'manager_products'),
                    businessId: businessId,
                  ),
                  const ManagerManageTab(),
                ],
              );
            },
          ),
          bottomNavigationBar: BlocBuilder<ManagerHomeBloc, ManagerHomeState>(
            builder: (context, state) {
              if (state.businessId == null) {
                return const SizedBox.shrink();
              }

              return BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  if (index == 0 && _currentIndex != 0) {
                    context
                        .read<ManagerHomeBloc>()
                        .add(RefreshManagerHomeRequested(userId));
                  }
                  setState(() {
                    _currentIndex = index;
                  });
                },
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: true,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_rounded),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.point_of_sale_rounded),
                    label: 'Sales',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.inventory_2_rounded),
                    label: 'Stock',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.category_rounded),
                    label: 'Products',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings_rounded),
                    label: 'Manage',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
