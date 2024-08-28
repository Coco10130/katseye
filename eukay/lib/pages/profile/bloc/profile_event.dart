part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

final class ProfileInitialFetchEvent extends ProfileEvent {
  final String token;

  ProfileInitialFetchEvent({required this.token});
}

final class ProfileUpdateEvent extends ProfileEvent {
  final String id, userName, email, phoneNumber, image, token;

  ProfileUpdateEvent({
    required this.id,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.image,
    required this.token,
  });
}
