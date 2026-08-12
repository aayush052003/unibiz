import 'package:formz/formz.dart';

enum BusinessNameValidationError { empty }

class BusinessNameInput extends FormzInput<String, BusinessNameValidationError> {
  const BusinessNameInput.pure() : super.pure('');
  const BusinessNameInput.dirty([super.value = '']) : super.dirty();

  @override
  BusinessNameValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return BusinessNameValidationError.empty;
    }
    return null;
  }
}
