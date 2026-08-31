part of 'employee_home_bloc.dart';

class EmployeeHomeState extends Equatable {
  final FormzSubmissionStatus status;
  final String? businessId;
  final String? errorMessage;

  const EmployeeHomeState({
    this.status = FormzSubmissionStatus.initial,
    this.businessId,
    this.errorMessage,
  });

  EmployeeHomeState copyWith({
    FormzSubmissionStatus? status,
    String? businessId,
    String? errorMessage,
  }) {
    return EmployeeHomeState(
      status: status ?? this.status,
      businessId: businessId ?? this.businessId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, businessId, errorMessage];
}
