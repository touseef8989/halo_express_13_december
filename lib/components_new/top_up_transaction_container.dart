import 'package:flutter/material.dart';

import '../models/top_up_transaction_model.dart';
import '../screens/main/ewallet_top_up_detail_page.dart';
import '../utils/app_translations/app_translations.dart';
import '../utils/constants/custom_colors.dart';
import '../utils/constants/styles.dart';
import '../utils/services/datetime_formatter.dart';
import 'transaction_tag.dart';

class TopUpTransactionContainer extends StatelessWidget {
  TopUpTransactionContainer({
    this.topupTransaction,
  });

  final TopupTransaction? topupTransaction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EwalletTopUpDetailPage(
                      topUpTransaction: topupTransaction!,
                    )));
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
                          datetime: topupTransaction!.topupDatetime!)!,
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
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EwalletTopUpDetailPage(
                            topUpTransaction: topupTransaction!)));
              },
              child: Image.asset("images/ic_forward.png",
                  width: 40.0, height: 40.0))
        ],
      )),
    );
  }

  Widget getTransactionAmount(BuildContext context) {
    if (topupTransaction!.topupStatus!.toLowerCase() == "success") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: Text(
              "+ ${AppTranslations.of(context).text("currency_my")} ${topupTransaction!.topupAmount}",
              style: kTitleSemiBoldTextStyle.copyWith(color: Colors.green),
            ),
          ),
          getTransactionTag(context),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          child: Text(
            "${AppTranslations.of(context).text("currency_my")} ${topupTransaction!.topupAmount}",
            style: kTitleSemiBoldTextStyle.copyWith(color: Colors.black),
          ),
        ),
        getTransactionTag(context),
      ],
    );
  }

  Widget getTransactionType(BuildContext context) {
    return Container(
      child: Text(
        AppTranslations.of(context).text("topUp"),
        style: kLabelSemiBoldTextStyle,
      ),
    );
  }

  Widget getTransactionTag(BuildContext context) {
    return TransactionTag(
      tag: AppTranslations.of(context)
          .text("topup_${topupTransaction!.topupStatus}")
          .toUpperCase(),
      bgColor: getBgColor(),
      titleColor: getTextColor(),
    );
  }

  Color getBgColor() {
    if (topupTransaction!.topupStatus == "success") {
      return kColorLightGreen;
    } else if (topupTransaction!.topupStatus == "pending") {
      return kColorLightBlue2;
    } else if (topupTransaction!.topupStatus == "failed") {
      return kColorLightRed6;
    } else {
      return Colors.white;
    }
  }

  Color getTextColor() {
    if (topupTransaction!.topupStatus == "success") {
      return Colors.green;
    } else if (topupTransaction!.topupStatus == "pending") {
      return Colors.blueAccent;
    } else if (topupTransaction!.topupStatus == "failed") {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }
}
