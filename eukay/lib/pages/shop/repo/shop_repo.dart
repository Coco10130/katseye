import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eukay/pages/dashboard/mappers/product_model.dart';
import 'package:eukay/pages/shop/mappers/sales_product_model.dart';
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
    String otpCode,
  ) async {
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
        throw Exception(response.data["message"]);
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage =
            e.response?.data["message"] ?? e.response?.data["errorMessage"];
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
            e.response?.data["message"] ?? e.response?.data["errorMessage"];
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
        throw Exception("Failed to load Profile: ${response.data["message"]}");
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage =
            e.response?.data["message"] ?? e.response?.data["errorMessage"];
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
    List<int> stocks,
    List<String> categories,
    List<String> sizes,
    List<XFile> images,
  ) async {
    try {
      final formData = FormData.fromMap({
        "productName": productName,
        "productDescription": productDescription,
        "price": price,
        "quantities": stocks,
        "categories": categories,
        "sizes": sizes,
      });

      // Add images to formData
      for (var image in images) {
        formData.files.add(
          MapEntry(
            "images",
            await MultipartFile.fromFile(image.path, filename: image.name),
          ),
        );
      }

      // Make the POST request
      final response = await _dio.post(
        "${Server.serverUrl}/api/product/add",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
        data: formData,
      );

      // Check response status
      if (response.statusCode == 201 && response.data["success"] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage =
            e.response?.data["message"] ?? e.response?.data["errorMessage"];
        throw errorMessage;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Future<List<ProductModel>> fetchProductByStatus(
      String sellerId, String token, String status) async {
    try {
      final response = await _dio.get(
        "${Server.serverUrl}/api/product/get/products/$sellerId/$status",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 && response.data["success"]) {
        final List<dynamic> productList = response.data["data"];
        return productList.map((product) {
          return ProductModel.fromJson(product);
        }).toList();
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage =
            e.response?.data["message"] ?? e.response?.data["errorMessage"];
        throw errorMessage;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Future<List<SalesProductModel>> fetchSalesProduct(
      String token, String sellerId, String status) async {
    try {
      final response = await _dio.get(
        "${Server.serverUrl}/api/product/get/sales/$status/$sellerId",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 && response.data["success"]) {
        final List<dynamic> productList = response.data["data"];
        return productList.map((product) {
          return SalesProductModel.fromJson(product);
        }).toList();
      } else {
        throw Exception("Failed to fetch products");
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage =
            e.response?.data["message"] ?? e.response?.data["errorMessage"];
        throw errorMessage;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Future<bool> markProductAsNextStep({
    required String token,
    required String status,
    required String orderId,
    required String sellerId,
  }) async {
    try {
      final response = await _dio.put(
        "${Server.serverUrl}/api/orders/mark-order/$orderId/$status/$sellerId",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 && response.data["success"]) {
        return response.data["success"];
      } else {
        return false;
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage =
            e.response?.data["message"] ?? e.response?.data["errorMessage"];
        throw errorMessage;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Future<bool> changeSalesStatus({
    required String token,
    required String status,
    required String sellerId,
    required String nextStatus,
  }) async {
    try {
      final response = await _dio.put(
        "${Server.serverUrl}/api/orders/change-status/$status/$sellerId/$nextStatus",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 && response.data["success"]) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage =
            e.response?.data["message"] ?? e.response?.data["errorMessage"];
        throw errorMessage;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Future<ProductModel> fetchUpdateProduct(
      String token, String productId) async {
    try {
      final response = await _dio.get(
        "${Server.serverUrl}/api/product/get/$productId",
      );

      if (response.statusCode == 200 && response.data["success"]) {
        final product = response.data["data"];
        return ProductModel.fromJson(product);
      } else {
        throw response.data["message"];
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage =
            e.response?.data["message"] ?? e.response?.data["errorMessage"];
        throw errorMessage;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Future<bool> updateProduct({
    required String token,
    required String productId,
    required String productName,
    required String productDescription,
    required double price,
    required List<int> stocks,
    required List<String> sizes,
  }) async {
    try {
      final formData = {
        "productName": productName,
        "productDescription": productDescription,
        "price": price,
        "quantities": stocks,
        "sizes": sizes,
      };

      final response = await _dio.put(
        "${Server.serverUrl}/api/product/update/$productId",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
        data: jsonEncode(formData),
      );

      if (response.statusCode == 200 && response.data["success"]) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage =
            e.response?.data["message"] ?? e.response?.data["errorMessage"];
        throw errorMessage;
      } else {
        throw Exception(e.toString());
      }
    }
  }
}
