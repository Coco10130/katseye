import 'dart:async';

import 'package:eukay/pages/dashboard/mappers/product_model.dart';
import 'package:eukay/pages/shop/mappers/sales_product_model.dart';
import 'package:eukay/pages/shop/mappers/seller_model.dart';
import 'package:eukay/pages/shop/repo/shop_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final ShopRepository _shopRepository;
  ShopBloc(this._shopRepository) : super(ShopInitial()) {
    on<RegisterShopEvent>(registerShopEvent);
    on<SendOTPRegistrationEvent>(sendOTPRegistrationEvent);
    on<FetchSellerProfileEvent>(fetchSellerProfileEvent);
    on<MarkAsNextStepProductEvent>(markAsNextStepProductEvent);
    on<AddProductEvent>(addProductEvent);
    on<FetchLiveProductEvent>(fetchLiveProductEvent);
    on<FetchSalesProductEvent>(fetchSalesProductEvent);
    on<ChangeOrderStatusEvent>(changeOrderStatusEvent);
    on<FetchUpdateProductEvent>(fetchUpdateProductEvent);
    on<UpdateProductEvent>(updateProductEvent);
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

  FutureOr<void> addProductEvent(
      AddProductEvent event, Emitter<ShopState> emit) async {
    emit(ShopLoadingState());
    try {
      if (event.price.isEmpty ||
          event.productName.isEmpty ||
          event.description.isEmpty ||
          event.images.isEmpty ||
          event.categories.isEmpty ||
          event.sizes.isEmpty) {
        return emit(AddProductFailedState(
            errorMessage: "Please enter values in all fields"));
      }

      final double productPrice = double.parse(event.price);

      List<int> quantities = [];
      for (String size in event.sizes) {
        final quantityStr = event.sizeQuantities[size] ?? "0";
        quantities.add(int.parse(quantityStr));
      }

      // Validate quantities
      if (quantities.any((quantity) => quantity < 0)) {
        return emit(AddProductFailedState(
            errorMessage: "Quantities must be non-negative"));
      }

      final response = await _shopRepository.addProduct(
          event.token,
          event.productName,
          event.description,
          productPrice,
          quantities,
          event.categories,
          event.sizes,
          event.images);

      if (response) {
        emit(AddProductSuccessState(
            successMessage: "Product Added successfully"));
      } else {
        emit(AddProductFailedState(errorMessage: "Failed to add product"));
      }
    } catch (e) {
      emit(AddProductFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> fetchLiveProductEvent(
      FetchLiveProductEvent event, Emitter<ShopState> emit) async {
    emit(ShopLoadingState());
    try {
      final response = await _shopRepository.fetchProductByStatus(
          event.sellerId, event.token, event.status);

      emit(FetchLiveProductsSuccessState(products: response));
    } catch (e) {
      emit(FetchLiveProductsFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> fetchSalesProductEvent(
      FetchSalesProductEvent event, Emitter<ShopState> emit) async {
    emit(ShopLoadingState());

    try {
      final response = await _shopRepository.fetchSalesProduct(
          event.token, event.sellerId, event.status);
      emit(FetchSalesProductsState(products: response));
    } catch (e) {
      emit(FetchProductFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> markAsNextStepProductEvent(
      MarkAsNextStepProductEvent event, Emitter<ShopState> emit) async {
    emit(ShopLoadingState());
    try {
      final response = await _shopRepository.markProductAsNextStep(
          token: event.token,
          status: event.status,
          orderId: event.orderId,
          sellerId: event.sellerId);

      if (response) {
        emit(MarkSalesProductSuccessState(
            successMessage: "Marked product success"));
      } else {
        emit(MarkSalesProductFailedState(errorMessage: "Something went wrong"));
      }
    } catch (e) {
      emit(MarkSalesProductFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> changeOrderStatusEvent(
      ChangeOrderStatusEvent event, Emitter<ShopState> emit) async {
    emit(ShopLoadingState());
    try {
      final response = await _shopRepository.changeSalesStatus(
        nextStatus: event.nextStatus,
        sellerId: event.sellerId,
        status: event.status,
        token: event.token,
      );

      if (response) {
        emit(ChangeStatusSuccessState(
            successMessage: "Status changed successfully"));
      } else {
        emit(ChangeStatusFailedState(errorMessage: "Something went wrong"));
      }
    } catch (e) {
      emit(ChangeStatusFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> fetchUpdateProductEvent(
      FetchUpdateProductEvent event, Emitter<ShopState> emit) async {
    emit(ShopLoadingState());
    try {
      final response = await _shopRepository.fetchUpdateProduct(
          event.token, event.productId);

      emit(FetchUpdateProductState(product: response));
    } catch (e) {
      emit(UpdateProductFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> updateProductEvent(
      UpdateProductEvent event, Emitter<ShopState> emit) async {
    emit(ShopLoadingState());
    try {
      if (event.price.isEmpty ||
          event.productName.isEmpty ||
          event.description.isEmpty ||
          event.sizes.isEmpty) {
        return emit(AddProductFailedState(
            errorMessage: "Please enter values in all fields"));
      }

      final double productPrice = double.parse(event.price);

      List<int> quantities = [];
      for (String size in event.sizes) {
        final quantityStr = event.sizeQuantities[size] ?? 0;
        quantities.add(quantityStr);
      }

      // Validate quantities
      if (quantities.any((quantity) => quantity < 0)) {
        return emit(AddProductFailedState(
            errorMessage: "Quantities must be non-negative"));
      }

      final response = await _shopRepository.updateProduct(
        token: event.token,
        productId: event.productId,
        productName: event.productName,
        productDescription: event.description,
        price: productPrice,
        stocks: quantities,
        sizes: event.sizes,
      );

      if (response) {
        emit(UpdateProductSuccessState(
            successMessage: "Product updated Successfully"));
      }
    } catch (e) {
      emit(UpdateProductFailedState(errorMessage: e.toString()));
    }
  }
}
