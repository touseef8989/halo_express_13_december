import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../components/action_button.dart';
import '../../components/custom_flushbar.dart';
import '../../components/input_textfield.dart';
import '../../components/model_progress_hud.dart';
import '../../components_new/address_detail.dart';
import '../../components_new/order_food_widget.dart';
import '../../components_new/payment_method_selection_box.dart';
import '../../components_new/payment_method_selection_dialog.dart';
import '../../components_new/tip_and_don_enter/don_enter_widget.dart';
import '../../components_new/tip_and_don_enter/tip_enter_widget.dart';
import '../../components_new/vehicle_card.dart';
import '../../models/address_model.dart';
import '../../models/booking_model.dart';
import '../../models/coupon_model.dart';
import '../../models/payment_method_model.dart';
import '../../models/user_model.dart';
import '../../networkings/booking_networking.dart';
import '../../utils/app_translations/app_translations.dart';
import '../../utils/constants/api_urls.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/constants/fonts.dart';
import '../../utils/constants/styles.dart';
import '../../utils/services/pop_with_result_service.dart';
import '../../utils/services/shared_pref_service.dart';
import '../boarding/login_page.dart';
import '../delivery/delivery_booking_success_page.dart';
import '../delivery/delivery_payment_locations_dialog.dart';
import '../general/confirmation_dialog.dart';
import '../general/online_payment_page.dart';
import 'home_page_new.dart';
import 'voucher_list_page.dart';

class DeliveryReviewPage extends StatefulWidget {
  static const String id = 'deliveryReviewPage';

  @override
  _DeliveryReviewPageState createState() => _DeliveryReviewPageState();
}

class _DeliveryReviewPageState extends State<DeliveryReviewPage> {
  bool? _showSpinner = false;
  String? _validatedCouponCode = '';
  String? _finalPrice;
  String? _discountDescp;
  String? _discountedPrice;
  String? _couponCodeTFValue;
  String _selectedPaymentMethod = 'cod';
  List<Coupon> _coupons = [];
  List<DynamicPaymentMethodModel> _paymentMethods = [];
  String tipentered = "0.0";
  String donentered = "0.0";
  TextEditingController enterTipC = TextEditingController();
  TextEditingController enterDonC = TextEditingController();
  createExpressBooking() async {
    print(
      BookingModel().getBookingData(),
    );
    Map<String, dynamic> params = {
      "apiKey": APIUrls().getApiKey(),
      "data": BookingModel().getBookingData(),
    };
//    print(params);
    print('create/update booking for review');
    print(BookingModel().getVehicle().id);

    print("444444");
    printWrapped(params.toString());

    setState(() {
      _showSpinner = true;
    });

    try {
      setState(() {
        _showSpinner = true;
      });
      var data = await BookingNetworking().createBooking(params);
    } catch (e) {
      print(e.toString());
      showSimpleFlushBar(e.toString(), context);
    } finally {
      setState(() {
        _showSpinner = false;
      });
    }
  }

