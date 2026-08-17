import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import '../../../../route_config/route.gr.dart';
import 'bloc/stock_bloc.dart';
import 'repo/stock_repo.dart';
import 'model/purchase_history_model.dart';

@RoutePage()
class StockScreen extends StatefulWidget {
  final String businessId;
  final VoidCallback? onBack;

  const StockScreen({
    super.key,
    required this.businessId,
    this.onBack,
  });

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StockBloc(repo: StockRepo())
        ..add(FetchStockDataRequested(widget.businessId)),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: Text(
                'Stock',
                style: AppStyles.heading.copyWith(color: Colors.white, fontSize: 18),
              ),
              leading: widget.onBack != null
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: widget.onBack,
                    )
                  : (context.router.canPop()
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => context.router.maybePop(),
                        )
                      : null),
              actions: [
                BlocBuilder<StockBloc, StockState>(
                  builder: (context, state) {
                    if (state.status == FormzSubmissionStatus.success && state.products.isNotEmpty) {
                      return IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () async {
                          final added = await context.router.push(
                            AddStockRoute(businessId: widget.businessId),
                          );
                          if (added == true && context.mounted) {
                            context
                                .read<StockBloc>()
                                .add(RefreshStockRequested(widget.businessId));
                          }
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
              elevation: 0,
            ),
            body: SafeArea(
              child: BlocBuilder<StockBloc, StockState>(
                builder: (context, state) {
                  if (state.status == FormzSubmissionStatus.inProgress) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  if (state.status == FormzSubmissionStatus.failure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.errorMessage ?? 'Failed to load stock data',
                            style: AppStyles.body.copyWith(color: AppColors.error),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<StockBloc>()
                                  .add(FetchStockDataRequested(widget.businessId));
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

                  final products = state.products;

                  return RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<StockBloc>()
                          .add(RefreshStockRequested(widget.businessId));
                    },
                    color: AppColors.primary,
                    child: Column(
                      children: [
                        // Custom Pill-Shaped Tab Switcher
                        Padding(
                          padding: const EdgeInsets.all(16.0),
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
                                    child: Text('Current Stock'),
                                  ),
                                ),
                                Tab(
                                  child: Center(
                                    child: Text('Purchase History'),
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
                              _buildCurrentStockTab(context, state, products.isEmpty),
                              _buildPurchaseHistoryTab(context, state),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            floatingActionButton: null,
          );
        },
      ),
    );
  }

  Widget _buildCurrentStockTab(BuildContext context, StockState state, bool isProductsEmpty) {
    if (isProductsEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No products added yet. Add products first\nfrom Products section.',
              textAlign: TextAlign.center,
              style: AppStyles.body.copyWith(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                context.read<StockBloc>().add(StockSearchQueryChanged(query));
              },
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: GoogleFonts.poppins(color: AppColors.textSecondary.withOpacity(0.6), fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: AppStyles.body.copyWith(fontSize: 14),
            ),
          ),
        ),

        Expanded(
          child: state.filteredProducts.isEmpty
              ? Center(
                  child: Text(
                    'No products match your search',
                    style: AppStyles.label,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  itemCount: state.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = state.filteredProducts[index];
                    final qty = product.quantityRemainingInSellingUnits;

                    Widget? badge;
                    if (qty == 0) {
                      badge = Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Out of Stock',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    } else if (product.minStockThreshold > 0 && qty <= product.minStockThreshold) {
                      badge = Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Low Stock',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }

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
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                                  ? Image.network(
                                      product.imageUrl!,
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
                                    product.name,
                                    style: AppStyles.heading.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${qty.toStringAsFixed(qty % 1 == 0 ? 0 : 1)} ${product.sellingUnit} remaining',
                                    style: AppStyles.label.copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            if (badge != null) badge,
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildPurchaseHistoryTab(BuildContext context, StockState state) {
    if (state.purchaseHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.history_rounded,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No stock purchases recorded yet',
              style: AppStyles.body.copyWith(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    // Grouping logic in memory
    final Map<String, List<PurchaseHistoryModel>> grouped = {};
    for (final history in state.purchaseHistory) {
      final header = _getGroupHeader(history.purchaseDate);
      if (!grouped.containsKey(header)) {
        grouped[header] = [];
      }
      grouped[header]!.add(history);
    }

    final headers = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: headers.length,
      itemBuilder: (context, index) {
        final header = headers[index];
        final items = grouped[header]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0),
              child: Text(
                header,
                style: GoogleFonts.poppins(
                  color: AppColors.secondary,
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
                              '${item.quantityAdded.toStringAsFixed(item.quantityAdded % 1 == 0 ? 0 : 1)} ${item.buyingUnit} added',
                              style: AppStyles.body.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '₹${item.purchasePrice.toStringAsFixed(item.purchasePrice % 1 == 0 ? 0 : 2)} per ${item.buyingUnit}',
                              style: AppStyles.label.copyWith(fontSize: 11),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Added by: ${item.addedByName}',
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
