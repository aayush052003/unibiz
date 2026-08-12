import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';

class ManagerExpenseTab extends StatelessWidget {
  const ManagerExpenseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Expense',
          style: AppStyles.heading.copyWith(color: Colors.white, fontSize: 18),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.receipt_long_rounded,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'Expense Coming Soon',
                style: AppStyles.heading.copyWith(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
