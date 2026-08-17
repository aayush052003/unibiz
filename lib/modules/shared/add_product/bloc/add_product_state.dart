part of 'add_product_bloc.dart';

class AddProductState extends Equatable {
  final FormzSubmissionStatus status;
  final File? selectedImage;
  final String name;
  final String buyingUnit;
  final String sellingUnit;
  final String unitsPerPack;
  final String minStockThreshold;
  final bool isUploadingImage;
  final String? imageError;
  final String? nameError;
  final String? buyingUnitError;
  final String? sellingUnitError;
  final String? unitsPerPackError;
  final String? minStockThresholdError;
  final String? errorMessage;

  const AddProductState({
    this.status = FormzSubmissionStatus.initial,
    this.selectedImage,
    this.name = '',
    this.buyingUnit = '',
    this.sellingUnit = '',
    this.unitsPerPack = '1',
    this.minStockThreshold = '',
    this.isUploadingImage = false,
    this.imageError,
    this.nameError,
    this.buyingUnitError,
    this.sellingUnitError,
    this.unitsPerPackError,
    this.minStockThresholdError,
    this.errorMessage,
  });

  AddProductState copyWith({
    FormzSubmissionStatus? status,
    File? selectedImage,
    String? name,
    String? buyingUnit,
    String? sellingUnit,
    String? unitsPerPack,
    String? minStockThreshold,
    bool? isUploadingImage,
    String? imageError,
    String? nameError,
    String? buyingUnitError,
    String? sellingUnitError,
    String? unitsPerPackError,
    String? minStockThresholdError,
    String? errorMessage,
  }) {
    return AddProductState(
      status: status ?? this.status,
      selectedImage: selectedImage ?? this.selectedImage,
      name: name ?? this.name,
      buyingUnit: buyingUnit ?? this.buyingUnit,
      sellingUnit: sellingUnit ?? this.sellingUnit,
      unitsPerPack: unitsPerPack ?? this.unitsPerPack,
      minStockThreshold: minStockThreshold ?? this.minStockThreshold,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      imageError: imageError,
      nameError: nameError,
      buyingUnitError: buyingUnitError,
      sellingUnitError: sellingUnitError,
      unitsPerPackError: unitsPerPackError,
      minStockThresholdError: minStockThresholdError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedImage,
        name,
        buyingUnit,
        sellingUnit,
        unitsPerPack,
        minStockThreshold,
        isUploadingImage,
        imageError,
        nameError,
        buyingUnitError,
        sellingUnitError,
        unitsPerPackError,
        minStockThresholdError,
        errorMessage,
      ];
}
