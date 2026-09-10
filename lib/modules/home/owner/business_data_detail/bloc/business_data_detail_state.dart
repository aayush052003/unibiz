part of 'business_data_detail_bloc.dart';

class BusinessDataDetailState extends Equatable {
  final FormzSubmissionStatus status;
  final String businessName;
  final BusinessSummaryCardsModel summaryCards;
  final List<DetailSaleItemModel> sales;
  final List<DetailExpenseItemModel> expenses;
  final List<PeriodSummaryRowModel> periodSummaries;
  final int activeTabIndex; // 0: Sales, 1: Expenses (for Day view)
  final String? errorMessage;

  const BusinessDataDetailState({
    this.status = FormzSubmissionStatus.initial,
    this.businessName = '',
    this.summaryCards = const BusinessSummaryCardsModel(),
    this.sales = const [],
    this.expenses = const [],
    this.periodSummaries = const [],
    this.activeTabIndex = 0,
    this.errorMessage,
  });

  BusinessDataDetailState copyWith({
    FormzSubmissionStatus? status,
    String? businessName,
    BusinessSummaryCardsModel? summaryCards,
    List<DetailSaleItemModel>? sales,
    List<DetailExpenseItemModel>? expenses,
    List<PeriodSummaryRowModel>? periodSummaries,
    int? activeTabIndex,
    String? errorMessage,
  }) {
    return BusinessDataDetailState(
      status: status ?? this.status,
      businessName: businessName ?? this.businessName,
      summaryCards: summaryCards ?? this.summaryCards,
      sales: sales ?? this.sales,
      expenses: expenses ?? this.expenses,
      periodSummaries: periodSummaries ?? this.periodSummaries,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        businessName,
        summaryCards,
        sales,
        expenses,
        periodSummaries,
        activeTabIndex,
        errorMessage,
      ];
}
