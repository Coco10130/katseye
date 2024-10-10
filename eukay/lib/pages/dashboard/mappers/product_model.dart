class ProductModel {
  final String id;
  final List<String> productImage;
  final String productName;
  final double price;
  final String productDescription;
  final List<String> categories;
  final List<SizeQuantity> sizeQuantities;
  final String status;
  final double rating;
  final int reviews;
  final String sellerName;
  final List<String> wishedByUser;

  const ProductModel({
    required this.id,
    required this.productImage,
    required this.productName,
    required this.price,
    required this.productDescription,
    required this.categories,
    required this.sizeQuantities,
    required this.status,
    required this.rating,
    required this.reviews,
    required this.sellerName,
    required this.wishedByUser,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["_id"],
      productImage: List<String>.from(json["productImage"]),
      productName: json["productName"],
      price: (json["price"] is int)
          ? (json["price"] as int).toDouble()
          : json["price"].toDouble(),
      productDescription: json["productDescription"],
      categories: List<String>.from(json["categories"]),
      sizeQuantities: List<SizeQuantity>.from(
        json["sizeQuantities"]
            .map((sizeJson) => SizeQuantity.fromJson(sizeJson)),
      ),
      status: json["status"], // Make sure this is always present in JSON
      rating: (json["rating"] is int)
          ? (json["rating"] as int).toDouble()
          : json["rating"].toDouble(),
      reviews: json["reviews"],
      sellerName: json["sellerName"],
      wishedByUser: List<String>.from(json["wishedByUser"]),
    );
  }
}

class SizeQuantity {
  final String size;
  final int quantity;
  final String id;

  const SizeQuantity({
    required this.size,
    required this.quantity,
    required this.id,
  });

  factory SizeQuantity.fromJson(Map<String, dynamic> json) {
    return SizeQuantity(
      size: json["size"],
      quantity: json["quantity"],
      id: json["_id"],
    );
  }
}
