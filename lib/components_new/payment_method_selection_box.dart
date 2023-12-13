import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../models/payment_method_model.dart';
import '../models/user_model.dart';
import '../utils/app_translations/app_translations.dart';
import '../utils/constants/styles.dart';
import '../utils/utils.dart';

class PaymentMethodSelectionBox extends StatelessWidget {
  PaymentMethodSelectionBox(
      {this.image,
      this.paymentMethod,
      this.onPressed,
      this.isShowBalance = false});

  final String? image;
  final DynamicPaymentMethodModel? paymentMethod;
  final Function? onPressed;
  final bool? isShowBalance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 10.0,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: [
              Text(AppTranslations.of(context).text('payment_method'),
                  style: kAddressTextStyle),
            ],
          ),
          const SizedBox(height: 10.0),
          GestureDetector(
            onTap: onPressed!(),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 16),
                    child: (paymentMethod!.image == null)
                        ? Image.asset(
                            'images/halo_logo.png',
                            width: 24,
                            height: 24,
                          )
                        : Image.network(
                            paymentMethod!.image!,
                            width: 24,
                            height: 24,
                          ),
                  ),
                  getContainer(context, paymentMethod!),
                  Transform.rotate(
                    angle: -90 * math.pi / 180,
                    child: const Icon(
                      Icons.chevron_left,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getContainer(
      BuildContext context, DynamicPaymentMethodModel paymentMethodModel) {
    try {
      if (paymentMethodModel.name == "haloWallet" &&
          User().walletTransactionsResponse?.response?.walletBalance != null &&
          isShowBalance!) {
        return Expanded(
          child: Text(AppTranslations.of(context)
                  .text(paymentMethodModel.name!) +
              " (${AppTranslations.of(context).text("currency_my")}" +
              "${Utils.getFormattedPrice(double.parse(User().walletTransactionsResponse!.response!.walletBalance!))})"),
        );
      }
    } catch (e) {}
    return Expanded(
      child: Text(paymentMethodModel.title!),
      // child: Text(AppTranslations.of(context)!.text(paymentMethodModel.name)),
    );
  }
}
