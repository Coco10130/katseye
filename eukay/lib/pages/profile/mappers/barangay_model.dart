class BarangayModel {
  final String name;

  BarangayModel({required this.name});

  factory BarangayModel.fromJson(Map<String, dynamic> json) {
    return BarangayModel(
      name: json['name'],
    );
  }
}
