part of 'staff_sign_in_bloc.dart';

@immutable
sealed class StaffSignInEvent extends Equatable {
  const StaffSignInEvent();

  @override
  List<Object?> get props => [];
}

class StaffSignInUniqueIdChanged extends StaffSignInEvent {
  final String uniqueId;
  const StaffSignInUniqueIdChanged(this.uniqueId);

  @override
  List<Object?> get props => [uniqueId];
}

class StaffSignInPinChanged extends StaffSignInEvent {
  final String pin;
  const StaffSignInPinChanged(this.pin);

  @override
  List<Object?> get props => [pin];
}

class StaffSignInSubmitted extends StaffSignInEvent {
  const StaffSignInSubmitted();
}
