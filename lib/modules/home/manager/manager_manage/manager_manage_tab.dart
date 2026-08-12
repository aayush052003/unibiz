import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import '../../../../helper/hive_service.dart';
import '../../../../route_config/route.gr.dart';

class ManagerManageTab extends StatelessWidget {
  const ManagerManageTab({super.key});

  Widget _buildManageTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      color: AppColors.surface,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
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
      ),
    );
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
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      title: Text(
                        'Expense',
                        style: AppStyles.heading.copyWith(fontSize: 16),
                      ),
                      content: Text(
                        'Expense Coming Soon',
                        style: AppStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text(
                            'OK',
                            style: AppStyles.body.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
