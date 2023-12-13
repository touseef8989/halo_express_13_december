import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../components/custom_flushbar.dart';
import '../../components/model_progress_hud.dart';
import '../../components_new/address_icon.dart';
import '../../components_new/address_text.dart';
import '../../models/address_model.dart';
import '../../models/food_order_model.dart';
import '../../models/user_model.dart';
import '../../networkings/user_networking.dart';
import '../../utils/app_translations/app_translations.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/constants/fonts.dart';
import '../../utils/constants/styles.dart';
import '../../utils/debouncer.dart';
import '../../utils/services/google_map_places_service.dart';
import '../../utils/services/location_service.dart';
import '../general/save_address_page.dart';
import 'food_main_page.dart';

class FindAddressPage extends StatefulWidget {
  static const String id = '/findAddress';

  @override
  _FindAddressPageState createState() => _FindAddressPageState();
}

class _FindAddressPageState extends State<FindAddressPage> {
  FocusNode? focusNode = FocusNode();
  bool? _showSpinner = true;
  List? savedAddress = [];
  String? _customAddress = '';
  TextEditingController? _customAddressController = TextEditingController();
  dynamic position;
  bool? _popMode;
  bool? _bookingMode = false;

  // final TextEditingController _searchQuery = new TextEditingController();
  List<Prediction> result = <Prediction>[];
  final _debouncer = Debouncer(delay: Duration(milliseconds: 1500));

  @override
  void initState() {
    print('1');
    LocationService().checkPermission().then((value) {
      if (!value) {
        Navigator.pop(context);
      }
    });
  WidgetsBinding.instance.addPostFrameCallback((_) async {
  Map<String, dynamic> args = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>) ;
  _popMode = (args['popMode'] == true);
  _bookingMode = (args['bookingMode'] == true);
  gps();
});


