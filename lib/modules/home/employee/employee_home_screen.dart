import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import '../../../constants/colors.dart';
import '../../../constants/styles.dart';
import '../../../helper/hive_service.dart';
import '../../../route_config/route.gr.dart';
import 'employee_home/bloc/employee_home_bloc.dart';
import 'employee_home/repo/employee_home_repo.dart';
import 'employee_home/employee_home_tab.dart';
import 'employee_sales/employee_sales_tab.dart';
import 'employee_stock/employee_stock_tab.dart';
import 'employee_manage/employee_manage_tab.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@RoutePage()
class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  int _currentIndex = 0;
  static const Color activeColor = Color(0xFF1A2B4A);

  @override
  Widget build(BuildContext context) {
    final userId = HiveService.getUserId() ?? '';

    return BlocProvider(
      create: (context) => EmployeeHomeBloc(repo: EmployeeHomeRepo())
        ..add(FetchEmployeeBusinessRequested(userId)),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: BlocBuilder<EmployeeHomeBloc, EmployeeHomeState>(
            builder: (context, state) {
              if (state.status == FormzSubmissionStatus.inProgress) {
                return const SafeArea(
                  child: Center(
                    child: CircularProgressIndicator(color: activeColor),
                  ),
                );
              }

              if (state.status == FormzSubmissionStatus.failure) {
                return SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.errorMessage ?? 'Failed to load employee assignment',
                            textAlign: TextAlign.center,
                            style: AppStyles.body.copyWith(color: AppColors.error),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<EmployeeHomeBloc>()
                                  .add(FetchEmployeeBusinessRequested(userId));
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
                          'You have not been assigned to any business yet.\nContact your manager.',
                          textAlign: TextAlign.center,
                          style: AppStyles.heading.copyWith(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () async {
                            await Supabase.instance.client.auth.signOut();
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
                  const EmployeeHomeTab(),
                  EmployeeSalesTab(
                    key: ValueKey(_currentIndex == 1 ? DateTime.now() : 'employee_sales'),
                    businessId: businessId,
                  ),
                  EmployeeStockTab(
                    key: ValueKey(_currentIndex == 2 ? DateTime.now() : 'employee_stock'),
                    businessId: businessId,
                  ),
                  EmployeeManageTab(
                    key: ValueKey(_currentIndex == 3 ? DateTime.now() : 'employee_manage'),
                    businessId: businessId,
                  ),
                ],
              );
            },
          ),
          bottomNavigationBar: BlocBuilder<EmployeeHomeBloc, EmployeeHomeState>(
            builder: (context, state) {
              if (state.businessId == null) {
                return const SizedBox.shrink();
              }

              return BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                type: BottomNavigationBarType.fixed,
                selectedItemColor: activeColor,
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
