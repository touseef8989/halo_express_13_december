import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_facebook_keyhash/flutter_facebook_keyhash.dart';
import 'package:haloapp/components/custom_flushbar.dart';
import 'package:haloapp/models/notification_model.dart';
import 'package:haloapp/models/shop_model.dart';
import 'package:haloapp/networkings/food_networking.dart';

// import 'package:haloapp/screens/auth/change_profile_page.dart';
import 'package:haloapp/screens/boarding/get_started_page.dart';
import 'package:haloapp/screens/boarding/location_access_page.dart';
import 'package:haloapp/screens/boarding/login_page.dart';
import 'package:haloapp/screens/boarding/reset_new_password_page.dart';
import 'package:haloapp/screens/boarding/reset_password_page.dart';
import 'package:haloapp/screens/boarding/reset_sms_verification_page%20.dart';
import 'package:haloapp/screens/boarding/signup_page.dart';
import 'package:haloapp/screens/boarding/sms_verification_page.dart';
import 'package:haloapp/screens/boarding/social_merge_page.dart';
import 'package:haloapp/screens/boarding/splash_page.dart';
import 'package:haloapp/screens/boarding/step_page.dart';
import 'package:haloapp/screens/boarding/success_page.dart';
import 'package:haloapp/screens/boarding/success_page_ewallet.dart';
// import 'package:haloapp/screens/delivery/add_address_page.dart';
import 'package:haloapp/screens/delivery/addresses_list_page.dart';
// import 'package:haloapp/screens/general/language_selector_page.dart';
import 'package:haloapp/screens/general/online_payment_page.dart';
import 'package:haloapp/screens/general/settings_page.dart';
import 'package:haloapp/screens/general/support_page.dart';
import 'package:haloapp/screens/main/account_security_page.dart';
import 'package:haloapp/screens/main/activity_support_all_page.dart';
import 'package:haloapp/screens/main/activity_support_details_page.dart';
import 'package:haloapp/screens/main/activity_support_page.dart';
import 'package:haloapp/screens/main/activty_support_chat_page.dart';
import 'package:haloapp/screens/main/add_address_page.dart';
import 'package:haloapp/screens/main/change_phone_page.dart';
import 'package:haloapp/screens/boarding/change_phone_verification_page.dart';
import 'package:haloapp/screens/main/change_profile_page.dart';
import 'package:haloapp/screens/main/delivery_details_page.dart';
import 'package:haloapp/screens/main/delivery_history_details_page.dart';
import 'package:haloapp/screens/main/delivery_history_page.dart';
import 'package:haloapp/screens/main/delivery_main_page.dart';
import 'package:haloapp/screens/main/delivery_review_page.dart';
import 'package:haloapp/screens/main/ewallet_online_payment_page.dart';
import 'package:haloapp/screens/main/ewallet_page.dart';
import 'package:haloapp/screens/main/ewallet_top_up_detail_page.dart';
import 'package:haloapp/screens/main/ewallet_top_up_page.dart';
import 'package:haloapp/screens/main/find_address_page.dart';
import 'package:haloapp/screens/main/food_main_page.dart';
import 'package:haloapp/screens/main/language_selector_page.dart';
import 'package:haloapp/screens/main/notification_details_page.dart';
import 'package:haloapp/screens/main/notification_list_page.dart';
import 'package:haloapp/screens/main/points/points_page.dart';
import 'package:haloapp/screens/main/points/redeem_points_page.dart';
import 'package:haloapp/screens/main/referral_details_page.dart';
import 'package:haloapp/screens/main/referral_page.dart';
import 'package:haloapp/screens/main/shop_list_page.dart';
import 'package:haloapp/screens/main/shop_menu_page.dart';
import 'package:haloapp/screens/main/tab_bar_controller.dart';
import 'package:haloapp/screens/main/topup_new_feature/mobile_top_up_amount_page.dart';
import 'package:haloapp/screens/main/update_server_update.dart';
import 'package:haloapp/screens/main/user_profile_page.dart';
import 'package:haloapp/screens/main/voucher_list_page.dart';
import 'package:haloapp/utils/app_translations/app_translations_delegate.dart';
import 'package:haloapp/utils/app_translations/application.dart';
import 'package:haloapp/utils/constants/api_urls.dart';
import 'package:haloapp/utils/services/location_service.dart';
import 'package:haloapp/utils/services/push_notifications.dart';
import 'package:haloapp/utils/services/shared_pref_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'models/activity_model.dart';
import 'screens/boarding/change_password_page.dart';
import 'screens/main/home_page_new.dart';

/////  need to set this one
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

