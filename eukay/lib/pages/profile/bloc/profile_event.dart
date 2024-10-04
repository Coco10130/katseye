part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

final class ProfileInitialFetchEvent extends ProfileEvent {
  final String token;

  ProfileInitialFetchEvent({required this.token});
}

final class ProfileUpdateEvent extends ProfileEvent {
  final String id, userName, email, phoneNumber, token;
  final XFile? image;

  ProfileUpdateEvent({
    required this.id,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    this.image,
    required this.token,
  });
}

final class FetchMunicipalitiesSuccessState extends ProfileState {
  final List<MunicipalityModel> municipalities;

  FetchMunicipalitiesSuccessState({required this.municipalities});
}

final class FetchBarangaysSccessState extends ProfileState {
  final List<BarangayModel> barangays;

  FetchBarangaysSccessState({required this.barangays});
}

final class AddUserAddressEvent extends ProfileEvent {
  final String fullName, contact, municipality, barangay, street, token;

  AddUserAddressEvent({
    required this.fullName,
    required this.contact,
    required this.municipality,
    required this.barangay,
    required this.street,
    required this.token,
  });
}

final class FetchUserAddressEvent extends ProfileEvent {
  final String token, userId;

  FetchUserAddressEvent({required this.token, required this.userId});
}

final class DeleteAddressEvent extends ProfileEvent {
  final String addressId, token;

  DeleteAddressEvent({required this.addressId, required this.token});
}

final class FetchUserWishlistsEvent extends ProfileEvent {
  final String token;

  FetchUserWishlistsEvent({required this.token});
}

final class ProfileLogoutEvent extends ProfileEvent {}
