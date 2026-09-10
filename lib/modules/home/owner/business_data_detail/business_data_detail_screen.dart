import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import '../data/model/owner_data_model.dart';
import 'bloc/business_data_detail_bloc.dart';
import 'model/business_data_detail_model.dart';
import 'repo/business_data_detail_repo.dart';

@RoutePage()
class BusinessDataDetailScreen extends StatefulWidget {
  final String businessId;
  final PeriodType periodType;
  final DateTime selectedDate;
  final int selectedMonth;
  final int selectedYear;

  const BusinessDataDetailScreen({
    super.key,
    required this.businessId,
    required this.periodType,
    required this.selectedDate,
    required this.selectedMonth,
    required this.selectedYear,
  });

  @override
  State<BusinessDataDetailScreen> createState() => _BusinessDataDetailScreenState();
}

class _BusinessDataDetailScreenState extends State<BusinessDataDetailScreen> {
  static const List<String> _monthsShort = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  static const List<String> _monthsFull = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  String _formatAmount(double amount) {
    if (amount == 0) return '₹0';
    return '₹${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}';
  }

  String _formatTime(DateTime dateTime) {
    final localTime = dateTime.toLocal();
    final hour = localTime.hour == 0
        ? 12
        : (localTime.hour > 12 ? localTime.hour - 12 : localTime.hour);
    final amPm = localTime.hour >= 12 ? 'PM' : 'AM';
    final minute = localTime.minute.toString().padLeft(2, '0');
    return '${hour.toString().padLeft(2, '0')}:$minute $amPm';
  }

  String _getPeriodSubtitle() {
    switch (widget.periodType) {
      case PeriodType.day:
        final d = widget.selectedDate;
        final monthStr = _monthsShort[d.month - 1];
        return '${d.day} $monthStr ${d.year}';
      case PeriodType.month:
        final monthStr = _monthsFull[widget.selectedMonth - 1];
        return '$monthStr ${widget.selectedYear}';
      case PeriodType.year:
        return '${widget.selectedYear}';
    }
  }

