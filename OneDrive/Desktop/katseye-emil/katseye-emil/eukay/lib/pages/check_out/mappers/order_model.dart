class OrderModel {
  final String productName, productImage, size, id, sellerName;
  final double subTotal;
  final int quantity;

  OrderModel({
    required this.productImage,
    required this.id,
    required this.productName,
    required this.size,
    required this.subTotal,
    required this.quantity,
    required this.sellerName,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["_id"],
      productImage: json["productImage"],
      productName: json['productName'],
      size: json['size'],
      subTotal: (json["subTotal"] is int)
          ? (json["subTotal"] as int).toDouble()
          : json["subTotal"].toDouble(),
      quantity: json['quantity'],
      sellerName: json['sellerName'],
    );
  }
}
