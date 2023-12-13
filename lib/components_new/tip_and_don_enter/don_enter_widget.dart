import 'package:flutter/material.dart';

import '../../components/action_button.dart';
import '../../components/input_textfield.dart';
import '../../components/model_progress_hud.dart';
import '../../utils/app_translations/app_translations.dart';
import '../../utils/constants/styles.dart';
import '../../utils/utils.dart';




class EnterDonWidget extends StatefulWidget {
  static const String id = 'EnterDonWidget';

  EnterDonWidget({
    this.requiredAmount = 0,
  });

  final double requiredAmount;

  @override
  _EnterDonWidgetState createState() => _EnterDonWidgetState();
}

class _EnterDonWidgetState extends State<EnterDonWidget> {
  bool _showSpinner = false;
  List<double> topUpAmount = [2.0, 3.0, 4.0, 6.0, 8.0, 10.0];

  TextEditingController topUpAmountTextController = TextEditingController();
  double finalTopUpAmount = 0.00;
  SizedBox space = SizedBox(
    height: 10.0,
  );
  int selectedAmountPos = -1;
  int selectedPaymentMethod = 0;
  bool isEnableTopUp = false;

  @override
  void initState() {
    super.initState();
    if (widget.requiredAmount > 0) {
      selectTopUpAmount(widget.requiredAmount);
    }

    // _paymentMethods.addAll(AppConfig.paymentMethods);
    // topUpAmount.clear();
    // topUpAmount.addAll(AppConfig.consumerConfig.topUpAmount);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: Container(
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                )),
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10.0),
            // margin: EdgeInsets.only(bottom: 70.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                space,
                space,
                space,

                Text(
                  "${AppTranslations.of(context).text("Enter Donation")}",
                  style: kLabelSemiBoldTextStyle,
                ),
                space,
                space,
                space,

                Wrap(
                  children: List.generate(topUpAmount.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        if (selectedAmountPos == index) {
                          setState(() {
                            selectedAmountPos = -1;
                            selectTopUpAmount(0.00);
                          });
                        } else {
                          setState(() {
                            selectedAmountPos = index;
                            selectTopUpAmount(topUpAmount[index]);
                          });
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: isSelected(index)
                                  ? Colors.black
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                width: 1.4,
                                color: Colors.black,
                              ),
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: 3.0, vertical: 6.0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 10.0),
                            width: 100.0,
                            child: Center(
                              child: Text(
                                "${AppTranslations.of(context).text("currency_my")} ${Utils.getFormattedPrice(topUpAmount[index])}",
                                style: kLabelSemiBoldTextStyle.copyWith(
                                    color: isSelected(index)
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                          isSelected(index)
                              ? Positioned(
                                  right: 0.0,
                                  top: 0.0,
                                  child: Image.asset(
                                    "images/ic_red_tick.png",
                                    width: 15.0,
                                    height: 15.0,
                                  ))
                              : SizedBox.shrink()
                        ],
                      ),
                    );
                  }),
                ),
                space,
                space,
                space,

                space,

                InputTextFormField(
                  prefixText:
                      "${AppTranslations.of(context).text("currency_my")}",
                  controller: topUpAmountTextController,
                  inputType: TextInputType.numberWithOptions(decimal: true),
                  onChange: (value) {
                    setState(() {
                      selectedAmountPos = -1;
                      if (value.toString().isNotEmpty &&
                          double.parse(value) != 0.0) {
                        isEnableTopUp = true;
                      } else {
                        isEnableTopUp = false;
                      }
                    });
                  },
                  textInputFormatter:
                      DecimalTextInputFormatter(decimalRange: 2),
                  hintText:
                      "${AppTranslations.of(context).text("enter donation amount")}",
                ),

                space,
                Spacer(),
                ActionButton(
                  buttonText: "Confirm",
                  onPressed: () {
                    print(topUpAmountTextController.text);
                    Navigator.pop(context, topUpAmountTextController.text);
                  },
                )
                // Text(
                //   "${AppTranslations.of(context).text("title_payment_option")}",
                //   style: kSmallLabelTextStyle,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectTopUpAmount(double amount) {
    setState(() {
      topUpAmountTextController.text = Utils.getFormattedPrice(amount);
      topUpAmountTextController.selection = TextSelection.fromPosition(
          TextPosition(offset: topUpAmountTextController.text.length));
      if (amount != 0.0) {
        isEnableTopUp = true;
      } else {
        isEnableTopUp = false;
      }
    });
  }

  bool isSelected(int pos) {
    return pos == selectedAmountPos;
  }
}
