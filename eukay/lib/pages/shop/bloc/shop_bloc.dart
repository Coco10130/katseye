import 'dart:async';

import 'package:eukay/pages/shop/mappers/seller_model.dart';
import 'package:eukay/pages/shop/repo/shop_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final ShopRepository _shopRepository;
  ShopBloc(this._shopRepository) : super(ShopInitial()) {
    on<RegisterShopEvent>(registerShopEvent);
    on<SendOTPRegistrationEvent>(sendOTPRegistrationEvent);
    on<FetchSellerProfileEvent>(fetchSellerProfileEvent);
  }

  FutureOr<void> registerShopEvent(
      RegisterShopEvent event, Emitter<ShopState> emit) async {
    try {
      emit(ShopLoadingState());

      final response = await _shopRepository.registerShop(
        event.token,
        event.shopName,
        event.shopContact,
        event.shopEmail,
        event.otpHash,
        event.otpCode,
      );
      if (response != null) {
        emit(RegisterShopSuccessState(
            successMessage: "Shop registered successfully!", token: response));
      } else {
        emit(RegisterShopFailedState(errorMessage: "Failed to register shop."));
      }
    } catch (e) {
      emit(RegisterShopFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> sendOTPRegistrationEvent(
      SendOTPRegistrationEvent event, Emitter<ShopState> emit) async {
    try {
      emit(ShopLoadingState());

      final response = await _shopRepository.sendOTP(event.email, event.token);

      if (response != null) {
        emit(OtpSentSuccessState(
            successMessage: "OTP sent successfully", otpHash: response));
      } else {
        emit(OtpSentFailedState(errorMessage: "Failed to send OTP"));
      }
    } catch (e) {
      emit(OtpSentFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> fetchSellerProfileEvent(
      FetchSellerProfileEvent event, Emitter<ShopState> emit) async {
    try {
      final response = await _shopRepository.fetchSellerProfile(event.token);

      emit(FetchSellerSuccessState(seller: response));
    } catch (e) {
      emit(FetchSellerFailedState(errorMessage: e.toString()));
    }
  }
}
