import 'dart:io';


import 'address_model.dart';
import 'item_type_model.dart';
import 'user_model.dart';
import 'vehicle_model.dart';

class BookingModel {
  BookingModel._privateConstructor();
  static final BookingModel _instance = BookingModel._privateConstructor();

  factory BookingModel() {
    return _instance;
  }

  List<AddressModel>? _addresses = [];
  VehicleModel? _vehicle;
  String? _distance;
  String? _distancePrice;
  String? _pickupDate;
  String? _pickupTime;
  String? _attachedImage;
  String? _imageUrl;
  String? _imageDescp;
  String? _remarks = '';
  String? _couponCode = '';
  String? _bookingUniqueKey = '';
  String? _paymentMethod = '';
  String? _totalPrice = '';
  String? _paymentAtAddressId = '';
  ItemTypeModel? _itemType;
  String? _itemTypeDesc = '';
  String? _priorityFee = '';
  String? _isShowTips = '';
  String? _isShowDonat = '';
  String? tipPrice;
  String? donPrice;

  List<dynamic>? _validPaymentMethods = [];

  void clearBookingData() {
    _addresses!.clear();
    _vehicle = null;
    _distance = null;
    _distancePrice = null;
    _pickupDate = null;
    _pickupTime = null;
    _attachedImage = null;
    _imageUrl = null;
    _imageDescp = null;
    _remarks = '';
    _couponCode = '';
    _bookingUniqueKey = '';
    _paymentMethod = '';
    tipPrice = null;
    donPrice = null;
    _totalPrice = '';
    _paymentAtAddressId = '';
    _itemType = null;
    _itemTypeDesc = '';
    _priorityFee = '';
  }

  AddressModel? getAddressAtIndex(int index) => _addresses![index];
  List<AddressModel>? getAllAddresses() => _addresses!;

  void addAddress(AddressModel address) {
    _addresses!.add(address);
  }

  void replaceAddressAtIndex(int index, AddressModel address) {
    _addresses![index] = address;
  }

  void removeAddressAtIndex(int index) {
    _addresses!.removeAt(index);
  }

  void removeAllDropoffAddresses() {
    _addresses!.removeRange(1, _addresses!.length);
  }

  void setVehicle(VehicleModel vehicle) {
    _vehicle = vehicle;
  }

  void setDistanceAndPrice(String distance, String price) {
    _distance = distance;
    _distancePrice = price;
  }

  void setPickupDateAndTime(String date, String time) {
    _pickupDate = date;
    _pickupTime = time;
  }

  void setPhotoAndDescription(
      String photo, String photoUrl, String description) {
    _attachedImage = photo;
    _imageUrl = photoUrl;
    _imageDescp = description;
  }

  void setRemarks(String remarks) {
    _remarks = remarks;
  }

  void setDeliveryItemDetails(ItemTypeModel itemType, String itemTypeDesc) {
    _itemType = itemType;
    _itemTypeDesc = itemTypeDesc;
  }

  void setCouponCode(String code) {
    _couponCode = code;
  }

  void setPriorityFee(String amount) {
    _priorityFee = amount;
  }

  void setPaymentCollectionAddressId(String id) {
    _paymentAtAddressId = id;
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
  }

  void setCreatedBookingData(
      {String? key, String? totalPrice, List<AddressModel>? addresses}) {
    _bookingUniqueKey = key;
    _totalPrice = totalPrice;
    _addresses = addresses;
    _paymentAtAddressId = '';
  }

  void setPaymentMethods(List<dynamic> validPaymentMethods) {
    _validPaymentMethods = validPaymentMethods;
  }

  void setTotalPrice(String type) {
    _totalPrice = type;
  }

  void setShowTips(String type) {
    _isShowTips = type;
  }

  void setShowDonat(String type) {
    _isShowDonat = type;
  }

  void setTipPrice(String type) {
    tipPrice = type;
  }

  void setDonPrice(String type) {
    donPrice = type;
  }

