import 'package:formz/formz.dart';

enum ExpenseDescriptionValidationError { empty }

class ExpenseDescriptionInput extends FormzInput<String, ExpenseDescriptionValidationError> {
  const ExpenseDescriptionInput.pure() : super.pure('');
  const ExpenseDescriptionInput.dirty([super.value = '']) : super.dirty();

  @override
  ExpenseDescriptionValidationError? validator(String value) {
    return value.trim().isNotEmpty ? null : ExpenseDescriptionValidationError.empty;
  }
}
