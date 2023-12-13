import 'package:flutter/foundation.dart';

import 'address_model.dart';
import 'app_config_model.dart';
import 'food_variant_model.dart';
import 'shop_model.dart';

class FoodOrderModel {
  FoodOrderModel._privateConstructor();
  static final FoodOrderModel _instance = FoodOrderModel._privateConstructor();
  static ValueNotifier<List<FoodOrderCart>> orderCartNotifier =
      ValueNotifier([]);
  static ValueNotifier<AddressModel?> deliverAddressNotifier =
      ValueNotifier(null);

  factory FoodOrderModel() {
    return _instance;
  }

  FoodOption? foodOption;

  Map _offlineAddress = Map();
  AddressModel? _deliverAddress;
  ShopModel? _shop;
  List<FoodOrderCart>? _orderCart = [];
  List<dynamic>? _validPaymentMethods = [];

  // for after calculation
  String? _foodFinalPrice;
//  List<FoodOrderCart> _orderDetails = [];

  String? _finalPrice;
  String? _estDuration;
  String? _deliveryFee;
  String? _packingFee;
  String? _orderFoodSST;
  String? _minFee;
  String? _paymentFee;
  String? _autoDiscount;
  String? _paymentMethod;
  String? _orderUniqueKey;
  List<dynamic>? _availableDates = [];
  int? _deliveryInterval;
  String? _overtimeStatus;
  String? _paymentMethodSelected;
  String? _tipPrice;
  String? _donPrice;
  String? _isShowTips;
  String? _isShowDonat;
  String? _systemFee;
  String? getRiderComm;
  String? hideDeliveryFee;

  void clearFoodOrderData() {
    _shop = null;
    _orderCart!.clear();
    orderCartNotifier.value.clear();
    _foodFinalPrice = null;
    _finalPrice = null;
    _deliveryFee = null;
    _packingFee = null;
    _orderUniqueKey = null;
    _estDuration = null;
    _orderFoodSST = null;
    _minFee = null;
    _tipPrice = null;
    _donPrice = null;
    _systemFee = null;
    _paymentFee = null;
    _paymentMethod = null;
    _availableDates = [];
    _deliveryInterval = null;
    _overtimeStatus = null;
    _paymentMethodSelected = null;
  }

  int? isSameFood(FoodOrderCart order) {
    for (var i = 0; i < _orderCart!.length; i++) {
      bool isSame = order.getCreateOrderParam().toString() ==
          _orderCart![i].getCreateOrderParam().toString();

      if (isSame) {
        return i;
      }

      // print(_orderCart[i].getCreateOrderParam());
      // var isSame = order.getCreateOrderParam().toString() ==
      //     _orderCart[i].getCreateOrderParam().toString();
      // print("$i -- ${isSame}");
      // // if(isSame){
      // //   return i;
      // // }
      // var itemOrder = _orderCart[i];
      // if (itemOrder.foodId == order.foodId) {
      //   var isSame = true;
      //   // print("itemOrder == ${itemOrder.remark}");
      //   // print("order == ${order.remark}");

      //   isSame = isSame && (itemOrder.remark == order.remark);
      //   // print("isSame == $isSame");
      //   // print("dddd");
      //   FoodVariantItemModel orderOptions;
      //   try {
      //     itemOrder.options.forEach((element) {
      //       try {
      //         orderOptions = order.options.firstWhere((innerElement) =>
      //             (element.variantId == innerElement.variantId) &&
      //             (element.selected && innerElement.selected));
      //       } catch (e) {
      //         print(e);
      //       }
      //     });
      //   } catch (e) {
      //     print(e);
      //   }

      //   print("orderOptions ${orderOptions == null}");

      //   if (orderOptions != null) {
      //     return i;
      //   }
      // }
    }

    return null;
  }

  void addFoodInCart(FoodOrderCart order) {
    var index = isSameFood(order);
    if (index != null) {
      _orderCart!.elementAt(index).quantity =
          (int.parse(_orderCart!.elementAt(index).quantity!) +
                  int.parse(order.quantity!))
              .toString();
    } else {
      _orderCart!.add(order);
    }

    if (index != null) {
    } else {
      orderCartNotifier.value = List.from(orderCartNotifier.value)..add(order);
    }
  }

