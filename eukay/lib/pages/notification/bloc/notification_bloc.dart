import 'dart:async';

import 'package:eukay/pages/notification/mappers/notification_model.dart';
import 'package:eukay/pages/notification/repo/notification.repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;
  NotificationBloc(this._notificationRepository)
      : super(NotificationInitial()) {
    on<FetchNotificationsEvent>(fetchNotificationsEvent);
  }

  FutureOr<void> fetchNotificationsEvent(
      FetchNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoadingState());
    try {
      final response = await _notificationRepository.getNotification(
          event.token, event.userId);

      emit(FetchNotificationSuccessState(notifications: response));
    } catch (e) {
      if (e.toString() == "Unknown error") {
        return emit(NotificationServerErrorState(errorMessage: e.toString()));
      }
      emit(FetchNotificationFailedState(errorMessage: e.toString()));
    }
  }
}
