import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../components/action_button.dart';
import '../../components/custom_flushbar.dart';
import '../../components/model_progress_hud.dart';
import '../../components_new/address_icon.dart';
import '../../components_new/order_food_widget.dart';
import '../../models/address_model.dart';
import '../../models/app_config_model.dart';
import '../../models/food_history_model.dart';
import '../../models/food_order_model.dart';
import '../../models/payment_method_model.dart';
import '../../models/shop_model.dart';
import '../../models/user_model.dart';
import '../../networkings/food_history_networking.dart';
import '../../networkings/food_networking.dart';
import '../../utils/app_translations/app_translations.dart';
import '../../utils/constants/api_urls.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/constants/fonts.dart';
import '../../utils/constants/styles.dart';
import '../general/online_payment_page.dart';
import '../general/small_fee_dialog.dart';
import 'food_history_details_page.dart';
import 'tab_bar_controller.dart';
class ConfirmOrderPage extends StatefulWidget {
  ConfirmOrderPage({
    this.shop,
    this.couponCodeTFValue,
    this.remarksTFValue,
    this.cartUserName,
    this.cartUserEmail,
    this.cartUserPhone,
    this.selectedBookDate,
    this.selectedBookTime,
    this.validatedCoupon,
    this.paymentMethod,
  });

  final ShopModel? shop;

  final String? couponCodeTFValue;
  final String? remarksTFValue;
  final String? cartUserName;
  final String? cartUserEmail;
  final String? cartUserPhone;
  final String? selectedBookDate;
  final String? selectedBookTime;
  final Map? validatedCoupon;
  final DynamicPaymentMethodModel? paymentMethod;

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  bool _showSpinner = false;

  String? _cartUserName = User().getUsername();
  String? _cartUserEmail = User().getUserEmail();
  String? _cartUserPhone = User().getUserPhone();
  List<FoodOrderCart>? _items = FoodOrderModel().getOrderCart();
  AddressModel? _currentAddress = FoodOrderModel().getDeliveryAddress();
  String? _finalPrice = FoodOrderModel().getFinalPrice();
  Timer? _timer;
  int? countDown = 0;

