import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import 'bloc/add_product_bloc.dart';
import 'repo/add_product_repo.dart';

@RoutePage()
class AddProductScreen extends StatefulWidget {
  final String businessId;

  const AddProductScreen({
    super.key,
    required this.businessId,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _buyingUnitController = TextEditingController();
  final _sellingUnitController = TextEditingController();
  final _unitsPerPackController = TextEditingController(text: '1');
  final ImagePicker _picker = ImagePicker();

  static const List<String> _buyingUnitChips = [
    'Box',
    'Strip',
    'KG',
    'Bottle',
    'Bag',
    'Dozen',
    'Piece',
    'Packet',
  ];

  static const List<String> _sellingUnitChips = [
    'Piece',
    'Tablet',
    'KG',
    'Gram',
    'Bottle',
    'Packet',
    'Strip',
  ];

  @override
  void dispose() {
    _buyingUnitController.dispose();
    _sellingUnitController.dispose();
    _unitsPerPackController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(source: source);
      if (picked != null && context.mounted) {
        context
            .read<AddProductBloc>()
            .add(AddProductImageSelected(File(picked.path)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Widget _buildTipCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.secondary.withOpacity(0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tip: If you sell the same product in different ways '
              '(example: Wheat as full bag and also as loose per KG), '
              'add them as separate products with different names.',
              style: AppStyles.body.copyWith(
                fontSize: 13,
                color: AppColors.primary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context, AddProductState state, bool isDisabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Image *',
          style: AppStyles.heading.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: isDisabled
              ? null
              : () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (sheetContext) => SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera_alt_rounded,
                                  color: AppColors.primary),
                              title: Text('Take Photo', style: AppStyles.body),
                              onTap: () {
                                Navigator.pop(sheetContext);
                                _pickImage(context, ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_library_rounded,
                                  color: AppColors.primary),
                              title:
                                  Text('Choose from Gallery', style: AppStyles.body),
                              onTap: () {
                                Navigator.pop(sheetContext);
                                _pickImage(context, ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: state.imageError != null
                    ? AppColors.error
                    : AppColors.textSecondary.withOpacity(0.4),
                width: state.imageError != null ? 1.5 : 1,
                style: BorderStyle.solid,
              ),
            ),
            child: state.isUploadingImage
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: AppColors.primary),
                      SizedBox(height: 12),
                      Text(
                        'Uploading image to Cloudinary...',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  )
                : state.selectedImage != null
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              state.selectedImage!,
                              width: double.infinity,
                              height: 160,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.white, size: 20),
                                onPressed: isDisabled
                                    ? null
                                    : () {
                                        _pickImage(context, ImageSource.gallery);
                                      },
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.camera_alt_rounded,
                                  color: AppColors.primary, size: 32),
                              SizedBox(width: 16),
                              Icon(Icons.photo_library_rounded,
                                  color: AppColors.primary, size: 32),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap to select Product Image',
                            style: AppStyles.label.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
          ),
        ),
        if (state.imageError != null) ...[
          const SizedBox(height: 6),
          Text(
            state.imageError!,
            style: AppStyles.body.copyWith(
              color: AppColors.error,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildChips({
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String> onSelected,
    required bool isDisabled,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: options.map((option) {
        final isSelected = selectedValue.trim().toLowerCase() == option.toLowerCase();
        return ChoiceChip(
          label: Text(option),
          selected: isSelected,
          onSelected: isDisabled
              ? null
              : (selected) {
                  if (selected) {
                    onSelected(option);
                  }
                },
          selectedColor: AppColors.primary,
          backgroundColor: AppColors.surface,
          labelStyle: AppStyles.body.copyWith(
            fontSize: 13,
            color: isSelected ? Colors.white : AppColors.primary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.textSecondary.withOpacity(0.5),
            ),
          ),
          showCheckmark: false,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddProductBloc(repo: AddProductRepo()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text(
            'Add Product',
            style: AppStyles.heading.copyWith(color: Colors.white, fontSize: 18),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        body: SafeArea(
          child: BlocConsumer<AddProductBloc, AddProductState>(
            listener: (context, state) {
              if (state.status == FormzSubmissionStatus.success) {
                context.router.maybePop(true);
              } else if (state.status == FormzSubmissionStatus.failure &&
                  state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isDisabled = state.status == FormzSubmissionStatus.inProgress ||
                  state.isUploadingImage;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Info Card
                    _buildTipCard(),
                    const SizedBox(height: 20),

                    // 2. Product Image
                    _buildImagePicker(context, state, isDisabled),
                    const SizedBox(height: 20),

                    // 3. Product Name
                    TextFormField(
                      enabled: !isDisabled,
                      decoration: AppStyles.inputDecoration(
                        labelText: 'Product Name',
                        hintText: 'Example: Paracetamol 500mg, Balaji Wafers, Rice',
                      ),
                      style: AppStyles.body,
                      onChanged: (val) {
                        context
                            .read<AddProductBloc>()
                            .add(AddProductNameChanged(val));
                      },
                    ),
                    if (state.nameError != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        state.nameError!,
                        style: AppStyles.body
                            .copyWith(color: AppColors.error, fontSize: 12),
                      ),
                    ],
                    const SizedBox(height: 20),

                    // 4. Buying Unit
                    Text(
                      'Buying Unit',
                      style: AppStyles.heading.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'How do you purchase this from supplier?',
                      style: AppStyles.label.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    _buildChips(
                      options: _buyingUnitChips,
                      selectedValue: state.buyingUnit,
                      isDisabled: isDisabled,
                      onSelected: (unit) {
                        _buyingUnitController.text = unit;
                        context
                            .read<AddProductBloc>()
                            .add(AddProductBuyingUnitChanged(unit));
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _buyingUnitController,
                      enabled: !isDisabled,
                      decoration: AppStyles.inputDecoration(
                        labelText: 'Buying Unit (or select chip)',
                        hintText:
                            'Example: Strip for medicine, Box for wafers, KG for rice',
                      ),
                      style: AppStyles.body,
                      onChanged: (val) {
                        context
                            .read<AddProductBloc>()
                            .add(AddProductBuyingUnitChanged(val));
                      },
                    ),
                    if (state.buyingUnitError != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        state.buyingUnitError!,
                        style: AppStyles.body
                            .copyWith(color: AppColors.error, fontSize: 12),
                      ),
                    ],
                    const SizedBox(height: 20),

                    // 5. Selling Unit
                    Text(
                      'Selling Unit',
                      style: AppStyles.heading.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'How do you sell this to customer?',
                      style: AppStyles.label.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    _buildChips(
                      options: _sellingUnitChips,
                      selectedValue: state.sellingUnit,
                      isDisabled: isDisabled,
                      onSelected: (unit) {
                        _sellingUnitController.text = unit;
                        context
                            .read<AddProductBloc>()
                            .add(AddProductSellingUnitChanged(unit));
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _sellingUnitController,
                      enabled: !isDisabled,
                      decoration: AppStyles.inputDecoration(
                        labelText: 'Selling Unit (or select chip)',
                        hintText: 'Example: Tablet from strip, Packet from box',
                      ),
                      style: AppStyles.body,
                      onChanged: (val) {
                        context
                            .read<AddProductBloc>()
                            .add(AddProductSellingUnitChanged(val));
                      },
                    ),
                    if (state.sellingUnitError != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        state.sellingUnitError!,
                        style: AppStyles.body
                            .copyWith(color: AppColors.error, fontSize: 12),
                      ),
                    ],
                    const SizedBox(height: 20),

                    // 6. Units per Pack
                    TextFormField(
                      controller: _unitsPerPackController,
                      enabled: !isDisabled,
                      keyboardType: TextInputType.number,
                      decoration: AppStyles.inputDecoration(
                        labelText: 'Units per Pack',
                        hintText: 'Enter units count',
                      ),
                      style: AppStyles.body,
                      onChanged: (val) {
                        context
                            .read<AddProductBloc>()
                            .add(AddProductUnitsPerPackChanged(val));
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'How many selling units are in one buying unit? If you buy and sell in same unit enter 1',
                      style: AppStyles.label.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.textSecondary.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Examples:',
                              style: AppStyles.heading.copyWith(fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('• 1 Strip = 10 Tablets → enter 10',
                              style: AppStyles.label.copyWith(fontSize: 12)),
                          Text('• 1 Box = 12 Packets → enter 12',
                              style: AppStyles.label.copyWith(fontSize: 12)),
                          Text('• 1 KG = 1000 Grams → enter 1000',
                              style: AppStyles.label.copyWith(fontSize: 12)),
                          Text('• 1 Bottle = 1 Bottle → enter 1',
                              style: AppStyles.label.copyWith(fontSize: 12)),
                        ],
                      ),
                    ),
                    if (state.unitsPerPackError != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        state.unitsPerPackError!,
                        style: AppStyles.body
                            .copyWith(color: AppColors.error, fontSize: 12),
                      ),
                    ],
                    const SizedBox(height: 20),

                    // 7. Minimum Stock Alert
                    TextFormField(
                      enabled: !isDisabled,
                      keyboardType: TextInputType.number,
                      decoration: AppStyles.inputDecoration(
                        labelText: state.sellingUnit.trim().isNotEmpty
                            ? 'Minimum Stock Alert (in ${state.sellingUnit.trim()})'
                            : 'Minimum Stock Alert',
                        hintText: 'Example: 50',
                      ),
                      style: AppStyles.body,
                      onChanged: (val) {
                        context
                            .read<AddProductBloc>()
                            .add(AddProductMinStockThresholdChanged(val));
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'We will show a Low Stock warning when available quantity falls below this number. Example: enter 50 if you want a warning when stock goes below 50 Tablets',
                      style: AppStyles.label.copyWith(fontSize: 12),
                    ),
                    if (state.minStockThresholdError != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        state.minStockThresholdError!,
                        style: AppStyles.body
                            .copyWith(color: AppColors.error, fontSize: 12),
                      ),
                    ],
                    const SizedBox(height: 32),

                    // Submit Button
                    ElevatedButton(
                      onPressed: isDisabled
                          ? null
                          : () {
                              context.read<AddProductBloc>().add(
                                    AddProductSubmitted(widget.businessId),
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor:
                            AppColors.primary.withOpacity(0.6),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: isDisabled
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Add Product',
                              style:
                                  AppStyles.buttonText.copyWith(fontSize: 16),
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
