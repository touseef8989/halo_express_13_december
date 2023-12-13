import 'package:flutter/material.dart';

import '../../../components/action_button.dart';
import '../../../components/custom_flushbar.dart';
import '../../../components/input_textfield.dart';
import '../../../components/labeled_checkbox.dart';
import '../../../components/model_progress_hud.dart';
import '../../../components_new/payment_method_selection_dialog.dart';
import '../../../models/booking_model.dart';
import '../../../models/coupon_model.dart';
import '../../../models/preview_topup_model.dart';
import '../../../models/top_up_list_model.dart';
import '../../../models/top_up_method_model.dart';
import '../../../models/topup_payment_success_model.dart';
import '../../../networkings/ewallet_networking.dart';
import '../../../networkings/topup_networking.dart';
import '../../../utils/app_translations/app_translations.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/fonts.dart';
import '../../../utils/constants/styles.dart';
import '../../../utils/utils.dart';
import '../../general/confirmation_dialog.dart';
import '../voucher_list_page.dart';
import '../webview_page.dart';
import 'mobile_top_up_success_page.dart';

class MobileTopUpSummaryPage extends StatefulWidget {
  static const String id = 'mobileTopUpSummaryPage';

  MobileTopUpSummaryPage({
    this.phoneNumber,
    this.provider,
    this.amount,
    this.topUpListModel,
  });

  final String? phoneNumber;
  final String? provider;
  final double? amount;
  TopUpListModel? topUpListModel;

  @override
  _MobileTopUpSummaryPageState createState() => _MobileTopUpSummaryPageState();
}

class _MobileTopUpSummaryPageState extends State<MobileTopUpSummaryPage> {
  bool _showSpinner = false;
  //List<double> topUpAmount = [10.0, 50.0, 100.0, 150.0, 200.0, 300.0];
  // List<TopUpMethodModel> _paymentMethods = <TopUpMethodModel>[];
  List<TopUpMethodModel> _paymentMethods = <TopUpMethodModel>[];

  TextEditingController topUpAmountTextController = TextEditingController();
  double finalTopUpAmount = 0.00;
  SizedBox space = SizedBox(
    height: 10.0,
  );
  int selectedAmountPos = -1;
  int selectedPaymentMethod = 0;

  String _selectedPaymentMethod = 'cod';

  // Coupon
  String? _couponCodeTFValue;
  List<Coupon> _coupons = [];
  String _validatedCouponCode = '';
  Map _validatedCoupon = {};
  String ?outputDateString;

