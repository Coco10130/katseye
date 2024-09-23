class AddressModel {
  final String id, fullName, province, municipality, barangay, street, contact;

  AddressModel({
    required this.id,
    required this.fullName,
    required this.province,
    required this.municipality,
    required this.barangay,
    required this.street,
    required this.contact,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id'],
      fullName: json['fullName'],
      province: json['province'],
      municipality: json['municipality'],
      barangay: json['barangay'],
      street: json['street'],
      contact: json['contact'],
    );
  }
}
