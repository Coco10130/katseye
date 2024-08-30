import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eukay/pages/profile/mappers/profile_model.dart';
import 'package:eukay/pages/profile/repo/profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileInitialFetchEvent>(profileInitialFetchEvent);
    on<ProfileUpdateEvent>(profileUpdateEvent);
  }

  FutureOr<void> profileInitialFetchEvent(
      ProfileInitialFetchEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    try {
      final response = await ProfileRepo().fetchProfile(event.token);
      emit(FetchProfileSuccessState(profile: response));
    } catch (e) {
      emit(FetchProfileFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> profileUpdateEvent(
      ProfileUpdateEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    try {
      final response = await ProfileRepo().updateProfile(
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
}
