

// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// import '../../utils/app_translations/app_translations.dart';
// import '../../utils/constants/custom_colors.dart';

// class EwalletOnlinePaymentPage extends StatefulWidget {
//   static const String id = 'ewalletOnlinePaymentPage';
//   final String? paymentLink;

//   EwalletOnlinePaymentPage({this.paymentLink});

//   @override
//   _EwalletOnlinePaymentPageState createState() =>
//       _EwalletOnlinePaymentPageState();
// }

// class _EwalletOnlinePaymentPageState extends State<EwalletOnlinePaymentPage> {
//   // InAppWebViewController webView;
//   double progress = 0;
//   bool isLoading = true;
//   WebViewController? _controller;
//   // ProgressDialog pr;
//   _launchURL(String url) async {
//     if (await canLaunchUrl(Uri.parse(url))) {
//       await launchUrl(Uri.parse(url),
//           mode: LaunchMode.externalNonBrowserApplication);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//     if (Platform.isIOS) WebView.platform = CupertinoWebView();
//   }
//   // _confirmQuitPaymentDialog() {
//   //   showDialog(
//   //       context: context,
//   //       builder: (context) => ConfirmationDialog(
//   //             title: AppTranslations.of(context).text('quit_payment_ques'),
//   //             message: AppTranslations.of(context)
//   //                 .text('are_you_sure_to_quit_this_page'),
//   //           )).then((value) {
//   //     if (value != null && value == 'confirm') {
//   //       Navigator.pop(context);
//   //     }
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.black),
//         title: Text(AppTranslations.of(context).text('online_payment'),
//             style: kAppBarTextStyle),
//       ),
//       body: Stack(
//         children: [
//           WebView(
//             initialUrl: widget.paymentLink,
//             javascriptMode: JavascriptMode.unrestricted,
//             onWebViewCreated: (WebViewController webViewController) {
//               _controller = _controller;
//             },
//             onPageFinished: (url) {
//               print("finished $url");
//               String lastParamInUrl = url.toString().split('/').last;

//               if (lastParamInUrl == 'return' ||
//                   lastParamInUrl == 'completion') {
//                 Navigator.pop(context);
//               }
//               setState(() {
//                 isLoading = false;
//               });
//             },
//             onPageStarted: (String url) async {
//               // final Uri uri = Uri.parse(url);
//               // if (!url.contains("http")) {
//               //   if (await canLaunchUrl(uri)) {
//               //     await launchUrl(uri, mode: LaunchMode.externalApplication);
//               //   }
//               // }
//               print('Page started loading: $url');
//             },
//             navigationDelegate: (action) async {
//               final url = action.url;
//               {
//                 if (url.contains('deep_link')) {
//                   print('blocking navigation to $url}');
//                   _launchURL('$url');
//                   return NavigationDecision.prevent;
//                 }

//                 print('allowing navigation to $url');
//                 return NavigationDecision.navigate;
//               }
//             },
//           ),
          
