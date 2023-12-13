import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_map_polyline_point/flutter_polyline_point.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:haloapp/screens/delivery/add_address_page.dart';
// import 'package:haloapp/screens/delivery/delivery_details_page.dart';

import '../../components/action_button.dart';
import '../../components/custom_flushbar.dart';
import '../../components/google_map_widget.dart';
import 'dart:math' as math;

import '../../components/model_progress_hud.dart';
import '../../components_new/address_icon.dart';
import '../../components_new/address_otw_icon.dart';
import '../../models/address_model.dart';
import '../../models/booking_model.dart';
import '../../models/history_model.dart';
import '../../models/user_model.dart';
import '../../models/vehicle_model.dart';
import '../../networkings/booking_networking.dart';
import '../../networkings/history_networking.dart';
import '../../utils/app_translations/app_translations.dart';
import '../../utils/constants/api_urls.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/constants/fonts.dart';
import '../../utils/constants/styles.dart';
import '../../utils/constants/vehicles.dart';
import '../../utils/services/google_map_places_service.dart';
import '../../utils/services/location_service.dart';
import '../../utils/services/pop_with_result_service.dart';
import '../boarding/login_page.dart';
import '../delivery/add_address_page.dart';
import '../delivery/addresses_list_page.dart';
import '../general/confirmation_dialog.dart';
import '../general/custom_alert_dialog.dart';
import '../history/delivery_history_details_page.dart';
import 'delivery_details_page.dart';

// import 'package:huawei_map/components/latLng.dart' as huaweiLatLng;
// import 'package:huawei_map/components/marker.dart' as huaweiMarker;
// import 'package:huawei_map/components/polyline.dart' as huaweiPolyLine;
// import 'package:huawei_map/components/polylineId.dart' as huaweiPolyLineId;
// import 'package:huawei_map/map.dart' as huaweiMap;

class DeliveryMainPage extends StatefulWidget {
  static const String id = 'deliveryMainPage';

  @override
  _DeliveryMainPageState createState() => _DeliveryMainPageState();
}

class _DeliveryMainPageState extends State<DeliveryMainPage> {
  bool _showSpinner = false;
  List<VehicleModel> vehicles = Vehicles().getVehicles();

  // static GoogleMapController _mapController;
  Completer<GoogleMapController> _mapController = Completer();
  LatLng _initialPosition = LatLng(37.422153, -122.084047);
  BitmapDescriptor? initialIcon;
  BitmapDescriptor? pickupIcon;
  BitmapDescriptor? dropoffIcon;
  Map<String, Marker> _markers = {};
  PolylinePoints? polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> _polylines = {};

  //Huawei Map
  // Completer<huaweiMap.HuaweiMapController> _huaweiMapController = Completer();
  // huaweiMap.LatLng _huaweiInitialPosition =
  //     huaweiMap.LatLng(37.422153, -122.084047);
  // huaweiMap.BitmapDescriptor huaweiInitialIcon;
  // huaweiMap.BitmapDescriptor huaweiPickupIcon;
  // huaweiMap.BitmapDescriptor huaweiDropoffIcon;
  // Map<String, huaweiMarker.Marker> _huaweiMarkers = {};
  // List<huaweiMap.LatLng> huaweiPolylineCoordinates = [];
  // Map<huaweiPolyLineId.PolylineId, huaweiPolyLine.Polyline> _huaweiPolylines =
  //     {};

  double? _distance;
  VehicleModel? _selectedVehicle = Vehicles().getVehicles()[0];
  String? _calculatedPrice = '-';

  List<int> stops = [0, 1];

  @override
  void initState() {
    super.initState();
    setupIcons();

    while (stops.length != BookingModel().getAllAddresses()!.length &&
        BookingModel().getAllAddresses()!.length > 2) {
      stops.add(stops.length);
    }

    _getUserLocation();

    if (User().getAuthToken() != null) checkCompletedBookingToRate();

    Future.delayed(Duration.zero, () {
      showCopyWrite();
    });
  }

