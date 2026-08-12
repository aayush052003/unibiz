part of 'add_product_bloc.dart';

class AddProductState extends Equatable {
  final FormzSubmissionStatus status;
  final File? selectedImage;
  final String name;
  final String buyingUnit;
  final String sellingUnit;
  final String unitsPerPack;
  final bool isUploadingImage;
  final String? imageError;
  final String? nameError;
  final String? buyingUnitError;
  final String? sellingUnitError;
  final String? unitsPerPackError;
  final String? errorMessage;

  const AddProductState({
    this.status = FormzSubmissionStatus.initial,
    this.selectedImage,
    this.name = '',
    this.buyingUnit = '',
    this.sellingUnit = '',
    this.unitsPerPack = '1',
    this.isUploadingImage = false,
    this.imageError,
    this.nameError,
    this.buyingUnitError,
    this.sellingUnitError,
    this.unitsPerPackError,
    this.errorMessage,
  });

  AddProductState copyWith({
    FormzSubmissionStatus? status,
    File? selectedImage,
    String? name,
    String? buyingUnit,
    String? sellingUnit,
    String? unitsPerPack,
    bool? isUploadingImage,
    String? imageError,
    String? nameError,
    String? buyingUnitError,
    String? sellingUnitError,
    String? unitsPerPackError,
    String? errorMessage,
  }) {
    return AddProductState(
      status: status ?? this.status,
      selectedImage: selectedImage ?? this.selectedImage,
      name: name ?? this.name,
      buyingUnit: buyingUnit ?? this.buyingUnit,
      sellingUnit: sellingUnit ?? this.sellingUnit,
      unitsPerPack: unitsPerPack ?? this.unitsPerPack,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      imageError: imageError,
      nameError: nameError,
      buyingUnitError: buyingUnitError,
      sellingUnitError: sellingUnitError,
      unitsPerPackError: unitsPerPackError,
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
        isUploadingImage,
        imageError,
        nameError,
        buyingUnitError,
        sellingUnitError,
        unitsPerPackError,
        errorMessage,
      ];
}
