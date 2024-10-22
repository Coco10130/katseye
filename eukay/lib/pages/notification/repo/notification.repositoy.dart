import 'package:eukay/pages/notification/mappers/notification_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> getNotification(String token, String userId);
}
