import 'package:flutter/material.dart';
import '../../../shared/products/products_screen.dart';

class ManagerProductsTab extends StatelessWidget {
  final String businessId;

  const ManagerProductsTab({
    super.key,
    required this.businessId,
  });

  @override
  Widget build(BuildContext context) {
    return ProductsScreen(businessId: businessId);
  }
}
