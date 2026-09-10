import 'package:equatable/equatable.dart';

enum PeriodType { day, month, year }

class OwnerDataTopSummaryModel extends Equatable {
  final double grossProfit;
  final double expenses;
  final double netProfit;

  const OwnerDataTopSummaryModel({
    this.grossProfit = 0.0,
    this.expenses = 0.0,
    this.netProfit = 0.0,
  });

  @override
  List<Object?> get props => [grossProfit, expenses, netProfit];
}

class BusinessReportModel extends Equatable {
  final String id;
  final String name;
  final String? managerName;
  final double grossProfit;
  final double expenses;
  final double netProfit;

  const BusinessReportModel({
    required this.id,
    required this.name,
    this.managerName,
    this.grossProfit = 0.0,
    this.expenses = 0.0,
    this.netProfit = 0.0,
  });

  factory BusinessReportModel.fromJson({
    required Map<String, dynamic> businessJson,
    String? managerName,
    double grossProfit = 0.0,
    double expenses = 0.0,
  }) {
    return BusinessReportModel(
      id: businessJson['id'] as String,
      name: businessJson['name'] as String,
      managerName: managerName,
      grossProfit: grossProfit,
      expenses: expenses,
      netProfit: grossProfit - expenses,
    );
  }

  @override
  List<Object?> get props => [id, name, managerName, grossProfit, expenses, netProfit];
}
