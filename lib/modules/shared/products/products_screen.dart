import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import '../../../../route_config/route.gr.dart';
import 'bloc/products_bloc.dart';
import 'model/products_model.dart';
import 'repo/products_repo.dart';

@RoutePage()
class ProductsScreen extends StatelessWidget {
  final String businessId;

  const ProductsScreen({
    super.key,
    required this.businessId,
  });

  Widget _buildProductCard(ProductsModel product) {
    return Card(
      color: AppColors.surface,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 70,
                    height: 70,
                    color: AppColors.background,
                    child: const Icon(
                      Icons.image_not_supported_rounded,
                      color: AppColors.textSecondary,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppStyles.heading.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Buy: ',
                        style: AppStyles.label.copyWith(fontSize: 13),
                      ),
                      Text(
                        product.buyingUnit,
                        style: AppStyles.body.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Sell: ',
                        style: AppStyles.label.copyWith(fontSize: 13),
                      ),
                      Text(
                        product.sellingUnit,
                        style: AppStyles.body.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        'Units per pack: ',
                        style: AppStyles.label.copyWith(fontSize: 13),
                      ),
                      Text(
                        '${product.unitsPerPack}',
                        style: AppStyles.body.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsBloc(productsRepo: ProductsRepo())
        ..add(FetchProductsRequested(businessId)),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: Text(
                'Products',
                style: AppStyles.heading.copyWith(color: Colors.white, fontSize: 18),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () async {
                final refreshed = await context.router.push<bool>(
                  AddProductRoute(businessId: businessId),
                );
                if (refreshed == true && context.mounted) {
                  context
                      .read<ProductsBloc>()
                      .add(FetchProductsRequested(businessId));
                }
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
            body: SafeArea(
              child: BlocBuilder<ProductsBloc, ProductsState>(
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
                            state.errorMessage ?? 'Failed to load products',
                            style: AppStyles.body.copyWith(color: AppColors.error),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<ProductsBloc>()
                                  .add(FetchProductsRequested(businessId));
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

                  if (state.products.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.category_rounded,
                              size: 64,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No products added yet. Add your first product.',
                              textAlign: TextAlign.center,
                              style: AppStyles.heading.copyWith(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(24.0),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(state.products[index]);
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
