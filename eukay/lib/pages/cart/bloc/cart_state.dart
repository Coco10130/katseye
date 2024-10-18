part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

final class CartInitalState extends CartState {}

final class FetchCartSuccessState extends CartState {
  final List<CartModel> cartItems;

  FetchCartSuccessState({required this.cartItems});
}

final class FetchCartFailedState extends CartState {
  final String errorMessage;

  FetchCartFailedState({required this.errorMessage});
}

final class CartEventFailedState extends CartState {
  final String errorMessage;

  CartEventFailedState({required this.errorMessage});
}

final class DeleteCartItemSuccessState extends CartState {
  final String successMessage, newToken;

  DeleteCartItemSuccessState(
      {required this.successMessage, required this.newToken});
}

final class DeleteCartItemFailedState extends CartState {
  final String errorMessage;

  DeleteCartItemFailedState({required this.errorMessage});
}

final class CartLoadingState extends CartState {}
