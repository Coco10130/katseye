import 'package:dio/dio.dart';
import 'package:eukay/pages/profile/mappers/profile_model.dart';
import 'package:eukay/uitls/server.dart';
import 'package:image_picker/image_picker.dart';

class ProfileRepo {
  final _dio = Dio();

  Future<ProfileModel> fetchProfile(String token) async {
    try {
      final response = await _dio.get(
        "${Server.serverUrl}/api/profile/get",
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
    XFile? imageFile,
  ) async {
    final formData = FormData.fromMap({
      'userName': userName,
      'email': email,
      'phoneNumber': phoneNumber,
      if (imageFile != null)
        'image':
            await MultipartFile.fromFile(imageFile.path, filename: "image.jpg"),
    });
    try {
      final response = await _dio.put(
        "${Server.serverUrl}/api/profile/update/$id",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
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
        throw errorMessage;
      } else {
        throw Exception(e.toString());
      }
    }
  }
}
