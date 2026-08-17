import 'package:flutter/material.dart';
import '../../../shared/stock/stock_screen.dart';

class ManagerStockTab extends StatelessWidget {
  final String businessId;

  const ManagerStockTab({
    super.key,
    required this.businessId,
  });

  @override
  Widget build(BuildContext context) {
    return StockScreen(businessId: businessId);
  }
}
