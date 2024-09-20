import 'package:eukay/pages/dashboard/mappers/product_model.dart';
import 'package:eukay/pages/shop/mappers/seller_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class ShopRepository {
  Future<String?> sendOTP(String email, String token);
  Future<String?> registerShop(String token, String shopName,
      String shopContact, String shopEmail, String otpHash, String otpCode);
  Future<SellerModel> fetchSellerProfile(String token);
  Future<bool> addProduct(
      String token,
      String productName,
      String productDescription,
      double price,
      double stocks,
      List<String> categories,
      List<String> sizes,
      List<XFile> images);
  Future<List<ProductModel>> fetchLiveProducts(String sellerId, String token);
}
