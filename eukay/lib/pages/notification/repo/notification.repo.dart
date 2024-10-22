import 'package:dio/dio.dart';
import 'package:eukay/pages/notification/mappers/notification_model.dart';
import 'package:eukay/pages/notification/repo/notification.repositoy.dart';
import 'package:eukay/uitls/server.dart';

class NotificationRepo extends NotificationRepository {
  final _dio = Dio();
  @override
  Future<List<NotificationModel>> getNotification(
      String token, String userId) async {
    try {
      final response = await _dio.get(
        "${Server.serverUrl}/api/notification/get",
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200 && response.data["success"]) {
        final List<dynamic> notificationList = response.data["data"];

        return notificationList.map((data) {
          return NotificationModel.fromJson(data);
        }).toList();
      } else {
        throw response.data["message"];
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage = e.response?.data["message"] ?? "Unknown error";
        throw errorMessage;
      } else {
        throw Exception("Error: ${e.toString()}");
      }
    }
  }
}
