import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/transaction_list_model.dart';
import '../../../utils/app_translations/app_translations.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/payment_method.dart';
import '../../../utils/constants/styles.dart';
class MobileTopUpTransactionDetailPage extends StatefulWidget {
  static const String id = 'MobileTopUpTransactionDetailPage';

  // final WalletTransaction walletTransaction;
  final Transaction? topUpTransaction;

  MobileTopUpTransactionDetailPage({this.topUpTransaction});

  @override
  _EwalletTopUpDetailState createState() => _EwalletTopUpDetailState();
}

class _EwalletTopUpDetailState extends State<MobileTopUpTransactionDetailPage> {
  SizedBox space = SizedBox(
    height: 10.0,
  );

  double titleWidth = 130.0;
  String? outputDateString;

  @override
  void initState() {
    // Step 1: Convert string to DateTime object
    DateTime dateTime = DateTime.parse(widget.topUpTransaction!.topupDatetime!);

    // Step 2: Convert DateTime object back to string in a different format
    outputDateString = DateFormat("dd MMM yyyy hh:mm a").format(dateTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(outputDateString);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Container(
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: arrowBack),
        ),
        title: Text(
            '${AppTranslations.of(context).text("title_transaction_detail")}',
            textAlign: TextAlign.center,
            style: kAppBarTextStyle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child:
              Container(padding: EdgeInsets.all(16.0), child: getContainer()),
        ),
      ),
    );
  }

  Widget getContainer() {
    if (widget.topUpTransaction != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: titleWidth,
                child: Text(
                  "${AppTranslations.of(context).text("title_summary")}",
                  style: kLabelSemiBoldTextStyle,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                  child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  "${widget.topUpTransaction!.topupRemarks ?? ""}",
                  textAlign: TextAlign.end,
                  style: kLabelSemiBoldTextStyle,
                ),
              ))
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: titleWidth,
                child: Text(
                  "${AppTranslations.of(context).text("topup_amount")}",
                  style: kLabelSemiBoldTextStyle,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                  child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  "${widget.topUpTransaction!.topupAmount ?? ""}",
                  textAlign: TextAlign.end,
                  style: kLabelSemiBoldTextStyle,
                ),
              ))
            ],
          ),
          space,
          Container(
            height: 1,
            color: darkGrey,
          ),
          space,
          Row(
            children: [
              Container(
                width: titleWidth,
                child: Text(
                  "${AppTranslations.of(context).text("title_date_time")}",
                  style: kLabelTextStyle,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                  child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  "$outputDateString",
                  textAlign: TextAlign.end,
                  style: kLabelSemiBoldTextStyle,
                ),
              ))
            ],
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: titleWidth,
                child: Text(
                  "${AppTranslations.of(context).text("title_topup_summary")}",
                  style: kLabelSemiBoldTextStyle,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                  child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  "${widget.topUpTransaction!.topupNumber}",
                  textAlign: TextAlign.end,
                  style: kLabelSemiBoldTextStyle,
                ),
              ))
            ],
          ),
          space,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: titleWidth,
                child: Text(
                  AppTranslations.of(context).text('you_topped_up'),
                  style: kLabelSemiBoldTextStyle,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                  child: Container(
                      alignment: Alignment.centerRight,
                      child: getTransactionTopUp()))
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: titleWidth,
                child: Text(
                  "${AppTranslations.of(context).text("title_fee_amount")}",
                  style: kLabelSemiBoldTextStyle,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                  child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  "${AppTranslations.of(context).text("currency_my")} ${widget.topUpTransaction!.topupCharges}",
                  style: kTitleSemiBoldTextStyle,
                ),
              ))
            ],
          ),
          space,
          Container(
            height: 1,
            color: darkGrey,
          ),
          space,
          Row(
            children: [
              Text(
                "${AppTranslations.of(context).text("title_date_time")}",
                style: kLabelTextStyle,
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                  child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  "${widget.topUpTransaction!.topupDatetime}",
                  style: kLabelSemiBoldTextStyle,
                ),
              ))
            ],
          ),
          space,
          Row(
            children: [
              Text(
                "${AppTranslations.of(context).text("payment_method")}",
                style: kLabelTextStyle,
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                  child: Container(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            PaymentMethod()
                                .getPaymentMethod(
                                    widget.topUpTransaction!.topupMethod!)
                                .image!,
                            width: 40.0,
                            height: 40.0,
                          ),
                          SizedBox(
                            width: 6.0,
                          ),
                          Text(
                            "${AppTranslations.of(context).text(PaymentMethod().getPaymentMethod(widget.topUpTransaction!.topupMethod!).name!)}",
                            style: kLabelSemiBoldTextStyle,
                          ),
                        ],
                      )))
            ],
          ),
        ],
      );
    }
  }

  Widget getTransactionTopUp() {
    if (widget.topUpTransaction!.topupStatus!.toLowerCase() == "success") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: Text(
              "+ ${AppTranslations.of(context).text("currency_my")} ${widget.topUpTransaction!.topupAmount}",
              style: kTitleSemiBoldTextStyle.copyWith(color: Colors.green),
            ),
          )
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          child: Text(
            "${AppTranslations.of(context).text("currency_my")} ${widget.topUpTransaction!.topupAmount}",
            style: kTitleSemiBoldTextStyle.copyWith(color: Colors.black),
          ),
        )
      ],
    );
  }

  // Widget getTransactionTag() {
  //   return TransactionTag(
  //     tag: AppTranslations.of(context)
  //         .text("topup_${widget.topUpTransaction.topupStatus}")
  //         .toUpperCase(),
  //     bgColor: getBgColor(),
  //     titleColor: getTextColor(),
  //   );
  // }

  // Color getBgColor() {
  //   if (widget.topUpTransaction.topupStatus == "success") {
  //     return kColorLightGreen;
  //   } else if (widget.topUpTransaction.topupStatus == "pending") {
  //     return kColorLightBlue2;
  //   } else if (widget.topUpTransaction.topupStatus == "failed") {
  //     return kColorLightRed6;
  //   } else {
  //     return Colors.white;
  //   }
  // }

  Color getTextColor() {
    if (widget.topUpTransaction!.topupStatus == "success") {
      return Colors.green;
    } else if (widget.topUpTransaction!.topupStatus == "pending") {
      return Colors.blueAccent;
    } else if (widget.topUpTransaction!.topupStatus == "failed") {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }
}
