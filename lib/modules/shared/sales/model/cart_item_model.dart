import 'sales_product_model.dart';

class CartItemModel {
  final SalesProductModel product;
  final double buyingQty;
  final double sellingQty;

  CartItemModel({
    required this.product,
    required this.buyingQty,
    required this.sellingQty,
  });

  double get totalSellingUnits {
    if (product.buyingUnit == product.sellingUnit) {
      return buyingQty;
    }
    return (buyingQty * product.unitsPerPack) + sellingQty;
  }

  double get totalAmount {
    double remaining = totalSellingUnits;
    double amount = 0.0;
    final unitsPerPack = product.unitsPerPack;
    for (final b in product.batches) {
      if (remaining <= 0) break;
      final double batchQtySelling = b.quantityRemaining * unitsPerPack;
      final double taken = batchQtySelling <= remaining ? batchQtySelling : remaining;
      amount += taken * (b.sellingPrice / unitsPerPack);
      remaining -= taken;
    }
    return amount;
  }

  double get estimatedProfit {
    double remaining = totalSellingUnits;
    double profit = 0.0;
    final unitsPerPack = product.unitsPerPack;
    for (final b in product.batches) {
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

  CartItemModel copyWith({
    SalesProductModel? product,
    double? buyingQty,
    double? sellingQty,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      buyingQty: buyingQty ?? this.buyingQty,
      sellingQty: sellingQty ?? this.sellingQty,
    );
  }
}
