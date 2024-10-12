class CartModel {
  final String id, productImage, productName, productId, size, sellerName;
  final double price, subTotal;
  final int quantity;
  final bool toCheckOut;

  CartModel({
    required this.id,
    required this.productId,
    required this.productImage,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.subTotal,
    required this.toCheckOut,
    required this.size,
    required this.sellerName,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['_id'],
      productId: json['productId'],
      productImage: json["productImage"],
      productName: json['productName'],
      price: (json["price"] is int)
          ? (json["price"] as int).toDouble()
          : json["price"].toDouble(),
      subTotal: (json["subTotal"] is int)
          ? (json["subTotal"] as int).toDouble()
          : json["price"].toDouble(),
      quantity: json['quantity'],
      toCheckOut: json['toCheckOut'],
      size: json['size'],
      sellerName: json['sellerName'],
    );
  }
}
