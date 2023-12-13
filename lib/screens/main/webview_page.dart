// import 'dart:async';

// // import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart' as web;
// import 'package:webview_flutter/webview_flutter.dart';

// import '../../utils/constants/custom_colors.dart';
// import '../../utils/constants/styles.dart';

// class WebviewPage extends StatefulWidget {
//   WebviewPage({required this.title, this.url});
//   final String? url;
//   final String? title;

//   @override
//   WebviewPageState createState() {
//     return WebviewPageState();
//   }
// }

// class WebviewPageState extends State<WebviewPage> {
//   final Completer<web.WebViewController> _controller =
//       Completer<WebViewController>();
//   WebViewController? _webViewController;

//   @override
//   Widget build(BuildContext context) {
//     // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: arrowBack,
//         ),
//         title: Center(
//           child: Text(
//             widget.title!,
//             style: kAppBarTextStyle,
//           ),
//         ),
//         actions: <Widget>[
//           IconButton(
//             onPressed: () {},
//             icon: Icon(
//               Icons.chevron_left,
//               color: Colors.white,
//             ),
//           ),
//         ],
//         backgroundColor: Colors.white,
//       ),
//       body: SafeArea(
//         child: Builder(builder: (BuildContext context) {
//           return WebView(
//             initialUrl: widget.url,
//             backgroundColor: Colors.white,
//             javascriptMode: JavascriptMode.unrestricted,
//             onWebViewCreated: (WebViewController webViewController) {
//               _controller.complete(webViewController);
//               _webViewController = webViewController;
//             },
//             navigationDelegate: (NavigationRequest request) {
//               print('allowing navigation to $request');
//               return NavigationDecision.navigate;
//             },
//             onPageStarted: (String url) {
//               print('Page started loading: $url');
//             },
//             onPageFinished: (String url) {
//               print('Page finished loading: $url');
//             },
//             gestureNavigationEnabled: true,
//           );
//         }),
//       ),
//     );
//   }
// }



// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/constants/custom_colors.dart';
import '../../utils/constants/styles.dart';

class WebviewPage extends StatefulWidget {
  WebviewPage({required this.title, this.url,this.paymentLink});
  final String? url;
  final String? title;
  final String? paymentLink;

  @override
  WebviewPageState createState() {
    return WebviewPageState();
  }
}

class WebviewPageState extends State<WebviewPage> {
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
      onPageStarted: (String url) {
              print('Page started loading: $url');
            },
         onPageFinished: (String url) {
              print('Page finished loading: $url');
            },
            onNavigationRequest: (NavigationRequest request) {
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
   )
    );
    
  }
  Widget build(BuildContext context) {
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: arrowBack,
        ),
        title: Center(
          child: Text(
            widget.title!,
            style: kAppBarTextStyle,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Builder(builder: (BuildContext context) {
          return WebViewWidget(
            controller: controller,
            // backgroundColor: Colors.white,
            // onWebViewCreated: (WebViewController webViewController) {
            //   _controller.complete(webViewController);
            //   _webViewController = webViewController;
            // },
           
          
         
            // gestureNavigationEnabled: true,
          );
        }),
      ),
    );
  }
}

