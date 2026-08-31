part of 'employee_sales_bloc.dart';

class EmployeeSalesState extends Equatable {
  final FormzSubmissionStatus status;
  final String? businessId;
  final String? errorMessage;

  const EmployeeSalesState({
    this.status = FormzSubmissionStatus.initial,
    this.businessId,
    this.errorMessage,
  });

  EmployeeSalesState copyWith({
    FormzSubmissionStatus? status,
    String? businessId,
    String? errorMessage,
  }) {
    return EmployeeSalesState(
      status: status ?? this.status,
      businessId: businessId ?? this.businessId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, businessId, errorMessage];
}
