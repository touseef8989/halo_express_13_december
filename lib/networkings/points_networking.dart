import 'dart:convert';

import 'dart:io';

import '../utils/constants/api_urls.dart';
import '../utils/services/networking_services.dart';

class PointsNetworking {
  Future confirmBooking(Map<String, dynamic> params) async {
    HttpClientResponse response = await NetworkingService()
        .postRequestWithAuth(APIUrls().getConfirmBookingUrl(), params);

    String data = await response.transform(utf8.decoder).join();
    var decodedData = jsonDecode(data);
    // print(decodedData);

    if (response.statusCode == 200) {
      if (decodedData['status_code'] == 514) {
        throw decodedData;
      } else {
        Map<String, dynamic>? returnData = decodedData['return'];
        if (returnData != null &&
            returnData['paymentMethod'] != null &&
            returnData['paymentMethod'] == 'online' &&
            returnData['paymentUniqueKey'] != null) {
          Map<String, String> data = {
            "paymentUniqueKey": returnData['paymentUniqueKey']
          };
          return data;
        } else {
          return decodedData['msg'] ?? '';
        }
      }
    } else {
      print('confirmBooking Failed: ' + decodedData['msg']);
      throw decodedData['msg'] ?? '';
    }
  }
}
