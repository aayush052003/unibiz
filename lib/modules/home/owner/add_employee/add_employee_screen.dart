import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:formz/formz.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/styles.dart';
import '../../../../helper/hive_service.dart';
import '../../../../helper/add_employee/first_name_input.dart';
import '../../../../helper/add_employee/last_name_input.dart';
import '../../../../helper/add_employee/email_input.dart';
import '../../../../helper/add_employee/pin_input.dart';
import 'bloc/add_employee_bloc.dart';
import 'repo/add_employee_repo.dart';

@RoutePage()
class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  bool _obscurePin = true;

  @override
  Widget build(BuildContext context) {
    final ownerId = HiveService.getUserId() ?? '';

    return BlocProvider(
      create: (context) => AddEmployeeBloc(addEmployeeRepo: AddEmployeeRepo()),
      child: BlocConsumer<AddEmployeeBloc, AddEmployeeState>(
        listener: (context, state) {
          if (state.status == FormzSubmissionStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Employee added successfully'),
                backgroundColor: AppColors.success,
              ),
            );
            context.router.maybePop(true);
          } else if (state.status == FormzSubmissionStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Failed to add employee'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isSubmitting = state.status == FormzSubmissionStatus.inProgress;

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: Text(
                'Add Employee',
                style: AppStyles.heading.copyWith(color: Colors.white, fontSize: 18),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // First Name
                    TextFormField(
                      onChanged: (value) =>
                          context.read<AddEmployeeBloc>().add(FirstNameChanged(value)),
                      decoration: AppStyles.inputDecoration(
                        hintText: 'Enter first name',
                        labelText: 'First Name',
                      ).copyWith(
                        errorText: state.firstName.displayError == FirstNameValidationError.empty
                            ? 'First name is required'
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Last Name
                    TextFormField(
                      onChanged: (value) =>
                          context.read<AddEmployeeBloc>().add(LastNameChanged(value)),
                      decoration: AppStyles.inputDecoration(
                        hintText: 'Enter last name',
                        labelText: 'Last Name',
                      ).copyWith(
                        errorText: state.lastName.displayError == LastNameValidationError.empty
                            ? 'Last name is required'
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) =>
                          context.read<AddEmployeeBloc>().add(EmailChanged(value)),
                      decoration: AppStyles.inputDecoration(
                        hintText: 'Enter email address',
                        labelText: 'Email',
                      ).copyWith(
                        errorText: state.email.displayError == EmailValidationError.empty
                            ? 'Email is required'
                            : state.email.displayError == EmailValidationError.invalid
                                ? 'Enter a valid email format'
                                : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Role Dropdown
                    DropdownButtonFormField<String>(
                      value: state.role.value.isNotEmpty ? state.role.value : null,
                      decoration: AppStyles.inputDecoration(
                        hintText: 'Select role',
                        labelText: 'Role',
                      ).copyWith(
                        errorText: state.role.displayError != null
                            ? 'Select a valid role (Manager or Employee)'
                            : null,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Manager',
                          child: Text('Manager'),
                        ),
                        DropdownMenuItem(
                          value: 'Employee',
                          child: Text('Employee'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          context.read<AddEmployeeBloc>().add(RoleChanged(value));
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // PIN
                    TextFormField(
                      keyboardType: TextInputType.number,
                      obscureText: _obscurePin,
                      maxLength: 4,
                      onChanged: (value) =>
                          context.read<AddEmployeeBloc>().add(PinChanged(value)),
                      decoration: AppStyles.inputDecoration(
                        hintText: 'Enter 4-digit PIN',
                        labelText: 'PIN',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePin ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePin = !_obscurePin;
                            });
                          },
                        ),
                      ).copyWith(
                        counterText: '',
                        errorText: state.pin.displayError == PinValidationError.empty
                            ? 'PIN is required'
                            : state.pin.displayError == PinValidationError.invalid
                                ? 'PIN must be exactly 4 digits'
                                : null,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () {
                              context
                                  .read<AddEmployeeBloc>()
                                  .add(AddEmployeeSubmitted(ownerId));
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
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
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Add Account',
                              style: AppStyles.buttonText.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