  renderDeliveryDetails() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              AddressIcon(),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.shop!.shopName!,
                        // overflow: TextOverflow.ellipsis,
                        style: kInputTextStyle,
                      ),
                      Text(
                        widget.shop!.fullAddress!,
                        style: TextStyle(fontFamily: poppinsMedium),
                        // overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Container(
            height: 1,
            color: lightGrey,
            margin: EdgeInsets.symmetric(vertical: 10),
          ),
          Row(
            children: [
              Transform.rotate(
                angle: 180 * math.pi / 180,
                child: AddressIcon(),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${(_currentAddress!.receiverName != null && _currentAddress!.receiverName != '') ? _currentAddress!.receiverName : ''} - ${(_currentAddress!.receiverPhone != null && _currentAddress!.receiverPhone != '') ? _currentAddress!.receiverPhone : ''}',
                        // overflow: TextOverflow.ellipsis,
                        style: kInputTextStyle,
                      ),
                      Text(
                        _currentAddress!.fullAddress!,
                        style: TextStyle(fontFamily: poppinsMedium),
                        // overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  renderPaymentMethodAndPrice() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          FoodPricingWidget(
            title: 'total_price',
            amount: FoodOrderModel().getFoodFinalPrice(),
          ),
          Visibility(
            visible:
                FoodOrderModel().getDeliveryFee() == "true" ? false : true,
            child: FoodPricingWidget(
              title: 'delivery_fee',
              amount: FoodOrderModel().getDeliveryFee(),
            ),
          ),
          (FoodOrderModel().getMinFee() != '0.00')
              ? FoodPricingWidget(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => SmallFeeAlertDialog(
                              title: AppTranslations.of(context)
                                  .text("small_order_fee"),
                              message: AppTranslations.of(context)
                                  .text("small_order_fee_desc"),
                              buttonText:
                                  AppTranslations.of(context).text("proceed"),
                            ));
                  },
                  title: 'minimum_fee',
                  amount: FoodOrderModel().getMinFee(),
                )
              : Container(),
          (FoodOrderModel().getPackingFee() != '0.00')
              ? FoodPricingWidget(
                  title: 'packing_fee',
                  amount: FoodOrderModel().getPackingFee(),
                )
              : Container(),
          (FoodOrderModel().getPaymentFee() != '0.00')
              ? FoodPricingWidget(
                  title: 'payment_fee',
                  amount: FoodOrderModel().getPaymentFee(),
                )
              : Container(),
          (FoodOrderModel().getOrderFoodSST() != '0.00')
              ? FoodPricingWidget(
                  title: 'sst',
                  amount: FoodOrderModel().getOrderFoodSST(),
                )
              : Container(),
          (FoodOrderModel().getTipPrice() != '0.00')
              ? FoodPricingWidget(
                  title: AppTranslations.of(context).text("total_tip"),
                  amount: FoodOrderModel().getTipPrice(),
                )
              : Container(),
          (FoodOrderModel().getDonPrice() != '0.00')
              ? FoodPricingWidget(
                  title: AppTranslations.of(context).text("total_don"),
                  amount: FoodOrderModel().getDonPrice(),
                )
              : Container(),
          (FoodOrderModel().getSytemFee() != '0.00')
              ? FoodPricingWidget(
                  title: AppTranslations.of(context).text("system_fee"),
                  amount: FoodOrderModel().getSytemFee(),
                )
              : Container(),
          (FoodOrderModel().getAutoDiscount() != '0.00')
              ? FoodPricingWidget(
                  title:
                      AppTranslations.of(context).text("special_promo_label"),
                  amount: FoodOrderModel().getAutoDiscount(),
                  isDiscount: true,
                )
              : Container(),
          if (widget.validatedCoupon!.length > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '${AppTranslations.of(context).text('promo_code')}: ' +
                          widget.validatedCoupon!['couponName'],
                      style: kDetailsTextStyle,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      '- RM ' + widget.validatedCoupon!['discountedPrice'],
                      style: kDetailsTextStyle,
                    )
                  ],
                ),
                Text(
                  widget.validatedCoupon!['couponDesc'],
                  style: TextStyle(fontFamily: poppinsItalic, fontSize: 16),
                ),
                SizedBox(height: 10.0),
              ],
            ),
          FoodPricingWidget(
            title: 'final_price',
            amount: (widget.validatedCoupon!.length > 0)
                ? widget.validatedCoupon!['totalPrice']
                : FoodOrderModel().getFinalPrice(),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(right: 8),
                child: (widget.paymentMethod!.image == null)
                    ? Image.asset(
                        'images/halo_logo.png',
                        width: 24,
                        height: 24,
                      )
                    : Image.network(
                        widget.paymentMethod!.image!,
                        width: 24,
                        height: 24,
                      ),
              ),
              Expanded(
                child: Text(
                  widget.paymentMethod!.title!,
                ),
              ),
              Text(
                '${AppTranslations.of(context).text('currency_my')} $_finalPrice',
                style: TextStyle(fontFamily: poppinsSemiBold),
              )
            ],
          )
        ],
      ),
    );
  }

  List<Widget> renderItemCart() {
    return _items!
        .map(
          (item) => Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: lightGrey,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.name!,
                    style: TextStyle(fontFamily: poppinsBold, fontSize: 16),
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  margin: EdgeInsets.only(right: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: kColorRed),
                  ),
                  child: Text(
                    '${item.quantity}',
                    style: kTitleTextStyle.copyWith(
                        fontSize: 14, color: kColorRed),
                  ),
                ),
                Container(
                  child: Text(
                    item.finalPrice!,
                    style: TextStyle(fontFamily: poppinsMedium, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  void _confirmOrder() async {
    String validationError = '';

    _cartUserPhone = widget.cartUserPhone ?? "";
    _cartUserEmail = widget.cartUserEmail ?? "";
    _cartUserName = widget.cartUserName ?? "";

    validationError = (_cartUserPhone!.length <= 0) ? 'Phone is required.' : '';
    validationError = (_cartUserEmail!.length <= 0) ? 'Email is required.' : '';
//    validationError = (_cartUserName.length <= 0) ? 'Name is required.' : '';
    if (validationError.length > 0)
      return showSimpleFlushBar(validationError, context);

    Map<String, dynamic> params = {
      "apiKey": APIUrls().getFoodApiKey(),
      "data": {
        "couponName": widget.couponCodeTFValue ?? '',
        "orderUniqueKey": FoodOrderModel().getOrderUniqueKey(),
        "remark": widget.remarksTFValue ?? '',
        "paymentMethod": widget.paymentMethod!.name,
        "userPhone": _cartUserPhone,
        "userEmail": _cartUserEmail,
        "userName": _cartUserName,
        "preDate": widget.selectedBookDate,
        "preTime": widget.selectedBookTime,
      },
    };
    print(params);
//    printWrapped(params.toString());

    setState(() {
      _showSpinner = true;
    });

    try {
      var data = await FoodNetworking().confirmOrder(params);

      if (data is Map<String, String> &&
          data['paymentUrl'] != null &&
          data['paymentUrl'] != '') {
        // Online payment
        proceedToOnlinePayment(data['paymentUrl']!);
      } else {
        _showSuccessOrderPopup();
      }
    } catch (e) {
      print(e.toString());
      Navigator.pop(context);
      showSimpleFlushBar(e.toString(), context);
    } finally {
      setState(() {
        _showSpinner = false;
      });
    }
  }

  void proceedToOnlinePayment(String paymentLink) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OnlinePaymentPage(paymentLink: paymentLink)),
    ).then((value) async {
      if (value != null && value == 'onlinePaymentSuccess') {
        _showSuccessOrderPopup();
      } else {
        Navigator.popUntil(context, ModalRoute.withName(TabBarPage.id));
        FoodOrderModel().clearFoodOrderData();
      }
    });
  }

  _showSuccessOrderPopup() async {
    FoodHistoryModel fhm =
        await FoodHistoryNetworking().getFoodOrderHistoryDetails({
      "data": {"orderUniqueKey": FoodOrderModel().getOrderUniqueKey()}
    });
    FoodOrderModel().clearFoodOrderData();
    Navigator.popUntil(context, ModalRoute.withName(TabBarPage.id));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                FoodHistoryDetailsPage(success: true, history: fhm)));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      countDown = AppConfig.consumerConfig!.isConfirmOrderDelayTime! ~/ 1000;
    });
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      int countdownSec =
          AppConfig.consumerConfig!.isConfirmOrderDelayTime! ~/ 1000;
      setState(() {
        countDown = countdownSec - timer.tick;
      });
      if (timer.tick ==
          AppConfig.consumerConfig!.isConfirmOrderDelayTime! ~/ 1000) {
        _timer?.cancel();
        _confirmOrder();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 60.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Image.asset(
                          'images/processing.png',
                          width: 180.0,
                          height: 180.0,
                        )),
                    Center(
                      child: Container(
                        margin: EdgeInsets.all(20.0),
                        child: Text(
                          AppTranslations.of(context).text("processing_order"),
                          style: kTitleLargeBoldTextStyle,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.1),
                            blurRadius: 10.0,
                            offset: Offset(
                              0, // horizontal, move right 10
                              5.0, // vertical, move down 10
                            ),
                          )
                        ],
                      ),
                      child: Material(
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppTranslations.of(context)
                                    .text("title_order_summary"),
                                style: kTitleLargeBoldTextStyle,
                              ),
                              SizedBox(height: 10),
                              ...renderItemCart(),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                child: ActionRightIconButton(
                                  icon: Container(
                                    width: 20.0,
                                    height: 20.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${countDown}",
                                      style: kSmallLabelTextStyle,
                                    ),
                                  ),
                                  buttonText: AppTranslations.of(context)
                                      .text("cancel_order"),
                                  // textStyle: TextStyle(
                                  //   fontFamily: poppinsMedium,
                                  //   fontSize: 14,
                                  //   color: Colors.black,
                                  // ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              renderPaymentMethodAndPrice(),
                              SizedBox(height: 20),
                              Text(
                                AppTranslations.of(context)
                                    .text("delivery_details"),
                                style: kTitleLargeBoldTextStyle,
                              ),
                              renderDeliveryDetails(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Container(
              //     margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              //     child: ActionRightIconButton(
              //       icon: Container(
              //         width: 20.0,
              //         height: 20.0,
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           shape: BoxShape.circle,
              //         ),
              //         alignment: Alignment.center,
              //         child: Text(
              //           "${countDown}",
              //           style: kSmallLabelTextStyle,
              //         ),
              //       ),
              //       buttonText: 'Cancel Order',
              //       // textStyle: TextStyle(
              //       //   fontFamily: poppinsMedium,
              //       //   fontSize: 14,
              //       //   color: Colors.black,
              //       // ),
              //       onPressed: () {
              //         Navigator.pop(context);
              //       },
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
