import 'dart:convert';

import 'package:http/http.dart' as HTTP;
import '../models/preview_topup_model.dart';
import '../models/top_up_list_model.dart';
import '../models/topup_payment_success_model.dart';
import '../models/transaction_list_model.dart';
import '../models/user_model.dart';
import '../utils/constants/api_urls.dart';

class TopUpNetworking {
  Future<TopUpListModel> getAllTopUpsProviders() async {
    TopUpListModel topUpListModel;
    // HTTP.Response response = await NetworkingService()
    //     .postRequestWithAuth(APIUrls().getTopupList(), params);
    HTTP.Response response = await HTTP.get(APIUrls().getTopupList() as Uri,
        headers: {"Authorization": User().getAuthToken()!});
    var decodedData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      topUpListModel = TopUpListModel.fromJson(decodedData);

      return topUpListModel;
    } else {
      throw decodedData['msg'] ?? '';
    }
  }

  Future<PreviewTopUpModel> topUpPreview(
      {required String amount,
      required String paymentMethod,
      required String accountNumber,
      required String prodId}) async {
    PreviewTopUpModel previewTopUpModel;

    Map data = {
      "data": {
        "amount": "$amount",
        "paymentMethod": "$paymentMethod",
        "accountNumber": "0$accountNumber",
        "prodId": "$prodId"
      }
    };
    var body = json.encode(data);
    HTTP.Response response = await HTTP.post(APIUrls().getTopupPreview() as Uri,
        headers: {"Authorization": User().getAuthToken()!}, body: body);
    var decodedData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      previewTopUpModel = PreviewTopUpModel.fromJson(decodedData);
      print("000000000000 ${previewTopUpModel.msg}");

      return previewTopUpModel;
    } else {
      print('topup Failed: ' + decodedData['msg']);
      throw decodedData['msg'] ?? '';
    }
  }

  Future<TopUpPaymentSuccessModel> topupSubmit(
      {required String amount,
      required String paymentMethod,
      required String accountNumber,
      required String prodId,
      String? paymentUrl}) async {
    Map data = {
      "data": {
        "amount": "$amount",
        "paymentMethod": "$paymentMethod",
        "accountNumber": "0$accountNumber",
        "prodId": "$prodId",
      }
    };
    var body = json.encode(data);
    HTTP.Response response = await HTTP.post(
      APIUrls().getTopupSubmit() as Uri,
      headers: {"Authorization": User().getAuthToken()!},
      body: body,
    );
    var decodedData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      TopUpPaymentSuccessModel topUpPaymentSuccessModel =
          TopUpPaymentSuccessModel.fromJson(decodedData);
      print("ddddd ${topUpPaymentSuccessModel.response!.paymentUrl}");

      return topUpPaymentSuccessModel;
    } else {
      throw decodedData['msg'] ?? '';
    }
  }

  Future<TransactionListModel> getTopUpTransactions() async {
    TransactionListModel transactionListModel;
    // HTTP.Response response = await NetworkingService()
    //     .postRequestWithAuth(APIUrls().getTopupList(), params);
    HTTP.Response response = await HTTP.get(APIUrls().getTransactionList() as Uri,
        headers: {"Authorization": User().getAuthToken()!});
    var decodedData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      transactionListModel = TransactionListModel.fromJson(decodedData);
      print("5555555555 ${transactionListModel}");

      return transactionListModel;
    } else {
      print('topup Failed: ' + decodedData['msg']);
      throw decodedData['msg'] ?? '';
    }
  }
}
