import 'package:eukay/pages/cart/mappers/cart_model.dart';

abstract class CartRepository {
  Future<List<CartModel>> fetchCart(String token);
  Future<List<CartModel>> addQuantity(String cartItemId, String token);
  Future<List<CartModel>> minusQuantity(String cartItemId, String token);
  Future<List<CartModel>> toCheckOut(String cartItemId, String token);
  Future<String> deleteCartItem(String token);
}
