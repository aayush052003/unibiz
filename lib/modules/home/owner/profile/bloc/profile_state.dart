part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final FormzSubmissionStatus status;
  final ProfileModel? profile;
  final String? errorMessage;

  const ProfileState({
    this.status = FormzSubmissionStatus.initial,
    this.profile,
    this.errorMessage,
  });

  ProfileState copyWith({
    FormzSubmissionStatus? status,
    ProfileModel? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}
