// import 'package:flutter/material.dart';
// import 'package:haloapp/components/action_button.dart';
// import 'package:haloapp/components/input_textfield.dart';
// import 'package:haloapp/components/model_progress_hud.dart';

// import 'package:haloapp/utils/app_translations/app_translations.dart';
// import 'package:haloapp/utils/constants/custom_colors.dart';
// import 'package:haloapp/utils/constants/styles.dart';

// import 'mobile_top_up_amount_page.dart';

// class MobileTopUpPage extends StatefulWidget {
//   static const String id = 'mobileTopUpPage';

//   @override
//   _MobileTopUpPageState createState() => _MobileTopUpPageState();
// }

// class _MobileTopUpPageState extends State<MobileTopUpPage> {
//   bool _showSpinner = false;
//   TextEditingController phoneNumberTextController = TextEditingController();
//   SizedBox space = SizedBox(
//     height: 10.0,
//   );

//   int selectedProvider = -1;

//   String _phoneNumber = '';
//   String _provider =
//       "https://upload.wikimedia.org/wikipedia/en/thumb/f/f3/Digi_Telecommunications_logo.svg/1200px-Digi_Telecommunications_logo.svg.png";

//   bool isEnableButton = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ModalProgressHUD(
//       inAsyncCall: _showSpinner,
//       child: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           leading: Container(
//             child: IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: arrowBack),
//           ),
//           title: Text('${AppTranslations.of(context).text("title_top_up")}',
//               textAlign: TextAlign.center, style: kAppBarTextStyle),
//         ),
//         body: SafeArea(
//           child: Stack(
//             children: [
//               SingleChildScrollView(
//                 child: Container(
//                   padding: EdgeInsets.all(10.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Text(
//                         "${AppTranslations.of(context).text("mobile_top_up_title_1")}",
//                         style: kLabelSemiBoldTextStyle,
//                       ),
//                       space,
//                       InputTextFormField(
//                         controller: phoneNumberTextController,
//                         inputType: TextInputType.number,
//                         onChange: (value) {
//                           setState(() {
//                             _phoneNumber = value;
//                             if (value.toString().isNotEmpty &&
//                                 isPhoneNumber(value)) {
//                               isEnableButton = true;
//                             } else {
//                               isEnableButton = false;
//                             }
//                           });
//                         },
//                         hintText:
//                             "${AppTranslations.of(context).text("mobile_top_up_input_place_holder")}",
//                       ),
//                       space,
//                       Text(
//                         "${AppTranslations.of(context).text("mobile_top_up_recent")}",
//                         style: kLabelSemiBoldTextStyle,
//                       ),
//                       space,
//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         height: 50,
//                         child: ListView.builder(
//                           physics: ClampingScrollPhysics(),
//                           shrinkWrap: true,
//                           scrollDirection: Axis.horizontal,
//                           itemCount: 10,
//                           itemBuilder: (BuildContext context, int index) =>
//                               Container(
//                             alignment: Alignment.centerLeft,
//                             width: 60,
//                             child: CircleAvatar(
//                               radius: 40,
//                               backgroundImage: NetworkImage(
//                                 "https://www.clipartmax.com/png/middle/405-4050774_avatar-icon-flat-icon-shop-download-free-icons-for-avatar-icon-flat.png",
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       space,
//                       Text(
//                         "${AppTranslations.of(context).text("mobile_top_up_provider")}",
//                         style: kLabelSemiBoldTextStyle,
//                       ),
//                       space,
//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         height: 50,
//                         child: ListView.builder(
//                           physics: ClampingScrollPhysics(),
//                           shrinkWrap: true,
//                           scrollDirection: Axis.horizontal,
//                           itemCount: 10,
//                           itemBuilder: (BuildContext context, int index) =>
//                               GestureDetector(
//                             onTap: () {
//                               if (selectedProvider == index) {
//                                 setState(() {
//                                   selectedProvider = -1;
//                                 });
//                               } else {
//                                 setState(() {
//                                   selectedProvider = index;
//                                 });
//                               }
//                             },
//                             child: Stack(
//                               children: [
//                                 Container(
//                                   alignment: Alignment.centerLeft,
//                                   padding: EdgeInsets.symmetric(horizontal: 5),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.all(
//                                       Radius.circular(20),
//                                     ),
//                                   ),
//                                   child: Image.network(_provider),
//                                 ),
//                                 isSelected(index)
//                                     ? Positioned(
//                                         right: 0.0,
//                                         top: 0.0,
//                                         child: Image.asset(
//                                           "images/ic_red_tick.png",
//                                           width: 15.0,
//                                           height: 15.0,
//                                         ))
//                                     : SizedBox.shrink()
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   margin: EdgeInsets.only(bottom: 10.0),
//                   padding: EdgeInsets.symmetric(horizontal: 10.0),
//                   child: ActionButton(
//                     buttonText:
//                         "${AppTranslations.of(context).text("confirm")}",
//                     onPressed: isEnableButton
//                         ? () {
//                             nextPage();
//                           }
//                         : null,
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   bool isPhoneNumber(phoneNumber) {
//     return RegExp(r'^(01)[0-9]{8,9}$').hasMatch(phoneNumber);
//   }

//   bool isSelected(int pos) {
//     return pos == selectedProvider;
//   }

//   nextPage() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MobileTopUpAmountPage(
//           phoneNumber: _phoneNumber,
//           provider: _provider,
//         ),
//       ),
//     );
//   }
// }
