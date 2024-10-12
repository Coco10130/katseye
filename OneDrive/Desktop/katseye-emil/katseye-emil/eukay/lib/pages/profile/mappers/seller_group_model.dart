import 'package:eukay/pages/shop/mappers/sales_product_model.dart';

class SellerGroup {
  final String sellerName, id, sellerId;
  final double totalPrice;
  final String? orderId;
  final bool markedAsPrepared;
  final List<SalesProductModel> products;

  SellerGroup({
    required this.id,
    required this.sellerName,
    required this.sellerId,
    required this.markedAsPrepared,
    required this.products,
    required this.totalPrice,
    this.orderId,
  });
}
