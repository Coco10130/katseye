import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eukay/pages/auth/repo/auth_repository.dart';
import 'package:eukay/uitls/server.dart';

class AuthRepo extends AuthRepository {
  final _dio = Dio();

  @override
  Future<String> loginRequest(String email, String password) async {
    try {
      final payload = {"email": email, "password": password};
      final response = await _dio.post(
        "${Server.serverUrl}/api/auth/login",
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
        data: jsonEncode(payload),
      );

      return response.data["token"];
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
  Future<String> registerRequest(String userName, String email, String password,
      String confirmPassword) async {
    try {
      final payload = {
        "userName": userName,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword
      };
      final response = await _dio.post(
        "${Server.serverUrl}/api/auth/register",
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
        data: jsonEncode(payload),
      );

      return response.data["successMessage"];
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
