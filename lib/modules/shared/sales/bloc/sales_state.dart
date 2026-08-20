part of 'sales_bloc.dart';

class SalesState extends Equatable {
  final FormzSubmissionStatus status;
  final List<SalesProductModel> products;
  final List<SalesHistoryModel> salesHistory;
  final SalesProductModel? selectedProduct;
  final String buyingQtyStr;
  final String sellingQtyStr;
  final String? errorMessage;
  final String? successMessage;
  final List<CartItemModel> cartItems;
  final Map<String, double> cartReserved;

  const SalesState({
    this.status = FormzSubmissionStatus.initial,
    this.products = const [],
    this.salesHistory = const [],
    this.selectedProduct,
    this.buyingQtyStr = '',
    this.sellingQtyStr = '',
    this.errorMessage,
    this.successMessage,
    this.cartItems = const [],
    this.cartReserved = const {},
  });

  double get buyingQuantity => double.tryParse(buyingQtyStr) ?? 0.0;
  double get sellingQuantity => double.tryParse(sellingQtyStr) ?? 0.0;

  double get totalQuantitySold {
    if (selectedProduct == null) return 0.0;
    if (selectedProduct!.buyingUnit == selectedProduct!.sellingUnit) {
      return buyingQuantity;
    }
    return (buyingQuantity * selectedProduct!.unitsPerPack) + sellingQuantity;
  }

  double get totalAmount {
    if (selectedProduct == null) return 0.0;
    double remaining = totalQuantitySold;
    double amount = 0.0;
    final unitsPerPack = selectedProduct!.unitsPerPack;
    for (final b in selectedProduct!.batches) {
      if (remaining <= 0) break;
      final double batchQtySelling = b.quantityRemaining * unitsPerPack;
      final double taken = batchQtySelling <= remaining ? batchQtySelling : remaining;
      amount += taken * (b.sellingPrice / unitsPerPack);
      remaining -= taken;
    }
    return amount;
  }

  double get estimatedProfit {
    if (selectedProduct == null) return 0.0;
    double remaining = totalQuantitySold;
    double profit = 0.0;
    final unitsPerPack = selectedProduct!.unitsPerPack;
    for (final b in selectedProduct!.batches) {
      if (remaining <= 0) break;
      final double batchQtySelling = b.quantityRemaining * unitsPerPack;
      final double taken = batchQtySelling <= remaining ? batchQtySelling : remaining;
      final double sellingPricePerSellingUnit = b.sellingPrice / unitsPerPack;
      final double purchasePricePerSellingUnit = b.purchasePrice / unitsPerPack;
      profit += taken * (sellingPricePerSellingUnit - purchasePricePerSellingUnit);
      remaining -= taken;
    }
    return profit;
  }

  bool get isQuantityValid {
    if (selectedProduct == null) return false;
    if (selectedProduct!.buyingUnit == selectedProduct!.sellingUnit) {
      return buyingQuantity > 0;
    }
    return buyingQuantity > 0 || sellingQuantity > 0;
  }

  bool get isStockAvailable {
    if (selectedProduct == null) return false;
    final reserved = cartReserved[selectedProduct!.id] ?? 0.0;
    final available = selectedProduct!.totalStockInSellingUnits - reserved;
    return totalQuantitySold <= available;
  }

  double get totalCartAmount {
    double total = 0.0;
    for (final item in cartItems) {
      total += item.totalAmount;
    }
    return total;
  }

  double get totalCartProfit {
    double total = 0.0;
    for (final item in cartItems) {
      total += item.estimatedProfit;
    }
    return total;
  }

  int get totalCartItemsCount {
    return cartItems.length;
  }

  SalesState copyWith({
    FormzSubmissionStatus? status,
    List<SalesProductModel>? products,
    List<SalesHistoryModel>? salesHistory,
    SalesProductModel? selectedProduct,
    String? buyingQtyStr,
    String? sellingQtyStr,
    String? errorMessage,
    String? successMessage,
    List<CartItemModel>? cartItems,
    Map<String, double>? cartReserved,
    bool clearProduct = false,
  }) {
    final updatedCartItems = cartItems ?? this.cartItems;
    Map<String, double> updatedCartReserved;
    if (cartReserved != null) {
      updatedCartReserved = cartReserved;
    } else if (cartItems != null) {
      updatedCartReserved = {};
      for (final item in cartItems) {
        updatedCartReserved[item.product.id] = (updatedCartReserved[item.product.id] ?? 0.0) + item.totalSellingUnits;
      }
    } else {
      updatedCartReserved = this.cartReserved;
    }

    return SalesState(
      status: status ?? this.status,
      products: products ?? this.products,
      salesHistory: salesHistory ?? this.salesHistory,
      selectedProduct: clearProduct ? null : (selectedProduct ?? this.selectedProduct),
      buyingQtyStr: clearProduct ? '' : (buyingQtyStr ?? this.buyingQtyStr),
      sellingQtyStr: clearProduct ? '' : (sellingQtyStr ?? this.sellingQtyStr),
      errorMessage: errorMessage,
      successMessage: successMessage,
      cartItems: updatedCartItems,
      cartReserved: updatedCartReserved,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        salesHistory,
        selectedProduct,
        buyingQtyStr,
        sellingQtyStr,
        errorMessage,
        successMessage,
        cartItems,
        cartReserved,
      ];
}

