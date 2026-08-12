import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';

class StockScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const StockScreen({
    super.key,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Stock',
          style: AppStyles.heading.copyWith(color: Colors.white, fontSize: 18),
        ),
        leading: onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: onBack,
              )
            : null,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.inventory_2_rounded,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'Stock Management Coming Soon',
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
