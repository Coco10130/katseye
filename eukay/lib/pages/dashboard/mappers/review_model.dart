class ReviewModel {
  final String id;
  final int starRating;
  final String review;
  final String userName;
  final String userImage;
  final String productName;

  const ReviewModel({
    required this.id,
    required this.starRating,
    required this.review,
    required this.userName,
    required this.userImage,
    required this.productName,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json["_id"],
      starRating: json["starRating"],
      review: json["review"],
      userName: json["userName"],
      userImage: json["userImage"],
      productName: json["productName"],
    );
  }
}
