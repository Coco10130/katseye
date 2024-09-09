class ProductModel {
  final List<String> productImage, categories, sizes;
  final String productName, status, productDescription, id, sellerName;
  final int quantity;
  final double price, rating;

  const ProductModel({
    required this.productImage,
    required this.categories,
    required this.sizes,
    required this.productName,
    required this.status,
    required this.productDescription,
    required this.price,
    required this.quantity,
    required this.id,
    required this.sellerName,
    required this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["_id"],
      productImage: List<String>.from(json["productImage"]),
      categories: List<String>.from(json["categories"]),
      sizes: List<String>.from(json["sizes"]),
      productName: json["productName"],
      status: json["status"],
      productDescription: json["productDescription"],
      price: (json["price"] is int)
          ? (json["price"] as int).toDouble()
          : json["price"].toDouble(),
      quantity: json["quantity"],
      sellerName: json["sellerName"],
      rating: (json["rating"] is int)
          ? (json["rating"] as int).toDouble()
          : json["rating"].toDouble(),
    );
  }
}
