part of 'search_bloc.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchProductSuccessState extends SearchState {
  final List<ProductModel> products;

  SearchProductSuccessState({required this.products});
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

final class SearchLoadingState extends SearchState {}
