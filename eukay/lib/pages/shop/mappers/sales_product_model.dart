class SalesProductModel {
  final List<Product> products;
  final double totalPrice;
  final String buyerName,
      orderedBy,
      buyerContact,
      deliveryAddress,
      sellerId,
      shopName,
      id;
  final bool markAsNextStep;

  SalesProductModel({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.deliveryAddress,
    required this.buyerContact,
    required this.buyerName,
    required this.orderedBy,
    required this.sellerId,
    required this.shopName,
    required this.markAsNextStep,
  });

  factory SalesProductModel.fromJson(Map<String, dynamic> json) {
    return SalesProductModel(
      id: json["_id"],
      products: List<Product>.from(
          json["products"].map((item) => Product.fromJson(item))),
      totalPrice: (json["totalPrice"] is int)
          ? (json["totalPrice"] as int).toDouble()
          : json["totalPrice"].toDouble(),
      deliveryAddress: json["deliveryAddress"],
      buyerContact: json["buyerContact"],
      buyerName: json["buyerName"],
      shopName: json["shopName"],
      orderedBy: json["orderedBy"],
      markAsNextStep: json["markAsNextStep"],
      sellerId: json["sellerId"],
    );
  }
}

class Product {
  final String productName, size, id;
  final List<String> productImage;
  final int quantity;
  final double price;

  Product({
    required this.productName,
    required this.size,
    required this.id,
    required this.productImage,
    required this.quantity,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productName: json["productName"],
      size: json["size"],
      id: json["_id"],
      productImage: List<String>.from(
          json["productImage"].map((item) => item.toString())),
      quantity: json["quantity"],
      price: json["price"].toDouble(),
    );
  }
}
