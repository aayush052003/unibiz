part of 'owner_products_bloc.dart';

class OwnerProductsState extends Equatable {
  final FormzSubmissionStatus status;
  final List<OwnerProductsModel> businesses;
  final String? errorMessage;

  const OwnerProductsState({
    this.status = FormzSubmissionStatus.initial,
    this.businesses = const [],
    this.errorMessage,
  });

  OwnerProductsState copyWith({
    FormzSubmissionStatus? status,
    List<OwnerProductsModel>? businesses,
    String? errorMessage,
  }) {
    return OwnerProductsState(
      status: status ?? this.status,
      businesses: businesses ?? this.businesses,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, businesses, errorMessage];
}
