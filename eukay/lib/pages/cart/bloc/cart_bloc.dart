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
    on<CartItemAddQuantityEvent>(cartItemAddQuantityEvent);
    on<CartItemMinusQuantityEvent>(cartItemMinusQuantityEvent);
    on<CartItemCheckOutItemEvent>(cartItemCheckOutItemEvent);
    on<DeleteCartItemEvent>(deleteCartItemEvent);
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

  FutureOr<void> cartItemAddQuantityEvent(
      CartItemAddQuantityEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      final response =
          await _cartRepository.addQuantity(event.cartItemId, event.token);

      if (response.isNotEmpty) {
        emit(FetchCartSuccessState(cartItems: response));
      } else {
        emit(CartEventFailedState(errorMessage: "Something went wrong"));
      }
    } catch (e) {
      emit(CartEventFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> cartItemMinusQuantityEvent(
      CartItemMinusQuantityEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      final response =
          await _cartRepository.minusQuantity(event.cartItemId, event.token);

      if (response.isNotEmpty) {
        emit(FetchCartSuccessState(cartItems: response));
      } else {
        emit(CartEventFailedState(errorMessage: "Something went wrong"));
      }
    } catch (e) {
      emit(CartEventFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> cartItemCheckOutItemEvent(
      CartItemCheckOutItemEvent event, Emitter<CartState> emit) async {
    try {
      final response =
          await _cartRepository.toCheckOut(event.cartItemId, event.token);

      if (response.isNotEmpty) {
        emit(FetchCartSuccessState(cartItems: response));
      } else {
        emit(CartEventFailedState(errorMessage: "Something went wrong"));
      }
    } catch (e) {
      emit(CartEventFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> deleteCartItemEvent(
      DeleteCartItemEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      final response = await _cartRepository.deleteCartItem(event.token);

      if (response.isNotEmpty) {
        emit(DeleteCartItemSuccessState(
            successMessage: "Item deleted successfully", newToken: response));
      } else {
        emit(DeleteCartItemFailedState(errorMessage: "Something went wrong"));
      }
    } catch (e) {
      emit(DeleteCartItemFailedState(errorMessage: e.toString()));
    }
  }
}
