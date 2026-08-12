import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import '../stock/stock_screen.dart';
import '../products/products_screen.dart';

enum _InventoryView { options, stock, products }

@RoutePage()
class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  _InventoryView _currentView = _InventoryView.options;

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: AppColors.surface,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 28),
        ),
        title: Text(
          title,
          style: AppStyles.heading.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            subtitle,
            style: AppStyles.label.copyWith(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
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
    if (_currentView == _InventoryView.stock) {
      return StockScreen(
        onBack: () {
          setState(() {
            _currentView = _InventoryView.options;
          });
        },
      );
    }

    if (_currentView == _InventoryView.products) {
      return ProductsScreen(
        onBack: () {
          setState(() {
            _currentView = _InventoryView.options;
          });
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Inventory',
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
              _buildOptionCard(
                icon: Icons.inventory_2_rounded,
                title: 'Stock',
                subtitle: 'View and manage stock levels',
                onTap: () {
                  setState(() {
                    _currentView = _InventoryView.stock;
                  });
                },
              ),
              _buildOptionCard(
                icon: Icons.category_rounded,
                title: 'Products',
                subtitle: 'View and manage products',
                onTap: () {
                  setState(() {
                    _currentView = _InventoryView.products;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
