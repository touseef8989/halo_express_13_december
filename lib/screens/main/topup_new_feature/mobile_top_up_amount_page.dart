import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


import '../../../components/action_button.dart';
import '../../../components/custom_flushbar.dart';
import '../../../components/model_progress_hud.dart';
import '../../../models/top_up_list_model.dart';
import '../../../models/top_up_method_model.dart';
import '../../../models/user_model.dart';
import '../../../networkings/topup_networking.dart';
import '../../../utils/app_translations/app_translations.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/styles.dart';
import 'mobile_top_up_summary_page.dart';

class MobileTopUpAmountPage extends StatefulWidget {
  static const String id = 'mobileTopUpAmountPage';

  MobileTopUpAmountPage({
    this.phoneNumber,
    this.provider,
  });

  final String? phoneNumber;
  final String ?provider;

  @override
  _MobileTopUpAmountPageState createState() => _MobileTopUpAmountPageState();
}

class _MobileTopUpAmountPageState extends State<MobileTopUpAmountPage> {
  bool _showSpinner = false;
  List<double>? topUpAmount = [5.0, 10.0, 15.0, 30.0, 50.0, 100.0];
  List<TopUpMethodModel>? _paymentMethods = <TopUpMethodModel>[];
  TextEditingController? topUpAmountTextController = TextEditingController();
  TextEditingController? topUpCompanyTextController = TextEditingController();
  TextEditingController? topUpPhoneController = TextEditingController();

  double finalTopUpAmount = 0.00;
  String? prodId = "";
  SizedBox? space = SizedBox(
    height: 10.0,
  );
  TopUpListModel? topUpListModel;
  int selectedAmountPos = -1;
  int selectedTopUp = -1;
  String? selectedName;
  String ?selectedPhone;
  int selectedPaymentMethod = 0;
  bool isEnableTopUp = false;
  bool isEnablePayment = false;

