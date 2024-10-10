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
        final errorMessage = e.response?.data["message"] ?? "Unknown error";
        throw errorMessage;
      } else {
        throw Exception("Error: ${e.toString()}");
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
        final errorMessage = e.response?.data["message"] ?? "Unknown error";
        throw errorMessage;
      } else {
        throw Exception("Error: ${e.toString()}");
      }
    }
  }

  @override
  Future<String?> sendOtp(String email) async {
    try {
      final payload = {"shopEmail": email};
      final response = await _dio.post("${Server.serverUrl}/api/auth/send-otp",
          data: jsonEncode(payload));

      if (response.statusCode == 200) {
        return response.data["data"];
      } else {
        return null;
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

  @override
  Future<bool> verifyOtp(String email, String otp, String otpHash) async {
    try {
      final payload = {"shopEmail": email, "otp": otp, "hash": otpHash};
      final response = await _dio.post(
          "${Server.serverUrl}/api/auth/verify-otp",
          data: jsonEncode(payload));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Failed to verify OTP: ${response.data["message"]}");
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

  @override
  Future<bool> resetPassword(String newPassword, String confirmPassword,
      String email, bool otpVerified) async {
    try {
      final payload = {
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
        "email": email,
        "otpVerified": otpVerified
      };

      final response = await _dio.post(
          "${Server.serverUrl}/api/auth/change-password",
          data: jsonEncode(payload));

      if (response.statusCode == 200 && response.data["success"]) {
        return true;
      } else {
        throw Exception(
            "Failed to reset password: ${response.data["message"]}");
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
