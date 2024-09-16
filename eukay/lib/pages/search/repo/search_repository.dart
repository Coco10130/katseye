import 'package:eukay/pages/dashboard/mappers/product_model.dart';

abstract class SearchRepository {
  Future<List<ProductModel>> fetchSearchedProduct(String searched);
  Future<ProductModel> fetchViewProduct(String productId);
  Future<bool> addToCart(String token, String productId);
}