  getFunction() async {
    PreviewTopUpModel previewTopUpModel = await TopUpNetworking().topUpPreview(
        amount: widget.amount.toString(),
        paymentMethod: widget.topUpListModel!.response!
            .availablePaymentMethod![selectedPaymentMethod].methodName!,
        accountNumber: widget.phoneNumber!,
        prodId: widget.provider!);
    if (previewTopUpModel.msg == "Preview Topup Amount Success.") {
      TopUpPaymentSuccessModel result = await TopUpNetworking().topupSubmit(
          amount: widget.amount.toString(),
          paymentMethod: widget.topUpListModel!.response!
              .availablePaymentMethod![selectedPaymentMethod].methodName!,
          accountNumber: widget.phoneNumber!,
          prodId: widget.provider!);
      if (result.msg ==
          "Your wallet balance is low. Please topup halo wallet balance and try again.") {
        if (mounted) {
          showSimpleFlushBar(
              "Your wallet balance is low. Please topup halo wallet balance and try again.",
              context);
        }
      } else {
        if (result.response!.paymentUrl != '') {
          print("++++++++++++++++++++++++++++++");
          print(result.response!.paymentUrl!.isNotEmpty);
          print("++++++++++++++++++++++++++++++");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => WebviewPage(
                        title: "",
                        url: result.response!.paymentUrl,
                      )));
          // print(res.then((value) => value.));
          // Navigator.pushNamed(context, WebviewPage())
        } else
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MobileTopUpSuccessPage(
                status: true,
                topUpAmount: widget.amount,
                // dateTime: '14th December 2020',
                // refNo: '11223344',
                phoneNumber: widget.phoneNumber,
                topUpMethodModel: "hallo wallet",
              ),
            ),
          );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // _paymentMethods.addAll(AppConfig.paymentMethods);
    EwalletNetworking().getTopUpPaymentMethodList().then((result) {
      for (var element in result) {
        _paymentMethods.add(TopUpMethodModel(
            paymentIsActive: true,
            paymentType: element['method_name'],
            paymentTitle: element['method_display_name'],
            paymentIcon: element['method_icon_url']));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print("6666666666666 ${widget.phoneNumber}");

    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
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
            '${AppTranslations.of(context).text("mobile_top_up_review_pay")}',
            textAlign: TextAlign.center,
            style: kAppBarTextStyle,
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  color: Colors.grey[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        child: Row(
                          children: [
                            // Image.network(
                            //   widget.provider,
                            //   width: 50,
                            //   height: 50,
                            // ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  widget.phoneNumber!,
                                  style: kDetailsTextStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      space,
                      space,
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${AppTranslations.of(context).text("order_summary")}",
                              style: kLabelSemiBoldTextStyle,
                            ),
                            space,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${AppTranslations.of(context).text("Prepaid Reload")}",
                                  style: kLabelSemiBoldTextStyle,
                                ),
                                Text(
                                  "${AppTranslations.of(context).text("currency_my")} ${Utils.getFormattedPrice(widget.amount)}",
                                  style: kLabelSemiBoldTextStyle,
                                ),
                              ],
                            ),
                            space,
                            Divider(
                              thickness: 3,
                            ),
                            space,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${AppTranslations.of(context).text("Subtotal")}",
                                  style: kLabelTextStyle,
                                ),
                                Text(
                                  "${AppTranslations.of(context).text("currency_my")} ${Utils.getFormattedPrice(widget.amount)}",
                                  style: kLabelTextStyle,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${AppTranslations.of(context).text("Tax (SST)")}",
                                  style: kLabelTextStyle,
                                ),
                                Text(
                                  "${AppTranslations.of(context).text("currency_my")} ${Utils.getFormattedPrice(0)}",
                                  style: kLabelTextStyle,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${AppTranslations.of(context).text("Final Price")}",
                                  style: kLabelTextStyle,
                                ),
                                Text(
                                  "${AppTranslations.of(context).text("currency_my")} ${Utils.getFormattedPrice(widget.amount)}",
                                  style: kLabelTextStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      space,
                      // space,
                      // Container(
                      //   padding: EdgeInsets.symmetric(
                      //       horizontal: 15.0, vertical: 10.0),
                      //   color: Colors.white,
                      //   child: promoCodeWidget(),
                      // ),
                      // space,
                      space,
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            // PaymentMethodSelectionBox(
                            //   paymentMethod: PaymentMethod()
                            //       .getPaymentMethod(_selectedPaymentMethod),
                            //   onPressed: () {
                            //     _openPaymentMethodDialog();
                            //   },
                            // )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        color: Colors.white,
                        child: Text(
                          "${AppTranslations.of(context).text("title_payment_option")}",
                          style: kLabelSemiBoldTextStyle,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsets.only(bottom: 65.0),
                        color: Colors.white,
                        child: ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              final result = widget.topUpListModel!.response!
                                  .availablePaymentMethod![index];
                              return CheckboxWithContents(
                                onChanged: (value) {
                                  if (selectedPaymentMethod != index) {
                                    setState(() {
                                      selectedPaymentMethod = index;
                                    });
                                  }
                                },
                                value: selectedPaymentMethod == index,
                                padding: EdgeInsets.only(top: 0),
                                content: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    child: Row(
                                      children: [
                                        (result.methodIconUrl == null)
                                            ? Image.asset(
                                                'images/ic_e_wallet.png',
                                                width: 40.0,
                                                height: 40.0,
                                              )
                                            : Image.network(
                                                result.methodIconUrl!,
                                                width: 40.0,
                                                height: 40.0,
                                              ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                            "${AppTranslations.of(context).text(result.methodDisplayName!)}",
                                            style: kDetailsTextStyle),
                                      ],
                                    )),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Container();
                            },
                            itemCount: widget.topUpListModel!.response!
                                .availablePaymentMethod!.length),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomAppBar(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: ActionButton(
                      buttonText:
                          "${AppTranslations.of(context).text("mobile_top_up_place_order")}",
                      onPressed: () {
                        showConfirmDialog();

                        print(widget.amount);
                        print(widget
                            .topUpListModel!
                            .response!
                            .availablePaymentMethod![selectedPaymentMethod]
                            .methodName);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _openPaymentMethodDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      builder: (context) => PaymentMethodSelectionDialog(
        bookingType: 'express',
        selectedMethod: _selectedPaymentMethod,
        onChanged: (value) {
          setState(() {
            _selectedPaymentMethod = value;
            BookingModel().setPaymentMethod(value);
          });
        },
      ),
    );
  }

  void validateCoupon() async {}

  Widget promoCodeWidget() {
    if (_validatedCoupon.length > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppTranslations.of(context).text('promo_code'),
                style: kAddressTextStyle,
              ),
              GestureDetector(
                onTap: () async {
                  var data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VoucherListPage(
                        coupons: _coupons,
                      ),
                    ),
                  );
                  if (data != null) {
                    Coupon coupon = data;
                    setState(() {
                      _couponCodeTFValue = coupon.couponName;
                    });
                    validateCoupon();
                  }
                },
                child: Text(
                  '${_coupons.length} ${AppTranslations.of(context).text('available_voucher')}',
                  style: TextStyle(
                    fontFamily: poppinsSemiBold,
                    fontSize: 12,
                    color: kColorRed,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Container(
            height: 45.0,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(color: Colors.grey)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _couponCodeTFValue!,
                    style: TextStyle(fontFamily: poppinsItalic, fontSize: 16),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      _couponCodeTFValue = '';
                      _validatedCoupon = {};
                    });
                  },
                  color: kColorRed,
                  textColor: Colors.white,
                  child: Icon(Icons.clear),
                ),
              ],
            ),
          )
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // *** Don't remove, it is for Voucher listing **
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppTranslations.of(context).text('promo_code'),
                style: TextStyle(fontFamily: poppinsMedium, fontSize: 16),
              ),
              GestureDetector(
                onTap: () async {
                  var data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VoucherListPage(
                        coupons: _coupons,
                      ),
                    ),
                  );
                  if (data != null) {
                    Coupon coupon = data;
                    setState(() {
                      _couponCodeTFValue = coupon.couponName;
                    });
                    validateCoupon();
                  }
                },
                child: Text(
                  '${_coupons.length} ${AppTranslations.of(context).text('available_voucher')}',
                  style: TextStyle(
                    fontFamily: poppinsSemiBold,
                    fontSize: 12,
                    color: kColorRed,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              Expanded(
                child: InputTextField(
                  textAlign: TextAlign.center,
                  onChange: (value) {
                    _couponCodeTFValue = value;
                  },
                ),
              ),
              SizedBox(width: 10.0),
              MaterialButton(
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0)),
                onPressed: () {
                  // validateCoupon();
                },
                color: kColorRed,
                textColor: Colors.white,
                child: Text(
                  AppTranslations.of(context).text('validate'),
                  style: TextStyle(fontFamily: poppinsMedium, fontSize: 15),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  showConfirmDialog() async {
    showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
              title: AppTranslations.of(context)
                  .text('mobile_top_up_confirm_title'),
              message: AppTranslations.of(context)
                  .text('mobile_top_up_confirm_reload'),
            )).then((value) async {
      if (value != null && value == 'confirm') {
        print(value);
        try {
          // setState(() async {
          //   _showSpinner = true;
          // });
          await getFunction();
          // setState(() {
          //   _showSpinner = false;
          // });
        } catch (e) {
          showSimpleFlushBar(e.toString(), context);
        }
      }
    });
  }
}
