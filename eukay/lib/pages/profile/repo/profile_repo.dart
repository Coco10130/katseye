import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eukay/pages/profile/mappers/profile_model.dart';

class ProfileRepo {
  static const String serverUrl = "http://192.168.1.21:8080";

  final _dio = Dio();

  Future<ProfileModel> fetchProfile(String token) async {
    try {
      final response = await _dio.get(
        "$serverUrl/api/profile/get",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        final profile = response.data["data"];
        return ProfileModel.fromJson(profile);
      } else {
        throw Exception("Failed to load Profile: ${response.statusMessage}");
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

  Future<bool> updateProfile(
    String id,
    String token,
    String userName,
    String email,
    String phoneNumber,
    File? imageFile,
  ) async {
    try {
      final formData = FormData.fromMap({
        'userName': userName,
        'email': email,
        'phone': phoneNumber,
        if (imageFile != null)
          'image': MultipartFile.fromFileSync(imageFile.path),
      });

      final response = await _dio.put(
        "$serverUrl/api/profile/update/$id",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            "Content-Type": "application/json"
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
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
