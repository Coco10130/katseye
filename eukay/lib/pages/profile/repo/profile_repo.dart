import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eukay/pages/dashboard/mappers/product_model.dart';
import 'package:eukay/pages/profile/mappers/address_model.dart';
import 'package:eukay/pages/profile/mappers/barangay_model.dart';
import 'package:eukay/pages/profile/mappers/municipality_model.dart';
import 'package:eukay/pages/profile/mappers/profile_model.dart';
import 'package:eukay/pages/profile/repo/profile_repository.dart';
import 'package:eukay/pages/shop/mappers/sales_product_model.dart';
import 'package:eukay/uitls/server.dart';
import 'package:image_picker/image_picker.dart';

class ProfileRepo extends ProfileRepository {
  final _dio = Dio();

  @override
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
            e.response?.data["message"] ?? e.response?.data["errorMessage"];
        throw errorMessage;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
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
            e.response?.data["message"] ?? e.response?.data["errorMessage"];
        throw errorMessage;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Future<List<BarangayModel>> fetchBarangays(String municipalityCode) async {
    try {
      final response =
          await _dio.get(Server.municipalityBarangays(municipalityCode));

      final List<dynamic> barangayList = response.data;
      return barangayList.map((data) => BarangayModel.fromJson(data)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<MunicipalityModel>> fetchMunicipality() async {
    try {
      final response = await _dio.get(Server.pangasinanMunicipalities);

      final List<dynamic> municipalityList = response.data;
      return municipalityList
          .map((data) => MunicipalityModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> addAddress(String token, String fullName, String municipality,
      String barangay, String contact, String street) async {
    try {
      final payload = {
        "fullName": fullName,
        "municipality": municipality,
        "barangay": barangay,
        "contact": contact,
        "street": street,
      };

      final response = await _dio.post(
        "${Server.serverUrl}/api/address/add",
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
        throw Exception("Something went wrong");
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
  Future<List<AddressModel>> fetchUserAddresses(
      String userId, String token) async {
    try {
      final response = await _dio.get(
        "${Server.serverUrl}/api/address/user",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 && response.data["success"]) {
        final List<dynamic> addressList = response.data["data"];

        return addressList.map((address) {
          return AddressModel.fromJson(address);
        }).toList();
      } else {
        throw Exception("Failed to load addresses");
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
  Future<bool> deleteAddress(String addressId, String token) async {
    try {
      final response = await _dio.delete(
        "${Server.serverUrl}/api/address/delete/$addressId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data["success"]) {
        return true;
      } else {
        throw Exception("Failed to delete address");
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
  Future<List<ProductModel>> fetchWishlists(String token) async {
    try {
      final response = await _dio.get(
        "${Server.serverUrl}/api/wishlist/get/user",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 && response.data["success"]) {
        final List<dynamic> productList = response.data["data"];
        return productList
            .map((product) => ProductModel.fromJson(product))
            .toList();
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
  Future<bool> useAddress(String token, String addressId) async {
    try {
      final response = await _dio.put(
        "${Server.serverUrl}/api/address/use-address/$addressId",
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
        final errorMessage =
            e.response?.data["message"] ?? e.response?.data["errorMessage"];
        throw errorMessage;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Future<List<SalesProductModel>> fetchOrdersProduct(
      String token, String status) async {
    try {
      final response = await _dio.get(
        "${Server.serverUrl}/api/product/get/orders/$status",
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
  Future<bool> addReview({
    required String token,
    required int starRating,
    required String review,
    required String productId,
    required String orderId,
    required String id,
  }) async {
    try {
      final payload = {
        "starRating": starRating,
        "productId": productId,
        "review": review,
        "orderId": orderId,
        "id": id
      };
      final response = await _dio.post(
        "${Server.serverUrl}/api/reviews/post-review",
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        data: jsonEncode(payload),
      );

      if (response.statusCode == 201 && response.data["success"]) {
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
