part of 'owner_data_bloc.dart';

class OwnerDataState extends Equatable {
  final FormzSubmissionStatus status;
  final OwnerDataTopSummaryModel topSummary;
  final List<BusinessReportModel> businesses;
  final PeriodType periodType;
  final DateTime selectedDate;
  final int selectedMonth;
  final int selectedYear;
  final String? errorMessage;

  const OwnerDataState({
    this.status = FormzSubmissionStatus.initial,
    this.topSummary = const OwnerDataTopSummaryModel(),
    this.businesses = const [],
    this.periodType = PeriodType.day,
    required this.selectedDate,
    required this.selectedMonth,
    required this.selectedYear,
    this.errorMessage,
  });

  factory OwnerDataState.initial() {
    final now = DateTime.now();
    return OwnerDataState(
      selectedDate: DateTime(now.year, now.month, now.day),
      selectedMonth: now.month,
      selectedYear: now.year,
    );
  }

  OwnerDataState copyWith({
    FormzSubmissionStatus? status,
    OwnerDataTopSummaryModel? topSummary,
    List<BusinessReportModel>? businesses,
    PeriodType? periodType,
    DateTime? selectedDate,
    int? selectedMonth,
    int? selectedYear,
    String? errorMessage,
  }) {
    return OwnerDataState(
      status: status ?? this.status,
      topSummary: topSummary ?? this.topSummary,
      businesses: businesses ?? this.businesses,
      periodType: periodType ?? this.periodType,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        topSummary,
        businesses,
        periodType,
        selectedDate,
        selectedMonth,
        selectedYear,
        errorMessage,
      ];
}
