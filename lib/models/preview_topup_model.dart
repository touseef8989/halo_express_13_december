// To parse this JSON data, do
//
//     final previewTopUpModel = previewTopUpModelFromJson(jsonString);

import 'dart:convert';

PreviewTopUpModel previewTopUpModelFromJson(String str) =>
    PreviewTopUpModel.fromJson(json.decode(str));

String previewTopUpModelToJson(PreviewTopUpModel data) =>
    json.encode(data.toJson());

class PreviewTopUpModel {
  String? msg;
  Response? response;

  PreviewTopUpModel({
    this.msg,
    this.response,
  });

  factory PreviewTopUpModel.fromJson(Map<String, dynamic> json) =>
      PreviewTopUpModel(
        msg: json["msg"],
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "response": response!.toJson(),
      };
}

class Response {
  String? amount;
  String? paymentFee;
  String? prodId;
  String? paymentMethod;
  String? accountNumber;

  Response({
    this.amount,
    this.paymentFee,
    this.prodId,
    this.paymentMethod,
    this.accountNumber,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        amount: json["amount"],
        paymentFee: json["paymentFee"],
        prodId: json["prodId"],
        paymentMethod: json["paymentMethod"],
        accountNumber: json["accountNumber"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "paymentFee": paymentFee,
        "prodId": prodId,
        "paymentMethod": paymentMethod,
        "accountNumber": accountNumber,
      };
}