  void setupIcons() {
    ImageConfiguration imageConfig = ImageConfiguration(size: Size(25, 25));

    BitmapDescriptor.fromAssetImage(imageConfig, 'images/pin_blue.png')
        .then((value) => pickupIcon = value);

    BitmapDescriptor.fromAssetImage(imageConfig, 'images/pin_red.png')
        .then((value) => dropoffIcon = value);
  }

  // Get distance price
  void getDistancePrice() async {
    if (BookingModel().getAllAddresses() == null ||
        BookingModel().getAllAddresses()!.length < 2 ||
        _distance == null) {
      return;
    }

    Map<String, dynamic> params = {
      "apiKey": APIUrls().getApiKey(),
      "data": {
        "distance": _distance,
        "transportType": _selectedVehicle!.id,
        "addresses": BookingModel().getAddressesListData(),
      }
    };
    print(params);

    setState(() {
      _showSpinner = true;
    });

    try {
      var data = await BookingNetworking().getDistancePrice(params);

      setState(() {
        _calculatedPrice = data;
      });
    } catch (e) {
      showSimpleFlushBar(e.toString(), context);
    } finally {
      setState(() {
        _showSpinner = false;
      });
    }
  }

  renderSearchAddressInput() {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: stops.length,
      separatorBuilder: (context, index) {
        return Divider(
          height: 1,
          color: lightGrey,
          indent: 16,
          endIndent: 16,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            addAddress(index);
          },
          child: Row(
            children: [
              if (index == 0) AddressIcon(),
              if (index == stops.length - 1)
                Transform.rotate(
                  angle: 180 * math.pi / 180,
                  child: AddressIcon(),
                ),
              if (index != stops.length - 1 && index != 0) AddressOTWIcon(),
              // if (index != stops.length - 1 && index != 0)
              //   SizedBox(width: 10.0),
              SizedBox(width: 10.0),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  child: renderAddressText(
                    index,
                    index == 0
                        ? AppTranslations.of(context)
                            .text('enter_pickup_details')
                        : AppTranslations.of(context)
                            .text('enter_deliver_details'),
                  ),
                ),
              ),
              if (index > 1)
                IconButton(
                  onPressed: () {
                    setState(() {
                      stops.removeAt(index);
                    });

                    if (BookingModel().getAllAddresses()!.length > index) {
                      BookingModel().removeAddressAtIndex(index);
                      refreshMap();
                    }
                  },
                  icon: Icon(Icons.close),
                ),
            ],
          ),
        );
      },
    );
  }

  Text renderAddressText(int index, String placeholder) {
    if (BookingModel().getAllAddresses() != null &&
        BookingModel().getAllAddresses()!.length > index &&
        BookingModel().getAddressAtIndex(index) != null) {
      return Text(
        BookingModel().getAddressAtIndex(index)!.fullAddress!,
        overflow: TextOverflow.ellipsis,
        style: kTitleTextStyle.copyWith(fontSize: 16),
      );
    }
    return Text(
      placeholder,
      overflow: TextOverflow.ellipsis,
      style: kAddressPlaceholderTextStyle,
    );
  }

  bool isAddressExist(int index) {
    if (BookingModel().getAllAddresses() != null &&
        BookingModel().getAllAddresses()!.length > index &&
        BookingModel().getAddressAtIndex(index) != null) {
      return true;
    } else {
      return false;
    }
  }

  // Navigate to address list or add address page
  void addAddress(int index) async {
    dynamic refresh;

    if (index == 0 || index == 1) {
      refresh = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddAddressPage(addressIndex: index)),
      );
    } else {
      refresh = await Navigator.pushNamed(context, AddressesListPage.id);
    }

    if (stops.length != 2) {
      stops.clear();
      for (int i = 0; i < BookingModel().getAllAddresses()!.length; i++) {
        stops.add(i);
      }
    }

    if (refresh == 'refresh') {
      refreshMap();
    }
  }

  //Huawei Map
  // void _onHuaweiMapCreated(huaweiMap.HuaweiMapController controller) {
  //   // _mapController = controller;
  //   _huaweiMapController.complete(controller);
  // }

  void _onMapCreated(GoogleMapController controller) async {
    // _mapController = controller;
    controller
        .setMapStyle(await rootBundle.loadString('assets/map_style.json'));
    _mapController.complete(controller);

    if (BookingModel().getAllAddresses()!.length > 0) {
      refreshMap();
    }
  }

  void _getUserLocation() async {
    Position position = await LocationService.getLastKnownLocation();

    _initialPosition = LatLng(position.latitude, position.longitude);
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _initialPosition, zoom: 16)));
  }

  void refreshMap() async {
    print('refresh map');

    _markers.clear();
    polylinePoints = null;
    polylineCoordinates.clear();
    _polylines.clear();

    List<AddressModel> addresses = BookingModel().getAllAddresses()!;

    if (addresses.length == 0) {
      setState(() {});
      return;
    }

    for (int i = 0; i <= addresses.length - 1; i++) {
      final marker = Marker(
          markerId: MarkerId("$i"),
          position: LatLng(
              double.parse(addresses[i].lat!), double.parse(addresses[i].lng!)),
          icon: (i == 0) ? pickupIcon !: dropoffIcon!);

      _markers["$i"] = marker;
    }

    final GoogleMapController controller = await _mapController.future;

    if (addresses.length >= 2) {
      // draw polyline
      await _createPolylines(addresses);

      // animate camera to see all markers
      List<Marker> markersList = [];

      _markers.forEach((k, v) => markersList.add(v));
      LatLngBounds bound = GoogleMapPlacesService().getBounds(markersList);

      CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 70);
      controller.animateCamera(u2);
    } else {
      // final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(
              double.parse(addresses[0].lat!), double.parse(addresses[0].lng!)),
          zoom: 16)));
    }

    setState(() {});
  }

 Future <void> _createPolylines(List<AddressModel> addresses) async {
    polylinePoints = PolylinePoints();

    try {
      Map<String?, dynamic>? routeData = await GoogleMapPlacesService()
          .getRoute(BookingModel().getAllAddresses()!, true);
      int distanceInMeter = routeData!['distance'];
      _distance = distanceInMeter / 1000;
      getDistancePrice();

      polylineCoordinates = routeData['latLngList'];

      _addPolyline();
    } catch (e) {
      // showSimpleFlushBar(e.toString(), context);
    }
  }

  void _addPolyline() async {
    final PolylineId polylineId = PolylineId('poly');

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      color: Colors.red,
      width: 3,
      points: polylineCoordinates,
    );

    _polylines[polylineId] = polyline;
    setState(() {});
  }

  void proceedToDeliveryDetails() {
    if (_calculatedPrice == '-') return;
    if (BookingModel().getAllAddresses() == null ||
        BookingModel().getAllAddresses()!.length < 2 ||
        _distance == null) {
      showSimpleFlushBar(
          AppTranslations.of(context)
              .text('please_enter_delivery_address_to_proceed'),
          context);
      return;
    }

    if (User().getAuthToken() == null) {
      Navigator.pushNamed(context, LoginPage.id);
      return;
    }

    BookingModel().setVehicle(_selectedVehicle!);
    BookingModel().setDistanceAndPrice(_distance.toString(), _calculatedPrice!);

    Navigator.pushNamed(
      context,
      DeliveryDetailsPage.id,
    ).then((results) {
      if (results is PopWithResults) {
        PopWithResults popResult = results;
        if (popResult.toPage == DeliveryMainPage.id) {
        } else {
          // pop to previous page
          Navigator.of(context).pop(results);
        }
      }
    });

    // Navigator.pushNamed(context, DeliverySenderRecipientPage.id);
  }

  void showCopyWrite() {
    showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
              title: AppTranslations.of(context).text('title_note'),
              message: AppTranslations.of(context).text('copywrite_express'),
            )).then((value) {
      if (value != null && value == 'confirm') {
        setState(() {
          BookingModel().clearBookingData();
          refreshMap();
          _selectedVehicle = Vehicles().getVehicles()[0];
          _calculatedPrice = '-';
        });
      }
    });
  }

  void showConfirmMakeNewBookingDialog() {
    showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
              title: AppTranslations.of(context).text('make_new_booking'),
              message: AppTranslations.of(context).text(
                  'are_you_sure_make_new_booking_current_booking_will_discarded'),
            )).then((value) {
      if (value != null && value == 'confirm') {
        setState(() {
          BookingModel().clearBookingData();
          refreshMap();
          _selectedVehicle = Vehicles().getVehicles()[0];
          _calculatedPrice = '-';
        });
      }
    });
  }

  void checkCompletedBookingToRate() async {
    Map<String, dynamic> params = {
      "apiKey": APIUrls().getApiKey(),
      "data": {
        "userToken": User().getUserToken(),
      },
    };

    setState(() {
      _showSpinner = true;
    });

    try {
      var data = await HistoryNetworking().getBookingHistory(params);

      setState(() {
        if (data is List<HistoryModel>) {
          for (HistoryModel history in data) {
            if (history.orderStatus == 'completed' &&
                history.customerRating == '0') {
              showGoToRateDialog(history.bookingUniqueKey!);
              return;
            }
          }
        }
      });
    } catch (e) {
      print(e.toString());
      showSimpleFlushBar(e.toString(), context);
    } finally {
      setState(() {
        _showSpinner = false;
      });
    }
  }

  void showGoToRateDialog(String bookingKey) {
    showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
              title: AppTranslations.of(context).text('rate_our_service'),
              message: AppTranslations.of(context)
                  .text('there_is_completed_booking_to_rate'),
            )).then((value) {
      if (value != null && value == 'confirm') {
        getHistoryDetails(bookingKey);
      }
    });
  }

  void getHistoryDetails(String key) async {
    Map<String, dynamic> params = {
      "apiKey": APIUrls().getApiKey(),
      "data": {
        "bookingUniqueKey": key,
      },
    };

    setState(() {
      _showSpinner = true;
    });

    try {
      var data = await HistoryNetworking().getHistoryDetails(params);

      Navigator.pushNamed(context, DeliveryHistoryDetailsPage.id,
              arguments: data)
          .then((value) {
        if (value != null) {
          if (value == 'remakeBooking') {
            setState(() {
              refreshMap();
            });
          }
        }
      });
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: arrowBack,
          onPressed: () {
            BookingModel().clearBookingData();
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.my_location,
              size: 20,
              color: Colors.black,
            ),
            onPressed: () {
              _getUserLocation();
            },
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/ic_express.png',
              width: 24,
            ),
            SizedBox(width: 8),
            Text(
              AppTranslations.of(context).text('express'),
              style: kAppBarTextStyle,
            )
          ],
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    _initialPosition == null
                        ? Container(
                            child: Center(
                              child: Text(
                                AppTranslations.of(context).text('loading_map'),
                                style: TextStyle(
                                    fontFamily: poppinsMedium,
                                    color: Colors.grey[400]),
                              ),
                            ),
                          )
                        : getMap(),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            child: renderSearchAddressInput(),
                          ),
                          Divider(height: 1, color: lightGrey),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                //set max 5 address
                                if (stops.length !=
                                        BookingModel()
                                                .getAllAddresses()!
                                                .length +
                                            1 &&
                                    stops.length != 6) {
                                  stops.add(stops.length);
                                }
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              alignment: Alignment.center,
                              child: Text(
                                AppTranslations.of(context).text('add_a_stop'),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: ActionButton(
                  buttonText: AppTranslations.of(context).text('next'),
                  onPressed: () async {
                    proceedToDeliveryDetails();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getMap() {
    return GoogleMapWidget(
      onMapCreated: _onMapCreated,
      location: _initialPosition,
      markers: _markers,
      polylines: _polylines,
    );
  }
}
