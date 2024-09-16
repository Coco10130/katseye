import 'dart:async';

import 'package:eukay/pages/cart/mappers/cart_model.dart';
import 'package:eukay/pages/cart/repo/cart_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart.event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;
  CartBloc(this._cartRepository) : super(CartInitalState()) {
    on<InitialCartFetchEvent>(initialCartFetchEvent);
  }

  FutureOr<void> initialCartFetchEvent(
      InitialCartFetchEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      final response = await _cartRepository.fetchCart(event.token);

      emit(FetchCartSuccessState(cartItems: response));
    } catch (e) {
      emit(FetchCartFailedState(errorMessage: e.toString()));
    }
  }
}
