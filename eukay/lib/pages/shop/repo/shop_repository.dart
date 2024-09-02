abstract class ShopRepository {
  Future<bool> registerShop(
      String token, String shopName, String shopContact, String shopEmail);
}
