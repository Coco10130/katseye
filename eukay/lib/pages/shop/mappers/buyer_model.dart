import 'package:eukay/pages/shop/mappers/sales_product_model.dart';

class BuyerGroup {
  final String contact, address, buyerName, id, sellerId;
  final bool marked;
  final double totalPrice;
  final List<SalesProductModel> products;

  BuyerGroup({
    required this.id,
    required this.marked,
    required this.buyerName,
    required this.sellerId,
    required this.contact,
    required this.address,
    required this.products,
    required this.totalPrice,
  });
}
