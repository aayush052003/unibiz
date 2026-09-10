import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import 'bloc/employee_out_of_stock_bloc.dart';
import 'repo/employee_out_of_stock_repo.dart';

@RoutePage()
class EmployeeOutOfStockScreen extends StatelessWidget {
  final String businessId;

  const EmployeeOutOfStockScreen({
    super.key,
    required this.businessId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeOutOfStockBloc(repo: EmployeeOutOfStockRepo())
        ..add(FetchEmployeeOutOfStockRequested(businessId)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text(
            'Out of Stock Items',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        body: SafeArea(
          child: BlocBuilder<EmployeeOutOfStockBloc, EmployeeOutOfStockState>(
            builder: (context, state) {
              if (state.status == FormzSubmissionStatus.inProgress) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (state.status == FormzSubmissionStatus.failure) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.errorMessage ?? 'Failed to load out of stock items',
                          textAlign: TextAlign.center,
                          style: AppStyles.body.copyWith(color: AppColors.error),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<EmployeeOutOfStockBloc>()
                                .add(FetchEmployeeOutOfStockRequested(businessId));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state.products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 64,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No out of stock items',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return Card(
                    color: AppColors.surface,
                    elevation: 1,
                    shadowColor: Colors.black.withOpacity(0.04),
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFFFEE2E2), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                                ? Image.network(
                                    product.imageUrl!,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(
                                      width: 48,
                                      height: 48,
                                      color: Colors.grey.shade100,
                                      child: const Icon(
                                        Icons.inventory_2_outlined,
                                        size: 24,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 48,
                                    height: 48,
                                    color: Colors.grey.shade100,
                                    child: const Icon(
                                      Icons.inventory_2_outlined,
                                      size: 24,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '0 ${product.sellingUnit} remaining',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFFCA5A5)),
                            ),
                            child: Text(
                              'Out of Stock',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
