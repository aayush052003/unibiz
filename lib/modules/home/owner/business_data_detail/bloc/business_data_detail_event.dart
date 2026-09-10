part of 'business_data_detail_bloc.dart';

@immutable
sealed class BusinessDataDetailEvent {
  const BusinessDataDetailEvent();
}

final class FetchBusinessDataDetailRequested extends BusinessDataDetailEvent {
  final String businessId;
  final PeriodType periodType;
  final DateTime selectedDate;
  final int selectedMonth;
  final int selectedYear;

  const FetchBusinessDataDetailRequested({
    required this.businessId,
    required this.periodType,
    required this.selectedDate,
    required this.selectedMonth,
    required this.selectedYear,
  });
}

final class BusinessDataDetailTabChanged extends BusinessDataDetailEvent {
  final int tabIndex;

  const BusinessDataDetailTabChanged(this.tabIndex);
}
