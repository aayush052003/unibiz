part of 'manager_home_bloc.dart';

@immutable
sealed class ManagerHomeEvent extends Equatable {
  const ManagerHomeEvent();

  @override
  List<Object?> get props => [];
}

class FetchManagerBusinessRequested extends ManagerHomeEvent {
  final String userId;

  const FetchManagerBusinessRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}