    super.initState();
  }

  Future gps() async {
    setState(() {
      _showSpinner = true;
    });
    position = await LocationService.getLastKnownLocation();
    if (User().getAuthToken() != null &&
        !_popMode! &&
        !_bookingMode! &&
        position != null) await loadNearbyAddress();
    if (User().getAuthToken() != null) await loadSaveAddress();
    if (mounted)
      setState(() {
        _showSpinner = false;
      });
  }

  search(value) async {
    setState(() {
      _showSpinner = true;
    });
    if (value.length <= 0)
      result = <Prediction>[];
    else
      result = await GoogleMapPlacesService.searchPlaceByText(value);

    setState(() {
      _showSpinner = false;
    });
  }

  loadNearbyAddress() async {
    print('gg[');
    Map nearbyAddress = (await UserNetworking.nearbyAddress({
          'data': {
            'lat': position.latitude.toString(),
            'lng': position.longitude.toString()
          }
        }))['addresses'] ??
        Map();
    if (nearbyAddress.length > 0) {
      var am = AddressModel(
        name: nearbyAddress['address_name'],
        note: nearbyAddress['address_note'],
        lat: nearbyAddress['address_lat'],
        lng: nearbyAddress['address_lng'],
        fullAddress: nearbyAddress['address_full'],
        zip: nearbyAddress['address_zip'],
        unitNo: nearbyAddress['address_unit'],
        // buildingName: savedAddress[index]
        //     ['address_custom'],
        city: nearbyAddress['address_city'],
        state: nearbyAddress['address_state'],
        street: nearbyAddress['address_street'],
      );
      FoodOrderModel().setDeliverAddress(am);
      print('gg loe');
      afterSave('saved');
    }
  }

  loadSaveAddress() async {
    try {
      savedAddress = (await UserNetworking.getSavedAddressList())['addresses'];
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  afterSave(res) {
    print('>>> ' + (res ?? ''));
    if (res == 'removed' || res == 'edit') loadSaveAddress();
    if (res == 'saved') {
      print('gg123');
      if (_bookingMode!) {
        AddressModel am = FoodOrderModel().getDeliveryAddress()!;
        // GooglePlacesComponentModel component = GooglePlacesComponentModel();

        // component.city = am.city;
        // component.zip = am.zip;
        // component.state = am.state;
        // component.fullAddress =
        //     (am.unitNo != '' ? (am.unitNo + ', ') : '') + am.fullAddress;
        // // component.route = am.street;
        // component.street = am.street;
        // component.lat = num.tryParse(am.lat.toString()).toDouble();
        // component.lng = num.tryParse(am.lng.toString()).toDouble();

        return Navigator.pop(context, am);
      }
      // print(ModalRoute.of(context).settings.arguments);
      if (_popMode!) return Navigator.pop(context);
      Navigator.pushReplacementNamed(context, FoodMainPage.id);
      print('gg hel');
    }
  }

  getAdressModelById(placeId) async {
    print(placeId);
    var place = await GoogleMapPlacesService.searchPlaceById(placeId);
    List<AddressComponent?> addressComponent = place.addressComponents;

    return AddressModel(
      lat: place.geometry!.location.lat.toString(),
      lng: place.geometry!.location.lng.toString(),
      fullAddress: place.name.length > 0 &&
              place.name.contains(place.formattedAddress!.split(',')[0]) &&
              !place.name.contains(',')
          ? place.name +
              place.formattedAddress!
                  .substring(place.formattedAddress!.indexOf(','))
          : ((place.name.length > 0 && !place.name.contains(','))
                  ? '${place.name}, '
                  : '') +
              place.formattedAddress!,
      zip: addressComponent
          .firstWhere((entry) => entry!.types.contains('postal_code'),
              orElse: () => null)
          ?.longName,
      city: addressComponent
          .firstWhere((entry) => entry!.types.contains('locality'),
              orElse: () => null)
          ?.longName,
      state: addressComponent
          .firstWhere(
              (entry) => entry!.types.contains('administrative_area_level_1'),
              orElse: () => null)
          ?.longName,
      street: addressComponent
          .firstWhere((entry) => entry!.types.contains('street_number'),
              orElse: () => null)
          ?.longName,
      buildingName: "",
      unitNo: "",
    );
  }

  void retrieveLocation() async {
    try {
      setState(() {
        _showSpinner = true;
      });

      bool locationPermissionGranted =
          await LocationService().checkPermission();
      if (!locationPermissionGranted) {
        showSimpleFlushBar(
            AppTranslations.of(context)
                .text('please_enable_location_service_in_phone_settings'),
            context);

        setState(() {
          _showSpinner = false;
        });
        return;
      }

      position = await LocationService.getLastKnownLocation();

      var aa = await GoogleMapPlacesService().getPlaceComponentByLocation(
          LatLng(position.latitude, position.longitude));
      print('end');
      _customAddressController!.text = aa['fullAddress'];
      setState(() {
        _customAddress = aa['fullAddress'];
        _showSpinner = false;
      });
    } catch (_) {
      setState(() {
        _showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: arrowBack,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              onPressed: () async {
                retrieveLocation();
              },
              icon: Icon(
                Icons.my_location,
                size: 20,
                color: Colors.black,
              ),
            ),
          ],
          title: Text(
            AppTranslations.of(context).text('find_address'),
            style: kAppBarTextStyle,
          ),
        ),
        body: SafeArea(
          child: ModalProgressHUD(
            inAsyncCall: _showSpinner,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(color: light4Grey),
                    padding: EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        AddressIcon(),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            // width: double.infinity,
                            child: TextField(
                              focusNode: focusNode,
                              controller: _customAddressController,
                              // autofocus: true,
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  _customAddress = value;
                                });
                                _debouncer.run(() => search(value));
                              },
                              style: TextStyle(
                                color: Colors.black,
                              ),

                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                hintText: AppTranslations.of(context)
                                    .text('type_your_address_here'),
                                hintStyle: TextStyle(color: Colors.black),
                                suffixIcon: _customAddressController!.text != ''
                                    ? IconButton(
                                        onPressed: () {
                                          _customAddressController!.clear();
                                        },
                                        icon: Icon(
                                          Icons.clear_rounded,
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  ListView.separated(
                      separatorBuilder: (context, index) =>
                          Divider(indent: 16, endIndent: 16),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: result.length,
                      itemBuilder: (_, index) {
                        return AddressText(
                          showSaveBtn: (User().getAuthToken() != null),
                          isSaved: false,
                          primaryText:
                              result[index].structuredFormatting!.mainText,
                          secondaryText:
                              result[index].structuredFormatting!.secondaryText,
                          onCardPressed: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            var am =
                                await getAdressModelById(result[index].placeId);
                            var res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SaveAddressPage(am)));

                            afterSave(res);
                            print('gg');
                          },
                        );
                      }),
                  if (_customAddress != '')
                    AutoCompleteCard(
                      showSaveBtn: (User().getAuthToken() != null),
                      isSaved: false,
                      primaryText:
                          AppTranslations.of(context).text('cant_find_address'),
                      secondaryText: _customAddress,
                      onCardPressed: () async {
                        bool locationPermissionGranted =
                            await LocationService().checkPermission();
                        if (locationPermissionGranted) {
                          await gps();
                          FocusScope.of(context).requestFocus(FocusNode());
                          print(
                              "MyLatitude is: " + position.latitude.toString());
                          print("MyLongitude is: " +
                              position.longitude.toString());
                          if (position == null) return;
                          AddressModel am = AddressModel(
                              fullAddress: _customAddress,
                              lat: position.latitude != null
                                  ? position.latitude.toString()
                                  : 0.0.toString(),
                              lng: position.longitude != null
                                  ? position.longitude.toString()
                                  : 0.0.toString());
                          var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SaveAddressPage(
                                        am,
                                        currentLocationMode: false,
                                      )));
                          afterSave(res);
                        } else {
                          showSimpleFlushBar(
                              AppTranslations.of(context).text(
                                  'please_enable_location_service_in_phone_settings'),
                              context);
                        }
                      },
                    ),
                  ListView.separated(
                      separatorBuilder: (context, index) =>
                          Divider(indent: 16, endIndent: 16),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: savedAddress!.length,
                      itemBuilder: (_, index) {
                        return AddressText(
                          isSaved: true,
                          showSaveBtn: (User().getAuthToken() != null),
                          primaryText: savedAddress![index]['address_name'],
                          secondaryText: savedAddress![index]['address_full'],
                          onCardPressed: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            var am = AddressModel(
                              name: savedAddress![index]['address_name'],
                              note: savedAddress![index]['address_note'],
                              lat: savedAddress![index]['address_lat'],
                              lng: savedAddress![index]['address_lng'],
                              fullAddress: savedAddress![index]['address_full'],
                              zip: savedAddress![index]['address_zip'],
                              unitNo: savedAddress![index]['address_unit'],
                              // buildingName: savedAddress[index]
                              //     ['address_custom'],
                              city: savedAddress![index]['address_city'],
                              state: savedAddress![index]['address_state'],
                              street: savedAddress![index]['address_street'],
                            );
                            FoodOrderModel().setDeliverAddress(am);
                            afterSave('saved');
                          },
                          onSavePressed: () async {
                            var am = AddressModel(
                              name: savedAddress![index]['address_name'],
                              note: savedAddress![index]['address_note'],
                              lat: savedAddress![index]['address_lat'],
                              lng: savedAddress![index]['address_lng'],
                              fullAddress: savedAddress![index]['address_full'],
                              zip: savedAddress![index]['address_zip'],
                              unitNo: savedAddress![index]['address_unit'],
                              // buildingName: savedAddress![index]
                              //     ['address_custom'],
                              city: savedAddress![index]['address_city'],
                              state: savedAddress![index]['address_state'],
                              street: savedAddress![index]['address_street'],
                            );
                            var res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SaveAddressPage(am,
                                        adderssId: savedAddress![index]
                                            ['address_id'])));

                            // if (res == 'saved' || res == 'removed') {
                            //   // print('gg');
                            //   // result = new List<Prediction>();
                            //   // loadSaveAddress();
                            // }

                            afterSave('edit');
                            print('gg');
                          },
                        );
                      }),
                ],
              ),
            ),
          ),
        ));
  }
}