  void confirmBooking() async {
    Map<String, dynamic> params = {
      "apiKey": APIUrls().getApiKey(),
      "data": BookingModel().getConfirmedBookingData(),
    };

    setState(() {
      _showSpinner = true;
    });

    try {
      var data = await BookingNetworking().confirmBooking(params);

      if (data is Map<String, String>) {
        // Online payment
        proceedToOnlinePayment(data['paymentUniqueKey']!);
      } else {
        _showBookingSuccessPage();
      }
    } catch (e) {
      if (e is Map<String, dynamic>) {
        if (e['status_code'] == 514) {
          SharedPrefService().removeLoginInfo();
          Navigator.popUntil(context, ModalRoute.withName(LoginPage.id));
        }
      } else {
        print(e.toString());
        showSimpleFlushBar(e.toString(), context);
      }
    } finally {
      setState(() {
        _showSpinner = false;
      });
    }
  }

  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  void showConfirmBookDialog() {
    if (BookingModel().getSelectedAddressIdToCollectPayment() == null ||
        BookingModel().getSelectedAddressIdToCollectPayment() == '') {
      showSimpleFlushBar(
          AppTranslations.of(context)
              .text('please_select_location_for_rider_to_collect_payment'),
          context);
      return;
    }

    showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
              title: AppTranslations.of(context).text('booking_confirmation'),
              message: AppTranslations.of(context).text('confirm_to_book_ques'),
            )).then((value) {
      if (value != null && value == 'confirm') {
        BookingModel().setCouponCode(_validatedCouponCode!);
        confirmBooking();
      }
    });
  }

  void validateCoupon() async {
    Map<String, dynamic> params = {
      "apiKey": APIUrls().getApiKey(),
      "data": {
        "bookingUniqueKey": BookingModel().getBookingUniqueKey(),
        "userToken": User().getUserToken(),
        "couponName": _couponCodeTFValue
      },
    };
    print(params);
    print(User().getAuthToken());

    setState(() {
      _showSpinner = true;
    });

    try {
      var data = await BookingNetworking().validateCoupon(params);

      if (data is Map<String, dynamic>) {
        String msg = data['msg'];
        if (msg != null && msg != '') {
          showSimpleFlushBar(data['msg'] ?? '', context, isError: false);
        }

        Map<String, dynamic> discountData = data['return'];
        _finalPrice = discountData['totalPrice'].toString() ?? '';
        _discountedPrice = discountData['discountedPrice'].toString() ?? '';
        _discountDescp = discountData['couponDesc'] ?? '';
        _validatedCouponCode = discountData['couponName'] ?? '';
      }
    } catch (e) {
      if (e is Map<String, dynamic>) {
        if (e['status_code'] == 514) {
          SharedPrefService().removeLoginInfo();
          Navigator.popUntil(context, ModalRoute.withName(LoginPage.id));
        }
      } else {
        showSimpleFlushBar(e.toString(), context);
      }
    } finally {
      setState(() {
        _showSpinner = false;
      });
    }
  }

  void showPaymentLocationSelectionDialog() {
    showDialog(
        context: context,
        builder: (context) => DeliveryPaymentLocationsDialog()).then((value) {
      if (value != null && value != '') {
        print('select location payment');
        print(value);
        setState(() {
          BookingModel().setPaymentCollectionAddressId(value);
        });
      }
    });
  }

  _showBookingSuccessPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DeliveryBookingSuccessPage())).then((value) {
      if (value != null && value == 'close') {
        Navigator.pop(
            context,
            PopWithResults(
                fromPage: DeliveryReviewPage.id,
                toPage: HomePage.id!,
                results: {
                  'bookingSuccess': true,
                }));
      }
    });
  }

  void proceedToOnlinePayment(String paymentUniqueKey) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OnlinePaymentPage(
              paymentLink:
                  'https://halo.express/payment/online/$paymentUniqueKey')),
    ).then((value) {
      if (value != null && value == 'onlinePaymentSuccess') {
        _showBookingSuccessPage();
      }
    });
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

  @override
  void initState() {
    super.initState();
    _initPaymentMethods();
    _initCouponList();
  }

  _initPaymentMethods() async {
    BookingModel().getPaymentMethods().forEach((element) {
      _paymentMethods.add(DynamicPaymentMethodModel(
        name: element['method_name'],
        title: element['method_display_name'],
        image: element['method_icon_url'],
      ));
    });
  }

  _initCouponList() async {
    Map<String, dynamic> params = {
      "apiKey": APIUrls().getApiKey(),
      "data": {
        "bookingUniqueKey": BookingModel().getBookingUniqueKey(),
        "userToken": User().getUserToken(),
      }
    };
    print(params);
    setState(() {
      _showSpinner = true;
    });

    try {
      var data = await BookingNetworking().couponList(params);
      _coupons = data;
    } catch (e) {
      print(e.toString());
      showSimpleFlushBar(e.toString(), context);
    } finally {
      setState(() {
        _showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(BookingModel().getTotalPrice());
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
            ),
          ],
          title: Center(
            child: Text(
              AppTranslations.of(context).text('delivery_review'),
              style: kAppBarTextStyle.copyWith(
                fontFamily: poppinsBold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: _showSpinner,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.grey[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            AppTranslations.of(context)
                                .text('delivery_details'),
                            style: kTitleTextStyle.copyWith(fontSize: 16),
                          ),
                          Row(
                            children: [
                              Image.asset('images/ic_timer.png', width: 36),
                              Text(
                                '${BookingModel().getPickupDate() ?? ''} ${BookingModel().getPickupTime()}',
                                style: TextStyle(
                                    fontFamily: poppinsSemiBold, fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1),
                    Container(
                      color: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AddressDetail(
                            addresses: BookingModel().getAllAddresses(),
                            selectedId: BookingModel()
                                .getSelectedAddressIdToCollectPayment(),
                            showContact: true,
                          ),
                          (BookingModel().getSelectedAddressIdToCollectPayment() !=
                                      null &&
                                  BookingModel()
                                          .getSelectedAddressIdToCollectPayment() !=
                                      '')
                              ? Container()
                              : Text(
                                  '${AppTranslations.of(context).text('please_select_location_for_rider_to_collect_payment')}',
                                  style: TextStyle(
                                    fontFamily: poppinsMedium,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                          SizedBox(height: 10),
                          VehicleCard(
                            vehcileImage: BookingModel().getVehicle().image,
                            vehicleTitle: (BookingModel().getVehicle() != null)
                                ? BookingModel().getVehicle().name
                                : '',
                            vehicleDesc:
                                BookingModel().getVehicle().description,
                            vehicleMeasure:
                                BookingModel().getVehicle().description2,
                            isSelected: true,
                            onSelected: () {},
                          ),
                          SizedBox(height: 10.0),
                          MaterialButton(
                            height: 50,
                            minWidth: double.infinity,
                            onPressed: () {
                              showPaymentLocationSelectionDialog();
                            },
                            color: kColorRed,
                            textColor: Colors.white,
                            child: Text(
                              AppTranslations.of(context)
                                  .text('select_the_payment_location'),
                              style: TextStyle(
                                  fontFamily: poppinsMedium, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20.0),
                      child: promoCodeWidget(),
                    ),
                    SizedBox(height: 30.0),
                    Container(
                      color: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
                      child: Column(
                        children: [
                          // enter tip
                          Visibility(
                            visible: BookingModel().getShowTips() == "true"
                                ? true
                                : false,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppTranslations.of(context).text('Tip'),
                                  style: kAddressTextStyle,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    tipentered = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => EnterTipWidget()));

                                    if (tipentered != null) {
                                      setState(() {
                                        enterTipC.text = tipentered;
                                      });
                                      BookingModel()
                                          .setTipPrice(enterTipC.text);

                                      createExpressBooking();
                                    }
                                  },
                                  child: InputTextField(
                                    controller: enterTipC,
                                    inputType: TextInputType.number,
                                    // initText: enteredTip,
                                    enabled: false,
                                    hintText: "enter tip",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // enter don

                          Visibility(
                            visible: (BookingModel().getShowDona() == "true")
                                ? true
                                : false,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppTranslations.of(context).text('Donation'),
                                  style: kAddressTextStyle,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    donentered = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => EnterDonWidget()));
                                    if (donentered != null) {
                                      setState(() {
                                        enterDonC.text = donentered;
                                      });
                                      // getFinalPrice();
                                      BookingModel()
                                          .setDonPrice(enterDonC.text);
                                      createExpressBooking();
                                    }
                                    // createOrder();
                                  },
                                  child: InputTextField(
                                    controller: enterDonC,
                                    inputType: TextInputType.number,
                                    // initText: enteredTip,
                                    hintText: "enter donation",

                                    enabled: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      color: Colors.white,
                      child: PaymentMethodSelectionBox(
                        paymentMethod: _paymentMethods.firstWhere(
                            (e) => e.name == _selectedPaymentMethod),
                        onPressed: () {
                          _openPaymentMethodDialog();
                        },
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _bookingPricing(),
                          ActionButton(
                            buttonText:
                                AppTranslations.of(context).text('book'),
                            onPressed: () {
                              showConfirmBookDialog();
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget promoCodeWidget() {
    if (_validatedCouponCode != null && _validatedCouponCode != '') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
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
                    _validatedCouponCode!,
                    style: TextStyle(fontFamily: poppinsItalic, fontSize: 16),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      _finalPrice = '';
                      _validatedCouponCode = '';
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
                  ))
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
                onPressed: () {
                  validateCoupon();
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

  renderAddresses() {
    List<Widget> addressesView = [];

    for (int i = 0; i < BookingModel().getAllAddresses()!.length; i++) {
      AddressModel address = BookingModel().getAllAddresses()![i];

      Widget view = Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${(address.receiverName != null && address.receiverName != '') ? address.receiverName : ''} - ${(address.receiverPhone != null && address.receiverPhone != '') ? address.receiverPhone : ''}',
              overflow: TextOverflow.ellipsis,
              style: kAddressPlaceholderTextStyle.copyWith(fontSize: 14),
            ),
            Text(
              address.fullAddress!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: poppinsSemiBold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );

      if (i == 1) {
        addressesView.add(Divider());
      }

      addressesView.add(view);
    }

    return addressesView;
  }

  Widget displayImage() {
    if (BookingModel().getAttachedImage() != null &&
        BookingModel().getAttachedImage() != '') {
      Uint8List bytes = base64Decode(BookingModel().getAttachedImage());
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.memory(
            bytes,
            height: 200,
            fit: BoxFit.fitHeight,
          ),
          SizedBox(height: 10.0),
          Text(
            BookingModel().getImageDescription() ?? '',
            textAlign: TextAlign.center,
            style: kDetailsTextStyle,
          )
        ],
      );
    } else {
      return Text(AppTranslations.of(context).text('no_image'),
          textAlign: TextAlign.center, style: kDetailsTextStyle);
    }
  }

  Widget _bookingPricing() {
    List<Widget> priceDetails = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(AppTranslations.of(context).text('delivery_charges'),
              style: kDetailsTextStyle),
          SizedBox(width: 10.0),
          Text(
              '${AppTranslations.of(context).text('currency_my')} ${BookingModel().getDistancePrice()}',
              style: kDetailsTextStyle),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(AppTranslations.of(context).text('priority_fee'),
              style: kDetailsTextStyle),
          SizedBox(width: 10.0),
          Text(
              '${AppTranslations.of(context).text('currency_my')} ${(BookingModel().getPriorityFee() != '' ? BookingModel().getPriorityFee() : '0.00')}',
              style: kDetailsTextStyle),
        ],
      ),
      (BookingModel().getTipPrice() != '0.00' &&
              BookingModel().getTipPrice() != null)
          ? FoodPricingWidget(
              title: AppTranslations.of(context).text("total_tip"),
              amount: BookingModel().getTipPrice(),
            )
          : Container(),
      (BookingModel().getDonPrice() != '0.00' &&
              BookingModel().getDonPrice() != null)
          ? FoodPricingWidget(
              title: AppTranslations.of(context).text("total_don"),
              amount: BookingModel().getDonPrice(),
            )
          : Container(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(AppTranslations.of(context).text('total_price'),
              style: kDetailsTextStyle),
          SizedBox(width: 10.0),
          Text(
              '${AppTranslations.of(context).text('currency_my')} ${BookingModel().getTotalPrice()}',
              style: kDetailsTextStyle),
        ],
      )
    ];

    if (_validatedCouponCode != null && _validatedCouponCode != '') {
      priceDetails.add(Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${AppTranslations.of(context).text('promo_code')}: $_validatedCouponCode',
                style: kDetailsTextStyle,
              ),
              SizedBox(width: 10.0),
              Text(
                '- RM $_discountedPrice',
                style: kDetailsTextStyle,
              )
            ],
          ),
          Text(
            '($_discountDescp)',
            style: TextStyle(fontFamily: poppinsItalic, fontSize: 16),
          ),
          SizedBox(height: 10.0),
        ],
      ));
    }

    priceDetails.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          AppTranslations.of(context).text('final_price'),
          style: kAddressTextStyle,
        ),
        SizedBox(width: 10.0),
        Text(
            '${AppTranslations.of(context).text('currency_my')} ${(_finalPrice != null && _finalPrice != '') ? _finalPrice : BookingModel().getTotalPrice()}',
            style: kAddressTextStyle.copyWith(fontSize: 18, color: Colors.red))
      ],
    ));

    priceDetails.add(SizedBox(height: 10.0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: priceDetails,
    );
  }

  // Not using
  Widget totalPriceWidget() {
    if (_validatedCouponCode != null && _validatedCouponCode != '') {
      return Column(
        children: <Widget>[
          Text(
              '${AppTranslations.of(context).text('currency_my')} ${BookingModel().getTotalPrice()}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: poppinsRegular,
                  fontSize: 15,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough)),
          Text(
            '${AppTranslations.of(context).text('currency_my')} ' +
                _finalPrice!,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: poppinsBold, fontSize: 26, color: kColorRed),
          ),
          Text(
            _discountDescp!,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: poppinsItalic, fontSize: 16, color: kColorRed),
          ),
        ],
      );
    } else {
      return Text(
        '${AppTranslations.of(context).text('currency_my')} ${BookingModel().getTotalPrice()}',
        textAlign: TextAlign.center,
        style:
            TextStyle(fontFamily: poppinsBold, fontSize: 26, color: kColorRed),
      );
    }
  }
}
