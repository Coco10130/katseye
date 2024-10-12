part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

final class InitialCartFetchEvent extends CartEvent {
  final String token;

  InitialCartFetchEvent({required this.token});
}

final class CartItemAddQuantityEvent extends CartEvent {
  final String cartItemId, token;

  CartItemAddQuantityEvent({required this.cartItemId, required this.token});
}

final class CartItemMinusQuantityEvent extends CartEvent {
  final String cartItemId, token;
  final int quantity;

  CartItemMinusQuantityEvent(
      {required this.cartItemId, required this.token, required this.quantity});
}

final class CartItemCheckOutItemEvent extends CartEvent {
  final String cartItemId, token;

  CartItemCheckOutItemEvent({required this.cartItemId, required this.token});
}
