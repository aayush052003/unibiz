part of 'add_stock_bloc.dart';

class AddStockState extends Equatable {
  final FormzSubmissionStatus status;
  final List<ProductsModel> products;
  final ProductsModel? selectedProduct;
  final String quantity;
  final String purchasePrice;
  final String sellingPrice;
  final DateTime purchaseDate;

  final String? productError;
  final String? quantityError;
  final String? purchasePriceError;
  final String? sellingPriceError;
  final String? errorMessage;

  AddStockState({
    this.status = FormzSubmissionStatus.initial,
    this.products = const [],
    this.selectedProduct,
    this.quantity = '',
    this.purchasePrice = '',
    this.sellingPrice = '',
    DateTime? purchaseDate,
    this.productError,
    this.quantityError,
    this.purchasePriceError,
    this.sellingPriceError,
    this.errorMessage,
  }) : purchaseDate = purchaseDate ?? DateTime.now();

  AddStockState copyWith({
    FormzSubmissionStatus? status,
    List<ProductsModel>? products,
    ProductsModel? selectedProduct,
    bool clearSelectedProduct = false,
    String? quantity,
    String? purchasePrice,
    String? sellingPrice,
    DateTime? purchaseDate,
    String? productError,
    String? quantityError,
    String? purchasePriceError,
    String? sellingPriceError,
    String? errorMessage,
  }) {
    return AddStockState(
      status: status ?? this.status,
      products: products ?? this.products,
      selectedProduct: clearSelectedProduct ? null : (selectedProduct ?? this.selectedProduct),
      quantity: quantity ?? this.quantity,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      productError: productError,
      quantityError: quantityError,
      purchasePriceError: purchasePriceError,
      sellingPriceError: sellingPriceError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        selectedProduct,
        quantity,
        purchasePrice,
        sellingPrice,
        purchaseDate,
        productError,
        quantityError,
        purchasePriceError,
        sellingPriceError,
        errorMessage,
      ];
}