class AutoCompleteCard extends StatelessWidget {
  AutoCompleteCard({
    this.onCardPressed,
    this.primaryText,
    this.secondaryText,
    this.onSavePressed,
    this.isSaved = false,
    this.showSaveBtn = true,
  });
  final onCardPressed;
  final primaryText;
  final secondaryText;
  final onSavePressed;
  final isSaved;
  final showSaveBtn;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: new BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 10.0, // has the effect of softening the shadow

              offset: Offset(
                0, // horizontal, move right 10
                5.0, // vertical, move down 10
              ),
            )
          ],
        ),
        child: Material(
          // clipBehavior: Clip.none,
          // color: Colors.transparent,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Container(
              padding: EdgeInsets.fromLTRB(15, 12, 5, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(primaryText,
                          style: TextStyle(fontFamily: poppinsMedium)),
                      Text(secondaryText, style: TextStyle(fontSize: 12)),
                    ],
                  )),
                  if (showSaveBtn)
                    IconButton(
                      icon: Icon(
                        !isSaved
                            ? Icons.edit_outlined
                            : Icons.bookmark_border_outlined,
                        color: kColorRed,
                        size: 18,
                      ),
                      onPressed: onSavePressed,
                    ),
                ],
              )),
        ),
      ),
    );
  }
}
