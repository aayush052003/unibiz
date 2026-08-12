part of 'business_list_bloc.dart';

class BusinessListState extends Equatable {
  final FormzSubmissionStatus status;
  final List<BusinessListModel> businesses;
  final String? errorMessage;

  const BusinessListState({
    this.status = FormzSubmissionStatus.initial,
    this.businesses = const [],
    this.errorMessage,
  });

  BusinessListState copyWith({
    FormzSubmissionStatus? status,
    List<BusinessListModel>? businesses,
    String? errorMessage,
  }) {
    return BusinessListState(
      status: status ?? this.status,
      businesses: businesses ?? this.businesses,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, businesses, errorMessage];
}
