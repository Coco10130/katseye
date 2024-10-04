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

final class FetchMunicipalitiesEvent extends ProfileEvent {}

final class FetchBarangaysEvent extends ProfileEvent {
  final String municipalityCode;

  FetchBarangaysEvent({required this.municipalityCode});
}

final class FetchingFailedState extends ProfileState {
  final String errorMessage;

  FetchingFailedState({required this.errorMessage});
}

final class AddUserAddressSuccessState extends ProfileState {
  final String successMessage;

  AddUserAddressSuccessState({required this.successMessage});
}

final class AddUserAddressFailedState extends ProfileState {
  final String errorMessage;

  AddUserAddressFailedState({required this.errorMessage});
}

final class FetchUserAddressSuccessState extends ProfileState {
  final List<AddressModel> addresses;

  FetchUserAddressSuccessState({required this.addresses});
}

final class FetchUserAddressFailedState extends ProfileState {
  final String errorMessage;

  FetchUserAddressFailedState({required this.errorMessage});
}

final class DeleteAddressSuccessState extends ProfileState {
  final String successMessage;

  DeleteAddressSuccessState({required this.successMessage});
}

final class DeleteAddressFailedState extends ProfileState {
  final String errorMessage;

  DeleteAddressFailedState({required this.errorMessage});
}

final class WishListSuccessState extends ProfileState {
  final List<ProductModel> products;

  WishListSuccessState({required this.products});
}

final class WishListFailedState extends ProfileState {
  final String errorMessage;

  WishListFailedState({required this.errorMessage});
}

final class ProfileLoadingState extends ProfileState {}
