import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import '../../../../helper/hive_service.dart';
import '../../../../route_config/route.gr.dart';

class EmployeeManageTab extends StatelessWidget {
  final String businessId;

  const EmployeeManageTab({
    super.key,
    required this.businessId,
  });

  Widget _buildManageTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: AppStyles.heading.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }

  Future<void> _navigateToExpense(BuildContext context) async {
    try {
      final userId = HiveService.getUserId();
      if (userId == null) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );

      final response = await Supabase.instance.client
          .from('business_members')
          .select('business_id, businesses(name)')
          .eq('user_id', userId)
          .eq('role', 'employee')
          .maybeSingle();

      if (context.mounted) {
        Navigator.of(context).pop(); // Dismiss loader
      }

      if (response != null && response['business_id'] != null) {
        final bId = response['business_id'] as String;
        final businessName = (response['businesses'] as Map<String, dynamic>?)?['name'] as String? ?? 'Business';

        if (context.mounted) {
          context.router.push(
            ExpenseDetailRoute(
              businessId: bId,
              businessName: businessName,
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No business assigned to this employee'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Dismiss loader
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Manage',
          style: AppStyles.heading.copyWith(color: Colors.white, fontSize: 18),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildManageTile(
                icon: Icons.receipt_long_outlined,
                title: 'Expense',
                onTap: () => _navigateToExpense(context),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  await Supabase.instance.client.auth.signOut();
                  await HiveService.clearSession();
                  if (context.mounted) {
                    context.router.replaceAll([const RoleSelectionRoute()]);
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
  }
}
