import 'dart:convert';

class MakesModel {
  MakesModel({
    required this.makeId,
    required this.makeName,
    required this.modelId,
    required this.modelName,
  });

  final int? makeId;
  final String? makeName;
  final int? modelId;
  final String? modelName;

  factory MakesModel.fromRawJson(String str) =>
      MakesModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MakesModel.fromJson(Map<String, dynamic> json) => MakesModel(
        makeId: json["Make_ID"] ?? 0,
        makeName: json["Make_Name"].toLowerCase() ?? "",
        modelId: json["Model_ID"] ?? 0,
        modelName: json["Model_Name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Make_ID": makeId,
        "Make_Name": makeName,
        "Model_ID": modelId,
        "Model_Name": modelName,
      };
}
