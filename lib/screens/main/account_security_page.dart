import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../components/custom_flushbar.dart';
import '../../components/model_progress_hud.dart';
import '../../components_new/profile_option.dart';
import '../../models/booking_model.dart';
import '../../models/food_order_model.dart';
import '../../models/user_model.dart';
import '../../networkings/auth_networking.dart';
import '../../utils/app_translations/app_translations.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/constants/styles.dart';
import '../../utils/services/shared_pref_service.dart';
import '../boarding/change_password_page.dart';
import '../general/confirmation_dialog.dart';
import '../general/language_selector_page.dart';
import 'tab_bar_controller.dart';

class AccountSecurityPage extends StatefulWidget {
  static const String id = 'AccountSecurityPage';

  @override
  AccountSecurityPageState createState() => AccountSecurityPageState();
}

class AccountSecurityPageState extends State<AccountSecurityPage> {
  bool _showSpiner = false;
  removeAccountApiCall() async {
    setState(() {
      _showSpiner = true;
    });

    var headers = {'Authorization': User().getAuthToken()};
    var request = http.Request(
        'POST', Uri.parse('https://userapi.halo.express/user/removeAccount'));
    request.body = '''''';
    // request.headers.addAll(headers);
Map<String, String> nonNullableHeaders = headers.cast<String, String>();
request.headers.addAll(nonNullableHeaders);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      showSimpleFlushBar("account deleted", context);
      SharedPrefService().removeLoginInfo();
      BookingModel().clearBookingData();
      FoodOrderModel().clearFoodOrderData();
      User().resetUserData();
      setState(() {
        _showSpiner = false;
      });
      User.currentTab.value = 0;

      // Use addPostFrameCallback to navigate after the current frame is finished.
      Navigator.pushReplacementNamed(context, TabBarPage.id);
    } else {
      showSimpleFlushBar(response.reasonPhrase!, context);
      print(response.reasonPhrase);
    }
  }

  Future _removeAccount() async {
    Map<String, dynamic> params = {};

    print(params);

    try {
      String data = await AuthNetworking().removeAccount(params);
      print("222222222 ${data}");
      showSimpleFlushBar(data, context, isError: false);
      SharedPrefService().removeLoginInfo();
      BookingModel().clearBookingData();
      FoodOrderModel().clearFoodOrderData();
      User().resetUserData();
      User.currentTab.value = 0;
      Navigator.popUntil(context, ModalRoute.withName(TabBarPage.id));
      setState(() {
        _showSpiner = false;
      });
    } catch (e) {
      print('gg');

      setState(() {
        _showSpiner = false;
      });
      // print(e.toString());
    } finally {}
  }

  void showConfirmMakeNewBookingDialog() {
    showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
              title: AppTranslations.of(context).text('delete_account'),
              message:
                  AppTranslations.of(context).text('delete_account_confirm'),
            )).then((value) {
      if (value != null && value == 'confirm') {
        removeAccountApiCall();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: arrowBack,
          onPressed: () => {Navigator.pop(context)},
        ),
        title: Text(
          AppTranslations.of(context).text('profile_option_security'),
          style: kAppBarTextStyle,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _showSpiner,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 25.0,
            ),
            child: Column(
              children: [
                ProfileOption(
                  icon: 'images/ic_language_setting.png',
                  label: AppTranslations.of(context)
                      .text('profile_option_languages'),
                  onPressed: () {
                    Navigator.pushNamed(context, LanguageSelectorPage.id);
                  },
                ),
                ProfileOption(
                  icon: 'images/ic_change_pw.png',
                  label: AppTranslations.of(context)
                      .text('profile_option_password'),
                  onPressed: () {
                    Navigator.pushNamed(context, ChangePasswordPage.id);
                  },
                ),
                ProfileOption(
                  icon: 'images/ic_change_pw.png',
                  label: AppTranslations.of(context).text('delete_account'),
                  onPressed: () {
                    showConfirmMakeNewBookingDialog();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
