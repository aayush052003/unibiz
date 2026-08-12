part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

final class FetchDashboardRequested extends DashboardEvent {
  final String ownerId;

  const FetchDashboardRequested(this.ownerId);

  @override
  List<Object?> get props => [ownerId];
}
