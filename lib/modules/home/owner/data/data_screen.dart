import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import '../../../../helper/hive_service.dart';
import '../../../../route_config/route.gr.dart';
import 'bloc/owner_data_bloc.dart';
import 'model/owner_data_model.dart';
import 'repo/owner_data_repo.dart';

@RoutePage()
class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  static const List<String> _monthsShort = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  String _formatAmount(double amount) {
    if (amount == 0) return '₹0';
    return '₹${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}';
  }

  Widget _buildTopSummaryCards(OwnerDataTopSummaryModel summary) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'Gross Profit',
            value: _formatAmount(summary.grossProfit),
            valueColor: AppColors.secondary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSummaryCard(
            title: 'Expenses',
            value: _formatAmount(summary.expenses),
            valueColor: AppColors.error,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSummaryCard(
            title: 'Net Profit',
            value: _formatAmount(summary.netProfit),
            valueColor: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
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

  Widget _buildFilterToggles(
    BuildContext context,
    OwnerDataState state,
    String ownerId,
  ) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _buildFilterPillItem(
            label: 'Day',
            isSelected: state.periodType == PeriodType.day,
            onTap: () {
              context.read<OwnerDataBloc>().add(
                    OwnerDataPeriodTypeChanged(
                      periodType: PeriodType.day,
                      ownerId: ownerId,
                    ),
                  );
            },
          ),
          _buildFilterPillItem(
            label: 'Month',
            isSelected: state.periodType == PeriodType.month,
            onTap: () {
              context.read<OwnerDataBloc>().add(
                    OwnerDataPeriodTypeChanged(
                      periodType: PeriodType.month,
                      ownerId: ownerId,
                    ),
                  );
            },
          ),
          _buildFilterPillItem(
            label: 'Year',
            isSelected: state.periodType == PeriodType.year,
            onTap: () {
              context.read<OwnerDataBloc>().add(
                    OwnerDataPeriodTypeChanged(
                      periodType: PeriodType.year,
                      ownerId: ownerId,
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPillItem({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppStyles.body.copyWith(
              color: isSelected ? Colors.white : Colors.grey.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterField(
    BuildContext context,
    OwnerDataState state,
    String ownerId,
  ) {
    switch (state.periodType) {
      case PeriodType.day:
        final selectedDate = state.selectedDate;
        final formattedDate =
            '${selectedDate.day} ${_monthsShort[selectedDate.month - 1]} ${selectedDate.year}';
        return _buildSelectableField(
          context: context,
          displayText: formattedDate,
          icon: Icons.calendar_today_rounded,
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: state.selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: AppColors.primary,
                      onPrimary: Colors.white,
                      onSurface: AppColors.textPrimary,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null && context.mounted) {
              context.read<OwnerDataBloc>().add(
                    OwnerDataDateChanged(
                      date: pickedDate,
                      ownerId: ownerId,
                    ),
                  );
            }
          },
        );

      case PeriodType.month:
        final formattedMonth =
            '${_monthNames[state.selectedMonth - 1]} ${state.selectedYear}';
        return _buildSelectableField(
          context: context,
          displayText: formattedMonth,
          icon: Icons.calendar_month_rounded,
          onTap: () => _showMonthYearPicker(context, ownerId),
        );

      case PeriodType.year:
        return _buildSelectableField(
          context: context,
          displayText: '${state.selectedYear}',
          icon: Icons.calendar_today_rounded,
          onTap: () => _showYearPicker(context, ownerId),
        );
    }
  }

  Widget _buildSelectableField({
    required BuildContext context,
    required String displayText,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              displayText,
              style: AppStyles.body.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMonthYearPicker(
    BuildContext context,
    String ownerId,
  ) async {
    final bloc = context.read<OwnerDataBloc>();
    final currentMonth = bloc.state.selectedMonth;
    final currentYear = bloc.state.selectedYear;

    final result = await showModalBottomSheet<Map<String, int>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => MonthYearPickerBottomSheet(
        initialMonth: currentMonth,
        initialYear: currentYear,
      ),
    );

    if (result != null) {
      bloc.add(
        OwnerDataMonthYearChanged(
          month: result['month']!,
          year: result['year']!,
          ownerId: ownerId,
        ),
      );
    }
  }

  Future<void> _showYearPicker(
    BuildContext context,
    String ownerId,
  ) async {
    final bloc = context.read<OwnerDataBloc>();
    final currentSelectedYear = bloc.state.selectedYear;
    final currentYear = DateTime.now().year;
    final years = List.generate(13, (index) => (currentYear + 2) - index);

    final selectedYear = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Year',
                style: AppStyles.heading.copyWith(
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.pop(dialogContext),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(height: 1),
              const SizedBox(height: 12),
              SizedBox(
                width: 280,
                height: 240,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: years.length,
                  itemBuilder: (context, index) {
                    final year = years[index];
                    final isSelected = year == currentSelectedYear;
                    return InkWell(
                      onTap: () => Navigator.pop(dialogContext, year),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(color: AppColors.primary, width: 1.5)
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$year',
                              style: AppStyles.heading.copyWith(
                                fontSize: 15,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.primary,
                                size: 18,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selectedYear != null) {
      bloc.add(
        OwnerDataYearChanged(
          year: selectedYear,
          ownerId: ownerId,
        ),
      );
    }
  }

  Widget _buildBusinessCard(
    BuildContext context,
    BusinessReportModel business,
    OwnerDataState state,
  ) {
    final showNetProfit = state.periodType != PeriodType.day;

    return Card(
      color: AppColors.surface,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.04),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          context.router.push(
            BusinessDataDetailRoute(
              businessId: business.id,
              periodType: state.periodType,
              selectedDate: state.selectedDate,
              selectedMonth: state.selectedMonth,
              selectedYear: state.selectedYear,
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      business.name,
                      style: AppStyles.heading.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Manager: ',
                    style: AppStyles.label.copyWith(fontSize: 12),
                  ),
                  Text(
                    business.managerName ?? 'No Manager Assigned',
                    style: AppStyles.body.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: business.managerName != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gross Profit',
                          style: AppStyles.label.copyWith(fontSize: 11),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatAmount(business.grossProfit),
                          style: AppStyles.body.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expenses',
                          style: AppStyles.label.copyWith(fontSize: 11),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatAmount(business.expenses),
                          style: AppStyles.body.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showNetProfit)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Net Profit',
                            style: AppStyles.label.copyWith(fontSize: 11),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatAmount(business.netProfit),
                            style: AppStyles.body.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ownerId = HiveService.getUserId() ?? '';

    Widget buildContent(BuildContext context) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text(
            'Data & Reports',
            style: AppStyles.heading.copyWith(color: Colors.white, fontSize: 18),
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        body: SafeArea(
          child: BlocBuilder<OwnerDataBloc, OwnerDataState>(
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<OwnerDataBloc>()
                      .add(OwnerDataRefreshRequested(ownerId));
                },
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Section — Summary Cards (Current Year, All Businesses)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Annual Overview',
                                  style: AppStyles.heading.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  '${DateTime.now().year}',
                                  style: AppStyles.label.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildTopSummaryCards(state.topSummary),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),
                      const Divider(height: 1, color: Color(0xFFE5E7EB)),
                      const SizedBox(height: 16),

                      // Filter Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFilterToggles(context, state, ownerId),
                            const SizedBox(height: 14),
                            _buildFilterField(context, state, ownerId),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Business List Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Business Performance',
                          style: AppStyles.heading.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (state.status == FormzSubmissionStatus.inProgress)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      else if (state.status == FormzSubmissionStatus.failure)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  state.errorMessage ?? 'Failed to load data',
                                  style: AppStyles.body.copyWith(
                                      color: AppColors.error),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<OwnerDataBloc>()
                                        .add(OwnerDataRefreshRequested(ownerId));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                  ),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (state.businesses.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 40, horizontal: 24),
                          child: Center(
                            child: Text(
                              'No businesses found',
                              style: AppStyles.body.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 24.0),
                          itemCount: state.businesses.length,
                          itemBuilder: (context, index) {
                            return _buildBusinessCard(
                              context,
                              state.businesses[index],
                              state,
                            );
                          },
                        ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    try {
      BlocProvider.of<OwnerDataBloc>(context);
      return buildContent(context);
    } catch (_) {
      return BlocProvider(
        create: (context) => OwnerDataBloc(repo: OwnerDataRepo())
          ..add(OwnerDataInitialLoadRequested(ownerId)),
        child: Builder(builder: (context) => buildContent(context)),
      );
    }
  }
}

class MonthYearPickerBottomSheet extends StatefulWidget {
  final int initialMonth;
  final int initialYear;

  const MonthYearPickerBottomSheet({
    super.key,
    required this.initialMonth,
    required this.initialYear,
  });

  @override
  State<MonthYearPickerBottomSheet> createState() =>
      _MonthYearPickerBottomSheetState();
}

class _MonthYearPickerBottomSheetState
    extends State<MonthYearPickerBottomSheet> {
  static const List<String> _monthsShort = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  late int _tempMonth;
  late int _tempYear;

  @override
  void initState() {
    super.initState();
    _tempMonth = widget.initialMonth;
    _tempYear = widget.initialYear;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Month & Year',
                  style: AppStyles.heading.copyWith(
                    fontSize: 18,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Year Selector Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                    onPressed: () {
                      setState(() {
                        _tempYear--;
                      });
                    },
                  ),
                  Text(
                    '$_tempYear',
                    style: AppStyles.heading.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                    onPressed: () {
                      setState(() {
                        _tempYear++;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 12 Months Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final monthNum = index + 1;
                final isSelected = monthNum == _tempMonth;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _tempMonth = monthNum;
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected
                          ? Border.all(color: AppColors.secondary, width: 1.5)
                          : Border.all(color: Colors.transparent),
                    ),
                    child: Text(
                      _monthsShort[index],
                      style: AppStyles.body.copyWith(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'month': _tempMonth,
                    'year': _tempYear,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Confirm',
                  style: AppStyles.heading.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
