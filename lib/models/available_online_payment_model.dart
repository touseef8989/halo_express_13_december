// To parse this JSON data, do
//
//     final availableOnlinePaymentModel = availableOnlinePaymentModelFromJson(jsonString);

import 'dart:convert';

AvailableOnlinePaymentModel availableOnlinePaymentModelFromJson(String str) =>
    AvailableOnlinePaymentModel.fromJson(json.decode(str));

String availableOnlinePaymentModelToJson(AvailableOnlinePaymentModel data) =>
    json.encode(data.toJson());

class AvailableOnlinePaymentModel {
  String? msg;
  Return? availableOnlinePaymentModelReturn;

  AvailableOnlinePaymentModel({
    this.msg,
    this.availableOnlinePaymentModelReturn,
  });

  factory AvailableOnlinePaymentModel.fromJson(Map<String, dynamic> json) =>
      AvailableOnlinePaymentModel(
        msg: json["msg"],
        availableOnlinePaymentModelReturn: Return.fromJson(json["return"]),
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "return": availableOnlinePaymentModelReturn!.toJson(),
      };
}

class Return {
  List<String>? availablePaymentMethod;
  List<AvailablePaymentMethodWithIcon>? availablePaymentMethodWithIcon;

  Return({
    this.availablePaymentMethod,
    this.availablePaymentMethodWithIcon,
  });

  factory Return.fromJson(Map<String, dynamic> json) => Return(
        availablePaymentMethod:
            List<String>.from(json["availablePaymentMethod"].map((x) => x)),
        availablePaymentMethodWithIcon:
            List<AvailablePaymentMethodWithIcon>.from(
                json["availablePaymentMethodWithIcon"]
                    .map((x) => AvailablePaymentMethodWithIcon.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "availablePaymentMethod":
            List<dynamic>.from(availablePaymentMethod!.map((x) => x)),
        "availablePaymentMethodWithIcon": List<dynamic>.from(
            availablePaymentMethodWithIcon!.map((x) => x.toJson())),
      };
}

class AvailablePaymentMethodWithIcon {
  String? methodName;
  String? methodDisplayName;
  String? methodIconUrl;

  AvailablePaymentMethodWithIcon({
    this.methodName,
    this.methodDisplayName,
    this.methodIconUrl,
  });

  factory AvailablePaymentMethodWithIcon.fromJson(Map<String, dynamic> json) =>
      AvailablePaymentMethodWithIcon(
        methodName: json["method_name"],
        methodDisplayName: json["method_display_name"],
        methodIconUrl: json["method_icon_url"],
      );

  Map<String, dynamic> toJson() => {
        "method_name": methodName,
        "method_display_name": methodDisplayName,
        "method_icon_url": methodIconUrl,
      };
}
