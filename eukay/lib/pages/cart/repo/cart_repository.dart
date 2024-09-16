import 'package:eukay/pages/cart/mappers/cart_model.dart';

abstract class CartRepository {
  Future<List<CartModel>> fetchCart(String token);
}
