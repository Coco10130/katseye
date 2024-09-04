import 'package:eukay/pages/shop/mappers/seller_model.dart';

abstract class ShopRepository {
  Future<String?> sendOTP(String email, String token);
  Future<String?> registerShop(String token, String shopName,
      String shopContact, String shopEmail, String otpHash, String otpCode);
  Future<SellerModel> fetchSellerProfile(String token);
}
