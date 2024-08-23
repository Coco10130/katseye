part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

final class InitializeCart extends CartEvent {
  final List<Map<String, dynamic>> cartItems;

  InitializeCart({required this.cartItems});
}

final class CartAddQuantity extends CartEvent {
  final int index;

  CartAddQuantity({required this.index});
}

final class CartMinusQuantity extends CartEvent {
  final int index;

  CartMinusQuantity({required this.index});
}

final class CartToggleCheckOut extends CartEvent {
  final int index;

  CartToggleCheckOut({required this.index});
}
