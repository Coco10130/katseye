class ProfileModel {
  final String userName, email, id, image;
  final String? phoneNumber, shopName, shopEmail;

  ProfileModel({
    required this.userName,
    required this.email,
    required this.id,
    this.phoneNumber,
    required this.image,
    this.shopEmail,
    this.shopName,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["_id"],
      userName: json['userName'],
      email: json['email'],
      phoneNumber: json['shopContact'],
      image: json['image'],
      shopEmail: json['shopEmail'],
      shopName: json['shopName'],
    );
  }
}
