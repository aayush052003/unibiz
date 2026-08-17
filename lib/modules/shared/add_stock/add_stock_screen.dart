import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import '../products/model/products_model.dart';
import 'bloc/add_stock_bloc.dart';
import 'repo/add_stock_repo.dart';

@RoutePage()
class AddStockScreen extends StatefulWidget {
  final String businessId;

  const AddStockScreen({
    super.key,
    required this.businessId,
  });

  @override
  State<AddStockScreen> createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final _quantityController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(DateTime.now());
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dayStr = date.day.toString().padLeft(2, '0');
    final monthStr = months[date.month - 1];
    return '$dayStr $monthStr ${date.year}';
  }

  Future<void> _selectDate(BuildContext context, AddStockState state) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: state.purchaseDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      _dateController.text = _formatDate(picked);
      context.read<AddStockBloc>().add(AddStockPurchaseDateChanged(picked));
    }
  }

  void _showProductSearchSheet(BuildContext context, List<ProductsModel> products) {
    final bloc = context.read<AddStockBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return ProductSearchSheet(
          products: products,
          onProductSelected: (p) {
            Navigator.pop(sheetContext);
            bloc.add(AddStockProductChanged(p));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddStockBloc(repo: AddStockRepo())
        ..add(FetchAddStockProductsRequested(widget.businessId)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text(
            'Add Stock',
            style: AppStyles.heading.copyWith(color: Colors.white, fontSize: 18),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        body: SafeArea(
          child: BlocConsumer<AddStockBloc, AddStockState>(
            listener: (context, state) {
              if (state.status == FormzSubmissionStatus.success) {
                context.router.maybePop(true);
              } else if (state.status == FormzSubmissionStatus.failure && state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isFetching = state.status == FormzSubmissionStatus.inProgress && state.products.isEmpty;
              final isSubmitting = state.status == FormzSubmissionStatus.inProgress && state.products.isNotEmpty;
              final selectedProduct = state.selectedProduct;
              final isProductSelected = selectedProduct != null;

              if (isFetching) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Select Product Dropdown
                    Text(
                      'Select Product *',
                      style: AppStyles.heading.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: isSubmitting
                          ? null
                          : () => _showProductSearchSheet(context, state.products),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: state.productError != null ? AppColors.error : AppColors.textSecondary.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            if (isProductSelected && selectedProduct.imageUrl.isNotEmpty) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  selectedProduct.imageUrl,
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => const Icon(Icons.image, size: 24),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Expanded(
                              child: Text(
                                isProductSelected ? selectedProduct.name : 'Choose a product...',
                                style: AppStyles.body.copyWith(
                                  color: isProductSelected ? AppColors.textPrimary : AppColors.textSecondary.withOpacity(0.6),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Search and select the product you purchased. If product is not in list, add it first from Products section.',
                      style: AppStyles.label.copyWith(fontSize: 11),
                    ),
                    if (state.productError != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        state.productError!,
                        style: AppStyles.body.copyWith(color: AppColors.error, fontSize: 12),
                      ),
                    ],
                    const SizedBox(height: 20),

                    // Animated fields 2, 3, 4
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: !isProductSelected
                          ? const SizedBox.shrink()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // 2. Quantity
                                TextFormField(
                                  controller: _quantityController,
                                  enabled: !isSubmitting,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: AppStyles.inputDecoration(
                                    labelText: 'Quantity (in ${selectedProduct.buyingUnit})',
                                    hintText: 'Example: 5',
                                  ),
                                  style: AppStyles.body,
                                  onChanged: (val) {
                                    context.read<AddStockBloc>().add(AddStockQuantityChanged(val));
                                  },
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Enter how many ${selectedProduct.buyingUnit} you purchased. Example: if you bought 5 strips enter 5',
                                  style: AppStyles.label.copyWith(fontSize: 11),
                                ),
                                if (state.quantityError != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    state.quantityError!,
                                    style: AppStyles.body.copyWith(color: AppColors.error, fontSize: 12),
                                  ),
                                ],
                                const SizedBox(height: 20),

                                // 3. Purchase Price
                                TextFormField(
                                  controller: _purchasePriceController,
                                  enabled: !isSubmitting,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: AppStyles.inputDecoration(
                                    labelText: 'Purchase Price per ${selectedProduct.buyingUnit}',
                                    hintText: 'Example: 20',
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text('₹', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  style: AppStyles.body,
                                  onChanged: (val) {
                                    context.read<AddStockBloc>().add(AddStockPurchasePriceChanged(val));
                                  },
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Enter the price you paid per ${selectedProduct.buyingUnit}. Example: if 1 strip costs ₹20 enter 20',
                                  style: AppStyles.label.copyWith(fontSize: 11),
                                ),
                                if (state.purchasePriceError != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    state.purchasePriceError!,
                                    style: AppStyles.body.copyWith(color: AppColors.error, fontSize: 12),
                                  ),
                                ],
                                const SizedBox(height: 20),

                                // 4. Selling Price
                                TextFormField(
                                  controller: _sellingPriceController,
                                  enabled: !isSubmitting,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: AppStyles.inputDecoration(
                                    labelText: 'Selling Price per ${selectedProduct.sellingUnit}',
                                    hintText: 'Example: 3',
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text('₹', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  style: AppStyles.body,
                                  onChanged: (val) {
                                    context.read<AddStockBloc>().add(AddStockSellingPriceChanged(val));
                                  },
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Enter the price you will charge customer per ${selectedProduct.sellingUnit}. Example: if you sell 1 tablet for ₹3 enter 3',
                                  style: AppStyles.label.copyWith(fontSize: 11),
                                ),
                                if (state.sellingPriceError != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    state.sellingPriceError!,
                                    style: AppStyles.body.copyWith(color: AppColors.error, fontSize: 12),
                                  ),
                                ],
                                const SizedBox(height: 20),
                              ],
                            ),
                    ),

                    // 5. Purchase Date
                    TextFormField(
                      controller: _dateController,
                      enabled: !isSubmitting,
                      readOnly: true,
                      onTap: isSubmitting ? null : () => _selectDate(context, state),
                      decoration: AppStyles.inputDecoration(
                        labelText: 'Purchase Date',
                        hintText: 'Choose purchase date',
                        suffixIcon: const Icon(Icons.calendar_today_rounded, color: AppColors.primary),
                      ),
                      style: AppStyles.body,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Date when you purchased this stock. Defaults to today.',
                      style: AppStyles.label.copyWith(fontSize: 11),
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () {
                              context.read<AddStockBloc>().add(AddStockSubmitted(widget.businessId));
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Add Stock',
                              style: AppStyles.buttonText.copyWith(fontSize: 16),
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

class ProductSearchSheet extends StatefulWidget {
  final List<ProductsModel> products;
  final ValueChanged<ProductsModel> onProductSelected;

  const ProductSearchSheet({
    super.key,
    required this.products,
    required this.onProductSelected,
  });

  @override
  State<ProductSearchSheet> createState() => _ProductSearchSheetState();
}

class _ProductSearchSheetState extends State<ProductSearchSheet> {
  late final TextEditingController _searchController;
  late List<ProductsModel> _filtered;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filtered = List.from(widget.products);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = List.from(widget.products);
      } else {
        _filtered = widget.products.where((p) => p.name.toLowerCase().contains(q)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      height: MediaQuery.of(context).size.height * 0.7,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Search Product',
                style: AppStyles.heading.copyWith(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filter,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Type product name...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                style: AppStyles.body.copyWith(fontSize: 14),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No products found',
                        style: AppStyles.label,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final p = _filtered[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: p.imageUrl.isNotEmpty
                                ? Image.network(
                                    p.imageUrl,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(
                                      width: 40,
                                      height: 40,
                                      color: Colors.grey.shade100,
                                      child: const Icon(Icons.image, size: 20, color: Colors.grey),
                                    ),
                                  )
                                : Container(
                                    width: 40,
                                    height: 40,
                                    color: Colors.grey.shade100,
                                    child: const Icon(Icons.image, size: 20, color: Colors.grey),
                                  ),
                          ),
                          title: Text(
                            p.name,
                            style: AppStyles.body.copyWith(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            'Unit: ${p.buyingUnit} / ${p.sellingUnit}',
                            style: AppStyles.label.copyWith(fontSize: 12),
                          ),
                          onTap: () {
                            widget.onProductSelected(p);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
