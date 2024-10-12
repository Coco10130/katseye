import 'dart:async';

import 'package:eukay/pages/dashboard/mappers/product_model.dart';
import 'package:eukay/pages/profile/mappers/address_model.dart';
import 'package:eukay/pages/profile/mappers/barangay_model.dart';
import 'package:eukay/pages/profile/mappers/municipality_model.dart';
import 'package:eukay/pages/profile/mappers/profile_model.dart';
import 'package:eukay/pages/profile/repo/profile_repository.dart';
import 'package:eukay/pages/shop/mappers/sales_product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;
  ProfileBloc(this._profileRepository) : super(ProfileInitial()) {
    on<ProfileInitialFetchEvent>(profileInitialFetchEvent);
    on<ProfileUpdateEvent>(profileUpdateEvent);
    on<FetchMunicipalitiesEvent>(fetchMunicipalitiesEvent);
    on<FetchBarangaysEvent>(fetchBarangaysEvent);
    on<AddUserAddressEvent>(addUserAddressEvent);
    on<FetchUserAddressEvent>(fetchUserAddressEvent);
    on<FetchUserWishlistsEvent>(fetchUserWishlistsEvent);
    on<DeleteAddressEvent>(deleteAddressEvent);
    on<CancelOrderEvent>(cancelOrderEvent);
    on<UseAddressEvent>(useAddressEvent);
    on<FetchOrdersEvent>(fetchOrdersEvent);
    on<FetchDeliveryAddressEvent>(fetchDeliveryAddressEvent);
    on<AddReviewProductEvent>(addReviewProductEvent);
    on<ProfileLogoutEvent>((event, emit) {
      emit(ProfileInitial());
    });
  }

  FutureOr<void> profileInitialFetchEvent(
      ProfileInitialFetchEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    try {
      final response = await _profileRepository.fetchProfile(event.token);
      emit(FetchProfileSuccessState(profile: response));
    } catch (e) {
      emit(FetchProfileFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> profileUpdateEvent(
      ProfileUpdateEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    try {
      final response = await _profileRepository.updateProfile(
        event.id,
        event.token,
        event.userName,
        event.email,
        event.phoneNumber,
        event.image,
      );

      if (response) {
        emit(ProfileUpdateSuccessfulState(
            successMessage: "Profile updated successfully"));
      }
    } catch (e) {
      emit(ProfileUpdateFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> fetchMunicipalitiesEvent(
      FetchMunicipalitiesEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    try {
      final response = await _profileRepository.fetchMunicipality();

      emit(FetchMunicipalitiesSuccessState(municipalities: response));
    } catch (e) {
      emit(FetchingFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> fetchBarangaysEvent(
      FetchBarangaysEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    try {
      final response =
          await _profileRepository.fetchBarangays(event.municipalityCode);

      emit(FetchBarangaysSccessState(barangays: response));
    } catch (e) {
      emit(FetchingFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> addUserAddressEvent(
      AddUserAddressEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    try {
      final response = await _profileRepository.addAddress(
        event.token,
        event.fullName,
        event.municipality,
        event.barangay,
        event.contact,
        event.street,
      );

      if (response) {
        emit(AddUserAddressSuccessState(
            successMessage: "Address added successfully"));
      }
    } catch (e) {
      emit(AddUserAddressFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> fetchUserAddressEvent(
      FetchUserAddressEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());

    try {
      final response = await _profileRepository.fetchUserAddresses(
          event.userId, event.token);

      emit(FetchUserAddressSuccessState(addresses: response));

      emit(FetchUserAddressSuccessState(addresses: response));
    } catch (e) {
      emit(FetchUserAddressFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> deleteAddressEvent(
      DeleteAddressEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    try {
      final response =
          await _profileRepository.deleteAddress(event.addressId, event.token);

      if (response) {
        emit(DeleteAddressSuccessState(
            successMessage: "Address deleted successfully"));
      } else {
        throw Exception("Something went wrong");
      }
    } catch (e) {
      emit(DeleteAddressFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> fetchUserWishlistsEvent(
      FetchUserWishlistsEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());

    try {
      final response = await _profileRepository.fetchWishlists(event.token);

      emit(WishListSuccessState(products: response));
    } catch (e) {
      emit(WishListFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> useAddressEvent(
      UseAddressEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());

    try {
      final response =
          await _profileRepository.useAddress(event.token, event.addressId);

      if (response) {
        emit(UseAddressSuccessState(
            successMessage: "Address used successfully"));
      } else {
        throw Exception("Something went wrong");
      }
    } catch (e) {
      emit(UseAddressFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> fetchDeliveryAddressEvent(
      FetchDeliveryAddressEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());

    try {
      final response = await _profileRepository.fetchUserAddresses(
          event.userId, event.token);

      AddressModel? address;

      for (var i = 0; i < response.length; i++) {
        final currentAddress = response[i];

        if (currentAddress.inUse) {
          address = currentAddress;
          break;
        }
      }
      if (address == null) {
        emit(DeliveryAddressEmpty(errorMessage: "No shipping address in use"));
      } else {
        emit(FetchDeliveryAddressSuccessState(address: address));
      }
    } catch (e) {
      emit(FetchUserAddressFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> fetchOrdersEvent(
      FetchOrdersEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());

    try {
      final response = await _profileRepository.fetchOrdersProduct(
          event.token, event.status);

      emit(FetchOrdersProductsSuccessState(products: response));
    } catch (e) {
      emit(FetchOrdersProductsFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> addReviewProductEvent(
      AddReviewProductEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    try {
      final response = await _profileRepository.addReview(
        token: event.token,
        starRating: event.starRating,
        review: event.review,
        productId: event.productId,
        orderId: event.orderId,
        id: event.id,
      );

      if (response) {
        emit(AddReviewProductSuccessState(
            successMessage: "Review posted successfully"));
      }
    } catch (e) {
      emit(AddReviewProductFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> cancelOrderEvent(
      CancelOrderEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());

    try {
      final response = await _profileRepository.cancelOrder(
          token: event.token, orderId: event.orderId, status: event.status);

      if (response) {
        emit(CancelOrderSuccessState(
            successMessage: "Order cancelled successfully"));
      } else {
        emit(CancelOrderFailedState(errorMessage: "Failed to cancel order"));
      }
    } catch (e) {
      emit(CancelOrderFailedState(errorMessage: e.toString()));
    }
  }
}