//           Visibility(
//             visible: isLoading,
//             child: Center(
//               child: Container(
//                 color: Colors.white,
//                 child: Center(
//                     child: CircularProgressIndicator(
//                   color: kColorRed,
//                   backgroundColor: kColorRed,
//                 )),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
// //   @override
// //   Widget build(BuildContext context) {
// //     print(widget.paymentLink);
// //     return WillPopScope(
// //       onWillPop: () async {
// //         _confirmQuitPaymentDialog();
// //         return false;
// //       },
// //       child: Scaffold(
// //         appBar: AppBar(
// //           title: Text(AppTranslations.of(context).text('online_payment'),
// //               style: kAppBarTextStyle),
// //         ),
// //         body: SafeArea(
// //           child: Container(
// //             child: Column(
// //               children: <Widget>[
// //                 Row() ??
// //                     Container(
// //                         child: progress < 1.0
// //                             ? LinearProgressIndicator(value: progress)
// //                             : Container()),
// //                 Expanded(
// //                   child: Container(
// //                     child: InAppWebView(
// //                       initialOptions: InAppWebViewGroupOptions(
// //                           crossPlatform: InAppWebViewOptions(
// //                             useShouldOverrideUrlLoading: true,
// //                             mediaPlaybackRequiresUserGesture: false,
// //                           ),
// //                           android: AndroidInAppWebViewOptions(
// //                             useHybridComposition: true,
// //                           ),
// //                           ios: IOSInAppWebViewOptions(
// //                             allowsInlineMediaPlayback: true,
// //                           )),
// //                       initialUrlRequest:
// //                           URLRequest(url: Uri.parse(widget.paymentLink)),
// //                       onWebViewCreated: (InAppWebViewController controller) {
// //                         webView = controller;
// //                       },
// //                       onLoadStart: (controller, url) {
// // //                        print('onLoadStart: $url');
// //                       },
// //                       onLoadStop: (controller, url) async {
// //                         print('onLoadStop: $url');

//                         // String lastParamInUrl = url.toString().split('/').last;

//                         // if (lastParamInUrl == 'return' ||
//                         //     lastParamInUrl == 'completion') {
//                         //   Navigator.pop(context);
//                         // }
// //                         // }else if(lastParamInUrl == 'returnFailed'){
// //                         //   Navigator.pop(context, 'onlinePaymentFail');
// //                         // }
// //                       },
// //                       onProgressChanged:
// //                           (InAppWebViewController controller, int progress) {
// //                         //     if(progress != this.progress)
// //                         // setState(() {
// //                         //   this.progress = progress / 100;
// //                         // });
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

 import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/constants/custom_colors.dart';

class EwalletOnlinePaymentPage extends StatefulWidget {
  static const String id = 'ewalletTopUpDetailPage';

  final String? paymentLink;
   const EwalletOnlinePaymentPage({this.paymentLink});

  @override
  State<EwalletOnlinePaymentPage> createState() => _EwalletOnlinePaymentPageState();
}

class _EwalletOnlinePaymentPageState extends State<EwalletOnlinePaymentPage> {
  late final WebViewController controller;
  bool isLoading = true;
   _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalNonBrowserApplication);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  void initState() {
    super.initState();
    controller = WebViewController()
    ..loadRequest(Uri.parse(widget.paymentLink!))
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
   NavigationDelegate(
    onProgress: (int progress){
    
    },
      onPageStarted: (String url) async {
              // final Uri uri = Uri.parse(url);
              // if (!url.contains("http")) {
              //   if (await canLaunchUrl(uri)) {
              //     await launchUrl(uri, mode: LaunchMode.externalApplication);
              //   }
              // }
              print('Page started loading: $url');
            },
        onPageFinished: (String url) {
              print("finished $url");
              String lastParamInUrl = url.toString().split('/').last;

              if (lastParamInUrl == 'return' ||
                  lastParamInUrl == 'completion') {
                Navigator.pop(context);
              }
              setState(() {
                isLoading = false;
              });
            },
          onNavigationRequest:     (action) async {
              final url = action.url;
              {
                if (url.contains('deep_link')) {
                  print('blocking navigation to $url}');
                  _launchURL('$url');
                  return NavigationDecision.prevent;
                }

                print('allowing navigation to $url');
                return NavigationDecision.navigate;
              }
            }

            
   )
    );
    
  }
   @override
   Widget build(BuildContext context) {
     return Scaffold(
      
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
            // onWebViewCreated: (WebViewController webViewController) {
            //   controller = webViewController;
            // },
        
         
      
          ),
          
          Visibility(
            visible: isLoading,
            child: Center(
              child: Container(
                color: Colors.white,
                child: Center(
                    child: CircularProgressIndicator(
                  color: kColorRed,
                  backgroundColor: kColorRed,
                )),
              ),
            ),
          )
        ],
      ),
     );
   }
}
