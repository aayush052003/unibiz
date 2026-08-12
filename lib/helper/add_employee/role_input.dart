import 'package:formz/formz.dart';

enum RoleValidationError { empty, invalid }

class RoleInput extends FormzInput<String, RoleValidationError> {
  const RoleInput.pure() : super.pure('');
  const RoleInput.dirty([super.value = '']) : super.dirty();

  @override
  RoleValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return RoleValidationError.empty;
    }
    final lower = value.trim().toLowerCase();
    if (lower == 'manager' || lower == 'employee') {
      return null;
    }
    return RoleValidationError.invalid;
  }
}
