// To parse this JSON data, do
//
//     final transactionListModel = transactionListModelFromJson(jsonString);

import 'dart:convert';

TransactionListModel transactionListModelFromJson(String str) =>
    TransactionListModel.fromJson(json.decode(str));

String transactionListModelToJson(TransactionListModel data) =>
    json.encode(data.toJson());

class TransactionListModel {
  String? msg;
  Response? response;

  TransactionListModel({
    this.msg,
    this.response,
  });

  factory TransactionListModel.fromJson(Map<String, dynamic> json) =>
      TransactionListModel(
        msg: json["msg"],
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "response": response!.toJson(),
      };
}

class Response {
  List<Transaction>? transactions;

  Response({
    this.transactions,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        transactions: List<Transaction>.from(
            json["transactions"].map((x) => Transaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "transactions":
            List<dynamic>.from(transactions!.map((x) => x.toJson())),
      };
}

class Transaction {
  String? topupId;
  String? userId;
  String? topupNumber;
  String? topupAmount;
  String? topupDatetime;
  String? topupUpdateDatetime;
  String? topupStatus;
  String? topupMethod;
  dynamic topupRemarks;
  String? topupCharges;
  String? topupTotalPaid;
  String? topupAccountNumber;
  String? topupGatewayBillId;
  String? topupGateway;
  String? topupGatewayMethod;
  String? topupGatewayRemarks;

  Transaction({
    this.topupId,
    this.userId,
    this.topupNumber,
    this.topupAmount,
    this.topupDatetime,
    this.topupUpdateDatetime,
    this.topupStatus,
    this.topupMethod,
    this.topupRemarks,
    this.topupCharges,
    this.topupTotalPaid,
    this.topupAccountNumber,
    this.topupGatewayBillId,
    this.topupGateway,
    this.topupGatewayMethod,
    this.topupGatewayRemarks,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        topupId: json["topup_id"],
        userId: json["user_id"],
        topupNumber: json["topup_number"],
        topupAmount: json["topup_amount"],
        topupDatetime: json["topup_datetime"],
        topupUpdateDatetime: json["topup_update_datetime"],
        topupStatus: json["topup_status"],
        topupMethod: json["topup_method"],
        topupRemarks: json["topup_remarks"],
        topupCharges: json["topup_charges"],
        topupTotalPaid: json["topup_total_paid"],
        topupAccountNumber: json["topup_account_number"],
        topupGatewayBillId: json["topup_gateway_bill_id"],
        topupGateway: json["topup_gateway"],
        topupGatewayMethod: json["topup_gateway_method"],
        topupGatewayRemarks: json["topup_gateway_remarks"],
      );

  Map<String, dynamic> toJson() => {
        "topup_id": topupId,
        "user_id": userId,
        "topup_number": topupNumber,
        "topup_amount": topupAmount,
        "topup_datetime": topupDatetime,
        "topup_update_datetime": topupUpdateDatetime,
        "topup_status": topupStatus,
        "topup_method": topupMethod,
        "topup_remarks": topupRemarks,
        "topup_charges": topupCharges,
        "topup_total_paid": topupTotalPaid,
        "topup_account_number": topupAccountNumber,
        "topup_gateway_bill_id": topupGatewayBillId,
        "topup_gateway": topupGateway,
        "topup_gateway_method": topupGatewayMethod,
        "topup_gateway_remarks": topupGatewayRemarks,
      };
}
