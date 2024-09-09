part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

final class FetchSearchedProductEvent extends SearchEvent {
  final String searchPrompt;

  FetchSearchedProductEvent({required this.searchPrompt});
}

final class FetchViewProductEvent extends SearchEvent {
  final String productId;

  FetchViewProductEvent({required this.productId});
}