  String getShowTips() => _isShowTips!;
  String getShowDona() => _isShowDonat!;
  String getTipPrice() => tipPrice!;
  String getDonPrice() => donPrice!;
  VehicleModel getVehicle() => _vehicle!;
  String getPickupDate() => _pickupDate!;
  String getPickupTime() => _pickupTime!;
  String getAttachedImage() => _attachedImage!;
  String getImageDescription() => _imageDescp!;
  String getBookingRemarks() => _remarks!;
  String getDeliveryDistance() => _distance!;
  String getDistancePrice() => _distancePrice!;
  String getTotalPrice() => _totalPrice!;
  String getBookingUniqueKey() => _bookingUniqueKey!;
  String getSelectedAddressIdToCollectPayment() => _paymentAtAddressId!;
  String getCouponCode() => _couponCode!;
  String getPaymentMethod() => _paymentMethod!;
  ItemTypeModel getDeliveryItemType() => _itemType!;
  String getDeliveryItemDesc() => _itemTypeDesc!;
  String getPriorityFee() => _priorityFee!;

  List<Map<String, dynamic>> getAddressesListData() {
    List<Map<String, dynamic>> addressDataList = [];

    if (_addresses!.length > 0) {
      for (int i = 0; i < _addresses!.length; i++) {
        AddressModel address = _addresses![i];

        Map<String, dynamic> addressData = {
          "type": (i == 0) ? 'pickup' : 'dropoff',
          "fullAddress": address.fullAddress ?? '',
          "buildingName": address.buildingName ?? '',
          "buildingUnit": address.unitNo ?? '',
          "street": address.street ?? '',
          "zip": address.zip ?? '',
          "city": address.city ?? '',
          "state": address.state ?? '',
          "lat": address.lat,
          "lng": address.lng,
          "distance": '',
          "recipientName": address.receiverName,
          "recipientPhone": address.receiverPhone
        };

        addressDataList.add(addressData);
      }
    }

    return addressDataList;
  }

  Map<String, dynamic> getBookingData() {
    List<Map<String, dynamic>> addressDataList = getAddressesListData();

    return {
      "bookingUniqueKey": this._bookingUniqueKey,
      "userToken": User().getUserToken(),
      "userName": User().getUsername(),
      "userPhoneCountry": User().getUserPhoneCountryCode(),
      "userPhone": User().getUserPhone(),
      "userEmail": User().getUserEmail(),
      "vehicleType": _vehicle!.id,
      "pickupDate": _pickupDate,
      "pickupTime": _pickupTime,
      "distance": _distance,
      "distancePrice": _distancePrice,
      "remarks": _remarks ?? '',
      "itemType": _itemType!.name,
      "itemTypeDesc": _itemTypeDesc ?? '',
      "priorityFee": _priorityFee ?? '',
      "addresses": addressDataList,
      "tips": tipPrice,
      "don": donPrice,
      "platform": (Platform.isIOS) ? 'ios' : 'android',
    };
  }

  Map<String, dynamic> getConfirmedBookingData() {
    List<Map<String, dynamic>> addressDataList = getAddressesListData();

    return {
      "bookingUniqueKey": this._bookingUniqueKey,
      "userToken": User().getUserToken(),
      "userName": User().getUsername(),
      "userPhoneCountry": User().getUserPhoneCountryCode(),
      "userPhone": User().getUserPhone(),
      "userEmail": User().getUserEmail(),
      "vehicleType": _vehicle!.id,
      "pickupDate": _pickupDate,
      "pickupTime": _pickupTime,
      "distance": _distance,
      "distancePrice": _distancePrice,
      "remarks": _remarks ?? '',
      "itemType": _itemType!.name,
      "itemTypeDesc": _itemTypeDesc ?? '',
      "priorityFee": _priorityFee ?? '',
      "addresses": addressDataList,
      "platform": (Platform.isIOS) ? 'ios' : 'android',
      "paymentMethod": _paymentMethod,
      "imageUrl": _imageUrl,
      "imageDescription": _imageDescp ?? '',
      "couponName": _couponCode ?? '',
      "addressId": _paymentAtAddressId,
    };
  }

  List<dynamic> getPaymentMethods() => _validPaymentMethods!;
}
