import 'package:dio/dio.dart';
import 'package:eukay/pages/dashboard/mappers/product_model.dart';
import 'package:eukay/pages/search/repo/search_repository.dart';
import 'package:eukay/uitls/server.dart';

class SearchRepo extends SearchRepository {
  final _dio = Dio();
  @override
  Future<List<ProductModel>> fetchSearchedProduct(String searched) async {
    try {
      final response =
          await _dio.get("${Server.serverUrl}/api/product/search/$searched");

      if (response.data["success"]) {
        final List<dynamic> resultList = response.data["data"];
        return resultList.map((result) {
          return ProductModel.fromJson(result);
        }).toList();
      } else {
        throw response.data["errorMessage"];
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
  Future<ProductModel> fetchViewProduct(String productId) async {
    try {
      final response =
          await _dio.get("${Server.serverUrl}/api/product/get/$productId");

      if (response.data["success"]) {
        final product = response.data["data"];
        return ProductModel.fromJson(product);
      } else {
        throw response.data["errorMessage"];
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
  Future<bool> addToCart(String token, String productId) async {
    try {
      final response = await _dio.post(
        "${Server.serverUrl}/api/cart/addToCart/$productId",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 201 && response.data["success"]) {
        return true;
      } else {
        throw Exception("Something went wrong");
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
