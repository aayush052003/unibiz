import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import '../../../constants/colors.dart';
import '../../../constants/styles.dart';
import '../../../widgets/brand_logo.dart';
import 'bloc/owner_forgot_password_bloc.dart';
import 'repo/owner_forgot_password_repo.dart';

@RoutePage()
class OwnerForgotPasswordScreen extends StatelessWidget {
  const OwnerForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OwnerForgotPasswordBloc(repo: OwnerForgotPasswordRepo()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocConsumer<OwnerForgotPasswordBloc, OwnerForgotPasswordState>(
            listener: (context, state) {
              if (state.status == FormzSubmissionStatus.failure &&
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
              final isSubmitting =
                  state.status == FormzSubmissionStatus.inProgress;
              final isSuccess = state.status == FormzSubmissionStatus.success;

              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const BrandLogo(fontSize: 40),
                      const SizedBox(height: 8),
                      Text(
                        'Reset Password',
                        textAlign: TextAlign.center,
                        style: AppStyles.heading.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 32),
                      Card(
                        color: AppColors.surface,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: isSuccess
                              ? Column(
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline,
                                      color: AppColors.success,
                                      size: 64,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'If this email is registered, you will receive a password reset link shortly',
                                      textAlign: TextAlign.center,
                                      style: AppStyles.body.copyWith(
                                        color: AppColors.textPrimary,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed: () {
                                        context.router.maybePop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 32, vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        'Back to Sign In',
                                        style: AppStyles.buttonText,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Enter your email to receive a password reset link',
                                      style: AppStyles.body.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      enabled: !isSubmitting,
                                      decoration: AppStyles.inputDecoration(
                                        hintText: 'Enter your email',
                                        labelText: 'Email',
                                      ),
                                      style: AppStyles.body,
                                      onChanged: (value) {
                                        context
                                            .read<OwnerForgotPasswordBloc>()
                                            .add(
                                              OwnerForgotPasswordEmailChanged(
                                                  value),
                                            );
                                      },
                                    ),
                                    if (state.email.displayError != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'Please enter a valid email',
                                        style: AppStyles.body.copyWith(
                                          color: AppColors.error,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed: isSubmitting
                                          ? null
                                          : () {
                                              context
                                                  .read<
                                                      OwnerForgotPasswordBloc>()
                                                  .add(
                                                    const OwnerForgotPasswordSubmitted(),
                                                  );
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        disabledBackgroundColor: AppColors
                                            .primary
                                            .withOpacity(0.6),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: isSubmitting
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                            )
                                          : Text(
                                              'Send Link',
                                              style:
                                                  AppStyles.buttonText.copyWith(
                                                fontSize: 16,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (!isSuccess)
                        TextButton(
                          onPressed: isSubmitting
                              ? null
                              : () {
                                  context.router.maybePop();
                                },
                          child: Text(
                            'Back to Sign In',
                            style: AppStyles.body.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
