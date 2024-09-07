import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eukay/pages/shop/mappers/seller_model.dart';
import 'package:eukay/pages/shop/repo/shop_repository.dart';
import 'package:eukay/uitls/server.dart';
import 'package:image_picker/image_picker.dart';

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
          await _dio.post("${Server.serverUrl}/api/seller/register-seller",
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
          await _dio.post("${Server.serverUrl}/api/seller/send-otp",
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
        "${Server.serverUrl}/api/seller/get-seller-profile",
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

  @override
  Future<bool> addProduct(
      String token,
      String productName,
      String productDescription,
      double price,
      double stocks,
      List<String> categories,
      List<String> sizes,
      List<XFile> images) async {
    try {
      final formData = FormData.fromMap({
        "productName": productName,
        "productDescription": productDescription,
        "price": price,
        "quantity": stocks,
        "categories": categories,
        "sizes": sizes,
      });

      for (var image in images) {
        formData.files.add(
          MapEntry(
            "images",
            await MultipartFile.fromFile(image.path, filename: image.name),
          ),
        );
      }

      final response = await _dio.post(
        "${Server.serverUrl}/api/product/add",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
        data: formData,
      );

      if (response.statusCode == 201 && response.data["success"] == true) {
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
