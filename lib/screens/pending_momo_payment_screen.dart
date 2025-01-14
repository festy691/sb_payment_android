import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sb_payment_sdk/core/network/url_config.dart';
import 'package:sb_payment_sdk/core/provider/payment_provider.dart';
import 'package:sb_payment_sdk/core/provider/result_provider.dart';
import 'package:sb_payment_sdk/core/utils/app_assets.dart';
import 'package:sb_payment_sdk/core/utils/page_router.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';
import 'package:sb_payment_sdk/core/widget/background_widget.dart';
import 'package:sb_payment_sdk/core/widget/countdown_timer.dart';
import 'package:sb_payment_sdk/core/widget/custom_button.dart';
import 'package:sb_payment_sdk/core/widget/footer_widget.dart';
import 'package:sb_payment_sdk/core/widget/header_widget.dart';
import 'package:sb_payment_sdk/core/widget/image_loader.dart';
import 'package:sb_payment_sdk/core/widget/tax_break_down_widget.dart';
import 'package:sb_payment_sdk/core/widget/text_views.dart';
import 'package:sb_payment_sdk/models/amount_breakdown_model.dart';
import 'package:sb_payment_sdk/models/api_response.dart';
import 'package:sb_payment_sdk/models/charge_model.dart';
import 'package:sb_payment_sdk/models/customer_detail_model.dart';
import 'package:sb_payment_sdk/models/paystack_detail_model.dart';
import 'package:sb_payment_sdk/models/transfer_detail_model.dart';
import 'package:sb_payment_sdk/screens/transaction_completed_screen.dart';

class PendingMomoPaymentScreen extends StatefulWidget {
  static String routeName = "pending-momo-payment";
  TransferDetailModel transferDetailModel;
  CustomerDetailModel customerDetailModel;
  CurrencyType currencyType;
  num amount;
  PendingMomoPaymentScreen({
    super.key,
    required this.transferDetailModel,
    required this.customerDetailModel,
    required this.currencyType,
    required this.amount,
  });

  @override
  State<PendingMomoPaymentScreen> createState() =>
      _PendingMomoPaymentScreenState();
}

class _PendingMomoPaymentScreenState extends State<PendingMomoPaymentScreen> {
  int countDownMinutes = 10;
  int countDownSeconds = 0;
  PaymentDetailModel? detailModel;
  AmountBreakdownModel? amountBreakdownModel;

  late StreamController<dynamic> _streamController;
  late Dio _dio;
  final CancelToken cancelToken = CancelToken();

  final resultController = Get.find<ResultController>();

  Future<void> _checkTransferStatus({required String transactionRef}) async {
    final url =
        '${UrlConfig.coreBaseUrl}${UrlConfig.listenForStream}?txnRef=$transactionRef'; // Replace with your API endpoint
    try {
      final response = await _dio.get(
        url,
        cancelToken: cancelToken,
        options: Options(responseType: ResponseType.stream),
      );

      response.data!.stream.listen(
        (data) {
          // Assuming data is utf-8 encoded JSON string
          final decodedData = utf8.decode(data);
          log(decodedData.split("data: ").last);
          final jsonData = json.decode((decodedData.split("data: ").last));
          if (jsonData["status"] == "successful" ||
              jsonData["status"] == "verified") {
            _streamController.close();
            cancelToken.cancel('successful');
            var data = {
              "reference": widget.transferDetailModel.reference,
              "amount": widget.amount,
              "email": widget.customerDetailModel.customerEmail,
              "currency": widget.currencyType,
              "bankName": widget.transferDetailModel.bankName,
              "accountName": widget.transferDetailModel.accountName,
              "accountNumber": widget.transferDetailModel.accountNumber,
              "paymentStatus": "successful",
              "paymentType": "Bank transfer",
              "paymentDate": DateTime.now().toIso8601String()
            };
            _streamController.close();
            String paymentRef = widget.transferDetailModel.reference ?? "";
            PageRouter.replacePage(
              context,
              TransactionCompletedScreen(
                paymentReference: paymentRef,
                response: APIResponse(
                    error: false, message: "Payment processing!!!", data: data),
              ),
            );
          }
        },
        onDone: () {
          if (!_streamController.isClosed) _streamController.close();
        },
        onError: (error) {
          log('Error: $error');
          if (!_streamController.isClosed) _streamController.addError(error);
        },
        cancelOnError: true, // Cancel the stream on error
      );
    } catch (error) {
      log('Error: $error');
      if (!_streamController.isClosed) _streamController.addError(error);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    detailModel = PaymentProvider.instance.paystackDetailModel;
    amountBreakdownModel = PaymentProvider.instance.amountBreakdownModel ??
        AmountBreakdownModel(
            total: detailModel?.amount ?? 0,
            subtotal: detailModel?.amount ?? 0,
            taxAndLevy: 0,
            taxBreak: []);
    _streamController = StreamController<dynamic>();
    _dio = Dio();
    _checkTransferStatus(
        transactionRef: widget.transferDetailModel.reference ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      hasPadding: true,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          children: [
            HeaderWidget(
              logo: detailModel
                  ?.merchantLogo, //widget.customerDetailModel.businessLogo,
              businessEmail: detailModel?.merchantEmail ??
                  "", //widget.customerDetailModel.businessEmail,
              businessName: detailModel?.merchantName ??
                  "", //widget.customerDetailModel.businessName,
              child: Column(
                children: [
                  TaxBreakDownWidget(
                    currency: widget.currencyType.name,
                    amountBreakdownModel: amountBreakdownModel!,
                    showTax: detailModel?.isTaxed ?? false,
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  ImageLoader(
                    path: AppAssets.timer,
                    width: 36.w,
                    height: 36.w,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  CountdownTimer(
                    minutes: countDownMinutes,
                    seconds: countDownSeconds,
                    message: "",
                    fontSize: 14,
                    onResendOtp: () async {
                      if (mounted) setState(() {});
                    },
                    onTimerEnd: () {},
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  TextView(
                    text:
                        "Please check your mobile phone and enter your pin to authorize this transaction.",
                    textAlign: TextAlign.center,
                    textStyle: GoogleFonts.hankenGrotesk(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Pallet.textColorLight,
                      //decoration: TextDecoration.underline
                    ),
                  ),
                  SizedBox(
                    height: 48.h,
                  ),
                  CustomOutlinedButtonWidget(
                    buttonText: 'Cancel',
                    buttonColor: Pallet.buttonColor,
                    borderColor: Pallet.buttonColor,
                    buttonTextColor: Pallet.buttonColor,
                    radius: 4.r,
                    fontSize: 12.sp,
                    height: 42.h,
                    width: 130.w,
                    onTap: () async {
                      PageRouter.goBack(context);
                    },
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24.h,
            ),
            FooterWidget(
              businessName: detailModel?.merchantName ??
                  "", //widget.customerDetailModel.businessName,
            )
          ],
        ),
      ),
    );
  }
}
