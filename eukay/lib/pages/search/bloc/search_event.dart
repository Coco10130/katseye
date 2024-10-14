part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

final class FetchSearchedProductEvent extends SearchEvent {
  final String? gender, ratings, category, priceRange, searchPrompt;

  FetchSearchedProductEvent({
    this.searchPrompt,
    this.gender,
    this.ratings,
    this.category,
    this.priceRange,
  });
}

final class FetchViewProductEvent extends SearchEvent {
  final String productId;

  FetchViewProductEvent({required this.productId});
}

final class AddToCartEvent extends SearchEvent {
  final String productId, token, size;

  AddToCartEvent(
      {required this.productId, required this.token, required this.size});
}

final class AddWishlistEvent extends SearchEvent {
  final String productId, token;

  AddWishlistEvent({required this.productId, required this.token});
}

final class RemoveWishlistEvent extends SearchEvent {
  final String productId, token;

  RemoveWishlistEvent({required this.productId, required this.token});
}

final class ReportProductEvent extends SearchEvent {
  final String token, productId, type, reason;

  ReportProductEvent(
      {required this.token,
      required this.productId,
      required this.type,
      required this.reason});
}
