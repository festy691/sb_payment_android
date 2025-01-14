import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sb_payment_sdk/core/provider/payment_provider.dart';
import 'package:sb_payment_sdk/core/provider/result_provider.dart';
import 'package:sb_payment_sdk/core/utils/app_assets.dart';
import 'package:sb_payment_sdk/core/utils/page_router.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';
import 'package:sb_payment_sdk/core/utils/utils.dart';
import 'package:sb_payment_sdk/core/widget/background_widget.dart';
import 'package:sb_payment_sdk/core/widget/image_loader.dart';
import 'package:sb_payment_sdk/models/amount_breakdown_model.dart';
import 'package:sb_payment_sdk/models/api_response.dart';
import 'package:sb_payment_sdk/models/charge_model.dart';
import 'package:sb_payment_sdk/models/customer_detail_model.dart';
import 'package:sb_payment_sdk/models/paystack_detail_model.dart';
import 'package:sb_payment_sdk/models/transfer_detail_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaystackScreen extends StatefulWidget {
  static String routeName = "other-payments";
  CustomerDetailModel customerDetailModel;
  num amount;
  CurrencyType currency;
  PaystackScreen({
    super.key,
    required this.customerDetailModel,
    required this.amount,
    required this.currency,
  });

  @override
  State<PaystackScreen> createState() => _PaystackScreenState();
}

class _PaystackScreenState extends State<PaystackScreen> {
  bool isLoading = true;
  PaymentDetailModel? detailModel;

  final resultController = Get.find<ResultController>();

  late WebViewController controller;
  _initPayment() async {
    isLoading = true;
    if (mounted) setState(() {});
    detailModel = PaymentProvider.instance.paystackDetailModel;
    List<String> _suppoertedPayments = [];
    if (detailModel?.paymentMethods != null) {
      for (String p in detailModel!.paymentMethods!) {
        if (p != "bank_transfer" && p != "mobile_money") {
          _suppoertedPayments.add(p);
        }
      }
    }
    var result = await PaymentProvider.instance.initPaystack(
        payment: Payment(
            amount: widget.amount,
            email: widget.customerDetailModel.customerEmail,
            reference: widget.customerDetailModel.reference,
            currencyType: widget.currency,
            paymentMethods: _suppoertedPayments,
            customerName: widget.customerDetailModel.customerName));
    if (result.error) {
      isLoading = false;
      if (mounted) setState(() {});
      resultController.setResult(result);
      PageRouter.goBack(context);
      return;
    }
    var response = await PaymentProvider.instance
        .loadTransactionDetails(token: PaymentProvider().token!);
    if (response.error) {
      isLoading = false;
      if (mounted) setState(() {});
      resultController.setResult(response);
      PageRouter.goBack(context);
      return;
    }
    detailModel = PaymentProvider.instance.paystackDetailModel!;

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            log("Loading content ==========> $progress %");
            if (progress == 100) {
              isLoading = false;
              if (mounted) setState(() {});
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {
            isLoading = false;
            if (mounted) setState(() {});
            resultController.setResult(APIResponse(
                error: true, message: "Http server error!!!", data: null));

            PageRouter.goBack(context);
          },
          onWebResourceError: (WebResourceError error) {
            isLoading = false;
            if (mounted) setState(() {});
            resultController.setResult(APIResponse(
                error: true, message: error.description, data: null));

            PageRouter.goBack(context);
          },
          onNavigationRequest: (NavigationRequest request) {
            log(request.url);
            if (request.url.contains("https://sb.payment.com/success")) {
              showToast("Redirecting in 5 seconds");
              TransferDetailModel transferDetailModel =
                  PaymentProvider.instance.transferDetailModel!;
              var data = {
                "reference": transferDetailModel.reference,
                "amount": widget.amount,
                "email": widget.customerDetailModel.customerEmail,
                "currency": widget.currency.name,
                "bankName": transferDetailModel.bankName,
                "accountName": transferDetailModel.accountName,
                "accountNumber": transferDetailModel.accountNumber,
                "paymentStatus": "successful",
                "paymentType": "Bank transfer",
                "paymentDate": DateTime.now().toIso8601String()
              };

              Future.delayed(const Duration(seconds: 3)).then((_) {
                resultController.setResult(APIResponse(
                    error: false,
                    message: "Payment processing!!!",
                    data: data));

                PageRouter.goBack(context);
              });
              return NavigationDecision.prevent;
            } else if (request.url.contains("https://your-cancel-url.com")) {
              resultController.setResult(APIResponse(
                  error: true,
                  message: "The request was canceled!!!",
                  data: null));

              PageRouter.goBack(context);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(PaymentProvider.instance.url ?? ""));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPayment();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      shouldExit: true,
      onPopResult: (status, result) {
        if (resultController.resultCode.value == 0) {
          resultController.setResult(APIResponse(
              error: true, message: "The request was canceled!!!", data: null));
        }
      },
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: 1.sw,
              height: 1.sh,
              child: isLoading
                  ? Center(
                      child: ImageLoader(
                        path: AppAssets.sbLoaderGif,
                        width: 200.w,
                        height: 100.h,
                        fit: BoxFit.fitWidth,
                      ),
                    )
                  : WebViewWidget(
                      controller: controller,
                    ),
            ),
            Container(
              width: 1.sw,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      resultController.setResult(APIResponse(
                          error: true,
                          message: "Payment cancelled!!!",
                          data: null));

                      PageRouter.goBack(context);
                    },
                    child: Icon(
                      CupertinoIcons.clear_circled,
                      color: Pallet.buttonColor,
                      size: 32.w,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
