class SellerModel {
  final String shopName, shopContact, shopEmail, image, id;

  SellerModel(
      {required this.shopName,
      required this.shopContact,
      required this.shopEmail,
      required this.image,
      required this.id});

  factory SellerModel.fromJson(Map<String, dynamic> json) {
    return SellerModel(
      id: json["_id"],
      shopName: json["shopName"],
      shopEmail: json["shopEmail"],
      shopContact: json["shopContact"],
      image: json["image"],
    );
  }
}
