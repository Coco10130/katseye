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

final class ProfileLogoutEvent extends ProfileEvent {}
