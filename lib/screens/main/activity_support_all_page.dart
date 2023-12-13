import 'package:flutter/material.dart';

import '../../components/model_progress_hud.dart';
import '../../models/activity_model.dart';
import '../../models/user_model.dart';
import '../../networkings/booking_networking.dart';
import '../../utils/app_translations/app_translations.dart';
import '../../utils/constants/api_urls.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/constants/fonts.dart';
import '../../utils/constants/styles.dart';
import '../../utils/services/datetime_formatter.dart';
import 'activity_support_details_page.dart';


class ActivitySupportAllPage extends StatefulWidget {
  static const String id = 'ActivitySupportAllPage';

  @override
  _ActivitySupportAllPageState createState() => _ActivitySupportAllPageState();
}

class _ActivitySupportAllPageState extends State<ActivitySupportAllPage> {
  bool _showSpinner = true;
  ActivityModel _activity = ActivityModel();

  @override
  initState() {
    _activity.bookingDetail = [];
    _getActivity();
    super.initState();
  }

  Future _getActivity() async {
    Map<String, dynamic> params = {
      "apiKey": APIUrls().getApiKey(),
      "data": {
        "userToken": User().getUserToken(),
      }
    };

    print(params);

    setState(() {
      _showSpinner = true;
    });

    try {
      _activity = await BookingNetworking().getAllRecentActivity(params);
    } catch (e) {
      print('gg wtf');
      // print(e.toString());
    } finally {
      setState(() {
        _showSpinner = false;
      });
    }
  }

  // List<String> _announcements = [];

  void viewActivityDetails(BookingDetail bookDetail) {
    Navigator.pushNamed(context, ActivitySupportDetailsPage.id,
        arguments: bookDetail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: arrowBack,
          onPressed: () => {Navigator.pop(context)},
        ),
        title: Text(
          AppTranslations.of(context).text('support'),
          style: kAppBarTextStyle,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: SafeArea(
          child: Container(
              padding: EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent activities',
                      style: kLargeTitleBoldTextStyle,
                    ),
                    (_activity.bookingDetail.length == 0)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                AppTranslations.of(context).text('no_activity'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: poppinsLight, fontSize: 16),
                              )
                            ],
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  viewActivityDetails(
                                      _activity.bookingDetail[index]);
                                },
                                behavior: HitTestBehavior.translucent,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 6),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                    boxShadow: [elevation],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(children: [
                                        Text(
                                            _activity.bookingDetail[index]
                                                .orderStatus,
                                            style: kLabelSemiBoldTextStyle),
                                        Spacer(),
                                        Text(
                                          DatetimeFormatter()
                                              .getFormattedDateStr(
                                                  format: 'dd MMM yyyy hh:mm a',
                                                  datetime: _activity
                                                      .bookingDetail[index]
                                                      .bookingDate
                                                      .toString())
                                              .toString(),
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ]),
                                      Divider(
                                        thickness: 1,
                                        color: lightGrey,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            _activity
                                                .bookingDetail[index].itemType,
                                            style: kLabelSemiBoldTextStyle,
                                          ),
                                          Spacer(),
                                          Row(
                                            children: [
                                              Text(
                                                'RM ',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              Text(
                                                  _activity.bookingDetail[index]
                                                      .totalPrice,
                                                  style:
                                                      kLabelSemiBoldTextStyle),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text(
                                          _activity.bookingDetail[index]
                                              .bookingAddress[0].recipientName,
                                          style: TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              );
                            },
                            // separatorBuilder: (context, index) {
                            //   return Padding(
                            //     padding: EdgeInsets.symmetric(vertical: 10.0),
                            //     child: Divider(
                            //       color: Colors.black,
                            //     ),
                            //   );
                            // },
                            itemCount: _activity.bookingDetail.length),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
