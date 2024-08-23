part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

final class CartInitalState extends CartState {}

final class CartUpdateState extends CartState {
  final List<Map<String, dynamic>> cartItems;

  CartUpdateState({required this.cartItems});
}
