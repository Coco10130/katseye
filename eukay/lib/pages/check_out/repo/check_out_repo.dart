import 'package:dio/dio.dart';
import 'package:eukay/pages/check_out/mappers/order_model.dart';
import 'package:eukay/pages/check_out/repo/check_out_repository.dart';
import 'package:eukay/uitls/server.dart';

class CheckOutRepo extends CheckOutRepository {
  final _dio = Dio();

  @override
  Future<List<OrderModel>> fetchOrders(String token) async {
    try {
      final response = await _dio.get(
        "${Server.serverUrl}/api/cart/get/orders",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data["success"]) {
        final List<dynamic> itemList = response.data["data"];
        return itemList.map((item) {
          return OrderModel.fromJson(item);
        }).toList();
      } else {
        throw Exception(response.data["message"]);
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage =
            e.response?.data["errorMessage"] ?? "Unknown error";
        throw Exception("DioException: $errorMessage");
      } else {
        throw Exception("Error: ${e.toString()}");
      }
    }
  }

  @override
  Future<String> checkOutOrders(String token) async {
    try {
      final response = await _dio.post(
        "${Server.serverUrl}/api/orders/process",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 201 && response.data["success"]) {
        return response.data["newToken"];
      } else {
        throw Exception(response.data["message"]);
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage =
            e.response?.data["errorMessage"] ?? "Unknown error";
        throw Exception("DioException: $errorMessage");
      } else {
        throw Exception("Error: ${e.toString()}");
      }
    }
  }
}
