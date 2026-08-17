part of 'stock_bloc.dart';

class StockState extends Equatable {
  final FormzSubmissionStatus status;
  final List<StockProductModel> products;
  final List<StockProductModel> filteredProducts;
  final List<PurchaseHistoryModel> purchaseHistory;
  final String searchQuery;
  final String? errorMessage;

  const StockState({
    this.status = FormzSubmissionStatus.initial,
    this.products = const [],
    this.filteredProducts = const [],
    this.purchaseHistory = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  StockState copyWith({
    FormzSubmissionStatus? status,
    List<StockProductModel>? products,
    List<StockProductModel>? filteredProducts,
    List<PurchaseHistoryModel>? purchaseHistory,
    String? searchQuery,
    String? errorMessage,
  }) {
    return StockState(
      status: status ?? this.status,
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      purchaseHistory: purchaseHistory ?? this.purchaseHistory,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        filteredProducts,
        purchaseHistory,
        searchQuery,
        errorMessage,
      ];
}
