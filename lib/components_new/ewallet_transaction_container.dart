import 'package:flutter/material.dart';

import '../models/wallet_transaction_model.dart';
import '../screens/main/ewallet_top_up_detail_page.dart';
import '../utils/app_translations/app_translations.dart';
import '../utils/constants/custom_colors.dart';
import '../utils/constants/styles.dart';
import '../utils/services/datetime_formatter.dart';

class EwalletTransactionContainer extends StatelessWidget {
  EwalletTransactionContainer({
    this.walletTransaction,
  });

  final WalletTransaction? walletTransaction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EwalletTopUpDetailPage(
                    walletTransaction: walletTransaction!)));
      },
      child: Container(
          child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getTransactionType(context),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(
                      DatetimeFormatter().getFormattedDateStrWithDate(
                          format: "dd MMM yyyy, hh:mm a",
                          datetime:
                              walletTransaction!.transactionCreatedDatetime!)!,
                      style: kSmallLabelTextStyle.copyWith(color: darkGrey),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            width: 6.0,
          ),
          getTransactionAmount(context),
          Image.asset("images/ic_forward.png", width: 40.0, height: 40.0)
        ],
      )),
    );
  }

  Widget getTransactionAmount(BuildContext context) {
    return Container(
      child: Text(
        "${AppTranslations.of(context).text("currency_my")} ${walletTransaction!.transactionAmount}",
        style: kTitleSemiBoldTextStyle.copyWith(
            color: isDeduct() ? kColorRed : Colors.green),
      ),
    );
  }

  bool isDeduct() {
    try {
      // ignore: unused_local_variable
      double previousAmount =
          double.parse(walletTransaction!.transactionAmountPrevious!);
      // ignore: unused_local_variable
      double currentAmount =
          double.parse(walletTransaction!.transactionAmountBalance!);

      double amount = double.parse(walletTransaction!.transactionAmount!);

      return (amount) <= 0.0;
    } catch (e) {}

    return false;
  }

  Widget getTransactionType(BuildContext context) {
    return Container(
      child: Text(
        AppTranslations.of(context).text(walletTransaction!.transactionType!),
        style: kLabelSemiBoldTextStyle,
      ),
    );
  }
}
