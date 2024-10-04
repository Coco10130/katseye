part of 'search_bloc.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchProductSuccessState extends SearchState {
  final List<ProductModel> products;

  SearchProductSuccessState({required this.products});
}

final class SearchProductSuccessEmptyState extends SearchState {
  final String message;

  SearchProductSuccessEmptyState({required this.message});
}

final class SearchProductFailedState extends SearchState {
  final String errorMessage;

  SearchProductFailedState({required this.errorMessage});
}

final class ViewProductFailedState extends SearchState {
  final String errorMessage;

  ViewProductFailedState({required this.errorMessage});
}

final class ViewProductSuccessState extends SearchState {
  final ProductModel product;

  ViewProductSuccessState({required this.product});
}

final class AddToCartSuccessState extends SearchState {
  final String successMessage, token;

  AddToCartSuccessState({required this.successMessage, required this.token});
}

final class AddToCartFailedState extends SearchState {
  final String errorMessage;

  AddToCartFailedState({required this.errorMessage});
}

final class WishlistSuccessState extends SearchState {
  final String successMessage;

  WishlistSuccessState({required this.successMessage});
}

final class WishlistFailedState extends SearchState {
  final String errorMessage;

  WishlistFailedState({required this.errorMessage});
}

final class SearchLoadingState extends SearchState {}
