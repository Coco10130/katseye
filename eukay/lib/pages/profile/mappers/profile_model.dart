class ProfileModel {
  final String userName, email, id, image;
  final String? phoneNumber, shopName, shopEmail, shopContact;
  final int prepareOrders,
      pendingOrders,
      deliverOrders,
      deliveredOrders,
      completeOrders,
      reviews;

  ProfileModel({
    required this.userName,
    required this.email,
    required this.id,
    required this.image,
    required this.prepareOrders,
    required this.pendingOrders,
    required this.deliverOrders,
    required this.deliveredOrders,
    required this.completeOrders,
    required this.reviews,
    this.phoneNumber,
    this.shopEmail,
    this.shopName,
    this.shopContact,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["_id"],
      userName: json['userName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      image: json['image'],
      shopEmail: json['shopEmail'],
      shopName: json['shopName'],
      shopContact: json['shopContact'],
      prepareOrders: json['prepareOrders'],
      pendingOrders: json['pendingOrders'],
      deliveredOrders: json['deliveredOrders'],
      deliverOrders: json['deliverOrders'],
      completeOrders: json['completeOrders'],
      reviews: json['reviews'],
    );
  }
}
