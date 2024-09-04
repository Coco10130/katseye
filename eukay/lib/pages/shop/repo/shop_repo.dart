import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eukay/pages/shop/mappers/seller_model.dart';
import 'package:eukay/pages/shop/repo/shop_repository.dart';
import 'package:eukay/uitls/server.dart';

class ShopRepo extends ShopRepository {
  final _dio = Dio();

  @override
  Future<String?> registerShop(
      String token,
      String shopName,
      String shopContact,
      String shopEmail,
      String otpHash,
      String otpCode) async {
    try {
      final payload = {
        "shopContact": shopContact,
        "shopEmail": shopEmail,
        "shopName": shopName,
        "hash": otpHash,
        "otp": otpCode,
      };

      final response =
          await _dio.post("${Server.serverUrl}/api/profile/register-seller",
              options: Options(
                headers: {
                  "Authorization": "Bearer $token",
                },
              ),
              data: jsonEncode(payload));

      if (response.data["success"] && response.statusCode == 200) {
        return response.data["token"];
      } else {
        return null;
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

  @override
  Future<String?> sendOTP(String email, String token) async {
    try {
      final response =
          await _dio.post("${Server.serverUrl}/api/profile/send-otp",
              options: Options(
                headers: {
                  "Authorization": "Bearer $token",
                },
              ),
              data: jsonEncode({"shopEmail": email}));
      if (response.statusCode == 200) {
        return response.data["data"];
      } else {
        return null;
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

  @override
  Future<SellerModel> fetchSellerProfile(String token) async {
    try {
      final response = await _dio.get(
        "${Server.serverUrl}/api/profile/get",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200 && response.data["success"] == true) {
        final profile = response.data["data"];
        return SellerModel.fromJson(profile);
      } else {
        throw Exception("Failed to load Profile: ${response.statusMessage}");
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
