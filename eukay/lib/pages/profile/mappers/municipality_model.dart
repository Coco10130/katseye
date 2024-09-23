class MunicipalityModel {
  final String code;
  final String name;

  MunicipalityModel({required this.code, required this.name});

  factory MunicipalityModel.fromJson(Map<String, dynamic> json) {
    return MunicipalityModel(
      code: json['code'],
      name: json['name'],
    );
  }
}
