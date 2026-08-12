import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../repo/add_product_repo.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final AddProductRepo repo;

  AddProductBloc({required this.repo}) : super(const AddProductState()) {
    on<AddProductImageSelected>(_onImageSelected);
    on<AddProductNameChanged>(_onNameChanged);
    on<AddProductBuyingUnitChanged>(_onBuyingUnitChanged);
    on<AddProductSellingUnitChanged>(_onSellingUnitChanged);
    on<AddProductUnitsPerPackChanged>(_onUnitsPerPackChanged);
    on<AddProductSubmitted>(_onSubmitted);
  }

  void _onImageSelected(
    AddProductImageSelected event,
    Emitter<AddProductState> emit,
  ) {
    emit(state.copyWith(
      selectedImage: event.imageFile,
      imageError: null,
    ));
  }

  void _onNameChanged(
    AddProductNameChanged event,
    Emitter<AddProductState> emit,
  ) {
    emit(state.copyWith(
      name: event.name,
      nameError: null,
    ));
  }

  void _onBuyingUnitChanged(
    AddProductBuyingUnitChanged event,
    Emitter<AddProductState> emit,
  ) {
    emit(state.copyWith(
      buyingUnit: event.buyingUnit,
      buyingUnitError: null,
    ));
  }

  void _onSellingUnitChanged(
    AddProductSellingUnitChanged event,
    Emitter<AddProductState> emit,
  ) {
    emit(state.copyWith(
      sellingUnit: event.sellingUnit,
      sellingUnitError: null,
    ));
  }

  void _onUnitsPerPackChanged(
    AddProductUnitsPerPackChanged event,
    Emitter<AddProductState> emit,
  ) {
    emit(state.copyWith(
      unitsPerPack: event.unitsPerPack,
      unitsPerPackError: null,
    ));
  }

  Future<void> _onSubmitted(
    AddProductSubmitted event,
    Emitter<AddProductState> emit,
  ) async {
    bool hasError = false;

    String? imageErr;
    String? nameErr;
    String? buyingUnitErr;
    String? sellingUnitErr;
    String? unitsPerPackErr;

    if (state.selectedImage == null) {
      imageErr = 'Please add a product image';
      hasError = true;
    }

    if (state.name.trim().isEmpty) {
      nameErr = 'Product name is required';
      hasError = true;
    }

    if (state.buyingUnit.trim().isEmpty) {
      buyingUnitErr = 'Buying unit is required';
      hasError = true;
    }

    if (state.sellingUnit.trim().isEmpty) {
      sellingUnitErr = 'Selling unit is required';
      hasError = true;
    }

    final parsedUnits = num.tryParse(state.unitsPerPack.trim());
    if (parsedUnits == null || parsedUnits <= 0) {
      unitsPerPackErr = 'Units per pack must be greater than 0';
      hasError = true;
    }

    if (hasError) {
      emit(state.copyWith(
        imageError: imageErr,
        nameError: nameErr,
        buyingUnitError: buyingUnitErr,
        sellingUnitError: sellingUnitErr,
        unitsPerPackError: unitsPerPackErr,
      ));
      return;
    }

    emit(state.copyWith(
      status: FormzSubmissionStatus.inProgress,
      isUploadingImage: true,
    ));

    try {
      final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
      final apiKey = dotenv.env['CLOUDINARY_API_KEY'] ?? '';
      final apiSecret = dotenv.env['CLOUDINARY_API_SECRET'] ?? '';

      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final signatureRaw = 'folder=unibiz_products&timestamp=$timestamp$apiSecret';
      final signature = sha1.convert(utf8.encode(signatureRaw)).toString();

      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', uri)
        ..fields['folder'] = 'unibiz_products'
        ..fields['timestamp'] = timestamp.toString()
        ..fields['api_key'] = apiKey
        ..fields['signature'] = signature
        ..files.add(await http.MultipartFile.fromPath('file', state.selectedImage!.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        throw Exception('Cloudinary upload failed: ${response.body}');
      }

      final jsonResponse = jsonDecode(response.body);
      final imageUrl = jsonResponse['secure_url'] as String;

      emit(state.copyWith(isUploadingImage: false));

      await repo.addProduct(
        businessId: event.businessId,
        name: state.name.trim(),
        buyingUnit: state.buyingUnit.trim(),
        sellingUnit: state.sellingUnit.trim(),
        unitsPerPack: parsedUnits!,
        imageUrl: imageUrl,
      );

      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        isUploadingImage: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
