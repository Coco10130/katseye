import 'package:eukay/pages/dashboard/mappers/product_model.dart';

class SellerModel {
  final String shopName, shopContact, shopEmail, image, id;
  final int pendingOrders, prepareOrders, deliverOrders, reviewOrders;
  final List<ProductModel> products;

  SellerModel({
    required this.shopName,
    required this.shopContact,
    required this.shopEmail,
    required this.image,
    required this.id,
    required this.pendingOrders,
    required this.prepareOrders,
    required this.deliverOrders,
    required this.reviewOrders,
    required this.products,
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) {
    return SellerModel(
      id: json["_id"],
      shopName: json["shopName"],
      shopEmail: json["shopEmail"],
      shopContact: json["shopContact"],
      image: json["image"],
      pendingOrders: json["pendingOrders"],
      prepareOrders: json["prepareOrders"],
      deliverOrders: json["deliverOrders"],
      reviewOrders: json["reviewOrders"],
      products: (json["products"] as List<dynamic>)
          .map((productJson) => ProductModel.fromJson(productJson))
          .toList(),
    );
  }
}
