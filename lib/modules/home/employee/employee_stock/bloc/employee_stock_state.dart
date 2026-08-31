part of 'employee_stock_bloc.dart';

class EmployeeStockState extends Equatable {
  final FormzSubmissionStatus status;
  final String? businessId;
  final String? errorMessage;

  const EmployeeStockState({
    this.status = FormzSubmissionStatus.initial,
    this.businessId,
    this.errorMessage,
  });

  EmployeeStockState copyWith({
    FormzSubmissionStatus? status,
    String? businessId,
    String? errorMessage,
  }) {
    return EmployeeStockState(
      status: status ?? this.status,
      businessId: businessId ?? this.businessId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, businessId, errorMessage];
}
