import 'package:eukay/pages/dashboard/mappers/review_model.dart';

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
  final double discount;
  final String sellerName;
  final String sellerId;
  final List<String> wishedByUser;
  final List<ReviewModel> reviews;

  const ProductModel({
    required this.id,
    required this.productImage,
    required this.sellerId,
    required this.productName,
    required this.price,
    required this.productDescription,
    required this.discount,
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
      sellerId: json["sellerId"],
      productImage: List<String>.from(json["productImage"] ?? []),
      productName: json["productName"],
      price: (json["price"] is int)
          ? (json["price"] as int).toDouble()
          : (json["price"] as double? ?? 0.0),
      productDescription: json["productDescription"],
      categories: List<String>.from(json["categories"] ?? []),
      sizeQuantities: (json["sizeQuantities"] is List)
          ? List<SizeQuantity>.from(json["sizeQuantities"]
              .map((sizeJson) => SizeQuantity.fromJson(sizeJson)))
          : [],
      status: json["status"],
      discount: (json["discount"] is int)
          ? (json["discount"] as int).toDouble()
          : (json["discount"] as double? ?? 0.0),
      rating: (json["rating"] is int)
          ? (json["rating"] as int).toDouble()
          : (json["rating"] as double? ?? 0.0),
      reviews: (json["reviews"] is List)
          ? List<ReviewModel>.from(json["reviews"]
              .map((reviewJson) => ReviewModel.fromJson(reviewJson)))
          : [], // Handle non-list cases
      sellerName: json["sellerName"],
      wishedByUser: List<String>.from(json["wishedByUser"] ?? []),
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
