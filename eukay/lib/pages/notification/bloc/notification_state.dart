part of 'notification_bloc.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class FetchNotificationSuccessState extends NotificationState {
  final List<NotificationModel> notifications;

  FetchNotificationSuccessState({required this.notifications});
}

final class FetchNotificationFailedState extends NotificationState {
  final String errorMessage;

  FetchNotificationFailedState({required this.errorMessage});
}

final class NotificationServerErrorState extends NotificationState {
  final String errorMessage;

  NotificationServerErrorState({required this.errorMessage});
}

final class NotificationLoadingState extends NotificationState {}
