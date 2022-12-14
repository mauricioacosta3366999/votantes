// To parse this JSON data, do
//
//     final createDebtModel = createDebtModelFromJson(jsonString);

import 'dart:convert';

CdiDetallesModel createDebtModelFromJson(String str) =>
    CdiDetallesModel.fromJson(json.decode(str));

String createDebtModelToJson(CdiDetallesModel data) =>
    json.encode(data.toJson());

class CdiDetallesModel {
  CdiDetallesModel({
    this.apellidos,
    this.celular,
    this.ci,
    this.collectionId,
    this.collectionName,
    this.created,
    this.direccion,
    this.id,
    this.nombres,
    this.sexo,
    this.updated,
  });

  String? apellidos;
  String? celular;
  int? ci;
  String? collectionId;
  String? collectionName;
  DateTime? created;
  String? direccion;
  String? id;
  String? nombres;
  String? sexo;
  DateTime? updated;

  factory CdiDetallesModel.fromJson(Map<String, dynamic> json) =>
      CdiDetallesModel(
        apellidos: json["apellidos"],
        celular: json["celular"],
        ci: json["ci"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: DateTime.parse(json["created"]),
        direccion: json["direccion"],
        id: json["id"],
        nombres: json["nombres"],
        sexo: json["sexo"],
        updated: DateTime.parse(json["updated"]),
      );

  Map<String, dynamic> toJson() => {
        "apellidos": apellidos,
        "celular": celular,
        "ci": ci,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "created": created?.toIso8601String(),
        "direccion": direccion,
        "id": id,
        "nombres": nombres,
        "sexo": sexo,
        "updated": updated?.toIso8601String(),
      };
}
