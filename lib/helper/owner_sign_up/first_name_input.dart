import 'package:formz/formz.dart';

enum FirstNameValidationError { empty, invalid }

class FirstNameInput extends FormzInput<String, FirstNameValidationError> {
  const FirstNameInput.pure() : super.pure('');
  const FirstNameInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _nameRegExp = RegExp(r'^[a-zA-Z\s]+$');

  @override
  FirstNameValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return FirstNameValidationError.empty;
    }
    return _nameRegExp.hasMatch(value) ? null : FirstNameValidationError.invalid;
  }
}
