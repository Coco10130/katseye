class NotificationModel {
  final String id, icon, message;
  final DateTime createdAt;

  NotificationModel({
    required this.icon,
    required this.id,
    required this.message,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["_id"],
      icon: json['icon'],
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