  void removeFoodFromCart(int index) {
    _orderCart!.removeAt(index);
    orderCartNotifier.value = List.from(orderCartNotifier.value)
      ..removeAt(index);
  }

  void setRiderComm(String? riderComm) {
    this.getRiderComm = riderComm;
  }

  void setHideDeliveryFee(String hideDeliveryFee) {
    this.hideDeliveryFee = hideDeliveryFee;
  }

  void setDeliverAddress(AddressModel address) {
    this._deliverAddress = address;
    deliverAddressNotifier.value = address;
  }

  void setDeliveryInterval(int v) {
    _deliveryInterval = v;
  }

  void setTipPrice(String price) {
    _tipPrice = price;
  }

  void setDonPrice(String price) {
    _donPrice = price;
  }

  void setSystemFee(String fee) {
    _systemFee = fee;
  }

  void setOfflineAddress(Map address) {
    _offlineAddress = address;
  }

  Map getOfflineAddress() {
    return _offlineAddress;
  }

  void setShop(ShopModel shop) {
    _shop = shop;
  }

  void clearOrderDetails() {
    _orderCart!.clear();
    orderCartNotifier.value = List.from(orderCartNotifier.value)..clear();
  }

  void setCalculatedFoodFinalPrice(String price) {
    _foodFinalPrice = price;
  }

  void setCreatedOrderPrice(
      {String? finalPrice,
      String? foodFinalPrice,
      String? estDuration,
      String? deliveryFee,
      String? packingFee,
      String? orderFoodSST,
      String? minFee,
      String? paymentFee,
      String? autoDiscount}) {
    _finalPrice = finalPrice;
    _foodFinalPrice = foodFinalPrice;
    _estDuration = estDuration;
    _deliveryFee = deliveryFee;
    _packingFee = packingFee;
    _orderFoodSST = orderFoodSST;
    _minFee = minFee;
    _paymentFee = paymentFee;
    _autoDiscount = autoDiscount;
  }

  void setAvailableDates(List<dynamic> dates) {
    _availableDates = dates;
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
  }

  void setPaymentMethodSelected(String selectMethod) {
    _paymentMethodSelected = selectMethod;
  }

  void setOrderCart(List<FoodOrderCart> orders) {
    _orderCart = orders;
    orderCartNotifier.value = List.from(orderCartNotifier.value)
      ..addAll(orders);
  }

  void setPaymentMethods(List<dynamic> validPaymentMethods) {
    _validPaymentMethods = validPaymentMethods;
  }

  void setOvertimeStatus(String status) {
    _overtimeStatus = status;
  }

  void updateOrderInCart(int index, FoodOrderCart updatedOrder) {
    FoodOrderCart order = FoodOrderCart(
      foodId: updatedOrder.foodId,
      name: updatedOrder.name,
      quantity: updatedOrder.quantity,
      options: updatedOrder.options,
      price: updatedOrder.price,
      finalPrice: updatedOrder.finalPrice,
      remark: updatedOrder.remark,
    );

    _orderCart![index] = order;
    orderCartNotifier.value[index] = order;
  }

  void setOrderUniqueKey(String key) {
    _orderUniqueKey = key;
  }

  void setSowTips(String type) {
    _isShowTips = type;
  }

  void setSowDonat(String type) {
    _isShowDonat = type;
  }

  String getShowTips() => _isShowTips!;

