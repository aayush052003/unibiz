import 'package:formz/formz.dart';

enum LastNameValidationError { empty, invalid }

class LastNameInput extends FormzInput<String, LastNameValidationError> {
  const LastNameInput.pure() : super.pure('');
  const LastNameInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _nameRegExp = RegExp(r'^[a-zA-Z\s]+$');

  @override
  LastNameValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LastNameValidationError.empty;
    }
    return _nameRegExp.hasMatch(value) ? null : LastNameValidationError.invalid;
  }
}
