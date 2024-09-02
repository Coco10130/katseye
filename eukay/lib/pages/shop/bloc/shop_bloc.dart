import 'dart:async';

import 'package:eukay/pages/shop/repo/shop_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final ShopRepository _shopRepository;
  ShopBloc(this._shopRepository) : super(ShopInitial()) {
    on<RegisterShopEvent>(registerShopEvent);
  }

  FutureOr<void> registerShopEvent(
      RegisterShopEvent event, Emitter<ShopState> emit) async {
    try {
      emit(RegistrationLoadingState());

      final response = await _shopRepository.registerShop(
          event.token, event.shopName, event.shopContact, event.shopEmail);

      if (response) {
        emit(RegisterShopSuccessState(
            successMessage: "Shop registered successfully!"));
      } else {
        emit(RegisterShopFailedState(errorMessage: "Failed to register shop."));
      }
    } catch (e) {
      emit(RegisterShopFailedState(errorMessage: e.toString()));
    }
  }
}
