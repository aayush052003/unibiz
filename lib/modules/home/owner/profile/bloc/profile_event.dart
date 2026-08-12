part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

final class FetchProfileRequested extends ProfileEvent {
  final String userId;

  const FetchProfileRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}