NotificationAppLaunchDetails? notificationAppLaunchDetails;
const bool isProduction = bool.fromEnvironment('dart.vm.product');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (isProduction) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  // WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  PushNotificationsManager().init();

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  // var initializationSettingsAndroid =
  //     new AndroidInitializationSettings('@mipmap/ic_launcher');
  // var initializationSettingsIOS = new DarwinInitializationSettings();
  // var initializationSettings = new InitializationSettings(
  //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  // flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //     onNotificationClicked: (String? payload) async {
  //   if (payload != null) {
  //     debugPrint('notification payload: ' + payload);
  //   }
  // });
   
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: (String? payload) async {
      //   if (payload != null) {
      //     debugPrint('notification payload: ' + payload);
      //   }
      // },
    );
 
  // Crashlytics.instance.enableInDevMode = true;
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static String huaweiToken = '';
  // static GlobalKey<TabBarPageState> myTabbedPageKey = GlobalKey<TabBarPageState>();
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Uri? _initialUri;
  // Uri? _latestUri;
  // Object? _err;
  // StreamSubscription? _sub;
  // bool _initialUriIsHandled = false;
  final GlobalKey<NavigatorState> myNavigatorKey = GlobalKey<NavigatorState>();
  // static void backgroundMessageCallback(RemoteMessage remoteMessage) async {
  //   String data = remoteMessage.data;
  //
  //   Push.localNotification({
  //     HMSLocalNotificationAttr.TITLE: '[Headless] DataMessage Received',
  //     HMSLocalNotificationAttr.MESSAGE: data
  //   });
  // }
  // void printKeyHash() async {
  //   String key = await FlutterFacebookKeyhash.getFaceBookKeyHash ??
  //       'Unknown platform version';
  //   print("fbkey $key");
  // }

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance.addPostFrameCallback((_) => _handleIncomingLinks());
    application.localeDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
    initiateLanguage();
    // checkPermission();
    // printKeyHash();
    //_handleIncomingLinks();
    //_handleInitialUri();
    // if (Platform.isAndroid) {
    //   Push.registerBackgroundMessageHandler(backgroundMessageCallback);
    //   initPlatformState();
    //   getToken();
    // }
  }

  // void _onTokenEvent(String event) {
  //   // Requested tokens can be obtained here
  //   setState(() {
  //     MyApp.huaweiToken = event;
  //   });
  //   print("TokenEvent: " + event);
  // }
  //
  // void _onTokenError(Object error) {
  //   PlatformException e = error;
  //   print("TokenErrorEvent: " + e.message);
  // }
  //
  // Future<void> initPlatformState() async {
  //   if (!mounted) return;
  //   Push.getTokenStream.listen(_onTokenEvent, onError: _onTokenError);
  // }

  // void getToken() async {
  //   // Call this method to request for a token
  //   var token = Push.getToken('HCM');
  // }

  void checkPermission() async {
    //return await LocationService().getCurrentLocation();
    bool locationPermissionGranted = await LocationService().checkPermission();

    if (!locationPermissionGranted) {
      Navigator.pushNamed(context, LocationPage.id);
    }
  }

  // void _handleIncomingLinks() {
  //   print('_handleIncomingLinks###############');
  //   // It will handle app links while the app is already started - be it in
  //   // the foreground or in the background.
  //   _sub = uriLinkStream.listen((Uri uri) {
  //     if (!mounted) return;
  //     String lastParamInUrl = uri.toString().split('/').last;

  //     getShopDetails(lastParamInUrl);
  //     // setState(() {
  //     //   _latestUri = uri;
  //     //   _err = null;
  //     // });
  //   }, onError: (Object err) {
  //     if (!mounted) return;
  //     print('got err: $err');
  //     setState(() {
  //       _latestUri = null;
  //       if (err is FormatException) {
  //         _err = err;
  //       } else {
  //         _err = null;
  //       }
  //     });
  //   });
  // }

  Future getShopDetails(String codeUniqueCode) async {
    Map<String, dynamic> params = {
      "apiKey": APIUrls().getFoodApiKey(),
      "data": {
        "lng": '0',
        "lat": '0',
        "shopUniqueCode": codeUniqueCode,
      }
    };
    print(params);

    // setState(() {
    //   //_showSpinner = true;
    // });

    try {
      var data = await FoodNetworking().getShopDetails(params);

      ShopModel shop = data;

      myNavigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => ShopMenuPage(
            shopUniqueCode: shop.uniqueCode!,
            shopInfo: shop,
          ),
        ),
      );

      return null;
    } catch (e) {
      print(e.toString());
      showSimpleFlushBar(e.toString(), context);
      return null;
    } finally {
      // setState(() {
      //  // _showSpinner = false;
      // });
    }
  }

  void initiateLanguage() async {
    String? languageCode = await SharedPrefService().getLanguage();
    if (languageCode != null) {
      application.onLocaleChanged!(Locale(languageCode));
    } else {
      application.onLocaleChanged!(Locale('en'));
      SharedPrefService().setLanguage('en');
    }
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      application.localeDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: myNavigatorKey,
      title: 'Halo App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins-Regular',
        primaryColor: Colors.white,
        appBarTheme: AppBarTheme(color: Colors.white, elevation: 2.0),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
      ),
      initialRoute: SplashPage.id,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings? settings) {
        var routes = <String, WidgetBuilder>{
          NotificationDetailsPage.id: (context) =>
              NotificationDetailsPage(settings!.arguments as NotificationSingleModel?),
          // ActivitySupportDetailsPage.id: (context) =>
          //     ActivitySupportDetailsPage(settings!.arguments!),
          ActivitySupportDetailsPage.id: (context) {
  final arguments = settings!.arguments as BookingDetail;
  return ActivitySupportDetailsPage(arguments);
},
        };
        WidgetBuilder builder = routes[settings!.name]!;
        return MaterialPageRoute(builder: (ctx) => builder(ctx));
      },
      routes: {
        SplashPage.id: (context) => SplashPage(),
        StepPage.id!: (context) => StepPage(),
        GetStartedPage.id: (context) => GetStartedPage(),
        SocialMergePage.id: (context) => SocialMergePage(),
        ChangeProfilePage.id: (context) => ChangeProfilePage(),
        LoginPage.id: (context) => LoginPage(),
        SignUpPage.id: (context) => SignUpPage(),
        SuccessPage.id: (context) => SuccessPage(),
        LocationPage.id: (context) => LocationPage(),
        ResetPasswordPage.id: (context) => ResetPasswordPage(),
        ResetSMSVerificationPage.id: (context) => ResetSMSVerificationPage(),
        ResetNewPasswordPage.id: (context) => ResetNewPasswordPage(),
        SMSVerificationPage.id: (context) => SMSVerificationPage(),
        SupportPage.id: (context) => SupportPage(),
        UserProfilePage.id: (context) => UserProfilePage(),
        ChangePasswordPage.id: (context) => ChangePasswordPage(),
        DeliveryMainPage.id: (context) => DeliveryMainPage(),
        AddAddressPage.id: (context) => AddAddressPage(),
        AddressesListPage.id: (context) => AddressesListPage(),
        DeliveryDetailsPage.id: (context) => DeliveryDetailsPage(),
        DeliveryReviewPage.id: (context) => DeliveryReviewPage(),
        DeliveryHistoryPage.id: (context) => DeliveryHistoryPage(),
        DeliveryHistoryDetailsPage.id: (context) =>
            DeliveryHistoryDetailsPage(),
        SettingsPage.id: (context) => SettingsPage(),
        LanguageSelectorPage.id: (context) => LanguageSelectorPage(),
        OnlinePaymentPage.id: (context) => OnlinePaymentPage(),
        TabBarPage.id: (context) => TabBarPage(key: UniqueKey(),),
        HomePage.id!: (context) => HomePage(),
        FoodMainPage.id: (context) => FoodMainPage(),
        FindAddressPage.id: (context) => FindAddressPage(),
        ShopListPage.id: (context) => ShopListPage(),
        AccountSecurityPage.id: (context) => AccountSecurityPage(),
        EwalletPage.id: (context) => EwalletPage(),
        SuccessEwalletPage.id: (context) => SuccessEwalletPage(),
        EwalletTopUpPage.id: (context) => EwalletTopUpPage(),
        EwalletOnlinePaymentPage.id: (context) => EwalletOnlinePaymentPage(),
        // ignore: equal_keys_in_map
        EwalletTopUpDetailPage.id: (context) => EwalletTopUpDetailPage(),
        VoucherListPage.id: (context) => VoucherListPage(),
        UpdateServerPage.id: (context) => UpdateServerPage(),
        NotificationListPage.id: (context) => NotificationListPage(),
        ActivitySupportPage.id: (context) => ActivitySupportPage(),
        ActivitySupportAllPage.id: (context) => ActivitySupportAllPage(),
        ActivitySupportChatPage.id: (context) => ActivitySupportChatPage(),
        ReferralsPage.id: (context) => ReferralsPage(),
        ReferralsDetailPage.id: (context) => ReferralsDetailPage(),
        ChangePhonePage.id: (context) => ChangePhonePage(),
        PointsPage.id: (context) => PointsPage(key: UniqueKey(),),
        ChangePhoneVerificationPage.id: (context) =>
            ChangePhoneVerificationPage(),
//// new

        RedeemPointsPage.id!: (context) => RedeemPointsPage(),
        MobileTopUpAmountPage.id: (context) => MobileTopUpAmountPage(),
      },
       localizationsDelegates: [
  application.localeDelegate!,
  AppTranslationsDelegate(),
  // Provides localized strings
  GlobalMaterialLocalizations.delegate,
  // Provides RTL support for material widgets
  GlobalWidgetsLocalizations.delegate,
  // Provides Cupertino (iOS-style) localization
  GlobalCupertinoLocalizations.delegate,
],

      supportedLocales: application.supportedLocales(),
    );
  }
}
