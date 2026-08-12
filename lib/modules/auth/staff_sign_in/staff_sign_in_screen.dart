import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import '../../../constants/colors.dart';
import '../../../constants/styles.dart';
import '../../../widgets/brand_logo.dart';
import '../../../route_config/route.gr.dart';
import 'bloc/staff_sign_in_bloc.dart';
import 'repo/staff_sign_in_repo.dart';

@RoutePage()
class StaffSignInScreen extends StatefulWidget {
  const StaffSignInScreen({super.key});

  @override
  State<StaffSignInScreen> createState() => _StaffSignInScreenState();
}

class _StaffSignInScreenState extends State<StaffSignInScreen> {
  bool _obscurePin = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StaffSignInBloc(repo: StaffSignInRepo()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocConsumer<StaffSignInBloc, StaffSignInState>(
            listener: (context, state) {
              if (state.status == FormzSubmissionStatus.success) {
                final role = state.uniqueId.value.substring(0, 3).toUpperCase();
                if (role == 'MAN') {
                  context.router.replaceAll([const ManagerHomeRoute()]);
                } else if (role == 'EMP') {
                  context.router.replaceAll([const EmployeeHomeRoute()]);
                }
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
                        'Staff Sign In',
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
                                textCapitalization: TextCapitalization.characters,
                                enabled: !isSubmitting,
                                decoration: AppStyles.inputDecoration(
                                  hintText: 'Enter Unique ID (e.g. MAN4821)',
                                  labelText: 'Unique ID',
                                ),
                                style: AppStyles.body,
                                onChanged: (value) {
                                  context.read<StaffSignInBloc>().add(
                                        StaffSignInUniqueIdChanged(value),
                                      );
                                },
                              ),
                              if (state.uniqueId.displayError != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Must start with MAN or EMP followed by 4 digits',
                                  style: AppStyles.body.copyWith(
                                    color: AppColors.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              TextFormField(
                                obscureText: _obscurePin,
                                keyboardType: TextInputType.number,
                                enabled: !isSubmitting,
                                decoration: AppStyles.inputDecoration(
                                  hintText: 'Enter 4-digit PIN',
                                  labelText: 'PIN',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePin
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.textSecondary,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePin = !_obscurePin;
                                      });
                                    },
                                  ),
                                ),
                                style: AppStyles.body,
                                onChanged: (value) {
                                  context.read<StaffSignInBloc>().add(
                                        StaffSignInPinChanged(value),
                                      );
                                },
                              ),
                              if (state.pin.displayError != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'PIN must be exactly 4 digits',
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
                                        context.read<StaffSignInBloc>().add(
                                              const StaffSignInSubmitted(),
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
                      TextButton(
                        onPressed: isSubmitting
                            ? null
                            : () {
                                context.router.maybePop();
                              },
                        child: Text(
                          'Back to Role Selection',
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
