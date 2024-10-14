import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eukay/pages/dashboard/mappers/product_model.dart';
import 'package:eukay/pages/search/repo/search_repository.dart';
import 'package:eukay/uitls/server.dart';

class SearchRepo extends SearchRepository {
  final _dio = Dio();
  @override
  Future<List<ProductModel>> fetchSearchedProduct({
    String? searched,
    String? gender,
    String? category,
    String? rating,
    String? priceRange,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        "gender": gender,
        "category": category,
        "ratings": rating,
        "priceRange": priceRange,
        "searchedProduct": searched
      };

      queryParams.removeWhere((key, value) => value == null);

      final response = await _dio.get(
        "${Server.serverUrl}/api/product/search",
        queryParameters: queryParams,
      );

      if (response.data["success"]) {
        final List<dynamic> resultList = response.data["data"];
        return resultList.map((result) {
          return ProductModel.fromJson(result);
        }).toList();
      } else {
        throw response.data["message"];
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage =
            e.response?.data["errorMessage"] ?? e.response?.data["message"];
        throw errorMessage;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Future<ProductModel> fetchViewProduct(String productId) async {
    try {
      final response =
          await _dio.get("${Server.serverUrl}/api/product/get/$productId");

      if (response.data["success"]) {
        final product = response.data["data"];
        return ProductModel.fromJson(product);
      } else {
        throw response.data["message"];
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage = e.response?.data["message"] ?? "Unknown error";
        throw errorMessage;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Future<String> addToCart(String token, String productId, String size) async {
    try {
      final payload = {"size": size};

      final response = await _dio.post(
        "${Server.serverUrl}/api/cart/addToCart/$productId",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
        data: jsonEncode(payload),
      );

      if (response.statusCode == 201 && response.data["success"]) {
        return response.data["token"];
      } else {
        throw response.data["message"];
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage = e.response?.data["message"] ?? "Unknown error";
        throw errorMessage;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Future<bool> addWishlist(String token, String productId) async {
    try {
      final response = await _dio.post(
        "${Server.serverUrl}/api/wishlist/add/$productId",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 201 && response.data["success"]) {
        return true;
      } else {
        throw response.data["message"];
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage = e.response?.data["message"] ?? "Unknown error";
        throw errorMessage;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Future<bool> removeWishlist(String token, String productId) async {
    try {
      final response = await _dio.delete(
        "${Server.serverUrl}/api/wishlist/delete/$productId",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 && response.data["success"]) {
        return true;
      } else {
        throw Exception(response.data["message"]);
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage = e.response?.data["message"] ?? "Unknown error";
        throw errorMessage;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Future<bool> reportProduct(
      {required String token,
      required String productId,
      required String type,
      required String reason}) async {
    try {
      final payload = {"productId": productId, "type": type, "reason": reason};

      final response = await _dio.post(
        "${Server.serverUrl}/api/report/create",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
        data: jsonEncode(payload),
      );

      if (response.statusCode == 201 && response.data["success"]) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage = e.response?.data["message"] ?? "Unknown error";
        throw errorMessage;
      } else {
        throw Exception(e.toString());
      }
    }
  }
}
