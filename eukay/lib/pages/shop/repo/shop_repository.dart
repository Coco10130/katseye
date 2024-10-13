import 'package:eukay/pages/dashboard/mappers/product_model.dart';
import 'package:eukay/pages/shop/mappers/seller_model.dart';
import 'package:image_picker/image_picker.dart';

import '../mappers/sales_product_model.dart';

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
      List<int> stocks,
      List<String> categories,
      List<String> sizes,
      List<XFile> images);
  Future<List<ProductModel>> fetchProductByStatus(
      String sellerId, String token, String status);
  Future<List<SalesProductModel>> fetchSalesProduct(
      String token, String sellerId, String status);
  Future<bool> markProductAsNextStep({
    required String token,
    required String status,
    required String orderId,
    required String sellerId,
  });
  Future<bool> changeSalesStatus({
    required String token,
    required String status,
    required String sellerId,
    required String nextStatus,
  });
  Future<ProductModel> fetchUpdateProduct(String token, String productId);
  Future<bool> updateProduct({
    required String token,
    required String productId,
    required String productName,
    required String productDescription,
    required double price,
    double? discount,
    required List<int> stocks,
    required List<String> sizes,
  });
  Future<bool> deleteProduct(
      {required String productId,
      required String sellerId,
      required String token});
}
