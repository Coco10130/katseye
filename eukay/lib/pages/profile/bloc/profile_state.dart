part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class FetchProfileFailedState extends ProfileState {
  final String errorMessage;

  FetchProfileFailedState({required this.errorMessage});
}

final class FetchProfileSuccessState extends ProfileState {
  final ProfileModel profile;

  FetchProfileSuccessState({required this.profile});
}

final class ProfileUpdateSuccessfulState extends ProfileState {
  final String successMessage;

  ProfileUpdateSuccessfulState({required this.successMessage});
}

final class ProfileUpdateFailedState extends ProfileState {
  final String errorMessage;

  ProfileUpdateFailedState({required this.errorMessage});
}

final class ProfileLoadingState extends ProfileState {}
