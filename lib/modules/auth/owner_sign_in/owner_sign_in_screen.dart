import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import '../../../constants/colors.dart';
import '../../../constants/styles.dart';
import '../../../widgets/brand_logo.dart';
import '../../../route_config/route.gr.dart';
import 'bloc/owner_sign_in_bloc.dart';
import 'repo/owner_sign_in_repo.dart';

@RoutePage()
class OwnerSignInScreen extends StatefulWidget {
  const OwnerSignInScreen({super.key});

  @override
  State<OwnerSignInScreen> createState() => _OwnerSignInScreenState();
}

class _OwnerSignInScreenState extends State<OwnerSignInScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OwnerSignInBloc(repo: OwnerSignInRepo()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocConsumer<OwnerSignInBloc, OwnerSignInState>(
            listener: (context, state) {
              if (state.status == FormzSubmissionStatus.success) {
                context.router.replaceAll([const OwnerHomeRoute()]);
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
              final isSubmitting = state.status == FormzSubmissionStatus.inProgress;

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
                        'Owner Sign In',
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                enabled: !isSubmitting,
                                decoration: AppStyles.inputDecoration(
                                  hintText: 'Enter your email',
                                  labelText: 'Email',
                                ),
                                style: AppStyles.body,
                                onChanged: (value) {
                                  context.read<OwnerSignInBloc>().add(
                                        OwnerSignInEmailChanged(value),
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
                              const SizedBox(height: 16),
                              TextFormField(
                                obscureText: _obscurePassword,
                                enabled: !isSubmitting,
                                decoration: AppStyles.inputDecoration(
                                  hintText: 'Enter your password',
                                  labelText: 'Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.textSecondary,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                style: AppStyles.body,
                                onChanged: (value) {
                                  context.read<OwnerSignInBloc>().add(
                                        OwnerSignInPasswordChanged(value),
                                      );
                                },
                              ),
                              if (state.password.displayError != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Password must be at least 6 characters',
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
                                        context.read<OwnerSignInBloc>().add(
                                              const OwnerSignInSubmitted(),
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
                                child: isSubmitting
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : Text(
                                        'Sign In',
                                        style: AppStyles.buttonText.copyWith(
                                          fontSize: 16,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: isSubmitting
                                ? null
                                : () {
                                    context.router
                                        .push(const OwnerForgotPasswordRoute());
                                  },
                            child: Text(
                              'Forgot Password?',
                              style: AppStyles.body.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: isSubmitting
                                ? null
                                : () {
                                    context.router.push(const OwnerSignUpRoute());
                                  },
                            child: Text(
                              'Sign Up',
                              style: AppStyles.body.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
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
