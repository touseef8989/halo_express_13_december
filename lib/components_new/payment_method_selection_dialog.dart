import 'package:flutter/material.dart';
import 'dart:developer';

import '../components/action_button.dart';
import '../components/custom_flushbar.dart';
import '../models/booking_model.dart';
import '../models/food_order_model.dart';
import '../models/payment_method_model.dart';
import '../models/user_model.dart';
import '../networkings/ewallet_networking.dart';
import '../screens/main/ewallet_top_up_page.dart';
import '../utils/app_translations/app_translations.dart';
import '../utils/constants/custom_colors.dart';
import '../utils/constants/styles.dart';
import '../utils/utils.dart';
import 'custom_check_box.dart';

class PaymentMethodSelectionDialog extends StatefulWidget {
  PaymentMethodSelectionDialog({
    this.bookingType,
    this.onChanged,
    this.selectedMethod,
    this.filters,
  });

  final String? bookingType;
  final String? selectedMethod;
  final Function(String)? onChanged;
  final List<String>? filters;

  @override
  _PaymentMethodSelectionDialogState createState() =>
      _PaymentMethodSelectionDialogState();
}

class _PaymentMethodSelectionDialogState
    extends State<PaymentMethodSelectionDialog> {
  List<DynamicPaymentMethodModel>? _paymentMethods =
      <DynamicPaymentMethodModel>[];

  @override
  void initState() {
    super.initState();
    List<dynamic> validPaymentMethods = [];
    if (widget.bookingType == 'food') {
      print('inside payment selecton');
      inspect(FoodOrderModel().getPaymentMethods());
      validPaymentMethods = FoodOrderModel().getPaymentMethods();
    } else if (widget.bookingType == 'express') {
      validPaymentMethods = BookingModel().getPaymentMethods();
    }

    validPaymentMethods.forEach((element) {
      _paymentMethods!.add(DynamicPaymentMethodModel(
        name: element['method_name'],
        title: element['method_display_name'],
        image: element['method_icon_url'],
      ));
    });

    _initWalletBalance();
  }

  Widget buildList() {
    List<Widget> list = [];

    for (int i = 0; i < _paymentMethods!.length; i++) {
      DynamicPaymentMethodModel method = _paymentMethods![i];

      Widget radioBtn = GestureDetector(
        onTap: () {
          widget.onChanged!(method.name!);
          Navigator.pop(context);
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
              Container(
                padding: const EdgeInsets.only(right: 16),
                child: (method.image == null)
                    ? Image.asset(
                        'images/ic_e_wallet.png',
                        width: 24,
                        height: 24,
                      )
                    : Image.network(
                        method.image!,
                        width: 24,
                        height: 24,
                      ),
              ),
              getContainer(method),
              CustomCheckBox(isChecked: widget.selectedMethod == method.name),
            ],
          ),
        ),
      );

      list.add(radioBtn);
    }

    return Expanded(
        child: ListView(
      shrinkWrap: true,
      children: list,
    ));
  }

  Widget getContainer(DynamicPaymentMethodModel paymentMethodModel) {
    try {
      if (paymentMethodModel.name == "haloWallet" &&
          User().walletTransactionsResponse?.response?.walletBalance != null) {
        return Expanded(
            child: ValueListenableBuilder(
          valueListenable: User.walletTransactionsResponseNotifier,
          builder: (BuildContext context, dynamic value, Widget? child) {
            return Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(AppTranslations.of(context)
                        .text(paymentMethodModel.name!) +
                    " (${AppTranslations.of(context).text("currency_my")}" +
                    "${Utils.getFormattedPrice(double.parse(User().walletTransactionsResponse!.response!.walletBalance!))})"),
                if (isInSufficientBalance())
                  Container(
                      width: 80.0,
                      height: 30.0,
                      margin: const EdgeInsets.only(left: 6.0),
                      child: ActionSmallButton(
                        buttonText: AppTranslations.of(context).text("top_up"),
                        onPressed: () {
                          checking();
                        },
                      ))
              ],
            );
          },
        ));
      }
    } catch (e) {
      print(e);
    }
    return Expanded(
      // child: Text(AppTranslations.of(context)!.text(paymentMethodModel.name)),
      child: Text(paymentMethodModel.title!),
    );
  }

  bool isInSufficientBalance() {
    try {
      if (widget.bookingType == 'food') {
        return User().walletTransactionsResponse != null &&
            double.parse(User()
                    .walletTransactionsResponse!
                    .response!
                    .walletBalance!) <
                double.parse(FoodOrderModel().getFinalPrice());
      } else if (widget.bookingType == 'express') {
        return User().walletTransactionsResponse != null &&
            double.parse(User()
                    .walletTransactionsResponse!
                    .response!
                    .walletBalance!) <
                double.parse(BookingModel().getTotalPrice());
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  void checking() async {
    try {
      double requiredAmount = double.parse(FoodOrderModel().getFinalPrice()) -
          double.parse(
              User().walletTransactionsResponse!.response!.walletBalance!);

      var isTopUp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EwalletTopUpPage(
            requiredAmount: Utils.roundDouble(requiredAmount, 2),
          ),
        ),
      );
    } catch (e) {}
    return;
  }

  _initWalletBalance() async {
    Map<String, dynamic> params = {
      "data": {
        "userToken": User().getUserToken(),
      }
    };
    print(params);

    try {
      var data = await EwalletNetworking().getEwalletTransaction(params);
      User().setEwalletTransaction(data);
    } catch (e) {
      if (e is Map<String, dynamic>) {
      } else {
        showSimpleFlushBar(e.toString(), context);
      }
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
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
            buildList(),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
