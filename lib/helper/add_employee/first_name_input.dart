import 'package:formz/formz.dart';

enum FirstNameValidationError { empty }

class FirstNameInput extends FormzInput<String, FirstNameValidationError> {
  const FirstNameInput.pure() : super.pure('');
  const FirstNameInput.dirty([super.value = '']) : super.dirty();

  @override
  FirstNameValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return FirstNameValidationError.empty;
    }
    return null;
  }
}