  String getTipPrice() => _tipPrice!;
  String getSytemFee() => _systemFee!;
  String getDonPrice() => _donPrice!;
  String getShowDona() => _isShowDonat!;
  AddressModel? getDeliveryAddress() => _deliverAddress!;
  bool hasSelectedShop() => (_shop == null) ? false : true;
  ShopModel getShop() => _shop!;
  String getShopUniqueCode() => _shop!.uniqueCode!;
  String getShopName() => _shop!.shopName!;
  String getFoodFinalPrice() => _foodFinalPrice!;
  String getFinalPrice() => _finalPrice!;
  String getEstDuration() => _estDuration!;
  String getDeliveryFee() => _deliveryFee!;
  String getOrderFoodSST() => _orderFoodSST!;
  String getAutoDiscount() => _autoDiscount!;
  String getMinFee() => _minFee!;
  String getPaymentFee() => _paymentFee!;
  String getPackingFee() => _packingFee!;
  String getOrderUniqueKey() => _orderUniqueKey!;
  List<FoodOrderCart> getOrderCart() => _orderCart!;
  List<dynamic> getAvailableDates() => _availableDates!;
  int getDeliveryInterval() => _deliveryInterval!;
  String getPaymentMethod() => _paymentMethod!;
  List<dynamic> getPaymentMethods() => _validPaymentMethods!;
  String getOverTimeStatus() => _overtimeStatus!;
  String getPaymentMethodSelected() => _paymentMethodSelected!;

  List<Map<String, dynamic>> getOrderCartParam() {
    List<Map<String, dynamic>> orderCartDataList = [];

    if (_orderCart!.length > 0) {
      for (FoodOrderCart order in _orderCart!) {
        List<Map<String, dynamic>> itemDataList = [];

        if (order.options!.length > 0) {
          for (FoodVariantItemModel item in order.options!) {
            itemDataList.add({"variantId": item.variantId});
          }
        }

        Map<String, dynamic> orderData = {
          "foodId": order.foodId,
          "quantity": order.quantity,
          "options": itemDataList,
          "remark": order.remark
        };

        orderCartDataList.add(orderData);
      }
    }

    return orderCartDataList;
  }

  Map<String, dynamic> getCreateOrderParam() {
    Map<String, dynamic> orderData = {
      "tips": _tipPrice,
      "systemFee": _systemFee,
      "don": _donPrice,
      "lat": _deliverAddress!.lat,
      "lng": _deliverAddress!.lng,
      "note": _deliverAddress!.note ?? '',
      "fullAddress": _deliverAddress!.fullAddress,
      "buildingName": _deliverAddress!.buildingName ?? '',
      "buildingUnit": _deliverAddress!.unitNo ?? '',
      "street": _deliverAddress!.street,
      "zip": _deliverAddress!.zip,
      "city": _deliverAddress!.city,
      "state": _deliverAddress!.state,
      "orderCart": getOrderCartParam(),
      "shopUniqueCode": _shop!.uniqueCode,
      "showTips": _isShowTips,
      "showDon": _isShowDonat,
      "orderUniqueKey": (_orderUniqueKey != null) ? this._orderUniqueKey : '',
      "paymentMethod": this._paymentMethod
    };

    return orderData;
  }
}

class FoodOrderCart {
  String? foodId;
  String? name = '';
  String? quantity;
  List<FoodVariantItemModel>? options = [];
  String? price = '';
  String? finalPrice = '';
  String? remark = '';

  FoodOrderCart({
    this.foodId,
    this.name,
    this.quantity,
    this.options,
    this.price,
    this.finalPrice,
    this.remark,
  });

  Map<String, dynamic> getCreateOrderParam() {
    Map<String, dynamic> orderData = {
      "foodId": foodId,
      // "name": this.name,
      // "quantity": this.quantity,
      // "price": this.price,
      // "finalPrice": this.finalPrice,
      "remark": remark,
      "options": getOrderCartParam()
    };

    return orderData;
  }

  List<Map<String, dynamic>> getOrderCartParam() {
    List<Map<String, dynamic>> orderCartDataList = [];

    if (this.options!.length > 0) {
      for (FoodVariantItemModel order in options!) {
        Map<String, dynamic> orderData = {
          "variantId": order.variantId,
          // "name": order.name,
          // "extraPrice": order.extraPrice,
          // "status": order.status,
          "selected": order.selected
        };

        orderCartDataList.add(orderData);
      }
    }

    return orderCartDataList;
  }
}
