part of 'manager_home_bloc.dart';

class ManagerHomeState extends Equatable {
  final FormzSubmissionStatus status;
  final String? businessId;
  final String? errorMessage;

  const ManagerHomeState({
    this.status = FormzSubmissionStatus.initial,
    this.businessId,
    this.errorMessage,
  });

  ManagerHomeState copyWith({
    FormzSubmissionStatus? status,
    String? businessId,
    String? errorMessage,
  }) {
    return ManagerHomeState(
      status: status ?? this.status,
      businessId: businessId ?? this.businessId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, businessId, errorMessage];
}
