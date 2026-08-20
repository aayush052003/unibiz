import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import 'bloc/sales_bloc.dart';
import 'repo/sales_repo.dart';
import 'model/sales_product_model.dart';
import 'model/sales_history_model.dart';

@RoutePage()
class SharedSalesScreen extends StatefulWidget {
  final String businessId;

  const SharedSalesScreen({
    super.key,
    required this.businessId,
  });

  @override
  State<SharedSalesScreen> createState() => _SharedSalesScreenState();
}

class _SharedSalesScreenState extends State<SharedSalesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _buyingQtyController = TextEditingController();
  final _sellingQtyController = TextEditingController();
  SalesBloc? _salesBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      if (_tabController.index == 1) {
        _salesBloc?.add(RefreshSalesRequested(widget.businessId));
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _salesBloc?.add(RefreshSalesRequested(widget.businessId));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _buyingQtyController.dispose();
    _sellingQtyController.dispose();
    super.dispose();
  }

  String _getGroupHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate == today) {
      return 'Today';
    } else if (checkDate == yesterday) {
      return 'Yesterday';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final dayStr = date.day.toString().padLeft(2, '0');
      final monthStr = months[date.month - 1];
      return '$dayStr $monthStr ${date.year}';
    }
  }

  String _formatTime(DateTime dateTime) {
    final localTime = dateTime.toLocal();
    final hour = localTime.hour == 0 ? 12 : (localTime.hour > 12 ? localTime.hour - 12 : localTime.hour);
    final amPm = localTime.hour >= 12 ? 'PM' : 'AM';
    final minute = localTime.minute.toString().padLeft(2, '0');
    return '${hour.toString().padLeft(2, '0')}:$minute $amPm';
  }

  void _showProductSearchSheet(BuildContext context, List<SalesProductModel> products, Map<String, double> cartReserved, SalesBloc bloc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SalesProductSearchSheet(
          products: products,
          cartReserved: cartReserved,
          onProductSelected: (p) {
            Navigator.pop(sheetContext);
            bloc.add(SalesProductChanged(p));
            _buyingQtyController.clear();
            _sellingQtyController.clear();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = SalesBloc(repo: SalesRepo())
          ..add(FetchSalesDataRequested(widget.businessId));
        _salesBloc = bloc;
        return bloc;
      },
      child: Builder(
        builder: (context) {
          final bloc = context.read<SalesBloc>();
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: Text(
                'Sales',
                style: AppStyles.heading.copyWith(color: Colors.white, fontSize: 18),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    _tabController.animateTo(0);
                  },
                ),
              ],
              elevation: 0,
            ),
            body: SafeArea(
              child: BlocConsumer<SalesBloc, SalesState>(
                listener: (context, state) {
                  if (state.successMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(state.successMessage!),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    _buyingQtyController.clear();
                    _sellingQtyController.clear();

                    if (state.successMessage == 'Sale completed successfully') {
                      _tabController.animateTo(1);
                    }
                  } else if (state.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage!),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state.status == FormzSubmissionStatus.inProgress && state.products.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  if (state.status == FormzSubmissionStatus.failure && state.products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.errorMessage ?? 'Failed to load sales data',
                            style: AppStyles.body.copyWith(color: AppColors.error),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              bloc.add(FetchSalesDataRequested(widget.businessId));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final isSubmitting = state.status == FormzSubmissionStatus.inProgress;

                  return Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async {
                          bloc.add(RefreshSalesRequested(widget.businessId));
                        },
                        color: AppColors.primary,
                        child: Column(
                          children: [
                            // Custom Pill-Shaped Tab Switcher
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                              child: Container(
                                height: 48,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: TabBar(
                                  controller: _tabController,
                                  dividerColor: Colors.transparent,
                                  indicator: BoxDecoration(
                                    color: const Color(0xFF1A2B4A),
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                  labelColor: Colors.white,
                                  unselectedLabelColor: Colors.grey.shade600,
                                  labelStyle: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                  unselectedLabelStyle: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  tabs: const [
                                    Tab(
                                      child: Center(
                                        child: Text('Record Sale'),
                                      ),
                                    ),
                                    Tab(
                                      child: Center(
                                        child: Text('Sales History'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  _buildRecordSaleTab(context, state, bloc),
                                  _buildSalesHistoryTab(context, state),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSubmitting)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.35),
                            child: const Center(
                              child: CircularProgressIndicator(color: AppColors.primary),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecordSaleTab(BuildContext context, SalesState state, SalesBloc bloc) {
    final selectedProduct = state.selectedProduct;
    final isProductSelected = selectedProduct != null;
    final isSubmitting = state.status == FormzSubmissionStatus.inProgress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
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
                      : () => _showProductSearchSheet(context, state.products, state.cartReserved, bloc),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.textSecondary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        if (isProductSelected && selectedProduct.imageUrl != null && selectedProduct.imageUrl!.isNotEmpty) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              selectedProduct.imageUrl!,
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
                const SizedBox(height: 6),
                Text(
                  'Search and select the product being sold. Only products with available stock are shown.',
                  style: AppStyles.label.copyWith(fontSize: 11),
                ),
                const SizedBox(height: 24),

                // 2. Quantity Fields (appear with smooth animation)
                AnimatedSize(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  child: !isProductSelected
                      ? const SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (selectedProduct.buyingUnit != selectedProduct.sellingUnit) ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: _buyingQtyController,
                                          enabled: !isSubmitting,
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                          decoration: AppStyles.inputDecoration(
                                            labelText: selectedProduct.buyingUnit,
                                            hintText: '0',
                                          ),
                                          style: AppStyles.body,
                                          onChanged: (val) {
                                            bloc.add(SalesBuyingQtyChanged(val));
                                          },
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Complete ${selectedProduct.buyingUnit}',
                                          style: AppStyles.label.copyWith(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: _sellingQtyController,
                                          enabled: !isSubmitting,
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                          decoration: AppStyles.inputDecoration(
                                            labelText: selectedProduct.sellingUnit,
                                            hintText: '0',
                                          ),
                                          style: AppStyles.body,
                                          onChanged: (val) {
                                            bloc.add(SalesSellingQtyChanged(val));
                                          },
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Loose ${selectedProduct.sellingUnit}',
                                          style: AppStyles.label.copyWith(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ] else ...[
                              // One Field Only
                              TextFormField(
                                controller: _buyingQtyController,
                                enabled: !isSubmitting,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: AppStyles.inputDecoration(
                                  labelText: selectedProduct.buyingUnit,
                                  hintText: '0',
                                ),
                                style: AppStyles.body,
                                onChanged: (val) {
                                  bloc.add(SalesBuyingQtyChanged(val));
                                },
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Enter quantity of ${selectedProduct.buyingUnit} sold.',
                                style: AppStyles.label.copyWith(fontSize: 11),
                              ),
                            ],
                            const SizedBox(height: 24),

                            // Real-time Summary Card
                            if (state.totalQuantitySold > 0) ...[
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF9EC), // Light gold background
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFFDE4B8)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Calculation Summary',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF1A2B4A),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total Quantity:',
                                          style: AppStyles.body.copyWith(color: const Color(0xFF1A2B4A), fontSize: 13),
                                        ),
                                        Text(
                                          '${state.totalQuantitySold.toStringAsFixed(state.totalQuantitySold % 1 == 0 ? 0 : 1)} ${selectedProduct.sellingUnit}',
                                          style: GoogleFonts.poppins(color: const Color(0xFF1A2B4A), fontWeight: FontWeight.w600, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total Amount:',
                                          style: AppStyles.body.copyWith(color: const Color(0xFF1A2B4A), fontSize: 13),
                                        ),
                                        Text(
                                          '₹${state.totalAmount.toStringAsFixed(state.totalAmount % 1 == 0 ? 0 : 2)}',
                                          style: GoogleFonts.poppins(color: const Color(0xFF1A2B4A), fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Estimated Profit:',
                                          style: AppStyles.body.copyWith(color: const Color(0xFF1A2B4A), fontSize: 13),
                                        ),
                                        Text(
                                          '₹${state.estimatedProfit.toStringAsFixed(state.estimatedProfit % 1 == 0 ? 0 : 2)}',
                                          style: GoogleFonts.poppins(color: Colors.green.shade700, fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Add to Cart Button (navy blue outlined)
                            OutlinedButton(
                              onPressed: isSubmitting
                                  ? null
                                  : () {
                                      bloc.add(const AddToCartRequested());
                                    },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF1A2B4A),
                                side: const BorderSide(color: Color(0xFF1A2B4A), width: 1.5),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                '+ Add to Cart',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                ),

                // Cart Section
                if (state.cartItems.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Cart Items',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF1A2B4A),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.cartItems.length,
                          itemBuilder: (context, index) {
                            final item = state.cartItems[index];
                            final product = item.product;
                            return Card(
                              color: Colors.white,
                              elevation: 1,
                              shadowColor: Colors.black.withOpacity(0.04),
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                                          ? Image.network(
                                              product.imageUrl!,
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
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            style: AppStyles.heading.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            product.buyingUnit == product.sellingUnit
                                                ? '${item.buyingQty.toStringAsFixed(item.buyingQty % 1 == 0 ? 0 : 1)} ${product.buyingUnit}'
                                                : '${item.buyingQty.toStringAsFixed(item.buyingQty % 1 == 0 ? 0 : 1)} ${product.buyingUnit} + ${item.sellingQty.toStringAsFixed(item.sellingQty % 1 == 0 ? 0 : 1)} ${product.sellingUnit}',
                                            style: AppStyles.body.copyWith(fontSize: 12, color: AppColors.textSecondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '₹${item.totalAmount.toStringAsFixed(item.totalAmount % 1 == 0 ? 0 : 2)}',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1A2B4A),
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.close, color: Colors.red, size: 20),
                                      onPressed: () {
                                        bloc.add(RemoveFromCartRequested(product.id));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        // Summary Card inside Cart
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF9EC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFDE4B8)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total Items:', style: GoogleFonts.poppins(color: const Color(0xFF1A2B4A), fontSize: 13)),
                                  Text('${state.totalCartItemsCount} products', style: GoogleFonts.poppins(color: const Color(0xFF1A2B4A), fontWeight: FontWeight.bold, fontSize: 13)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total Amount:', style: GoogleFonts.poppins(color: const Color(0xFF1A2B4A), fontSize: 13)),
                                  Text('₹${state.totalCartAmount.toStringAsFixed(state.totalCartAmount % 1 == 0 ? 0 : 2)}', style: GoogleFonts.poppins(color: const Color(0xFF1A2B4A), fontWeight: FontWeight.bold, fontSize: 14)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total Profit:', style: GoogleFonts.poppins(color: const Color(0xFF1A2B4A), fontSize: 13)),
                                  Text('₹${state.totalCartProfit.toStringAsFixed(state.totalCartProfit % 1 == 0 ? 0 : 2)}', style: GoogleFonts.poppins(color: Colors.green.shade700, fontWeight: FontWeight.bold, fontSize: 14)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        // Docked Confirm Sale Button
        if (state.cartItems.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () {
                      bloc.add(ConfirmSaleRequested(widget.businessId));
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A2B4A),
                disabledBackgroundColor: const Color(0xFF1A2B4A).withOpacity(0.6),
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
                      'Confirm Sale',
                      style: AppStyles.buttonText.copyWith(fontSize: 16, color: Colors.white),
                    ),
            ),
          ),
      ],
    );
  }

  Widget _buildSalesHistoryTab(BuildContext context, SalesState state) {
    if (state.salesHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.receipt_long_rounded,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No sales recorded yet',
              style: AppStyles.body.copyWith(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    // Grouping by date
    final Map<String, List<SalesHistoryModel>> grouped = {};
    for (final sale in state.salesHistory) {
      final header = _getGroupHeader(sale.createdAt);
      if (!grouped.containsKey(header)) {
        grouped[header] = [];
      }
      grouped[header]!.add(sale);
    }

    final headers = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      itemCount: headers.length,
      itemBuilder: (context, index) {
        final header = headers[index];
        final items = grouped[header]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0, left: 4.0),
              child: Text(
                header,
                style: GoogleFonts.poppins(
                  color: const Color(0xFFF4A700), // Gold text
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            ...items.map((item) {
              return Card(
                color: AppColors.surface,
                elevation: 1,
                shadowColor: Colors.black.withOpacity(0.04),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: item.productImageUrl != null && item.productImageUrl!.isNotEmpty
                            ? Image.network(
                                item.productImageUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.image, color: Colors.grey),
                                ),
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image, color: Colors.grey),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productName,
                              style: AppStyles.heading.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item.quantitySold.toStringAsFixed(item.quantitySold % 1 == 0 ? 0 : 1)} ${item.sellingUnit} sold',
                              style: AppStyles.body.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Total: ₹${item.totalAmount.toStringAsFixed(item.totalAmount % 1 == 0 ? 0 : 2)}',
                              style: AppStyles.label.copyWith(fontSize: 11),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  'Profit: ',
                                  style: AppStyles.label.copyWith(fontSize: 11),
                                ),
                                Text(
                                  '₹${item.profit.toStringAsFixed(item.profit % 1 == 0 ? 0 : 2)}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.green.shade700, // Profit in green
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Sold by: ${item.soldByName}',
                              style: AppStyles.label.copyWith(fontSize: 11, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _formatTime(item.createdAt),
                        style: AppStyles.label.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}

class SalesProductSearchSheet extends StatefulWidget {
  final List<SalesProductModel> products;
  final Map<String, double> cartReserved;
  final ValueChanged<SalesProductModel> onProductSelected;

  const SalesProductSearchSheet({
    super.key,
    required this.products,
    required this.cartReserved,
    required this.onProductSelected,
  });

  @override
  State<SalesProductSearchSheet> createState() => _SalesProductSearchSheetState();
}

class _SalesProductSearchSheetState extends State<SalesProductSearchSheet> {
  late final TextEditingController _searchController;
  late List<SalesProductModel> _filtered;

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
                        final reserved = widget.cartReserved[p.id] ?? 0.0;
                        final available = p.totalStockInSellingUnits - reserved;
                        final isUnavailable = available <= 0;

                        return Opacity(
                          opacity: isUnavailable ? 0.4 : 1.0,
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: p.imageUrl != null && p.imageUrl!.isNotEmpty
                                  ? Image.network(
                                      p.imageUrl!,
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
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    p.name,
                                    style: AppStyles.body.copyWith(
                                      fontWeight: FontWeight.w600,
                                      decoration: isUnavailable ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isUnavailable ? Colors.grey.shade300 : const Color(0xFFE8F5E9),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${available.toStringAsFixed(available % 1 == 0 ? 0 : 1)} avail',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isUnavailable ? Colors.grey.shade700 : Colors.green.shade800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              'Total Stock: ${p.totalStockInSellingUnits.toStringAsFixed(p.totalStockInSellingUnits % 1 == 0 ? 0 : 1)} ${p.sellingUnit}',
                              style: AppStyles.label.copyWith(fontSize: 12),
                            ),
                            onTap: isUnavailable
                                ? null
                                : () {
                                    widget.onProductSelected(p);
                                  },
                          ),
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

