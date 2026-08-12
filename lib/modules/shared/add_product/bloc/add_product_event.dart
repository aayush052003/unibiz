part of 'add_product_bloc.dart';

@immutable
sealed class AddProductEvent extends Equatable {
  const AddProductEvent();

  @override
  List<Object?> get props => [];
}

class AddProductImageSelected extends AddProductEvent {
  final File imageFile;

  const AddProductImageSelected(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}

class AddProductNameChanged extends AddProductEvent {
  final String name;

  const AddProductNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class AddProductBuyingUnitChanged extends AddProductEvent {
  final String buyingUnit;

  const AddProductBuyingUnitChanged(this.buyingUnit);

  @override
  List<Object?> get props => [buyingUnit];
}

class AddProductSellingUnitChanged extends AddProductEvent {
  final String sellingUnit;

  const AddProductSellingUnitChanged(this.sellingUnit);

  @override
  List<Object?> get props => [sellingUnit];
}

class AddProductUnitsPerPackChanged extends AddProductEvent {
  final String unitsPerPack;

  const AddProductUnitsPerPackChanged(this.unitsPerPack);

  @override
  List<Object?> get props => [unitsPerPack];
}

class AddProductSubmitted extends AddProductEvent {
  final String businessId;

  const AddProductSubmitted(this.businessId);

  @override
  List<Object?> get props => [businessId];
}
