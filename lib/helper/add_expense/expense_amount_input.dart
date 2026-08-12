import 'package:formz/formz.dart';

enum ExpenseAmountValidationError { empty, invalid, nonPositive }

class ExpenseAmountInput extends FormzInput<String, ExpenseAmountValidationError> {
  const ExpenseAmountInput.pure() : super.pure('');
  const ExpenseAmountInput.dirty([super.value = '']) : super.dirty();

  @override
  ExpenseAmountValidationError? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return ExpenseAmountValidationError.empty;
    final parsed = double.tryParse(trimmed);
    if (parsed == null) return ExpenseAmountValidationError.invalid;
    if (parsed <= 0) return ExpenseAmountValidationError.nonPositive;
    return null;
  }
}
