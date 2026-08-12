import 'package:formz/formz.dart';

enum PinValidationError { empty, invalid }

class PinInput extends FormzInput<String, PinValidationError> {
  const PinInput.pure() : super.pure('');
  const PinInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _pinRegExp = RegExp(r'^\d{4}$');

  @override
  PinValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return PinValidationError.empty;
    }
    return _pinRegExp.hasMatch(value) ? null : PinValidationError.invalid;
  }
}
