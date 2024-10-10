import 'package:eukay/pages/dashboard/mappers/product_model.dart';

abstract class SearchRepository {
  Future<List<ProductModel>> fetchSearchedProduct({
    String? searched,
    String? gender,
    String? category,
    String? rating,
    String? priceRange,
  });
  Future<ProductModel> fetchViewProduct(String productId);
  Future<String> addToCart(String token, String productId, String size);
  Future<bool> addWishlist(String token, String productId);
  Future<bool> removeWishlist(String token, String productId);
}
