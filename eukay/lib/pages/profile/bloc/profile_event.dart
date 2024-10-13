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

final class UseAddressEvent extends ProfileEvent {
  final String token, addressId;

  UseAddressEvent({required this.token, required this.addressId});
}

final class FetchDeliveryAddressEvent extends ProfileEvent {
  final String token, userId;

  FetchDeliveryAddressEvent({required this.token, required this.userId});
}

final class FetchOrdersEvent extends ProfileEvent {
  final String token, status;

  FetchOrdersEvent({
    required this.token,
    required this.status,
  });
}

final class AddReviewProductEvent extends ProfileEvent {
  final String token, productId, review, id, orderId;
  final int starRating;

  AddReviewProductEvent({
    required this.token,
    required this.productId,
    required this.review,
    required this.id,
    required this.orderId,
    required this.starRating,
  });
}

final class CancelOrderEvent extends ProfileEvent {
  final String token, orderId, status;

  CancelOrderEvent(
      {required this.token, required this.orderId, required this.status});
}

final class FetchReviewsEvent extends ProfileEvent {
  final String token;

  FetchReviewsEvent({required this.token});
}

final class ProfileLogoutEvent extends ProfileEvent {}
