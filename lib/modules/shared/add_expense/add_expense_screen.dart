import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import '../../../../helper/add_expense/expense_amount_input.dart';
import '../../../../helper/add_expense/expense_description_input.dart';
import 'bloc/add_expense_bloc.dart';
import 'repo/add_expense_repo.dart';

@RoutePage()
class AddExpenseScreen extends StatelessWidget {
  final String businessId;

  const AddExpenseScreen({
    super.key,
    required this.businessId,
  });

  String? _getDescriptionErrorMessage(ExpenseDescriptionValidationError? error) {
    if (error == null) return null;
    switch (error) {
      case ExpenseDescriptionValidationError.empty:
        return 'Description is required';
    }
  }

  String? _getAmountErrorMessage(ExpenseAmountValidationError? error) {
    if (error == null) return null;
    switch (error) {
      case ExpenseAmountValidationError.empty:
        return 'Amount is required';
      case ExpenseAmountValidationError.invalid:
        return 'Please enter a valid amount';
      case ExpenseAmountValidationError.nonPositive:
        return 'Amount must be greater than 0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddExpenseBloc(addExpenseRepo: AddExpenseRepo()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: Text(
                'Add Expense',
                style: AppStyles.heading.copyWith(color: Colors.white, fontSize: 18),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
            ),
            body: SafeArea(
              child: BlocListener<AddExpenseBloc, AddExpenseState>(
                listener: (context, state) {
                  if (state.status == FormzSubmissionStatus.success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Expense added successfully'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    context.maybePop(true);
                  } else if (state.status == FormzSubmissionStatus.failure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage ?? 'Failed to add expense'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        BlocBuilder<AddExpenseBloc, AddExpenseState>(
                          buildWhen: (previous, current) =>
                              previous.description != current.description,
                          builder: (context, state) {
                            return TextField(
                              onChanged: (value) {
                                context
                                    .read<AddExpenseBloc>()
                                    .add(DescriptionChanged(value));
                              },
                              decoration: AppStyles.inputDecoration(
                                hintText: 'Enter expense description',
                                labelText: 'Description',
                              ).copyWith(
                                errorText: _getDescriptionErrorMessage(
                                  state.description.displayError,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<AddExpenseBloc, AddExpenseState>(
                          buildWhen: (previous, current) =>
                              previous.amount != current.amount,
                          builder: (context, state) {
                            return TextField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(decimal: true),
                              onChanged: (value) {
                                context
                                    .read<AddExpenseBloc>()
                                    .add(AmountChanged(value));
                              },
                              decoration: AppStyles.inputDecoration(
                                hintText: 'Enter amount',
                                labelText: 'Amount',
                                suffixIcon: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Center(
                                    widthFactor: 1.0,
                                    child: Text(
                                      '₹',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ).copyWith(
                                errorText: _getAmountErrorMessage(
                                  state.amount.displayError,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                        BlocBuilder<AddExpenseBloc, AddExpenseState>(
                          builder: (context, state) {
                            final isInProgress =
                                state.status == FormzSubmissionStatus.inProgress;
                            return ElevatedButton(
                              onPressed: isInProgress
                                  ? null
                                  : () {
                                      context.read<AddExpenseBloc>().add(
                                            AddExpenseSubmitted(businessId),
                                          );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: isInProgress
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'Submit Expense',
                                      style: AppStyles.buttonText.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
