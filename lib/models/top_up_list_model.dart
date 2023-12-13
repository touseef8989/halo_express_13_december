// To parse this JSON data, do
//
//     final topUpListModel = topUpListModelFromJson(jsonString);

import 'dart:convert';

TopUpListModel topUpListModelFromJson(String str) =>
    TopUpListModel.fromJson(json.decode(str));

String topUpListModelToJson(TopUpListModel data) => json.encode(data.toJson());

class TopUpListModel {
  String? msg;
  Response? response;

  TopUpListModel({
    this.msg,
    this.response,
  });

  factory TopUpListModel.fromJson(Map<String, dynamic> json) => TopUpListModel(
        msg: json["msg"],
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "response": response!.toJson(),
      };
}

class Response {
  List<ListElement>? list;
  List<AvailablePaymentMethod>? availablePaymentMethod;

  Response({
    this.list,
    this.availablePaymentMethod,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        list: List<ListElement>.from(
            json["list"].map((x) => ListElement.fromJson(x))),
        availablePaymentMethod: List<AvailablePaymentMethod>.from(
            json["availablePaymentMethod"]
                .map((x) => AvailablePaymentMethod.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list!.map((x) => x.toJson())),
        "availablePaymentMethod":
            List<dynamic>.from(availablePaymentMethod!.map((x) => x.toJson())),
      };
}

class AvailablePaymentMethod {
  String? methodName;
  String? methodDisplayName;
  String? methodIconUrl;

  AvailablePaymentMethod({
    this.methodName,
    this.methodDisplayName,
    this.methodIconUrl,
  });

  factory AvailablePaymentMethod.fromJson(Map<String, dynamic> json) =>
      AvailablePaymentMethod(
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

class ListElement {
  String? id;
  String? name;
  String? type;
  String? pCode;
  String? imagepath;
  String? acceptValue;
  String? acceptValueLength;
  String? acceptAmtMin;
  String? pCategory;
  String? acceptAmtMax;
  String? acceptAmtDeno;
  String? acceptAmtDenoRm;
  String? pCountry;
  List<String>? acceptAmtDenoArr;

  ListElement({
    this.id,
    this.name,
    this.type,
    this.pCode,
    this.imagepath,
    this.acceptValue,
    this.acceptValueLength,
    this.acceptAmtMin,
    this.pCategory,
    this.acceptAmtMax,
    this.acceptAmtDeno,
    this.acceptAmtDenoRm,
    this.pCountry,
    this.acceptAmtDenoArr,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        id: json["ID"],
        name: json["Name"],
        type: json["Type"],
        pCode: json["PCode"],
        imagepath: json["imagepath"],
        acceptValue: json["AcceptValue"],
        acceptValueLength: json["AcceptValueLength"],
        acceptAmtMin: json["AcceptAmtMin"],
        pCategory: json["PCategory"],
        acceptAmtMax: json["AcceptAmtMax"],
        acceptAmtDeno: json["AcceptAmtDeno"],
        acceptAmtDenoRm: json["AcceptAmtDenoRM"],
        pCountry: json["PCountry"],
        acceptAmtDenoArr:
            List<String>.from(json["AcceptAmtDenoArr"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "Type": type,
        "PCode": pCode,
        "imagepath": imagepath,
        "AcceptValue": acceptValue,
        "AcceptValueLength": acceptValueLength,
        "AcceptAmtMin": acceptAmtMin,
        "PCategory": pCategory,
        "AcceptAmtMax": acceptAmtMax,
        "AcceptAmtDeno": acceptAmtDeno,
        "AcceptAmtDenoRM": acceptAmtDenoRm,
        "PCountry": pCountry,
        "AcceptAmtDenoArr": List<dynamic>.from(acceptAmtDenoArr!.map((x) => x)),
      };
}
