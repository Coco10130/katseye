import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart.event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitalState()) {
    on<InitializeCart>((event, emit) {
      emit(CartUpdateState(cartItems: event.cartItems));
    });

    on<CartAddQuantity>((event, emit) {
      if (state is CartUpdateState) {
        final cartItems = List<Map<String, dynamic>>.from(
            (state as CartUpdateState).cartItems);
        cartItems[event.index]["quantity"]++;
        emit(CartUpdateState(cartItems: cartItems));
      }
    });

    on<CartMinusQuantity>((event, emit) {
      if (state is CartUpdateState) {
        final cartItems = List<Map<String, dynamic>>.from(
            (state as CartUpdateState).cartItems);
        if (cartItems[event.index]["quantity"] > 0) {
          cartItems[event.index]["quantity"]--;
          return emit(CartUpdateState(cartItems: cartItems));
        }
      }
    });

    on<CartToggleCheckOut>((event, emit) {
      if (state is CartUpdateState) {
        final cartItems = List<Map<String, dynamic>>.from(
            (state as CartUpdateState).cartItems);

        cartItems[event.index]["toCheckOut"] =
            !cartItems[event.index]["toCheckOut"];
        emit(CartUpdateState(cartItems: cartItems));
      }
    });
  }
}
