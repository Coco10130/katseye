import 'package:eukay/pages/dashboard/mappers/product_model.dart';
import 'package:eukay/pages/dashboard/mappers/review_model.dart';
import 'package:eukay/pages/profile/mappers/address_model.dart';
import 'package:eukay/pages/profile/mappers/barangay_model.dart';
import 'package:eukay/pages/profile/mappers/municipality_model.dart';
import 'package:eukay/pages/profile/mappers/profile_model.dart';
import 'package:eukay/pages/shop/mappers/sales_product_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileRepository {
  Future<ProfileModel> fetchProfile(String token);
  Future<bool> updateProfile(
    String id,
    String token,
    String userName,
    String email,
    String phoneNumber,
    XFile? imageFile,
  );
  Future<List<MunicipalityModel>> fetchMunicipality();
  Future<List<BarangayModel>> fetchBarangays(String municipalityCode);
  Future<bool> addAddress(String token, String fullName, String municipality,
      String barangay, String contact, String street);
  Future<List<AddressModel>> fetchUserAddresses(String userId, String token);
  Future<bool> deleteAddress(String addressId, String token);
  Future<List<ProductModel>> fetchWishlists(String token);
  Future<bool> useAddress(String token, String addressId);
  Future<List<SalesProductModel>> fetchOrdersProduct(
      String token, String status);
  Future<bool> addReview({
    required String token,
    required int starRating,
    required String review,
    required String productId,
    required String orderId,
    required String id,
  });
  Future<bool> cancelOrder({
    required String token,
    required String orderId,
    required String status,
  });
  Future<List<ReviewModel>> fetchReviewsOfUser(String token);
}