  getAllTopUpList() async {
    setState(() {
      _showSpinner = true;
    });
    setState(() {
      topUpPhoneController!.text = "0" + User().getUserPhone()!;
    });
    try {
      topUpListModel = await TopUpNetworking().getAllTopUpsProviders();
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

  List prices = [];
  getListOfPrices() {
    if (topUpListModel == null) {
      return;
    } else {
      for (var i = 0; i < topUpListModel!.response!.list!.length; i++) {
        if (topUpListModel!.response!.list![i].name == selectedName) {
          prices = topUpListModel!.response!.list![i].acceptAmtDenoArr!;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getAllTopUpList();
    getListOfPrices();
    // _paymentMethods.addAll(AppConfig.paymentMethods);
    // topUpAmount.clear();
    // topUpAmount.addAll(AppConfig.consumerConfig.topUpAmount);
  }

  FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: GestureDetector(
        onTap: () {
          _focusNode.unfocus(); // Unfocus when user taps outside
        },
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
            title: Text('${AppTranslations.of(context).text("title_top_up")}',
                textAlign: TextAlign.center, style: kAppBarTextStyle),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "${AppTranslations.of(context).text("please_enter_phone_number")}",
                          style: kLabelSemiBoldTextStyle,
                        ),
                        space!,
                        Container(
                          child: Row(
                            children: [
                              // Image.network(
                              //   widget.provider,
                              //   width: 50,
                              //   height: 50,
                              // ),
                              // Expanded(
                              //   child: Container(
                              //     padding: EdgeInsets.symmetric(horizontal: 10),
                              //     child: Text(
                              //       User().getUserPhoneCountryCode() +
                              //           User().getUserPhone(),
                              //       style: kDetailsTextStyle,
                              //     ),
                              //   ),
                              // ),

                              // GestureDetector(
                              //   onTap: () {
                              //     Navigator.pop(context);
                              //   },
                              //   child: Container(
                              //     margin: EdgeInsets.only(right: 16),
                              //     child: Row(
                              //       children: [
                              //         Icon(Icons.edit, color: Colors.red),
                              //         Text(
                              //           AppTranslations.of(context).text("edit"),
                              //           style: TextStyle(color: Colors.red),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        space!,
                        // InputTextFormField(
                        //   enabled: false,
                        //   prefixText: "${selectedPhone}",
                        // ),
                        TextField(
                          controller: topUpPhoneController,
                          onSubmitted: (value) {
                            setState(() {
                              topUpPhoneController!.text = value;
                            });
                          },
                          focusNode: _focusNode,

                          // enabled: false,
                          // onTap: () {},
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.only(left: 10.0)),
                        ),

                        space!,
                        // topup cpomany controller

                        topUpCompanyTextController!.text.isEmpty
                            ? Text(
                                "${AppTranslations.of(context).text("select_topup_method")}",
                                style: kLabelSemiBoldTextStyle,
                              )
                            : Text(
                                "${AppTranslations.of(context).text("selected_topup_method")} : \n " +
                                    topUpCompanyTextController!.text,
                                style: kLabelSemiBoldTextStyle,
                              ),
                        space!,
                        // InputTextFormField(
                        //   enabled: false,
                        //   controller: topUpCompanyTextController,
                        //   onChange: (value) {
                        //     setState(() {
                        //       selectedAmountPos = -1;
                        //       if (value.toString().isNotEmpty &&
                        //           double.parse(value) != 0.0) {
                        //         isEnableTopUp = true;
                        //       } else {
                        //         isEnableTopUp = false;
                        //       }
                        //     });
                        //   },
                        //   textInputFormatter:
                        //       DecimalTextInputFormatter(decimalRange: 2),
                        //   hintText:
                        //       "${AppTranslations.of(context).text("title_top_up_payment_method")}",
                        // ),

                        space!,

                        topUpListModel == null
                            ? Container()
                            : Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.23,
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4),
                                  itemCount:
                                      topUpListModel!.response!.list!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final data =
                                        topUpListModel!.response!.list![index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          _focusNode
                                              .unfocus(); // Unfocus when user taps outside

                                          if (selectedTopUp == index) {
                                            setState(() {
                                              selectedTopUp = -1;
                                              selectTopUpCompany(data.name!);
                                            });
                                          } else {
                                            setState(() {
                                              selectedTopUp = index;
                                              prodId = data.id;
                                              isEnablePayment = true;
                                              selectedName = data.name;
                                            });
                                            getListOfPrices();
                                            selectTopUpCompany(data.name!);
                                          }
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                // boxShadow: [
                                                //   BoxShadow(
                                                //       color: Colors.grey.shade100,
                                                //       spreadRadius: 2.5,
                                                //       blurRadius: 2.5)
                                                // ],
                                                // border: Border.all(
                                                //     width: 4,
                                                //     color: isSelectedTopUp(index)
                                                //         ? Colors.red
                                                //         : Colors.transparent),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: topUpListModel!
                                                    .response!
                                                    .list![index]
                                                    .imagepath!,
                                                height: 60,
                                                width: 60,
                                                fit: BoxFit.contain,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Text("not available"),
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(
                                                  backgroundColor: kColorRed,
                                                ),
                                              ),
                                            ),
                                            isSelectedTopUp(index)
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
                                      ),
                                    );
                                  },
                                ),
                              ),
                        Wrap(
                          children: List.generate(prices.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                _focusNode
                                    .unfocus(); // Unfocus when user taps outside

                                if (selectedAmountPos == index) {
                                  setState(() {
                                    selectedAmountPos = -1;
                                    selectTopUpAmount(prices[index]);
                                  });
                                } else {
                                  setState(() {
                                    selectedAmountPos = index;
                                    selectTopUpAmount(prices[index]);
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
                                    width: 105.0,
                                    child: Center(
                                      child: Text(
                                        "${AppTranslations.of(context).text("currency_my")} ${prices[index]}",
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
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: ActionButton(
                      buttonText: "${AppTranslations.of(context).text("next")}",
                      onPressed:
                          (isEnableTopUp == true && isEnablePayment == true)
                              ? () {
                                  nextPage();
                                }
                              : null,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectTopUpAmount(String amount) {
    setState(() {
      topUpAmountTextController!.text = amount;
      topUpAmountTextController!.selection = TextSelection.fromPosition(
          TextPosition(offset: topUpAmountTextController!.text.length));
      if (amount != 0.0) {
        isEnableTopUp = true;
      } else {
        isEnableTopUp = false;
      }
    });
  }

  void selectTopUpCompany(String company) {
    setState(() {
      topUpCompanyTextController!.text = company;
      topUpCompanyTextController!.selection = TextSelection.fromPosition(
          TextPosition(offset: topUpAmountTextController!.text.length));
      if (company != 0.0) {
        isEnablePayment = true;
      } else {
        isEnablePayment = false;
      }
    });
  }

  bool isSelected(int pos) {
    return pos == selectedAmountPos;
  }

  bool isSelectedTopUp(int pos) {
    return pos == selectedTopUp;
  }

  void nextPage() {
    print("111212121212121212121 ${topUpPhoneController!.text}");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobileTopUpSummaryPage(
          phoneNumber: topUpPhoneController!.text,
          provider: prodId!,
          amount: double.parse(topUpAmountTextController!.text),
          topUpListModel: topUpListModel,
        ),
      ),
    );
  }
}
