part of 'business_list_bloc.dart';

@immutable
sealed class BusinessListEvent extends Equatable {
  const BusinessListEvent();

  @override
  List<Object?> get props => [];
}

final class FetchBusinessListRequested extends BusinessListEvent {
  final String ownerId;

  const FetchBusinessListRequested(this.ownerId);

  @override
  List<Object?> get props => [ownerId];
}
