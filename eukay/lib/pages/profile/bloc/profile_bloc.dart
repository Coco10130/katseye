import 'dart:async';

import 'package:eukay/pages/profile/mappers/address_model.dart';
import 'package:eukay/pages/profile/mappers/barangay_model.dart';
import 'package:eukay/pages/profile/mappers/municipality_model.dart';
import 'package:eukay/pages/profile/mappers/profile_model.dart';
import 'package:eukay/pages/profile/repo/profile_repository.dart';
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
}
