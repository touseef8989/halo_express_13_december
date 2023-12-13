import 'package:flutter/cupertino.dart';

import 'top_up_transaction_model.dart';
import 'wallet_transaction_model.dart';

class User {
  static ValueNotifier<WalletTransactionsResponse?>
      walletTransactionsResponseNotifier =
      ValueNotifier<WalletTransactionsResponse?>(null);
  static ValueNotifier<int> currentTab = ValueNotifier<int>(0);

  User._privateConstructor();
  static final User _instance = User._privateConstructor();

  factory User() {
    return _instance;
  }

  String? _userId;
  String? _username;
  String? _userEmail;
  String? _userPhone;
  String? _userPhoneCountryCode;
  String? _userDOB;
  String? _userToken;
  String? _authToken;
  List? _enabledOptions;
  bool? _enableFood;
  bool? _enableFrozen;
  bool? _enablePharmacy;
  bool? _enableGroceries;
  bool? _enableFestival;
  WalletTransactionsResponse? walletTransactionsResponse;
  TopUpTransactionResponse? topUpTransactionResponse;
  String? _userChatId;
  String? _userRefCode;
  String? _userRefLink;
  String? _refTotalCommission;
  String? _referLeaderShipBoard;

  void setUserData(
      {String? userId,
      String? username,
      String? userEmail,
      String? userPhone,
      String? userPhoneCountryCode,
      String? userDOB,
      String? userToken,
      String? authToken,
      String? userChatId,
      String? userRefCode,
      String? userRefLink,
      String? refTotalCommission,
      String? referLeaderShipBoard,
      List? enabledOptions,
      bool? enableFood,
      bool? enableFrozen,
      bool? enablePharmacy,
      bool? enableFestival,
      bool? enableGroceries}) {
    _userId = userId;
    _username = username;
    _userEmail = userEmail;
    _userPhone = userPhone;
    _userPhoneCountryCode = userPhoneCountryCode;
    _userDOB = userDOB;
    _userToken = userToken;
    _authToken = authToken;
    _enableFood = enableFood;
    _enableFrozen = enableFrozen;
    _enablePharmacy = enablePharmacy;
    _enableGroceries = enableGroceries;
    _enableFestival = enableFestival;
    _enabledOptions = enabledOptions;
    _userChatId = userChatId;
    _userRefCode = userRefCode;
    _userRefLink = userRefLink;
    _refTotalCommission = refTotalCommission;
    _referLeaderShipBoard = referLeaderShipBoard;
  }

  void resetUserData() {
    _userId = null;
    _username = null;
    _userEmail = null;
    _userPhone = null;
    _userPhoneCountryCode = null;
    _userDOB = null;
    _userToken = null;
    _authToken = null;
    _enableFood = false;
    _enableFrozen = false;
    _enablePharmacy = false;
    _enableGroceries = false;
    _enableFestival = false;
    _enabledOptions = [];
    _userChatId = null;
    _userRefCode = null;
    _userRefLink = null;
    _refTotalCommission = null;
    _referLeaderShipBoard = null;
  }

  String? getUsername() => _username;
  String? getUserId() => _userId;
  String? getUserEmail() => _userEmail;
  String? getUserPhone() => _userPhone;
  String? getUserPhoneCountryCode() => _userPhoneCountryCode;
  String? getUserDOB() => _userDOB;
  String? getUserToken() => _userToken;
  String? getAuthToken() => _authToken;
  String? getUserChatId() => _userChatId;
  String? getUserRefCode() => _userRefCode;
  String? getUserRefLink() => _userRefLink;
  String? getRefTotalCommission() => _refTotalCommission;
  String? getRefLeaderBoard() => _referLeaderShipBoard;
  bool? getEnableFoodStatus() => _enableFood;
  bool? getEnableFrozenStatus() => _enableFrozen;
  bool? getEnablePharmacyStatus() => _enablePharmacy;
  bool? getEnableGroceriesStatus() => _enableGroceries;
  bool? getEnabledFestivalStatus() => _enableFestival;
  List? getEnabledOptions() => _enabledOptions;
  WalletTransactionsResponse? getWalletTransactionsResponse() =>
      walletTransactionsResponse;
  TopUpTransactionResponse? getTopUpTransactionResponse() =>
      topUpTransactionResponse;

  void setUserToken(String token) {
    _userToken = token;
  }

  void setEmail(String email) {
    _userEmail = email;
  }

  void setUsername(String userName) {
    _username = userName;
  }

  void setRefTotalCommission(String commission) {
    _refTotalCommission = commission;
  }

  void setEwalletTransaction(
      WalletTransactionsResponse walletTransactionsResponse) {
    walletTransactionsResponseNotifier.value = walletTransactionsResponse;
    walletTransactionsResponse = walletTransactionsResponse;
  }

  void setTopUpTransaction(TopUpTransactionResponse topUpTransactionResponse) {
    topUpTransactionResponse = topUpTransactionResponse;
  }
}
