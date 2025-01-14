import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sb_payment_sdk/core/utils/app_theme.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';
import 'package:sb_payment_sdk/core/widget/dialog.dart';
import 'package:sb_payment_sdk/core/widget/text_views.dart';
import 'package:sb_payment_sdk/models/api_response.dart';
import 'package:sb_payment_sdk/models/paystack_detail_model.dart';
import 'package:sb_payment_sdk/sb_payment_sdk.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CardPaymentScreen extends StatefulWidget {
  OnPaymentSuccessful onPaymentSuccessful;
  OnPaymentFailed onPaymentFailed;
  String paymentUrl;
  PaystackDetailModel paymentModel;
  CardPaymentScreen({super.key, required this.paymentUrl, required this.paymentModel, required this.onPaymentSuccessful, required this.onPaymentFailed});

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  bool isLoading = true;

  late WebViewController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: WebView(
                initialUrl: widget.paymentUrl,
                javascriptMode: JavascriptMode.unrestricted,
                gestureNavigationEnabled: true,
                //userAgent: 'Flutter;Webview',
                // Enable mixed content
                initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
                // Enable mixed content
                userAgent: 'Mozilla/5.0 (Linux; Android 6.0; AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.150 Safari/537.36',
                onWebViewCreated: (WebViewController webViewController) async {
                  _controller = webViewController;
                },
                onPageFinished: (finish) {
                  log("Finished loading=====================>$finish");
                  isLoading = false;
                  if(mounted)setState(() {});
                },
                navigationDelegate: (navigation) {
                  //Listen for callback URL
                  log("Navigation url=====================>${navigation.url}");

                  if (navigation.url.contains("https://www.codesloopz.com/")) {
                    AppDialog.showSuccessDialog(context, onContinue: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      widget.onPaymentSuccessful(widget.paymentModel.transactionRef);
                    });
                  }
                  if (navigation.url.contains("https://www.google.com/")) {
                    Navigator.of(context).pop(APIResponse(error: true, message: "Payment failed!!!"));
                    widget.onPaymentFailed("Payment failed!!!");
                  }

                  return NavigationDecision.navigate;
                },
              ),
            ),

            if(isLoading) Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(child: CupertinoActivityIndicator(radius: 18.r,),),
            ),
          ],
        ),
      ),
    );
  }
}