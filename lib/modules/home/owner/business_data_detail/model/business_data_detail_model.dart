import 'package:equatable/equatable.dart';

class BusinessSummaryCardsModel extends Equatable {
  final double grossProfit;
  final double expenses;
  final double netProfit;

  const BusinessSummaryCardsModel({
    this.grossProfit = 0.0,
    this.expenses = 0.0,
    this.netProfit = 0.0,
  });

  @override
  List<Object?> get props => [grossProfit, expenses, netProfit];
}

class DetailSaleItemModel extends Equatable {
  final String id;
  final String productName;
  final String? productImageUrl;
  final double quantitySold;
  final String sellingUnit;
  final double totalAmount;
  final double profit;
  final String soldByName;
  final DateTime createdAt;

  const DetailSaleItemModel({
    required this.id,
    required this.productName,
    this.productImageUrl,
    required this.quantitySold,
    required this.sellingUnit,
    required this.totalAmount,
    required this.profit,
    required this.soldByName,
    required this.createdAt,
  });

  factory DetailSaleItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['products'] as Map<String, dynamic>? ?? {};
    final profile = json['profiles'] as Map<String, dynamic>? ?? {};

    final firstName = profile['first_name'] as String? ?? '';
    final lastName = profile['last_name'] as String? ?? '';
    final fullName = '$firstName $lastName'.trim();

    return DetailSaleItemModel(
      id: json['id'] as String,
      productName: product['name'] as String? ?? 'Unknown Product',
      productImageUrl: product['image_url'] as String?,
      quantitySold: (json['quantity_sold'] as num?)?.toDouble() ?? 0.0,
      sellingUnit: product['selling_unit'] as String? ?? '',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      profit: (json['profit'] as num?)?.toDouble() ?? 0.0,
      soldByName: fullName.isNotEmpty ? fullName : 'Unknown',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        productName,
        productImageUrl,
        quantitySold,
        sellingUnit,
        totalAmount,
        profit,
        soldByName,
        createdAt,
      ];
}

class DetailExpenseItemModel extends Equatable {
  final String id;
  final String description;
  final double amount;
  final String addedByName;
  final DateTime createdAt;

  const DetailExpenseItemModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.addedByName,
    required this.createdAt,
  });

  factory DetailExpenseItemModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profiles'] as Map<String, dynamic>? ?? {};
    final firstName = profile['first_name'] as String? ?? '';
    final lastName = profile['last_name'] as String? ?? '';
    final fullName = '$firstName $lastName'.trim();

    return DetailExpenseItemModel(
      id: json['id'] as String,
      description: json['description'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      addedByName: fullName.isNotEmpty ? fullName : 'Unknown',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  @override
  List<Object?> get props => [id, description, amount, addedByName, createdAt];
}

class PeriodSummaryRowModel extends Equatable {
  final String label; // e.g. "25 Aug" or "August 2026"
  final DateTime date; // for sorting newest first
  final double grossProfit;
  final double expenses;

  const PeriodSummaryRowModel({
    required this.label,
    required this.date,
    this.grossProfit = 0.0,
    this.expenses = 0.0,
  });

  @override
  List<Object?> get props => [label, date, grossProfit, expenses];
}
