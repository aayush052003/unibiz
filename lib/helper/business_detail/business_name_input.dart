import 'package:formz/formz.dart';

enum BusinessDetailNameValidationError { empty }

class BusinessDetailNameInput
    extends FormzInput<String, BusinessDetailNameValidationError> {
  const BusinessDetailNameInput.pure([super.value = '']) : super.pure();
  const BusinessDetailNameInput.dirty([super.value = '']) : super.dirty();

  @override
  BusinessDetailNameValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return BusinessDetailNameValidationError.empty;
    }
    return null;
  }
}
