import 'package:formz/formz.dart';

enum LastNameValidationError { empty }

class LastNameInput extends FormzInput<String, LastNameValidationError> {
  const LastNameInput.pure() : super.pure('');
  const LastNameInput.dirty([super.value = '']) : super.dirty();

  @override
  LastNameValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LastNameValidationError.empty;
    }
    return null;
  }
}
