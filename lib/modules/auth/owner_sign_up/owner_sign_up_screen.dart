import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import '../../../constants/colors.dart';
import '../../../constants/styles.dart';
import '../../../widgets/brand_logo.dart';
import '../../../route_config/route.gr.dart';
import 'bloc/owner_sign_up_bloc.dart';
import 'repo/owner_sign_up_repo.dart';

@RoutePage()
class OwnerSignUpScreen extends StatefulWidget {
  const OwnerSignUpScreen({super.key});

  @override
  State<OwnerSignUpScreen> createState() => _OwnerSignUpScreenState();
}

class _OwnerSignUpScreenState extends State<OwnerSignUpScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OwnerSignUpBloc(repo: OwnerSignUpRepo()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocConsumer<OwnerSignUpBloc, OwnerSignUpState>(
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
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const BrandLogo(fontSize: 40),
                      const SizedBox(height: 8),
                      Text(
                        'Owner Sign Up',
                        textAlign: TextAlign.center,
                        style: AppStyles.heading.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 24),
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
                                enabled: !isSubmitting,
                                decoration: AppStyles.inputDecoration(
                                  hintText: 'Enter your first name',
                                  labelText: 'First Name',
                                ),
                                style: AppStyles.body,
                                onChanged: (value) {
                                  context.read<OwnerSignUpBloc>().add(
                                        OwnerSignUpFirstNameChanged(value),
                                      );
                                },
                              ),
                              if (state.firstName.displayError != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Required, alphabetic characters only',
                                  style: AppStyles.body.copyWith(
                                    color: AppColors.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              TextFormField(
                                enabled: !isSubmitting,
                                decoration: AppStyles.inputDecoration(
                                  hintText: 'Enter your last name',
                                  labelText: 'Last Name',
                                ),
                                style: AppStyles.body,
                                onChanged: (value) {
                                  context.read<OwnerSignUpBloc>().add(
                                        OwnerSignUpLastNameChanged(value),
                                      );
                                },
                              ),
                              if (state.lastName.displayError != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Required, alphabetic characters only',
                                  style: AppStyles.body.copyWith(
                                    color: AppColors.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                enabled: !isSubmitting,
                                decoration: AppStyles.inputDecoration(
                                  hintText: 'Enter your email',
                                  labelText: 'Email',
                                ),
                                style: AppStyles.body,
                                onChanged: (value) {
                                  context.read<OwnerSignUpBloc>().add(
                                        OwnerSignUpEmailChanged(value),
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
                                  context.read<OwnerSignUpBloc>().add(
                                        OwnerSignUpPasswordChanged(value),
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
                              const SizedBox(height: 16),
                              TextFormField(
                                obscureText: _obscureConfirmPassword,
                                enabled: !isSubmitting,
                                decoration: AppStyles.inputDecoration(
                                  hintText: 'Confirm your password',
                                  labelText: 'Confirm Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.textSecondary,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                ),
                                style: AppStyles.body,
                                onChanged: (value) {
                                  context.read<OwnerSignUpBloc>().add(
                                        OwnerSignUpConfirmPasswordChanged(value),
                                      );
                                },
                              ),
                              if (state.confirmPassword.displayError != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Passwords must match',
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
                                        context.read<OwnerSignUpBloc>().add(
                                              const OwnerSignUpSubmitted(),
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
                                        'Sign Up',
                                        style: AppStyles.buttonText.copyWith(
                                          fontSize: 16,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: isSubmitting
                            ? null
                            : () {
                                context.router.maybePop();
                              },
                        child: Text(
                          'Already have an account? Sign In',
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
