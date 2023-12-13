// To parse this JSON data, do
//
//     final topUpPaymentSuccessModel = topUpPaymentSuccessModelFromJson(jsonString);

import 'dart:convert';

TopUpPaymentSuccessModel topUpPaymentSuccessModelFromJson(String str) =>
    TopUpPaymentSuccessModel.fromJson(json.decode(str));

String topUpPaymentSuccessModelToJson(TopUpPaymentSuccessModel data) =>
    json.encode(data.toJson());

class TopUpPaymentSuccessModel {
  String? msg;
  Response? response;

  TopUpPaymentSuccessModel({
    this.msg,
    this.response,
  });

  factory TopUpPaymentSuccessModel.fromJson(Map<String, dynamic> json) =>
      TopUpPaymentSuccessModel(
        msg: json["msg"],
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "response": response!.toJson(),
      };
}

class Response {
  String? paymentUrl;

  Response({
    this.paymentUrl,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        paymentUrl: json["paymentUrl"],
      );

  Map<String, dynamic> toJson() => {
        "paymentUrl": paymentUrl,
      };
}
