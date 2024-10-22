part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

final class FetchNotificationsEvent extends NotificationEvent {
  final String token, userId;

  FetchNotificationsEvent({required this.token, required this.userId});
}
