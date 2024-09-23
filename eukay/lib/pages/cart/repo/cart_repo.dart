import 'package:dio/dio.dart';
import 'package:eukay/pages/cart/mappers/cart_model.dart';
import 'package:eukay/pages/cart/repo/cart_repository.dart';
import 'package:eukay/uitls/server.dart';

class CartRepo extends CartRepository {
  final _dio = Dio();

  @override
  Future<List<CartModel>> fetchCart(String token) async {
    try {
      final response = await _dio.get(
        "${Server.serverUrl}/api/cart/get-cart",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data["success"]) {
        final List<dynamic> cartLists = response.data["data"];
        return cartLists.map((cart) {
          return CartModel.fromJson(cart);
        }).toList();
      } else {
        throw Exception("Something went wrong");
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
  Future<List<CartModel>> addQuantity(String cartItemId, String token) async {
    try {
      final response = await _dio.post(
        "${Server.serverUrl}/api/cart/add-quantity/$cartItemId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data["success"]) {
        final List<dynamic> cartList = response.data["data"];
        return cartList.map((cart) {
          return CartModel.fromJson(cart);
        }).toList();
      } else {
        throw Exception("Something went wrong");
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage = e.response?.data["message"] ?? "Unknown error";
        throw Exception("DioException: $errorMessage");
      } else {
        throw Exception("Error: ${e.toString()}");
      }
    }
  }

  @override
  Future<List<CartModel>> minusQuantity(String cartItemId, String token) async {
    try {
      final response = await _dio.post(
        "${Server.serverUrl}/api/cart/minus-quantity/$cartItemId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data["success"]) {
        final List<dynamic> cartList = response.data["data"];
        return cartList.map((cart) {
          return CartModel.fromJson(cart);
        }).toList();
      } else {
        throw Exception("Something went wrong");
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage = e.response?.data["message"] ?? "Unknown error";
        throw Exception("DioException: $errorMessage");
      } else {
        throw Exception("Error: ${e.toString()}");
      }
    }
  }

  @override
  Future<List<CartModel>> toCheckOut(String cartItemId, String token) async {
    try {
      final response = await _dio.post(
        "${Server.serverUrl}/api/cart/to-check-out/$cartItemId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data["success"]) {
        final List<dynamic> cartList = response.data["data"];
        return cartList.map((cart) {
          return CartModel.fromJson(cart);
        }).toList();
      } else {
        throw Exception("Something went wrong");
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage = e.response?.data["message"] ?? "Unknown error";
        throw Exception("DioException: $errorMessage");
      } else {
        throw Exception("Error: ${e.toString()}");
      }
    }
  }
}
