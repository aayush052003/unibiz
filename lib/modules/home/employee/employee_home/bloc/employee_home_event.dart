part of 'employee_home_bloc.dart';

@immutable
sealed class EmployeeHomeEvent extends Equatable {
  const EmployeeHomeEvent();

  @override
  List<Object?> get props => [];
}

class FetchEmployeeBusinessRequested extends EmployeeHomeEvent {
  final String userId;

  const FetchEmployeeBusinessRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class RefreshEmployeeHomeRequested extends EmployeeHomeEvent {
  final String userId;

  const RefreshEmployeeHomeRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}
