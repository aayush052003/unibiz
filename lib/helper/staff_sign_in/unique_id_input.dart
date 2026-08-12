import 'package:formz/formz.dart';

enum UniqueIdValidationError { empty, invalid }

class UniqueIdInput extends FormzInput<String, UniqueIdValidationError> {
  const UniqueIdInput.pure() : super.pure('');
  const UniqueIdInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _uniqueIdRegExp = RegExp(r'^(MAN|EMP)\d{4}$');

  @override
  UniqueIdValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return UniqueIdValidationError.empty;
    }
    return _uniqueIdRegExp.hasMatch(value) ? null : UniqueIdValidationError.invalid;
  }
}
