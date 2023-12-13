import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../components/action_button.dart';
import '../components/custom_flushbar.dart';
import '../components/halo_loading.dart';
import '../models/available_online_payment_model.dart';
import '../models/calculate_update_payment_model.dart';
import '../models/food_order_model.dart';
import '../models/payment_method_model.dart';
import '../models/update_payment_model.dart';
import '../networkings/food_history_networking.dart';
import '../screens/general/online_payment_page.dart';
import '../screens/main/tab_bar_controller.dart';
import '../utils/app_translations/app_translations.dart';
import '../utils/constants/api_urls.dart';
import '../utils/constants/custom_colors.dart';
import '../utils/constants/styles.dart';
import 'custom_check_box.dart';

class RepayMethodSelectionDialog extends StatefulWidget {
  RepayMethodSelectionDialog({
    this.orderUniqueKey,
    this.bookingType,
  });

  final String? orderUniqueKey;
  final String? bookingType;

  @override
  _RepayMethodSelectionDialogState createState() =>
      _RepayMethodSelectionDialogState();
}

class _RepayMethodSelectionDialogState
    extends State<RepayMethodSelectionDialog> {
  List<PaymentMethodModel>? _paymentMethods = [];
  String finalPrice = '0';
  String? paymentMethods;
  CalculateUpdatePaymentModel _calculateUpdatePaymentModel =
      CalculateUpdatePaymentModel();
  UpdatePaymentModel _updatePaymentModel = UpdatePaymentModel();
  AvailableOnlinePaymentModel _availableOnlinePaymentModel =
      AvailableOnlinePaymentModel();

  @override
  void initState() {
    super.initState();
    _availableOnlinePaymentMethod();
  }

  Widget buildList() {
    List<Widget> list = [];
    for (int i = 0; i < _paymentMethods!.length; i++) {
      PaymentMethodModel method = _paymentMethods![i];

      Widget radioBtn = GestureDetector(
        onTap: () {
          paymentMethods = method.name;
          _calculateUpdatePayment();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: lightGrey,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            children: [
              method.image != null
                  ? Container(
                      padding: const EdgeInsets.only(right: 16),
                      child: CachedNetworkImage(
                        imageUrl: method.image!,
                        width: 24,
                        height: 24,
                        errorWidget: (context, url, error) =>
                            const Text("data"),
                        placeholder: (context, url) => const HaloLoading(),
                      )
                      // Image.network(
                      //   method.image,
                      //   width: 24,
                      //   height: 24,
                      // ),
                      )
                  : Container(),
              Expanded(
                child: Text(AppTranslations.of(context).text(method.name!)),
              ),
              CustomCheckBox(isChecked: paymentMethods == method.name),
            ],
          ),
        ),
      );

      list.add(radioBtn);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: list,
    );
  }

  _availableOnlinePaymentMethod() async {
    Map<String, dynamic> params = {
      "apiKey": APIUrls().getApiKey(),
      "data": {'orderUniqueKey': widget.orderUniqueKey},
    };

    try {
      _availableOnlinePaymentModel =
          await FoodHistoryNetworking().getAvailableOnlinePaymentMethod(params);

      List<PaymentMethodModel> validPaymentMethods = [];
      for (var i = 0;
          i <
              _availableOnlinePaymentModel.availableOnlinePaymentModelReturn!
                  .availablePaymentMethodWithIcon!.length;
          i++) {
        final data = _availableOnlinePaymentModel
            .availableOnlinePaymentModelReturn!
            .availablePaymentMethodWithIcon![i];
        validPaymentMethods.add(PaymentMethodModel(
            name: data.methodDisplayName, image: data.methodIconUrl));
      }

      setState(() {
        _paymentMethods = validPaymentMethods;
      });
    } catch (e) {
      print(e.toString());
      if (e is Map<String, dynamic>) {
      } else {
        showSimpleFlushBar(e.toString(), context);
      }
    } finally {}
  }

  _calculateUpdatePayment() async {
    Map<String, dynamic> params = {
      "data": {
        "orderUniqueKey": widget.orderUniqueKey,
        "paymentMethod": paymentMethods,
      }
    };
    print(params);

    try {
      _calculateUpdatePaymentModel =
          await FoodHistoryNetworking().updatePaymentMethodCalculate(params);
      setState(() {
        finalPrice = _calculateUpdatePaymentModel.finalPrice!;
      });
    } catch (e) {
      print(e.toString());
      if (e is Map<String, dynamic>) {
      } else {
        showSimpleFlushBar(e.toString(), context);
      }
    } finally {}
  }

  _updatePayment() async {
    Map<String, dynamic> params = {
      "data": {
        "orderUniqueKey": widget.orderUniqueKey,
        "paymentMethod": paymentMethods,
      }
    };
    print(params);

    try {
      _updatePaymentModel =
          await FoodHistoryNetworking().updatePaymentMethod(params);
      proceedToOnlinePayment(_updatePaymentModel.paymentUrl!);
    } catch (e) {
      print(e.toString());
      if (e is Map<String, dynamic>) {
      } else {
        showSimpleFlushBar(e.toString(), context);
      }
    } finally {}
  }

  void proceedToOnlinePayment(String paymentLink) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OnlinePaymentPage(paymentLink: paymentLink)),
    ).then((value) async {
      if (value != null && value == 'onlinePaymentSuccess') {
        Navigator.pop(context);
        //_showSuccessOrderPopup();
      } else {
        Navigator.popUntil(context, ModalRoute.withName(TabBarPage.id));
        FoodOrderModel().clearFoodOrderData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.62,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppTranslations.of(context).text('payment_method'),
                  style: kTitleTextStyle,
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            _paymentMethods == null ? const HaloLoading() : buildList(),
            const SizedBox(height: 10.0),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        AppTranslations.of(context).text('final_price'),
                        style: kDetailsTextStyle,
                      ),
                      Text(
                        '${AppTranslations.of(context).text('currency_my')} ' +
                            finalPrice,
                        style: kTitleTextStyle,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                ActionButtonGreen(
                  buttonText: AppTranslations.of(context).text('pay_again'),
                  onPressed: () {
                    _updatePayment();
                  },
                )
              ],
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