  Widget _buildTopSummaryCards(BusinessDataDetailState state) {
    if (widget.periodType == PeriodType.day) {
      // Day View: 2 cards (Gross Profit and Expenses)
      return Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Gross Profit',
              value: _formatAmount(state.summaryCards.grossProfit),
              valueColor: AppColors.secondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              title: 'Expenses',
              value: _formatAmount(state.summaryCards.expenses),
              valueColor: AppColors.error,
            ),
          ),
        ],
      );
    } else {
      // Month and Year View: 3 cards (Gross Profit, Expenses, Net Profit)
      return Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Gross Profit',
              value: _formatAmount(state.summaryCards.grossProfit),
              valueColor: AppColors.secondary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryCard(
              title: 'Expenses',
              value: _formatAmount(state.summaryCards.expenses),
              valueColor: AppColors.error,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryCard(
              title: 'Net Profit',
              value: _formatAmount(state.summaryCards.netProfit),
              valueColor: AppColors.success,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppStyles.label.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppStyles.heading.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillTabs(BuildContext context, int activeIndex) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                context
                    .read<BusinessDataDetailBloc>()
                    .add(const BusinessDataDetailTabChanged(0));
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: activeIndex == 0 ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(26),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Sales',
                  style: AppStyles.body.copyWith(
                    color: activeIndex == 0 ? Colors.white : Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                context
                    .read<BusinessDataDetailBloc>()
                    .add(const BusinessDataDetailTabChanged(1));
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: activeIndex == 1 ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(26),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Expenses',
                  style: AppStyles.body.copyWith(
                    color: activeIndex == 1 ? Colors.white : Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaleItemCard(DetailSaleItemModel sale) {
    return Card(
      color: AppColors.surface,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.04),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 48,
                height: 48,
                color: Colors.grey.shade100,
                child: sale.productImageUrl != null && sale.productImageUrl!.isNotEmpty
                    ? Image.network(
                        sale.productImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.inventory_2_outlined, color: Colors.grey),
                      )
                    : const Icon(Icons.inventory_2_outlined, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            // Middle: Name, Qty sold, Sold by, Time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sale.productName,
                    style: AppStyles.heading.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${sale.quantitySold.toStringAsFixed(sale.quantitySold.truncateToDouble() == sale.quantitySold ? 0 : 2)} ${sale.sellingUnit}',
                    style: AppStyles.body.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'By: ${sale.soldByName}',
                        style: AppStyles.label.copyWith(fontSize: 11),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• ${_formatTime(sale.createdAt)}',
                        style: AppStyles.label.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Right: Amount and Profit in green
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatAmount(sale.totalAmount),
                  style: AppStyles.heading.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Profit: ${_formatAmount(sale.profit)}',
                  style: AppStyles.body.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseItemCard(DetailExpenseItemModel expense) {
    return Card(
      color: AppColors.surface,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.04),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.description,
                    style: AppStyles.heading.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Added by: ${expense.addedByName}',
                        style: AppStyles.label.copyWith(fontSize: 11),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• ${_formatTime(expense.createdAt)}',
                        style: AppStyles.label.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              _formatAmount(expense.amount),
              style: AppStyles.heading.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSummaryRow(PeriodSummaryRowModel row) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              row.label,
              style: AppStyles.heading.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Gross Profit',
                  style: AppStyles.label.copyWith(fontSize: 10),
                ),
                Text(
                  _formatAmount(row.grossProfit),
                  style: AppStyles.body.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Expenses',
                  style: AppStyles.label.copyWith(fontSize: 10),
                ),
                Text(
                  _formatAmount(row.expenses),
                  style: AppStyles.body.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BusinessDataDetailBloc(repo: BusinessDataDetailRepo())
        ..add(FetchBusinessDataDetailRequested(
          businessId: widget.businessId,
          periodType: widget.periodType,
          selectedDate: widget.selectedDate,
          selectedMonth: widget.selectedMonth,
          selectedYear: widget.selectedYear,
        )),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.router.maybePop(),
              ),
              title: BlocBuilder<BusinessDataDetailBloc, BusinessDataDetailState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.businessName.isNotEmpty
                            ? state.businessName
                            : 'Business Details',
                        style: AppStyles.heading.copyWith(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _getPeriodSubtitle(),
                        style: AppStyles.label.copyWith(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            body: SafeArea(
              child: BlocBuilder<BusinessDataDetailBloc, BusinessDataDetailState>(
                builder: (context, state) {
                  if (state.status == FormzSubmissionStatus.inProgress) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  if (state.status == FormzSubmissionStatus.failure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.errorMessage ?? 'Failed to load details',
                            style: AppStyles.body.copyWith(color: AppColors.error),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<BusinessDataDetailBloc>()
                                  .add(FetchBusinessDataDetailRequested(
                                    businessId: widget.businessId,
                                    periodType: widget.periodType,
                                    selectedDate: widget.selectedDate,
                                    selectedMonth: widget.selectedMonth,
                                    selectedYear: widget.selectedYear,
                                  ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      // Top Section Cards (24px horizontal padding)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                        child: _buildTopSummaryCards(state),
                      ),

                      // Detail Content based on Period Type
                      Expanded(
                        child: widget.periodType == PeriodType.day
                            ? _buildDayViewContent(context, state)
                            : _buildMonthOrYearViewContent(state),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDayViewContent(BuildContext context, BusinessDataDetailState state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: _buildPillTabs(context, state.activeTabIndex),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: state.activeTabIndex == 0
              ? (state.sales.isEmpty
                  ? Center(
                      child: Text(
                        'No sales recorded for this day',
                        style: AppStyles.body.copyWith(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      itemCount: state.sales.length,
                      itemBuilder: (context, index) {
                        return _buildSaleItemCard(state.sales[index]);
                      },
                    ))
              : (state.expenses.isEmpty
                  ? Center(
                      child: Text(
                        'No expenses recorded for this day',
                        style: AppStyles.body.copyWith(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      itemCount: state.expenses.length,
                      itemBuilder: (context, index) {
                        return _buildExpenseItemCard(state.expenses[index]);
                      },
                    )),
        ),
      ],
    );
  }

  Widget _buildMonthOrYearViewContent(BusinessDataDetailState state) {
    if (state.periodSummaries.isEmpty) {
      return Center(
        child: Text(
          widget.periodType == PeriodType.month
              ? 'No data for this month'
              : 'No data for this year',
          style: AppStyles.body.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    return Card(
      color: AppColors.surface,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.04),
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: state.periodSummaries.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
        itemBuilder: (context, index) {
          return _buildPeriodSummaryRow(state.periodSummaries[index]);
        },
      ),
    );
  }
}
