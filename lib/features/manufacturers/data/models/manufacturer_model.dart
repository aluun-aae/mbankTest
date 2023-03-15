import 'dart:convert';

class ManufacterModel {
  ManufacterModel({
    required this.country,
    required this.mfrCommonName,
    required this.mfrId,
    required this.mfrName,
  });

  final String country;
  final String? mfrCommonName;
  final int mfrId;
  final String mfrName;

  factory ManufacterModel.fromRawJson(String str) =>
      ManufacterModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ManufacterModel.fromJson(Map<String, dynamic> json) =>
      ManufacterModel(
        country: json["Country"],
        mfrCommonName: json["Mfr_CommonName"] ?? "",
        mfrId: json["Mfr_ID"],
        mfrName: json["Mfr_Name"],
      );

  Map<String, dynamic> toJson() => {
        "Country": country,
        "Mfr_CommonName": mfrCommonName,
        "Mfr_ID": mfrId,
        "Mfr_Name": mfrName,
      };
}
