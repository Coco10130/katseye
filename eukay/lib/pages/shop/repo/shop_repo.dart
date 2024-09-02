import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eukay/pages/shop/repo/shop_repository.dart';
import 'package:eukay/uitls/server.dart';

class ShopRepo extends ShopRepository {
  final _dio = Dio();
  @override
  Future<bool> registerShop(String token, String shopName, String shopContact,
      String shopEmail) async {
    try {
      final payload = {
        "shopContact": shopContact,
        "shopEmail": shopEmail,
        "shopName": shopName,
      };

      final response =
          await _dio.post("${Server.serverUrl}/api/profile/register-seller",
              options: Options(headers: {
                "Authorization": "Bearer $token",
              }),
              data: jsonEncode(payload));

      if (response.data["success"] && response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage =
            e.response?.data["errorMessage"] ?? "Unknown error";
        throw errorMessage;
      } else {
        throw Exception(e.toString());
      }
    }
  }
}
