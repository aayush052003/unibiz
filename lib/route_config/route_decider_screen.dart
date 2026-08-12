import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../helper/hive_service.dart';
import 'route.gr.dart';

@RoutePage()
class RouteDeciderScreen extends StatefulWidget {
  const RouteDeciderScreen({super.key});

  @override
  State<RouteDeciderScreen> createState() => _RouteDeciderScreenState();
}

class _RouteDeciderScreenState extends State<RouteDeciderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _decideNavigation();
    });
  }

  void _decideNavigation() {
    if (HiveService.isLoggedIn()) {
      final role = HiveService.getRole();
      if (role == 'owner') {
        context.router.replaceAll([const OwnerHomeRoute()]);
      } else if (role == 'manager') {
        context.router.replaceAll([const ManagerHomeRoute()]);
      } else if (role == 'employee') {
        context.router.replaceAll([const EmployeeHomeRoute()]);
      } else {
        context.router.replaceAll([const RoleSelectionRoute()]);
      }
    } else {
      context.router.replaceAll([const RoleSelectionRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
