part of 'owner_products_bloc.dart';

@immutable
sealed class OwnerProductsEvent extends Equatable {
  const OwnerProductsEvent();

  @override
  List<Object?> get props => [];
}

class FetchOwnerProductsBusinessesRequested extends OwnerProductsEvent {
  final String ownerId;

  const FetchOwnerProductsBusinessesRequested(this.ownerId);

  @override
  List<Object?> get props => [ownerId];
}
