part of 'employee_bloc.dart';

class EmployeeState extends Equatable {
  final FormzSubmissionStatus status;
  final List<EmployeeModel> employees;
  final String? errorMessage;

  const EmployeeState({
    this.status = FormzSubmissionStatus.initial,
    this.employees = const [],
    this.errorMessage,
  });

  EmployeeState copyWith({
    FormzSubmissionStatus? status,
    List<EmployeeModel>? employees,
    String? errorMessage,
  }) {
    return EmployeeState(
      status: status ?? this.status,
      employees: employees ?? this.employees,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, employees, errorMessage];
}
