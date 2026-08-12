part of 'staff_sign_in_bloc.dart';

class StaffSignInState extends Equatable {
  final UniqueIdInput uniqueId;
  final PinInput pin;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  const StaffSignInState({
    this.uniqueId = const UniqueIdInput.pure(),
    this.pin = const PinInput.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  StaffSignInState copyWith({
    UniqueIdInput? uniqueId,
    PinInput? pin,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return StaffSignInState(
      uniqueId: uniqueId ?? this.uniqueId,
      pin: pin ?? this.pin,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [uniqueId, pin, status, errorMessage];
}
