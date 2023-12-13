import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../components/custom_flushbar.dart';
import '../../../components/halo_loading.dart';
import '../../../components_new/top_up_transaction_container.dart';
import '../../../components_new/transaction_tag.dart';
import '../../../models/transaction_list_model.dart';
import '../../../networkings/topup_networking.dart';
import '../../../utils/app_translations/app_translations.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/styles.dart';
import '../../../utils/services/datetime_formatter.dart';
import '../ewallet_top_up_detail_page.dart';
import 'mobile_topup_transaction_detail_page.dart';

class TransactionListPage extends StatefulWidget {
  // const TransactionListPage({.key});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  bool _showSpinner = false;
  TransactionListModel? transactionListModel;

  getAllTransactionList() async {
    setState(() {
      _showSpinner = true;
    });
    try {
      transactionListModel = await TopUpNetworking().getTopUpTransactions();
      setState(() {
        _showSpinner = false;
      });
    } catch (e) {
      print(e);
      showSimpleFlushBar(e.toString(), context);
      setState(() {
        _showSpinner = false;
      });
    }
  }

  @override
  void initState() {
    getAllTransactionList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              '${AppTranslations.of(context).text("title_transactions")}',
              textAlign: TextAlign.center,
              style: kAppBarTextStyle),
        ),
        body: transactionListModel == null
            ? HaloLoading()
            : ListView.separated(
                padding: EdgeInsets.all(10.0),
                // physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final data =
                      transactionListModel!.response!.transactions![index];
                  return TopUpTransactionContainerhere(topupTransaction: data);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    height: 1,
                    color: lightGrey,
                  );
                },
                itemCount: transactionListModel!.response!.transactions!.length,
              ));
  }
}

class TopUpTransactionContainerhere extends StatefulWidget {
  TopUpTransactionContainerhere({
    this.topupTransaction,
  });

  final Transaction? topupTransaction;

  @override
  State<TopUpTransactionContainerhere> createState() =>
      _TopUpTransactionContainerhereState();
}

class _TopUpTransactionContainerhereState
    extends State<TopUpTransactionContainerhere> {
  String ?outputDateString;

  @override
  void initState() {
    super.initState();
    // Step 1: Convert string to DateTime object
    DateTime dateTime = DateTime.parse(widget.topupTransaction!.topupDatetime!);

    // Step 2: Convert DateTime object back to string in a different format
    outputDateString = DateFormat("dd MMM yyyy hh:mm a").format(dateTime);
    // var outputFormat = DateFormat('dd MMM yyyy hh:mm a');
    // widget.topupTransaction.topupDatetime = outputFormat.format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MobileTopUpTransactionDetailPage(
                      topUpTransaction: widget.topupTransaction,
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
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(
                      "$outputDateString",
                      style: kSmallLabelTextStyle.copyWith(color: darkGrey),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            width: 6.0,
          ),
          getTransactionAmount(context),
          GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => EwalletTopUpDetailPage(topUpTransaction: topupTransaction)));
              },
              child: Image.asset("images/ic_forward.png",
                  width: 40.0, height: 40.0))
        ],
      )),
    );
  }

  Widget getTransactionAmount(BuildContext context) {
    if (widget.topupTransaction!.topupStatus!.toLowerCase() == "success") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: Text(
              "+ ${AppTranslations.of(context).text("currency_my")} ${widget.topupTransaction!.topupAmount}",
              style: kTitleSemiBoldTextStyle.copyWith(color: Colors.green),
            ),
          ),
          // getTransactionTag(context),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          child: Text(
            "${AppTranslations.of(context).text("currency_my")} ${widget.topupTransaction!.topupAmount}",
            style: kTitleSemiBoldTextStyle.copyWith(color: Colors.black),
          ),
        ),
        // getTransactionTag(context),
      ],
    );
  }

  Widget getTransactionType(BuildContext context) {
    return Container(
      child: Text(
        "${AppTranslations.of(context).text("topUp")}",
        style: kLabelSemiBoldTextStyle,
      ),
    );
  }

  // Widget getTransactionTag(BuildContext context) {
  Color getTextColor() {
    if (widget.topupTransaction!.topupStatus == "success") {
      return Colors.green;
    } else if (widget.topupTransaction!.topupStatus == "pending") {
      return Colors.blueAccent;
    } else if (widget.topupTransaction!.topupStatus == "failed") {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }
}
