import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../constants/colors.dart';
import '../../../../helper/hive_service.dart';
import '../dashboard/dashboard_screen.dart';
import '../data/data_screen.dart';
import '../data/bloc/owner_data_bloc.dart';
import '../data/repo/owner_data_repo.dart';
import '../inventory/inventory_screen.dart';
import '../sales/sales_screen.dart';
import '../manage/manage_screen.dart';

@RoutePage()
class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            DashboardScreen(key: UniqueKey()),
            BlocProvider(
              create: (context) => OwnerDataBloc(repo: OwnerDataRepo())
                ..add(OwnerDataInitialLoadRequested(HiveService.getUserId() ?? '')),
              child: const DataScreen(),
            ),
            InventoryScreen(key: ValueKey(_currentIndex == 2 ? DateTime.now() : 'inventory')),
            const SalesScreen(),
            const ManageScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
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
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: 'Data',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_rounded),
              label: 'Inventory',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.point_of_sale_rounded),
              label: 'Sales',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'Manage',
            ),
          ],
        ),
      ),
    );
  }
}
