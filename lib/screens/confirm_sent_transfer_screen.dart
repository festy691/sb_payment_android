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
import 'package:sb_payment_sdk/core/utils/utils.dart';
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
import 'package:sb_payment_sdk/screens/paystack_screen.dart';
import 'package:sb_payment_sdk/screens/transaction_completed_screen.dart';
import 'package:sb_payment_sdk/screens/transfer_timeout_screen.dart';

typedef OnResponse = Function(APIResponse);

class ConfirmSentTransferScreen extends StatefulWidget {
  static String routeName = "confirm-transfer-payment";
  TransferDetailModel transferDetailModel;
  CustomerDetailModel customerDetailModel;
  AmountBreakdownModel? amountBreakdownModel;
  CurrencyType currencyType;
  OnRetry onRetry;
  ConfirmSentTransferScreen(
      {super.key,
      required this.transferDetailModel,
      required this.customerDetailModel,
      required this.amountBreakdownModel,
      required this.currencyType,
      required this.onRetry});

  @override
  State<ConfirmSentTransferScreen> createState() =>
      _ConfirmSentTransferScreenState();
}

class _ConfirmSentTransferScreenState extends State<ConfirmSentTransferScreen> {
  int countDownMinutes = 5;
  late Timer _timer = Timer(const Duration(seconds: 30), () {});

  late StreamController<dynamic> _streamController;
  late Dio _dio;
  final CancelToken cancelToken = CancelToken();

  final resultController = Get.find<ResultController>();

  PaymentDetailModel? detailModel;
  AmountBreakdownModel? amountBreakdownModel;

  void _startTimer() {
    DateTime _expireDate = DateTime.parse(
            PaymentProvider.instance.transferDetailModel?.expiryTime ?? "")
        .toLocal();
    int _secondsBetween = secondsBetween(DateTime.now(), _expireDate);

    countDownMinutes = _secondsBetween ~/ 60;
  }

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
            if (_timer.isActive) _timer.cancel();
            cancelToken.cancel('successful');
            var data = {
              "reference": widget.transferDetailModel.reference,
              "amount": widget.amountBreakdownModel?.total,
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

  Future<APIResponse> _verifyTransfer() async {
    if (mounted) setState(() {});
    var result = await PaymentProvider.instance.manualConfirmation(
        paymentCode: widget.transferDetailModel.reference ?? "");
    if (mounted) setState(() {});
    return result;
  }

  @override
  void initState() {
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
    _startTimer();
    _checkTransferStatus(
        transactionRef: widget.transferDetailModel.reference ?? "");
  }

  @override
  void dispose() {
    // Cancel the timer when the screen is disposed
    if (_timer.isActive) _timer.cancel();
    _streamController.close();
    super.dispose();
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
                    amountBreakdownModel: widget.amountBreakdownModel ??
                        AmountBreakdownModel(
                            total: detailModel?.amount ?? 0,
                            subtotal: detailModel?.amount ?? 0,
                            taxAndLevy: 0,
                            taxBreak: []),
                    showTax: detailModel?.isTaxed ?? false,
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  ImageLoader(
                    path: AppAssets.loaderLottie,
                    width: 100.w,
                    height: 30.h,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  TextView(
                    text: "We’re currently trying to confirm your transfer.",
                    textAlign: TextAlign.center,
                    textStyle: GoogleFonts.hankenGrotesk(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Pallet.textColorLight,
                      //decoration: TextDecoration.underline
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  CountdownTimer(
                    minutes: countDownMinutes,
                    seconds: 0,
                    message: "This may take a few minutes. Please wait for ",
                    onResendOtp: () async {
                      if (mounted) setState(() {});
                    },
                    onTimerEnd: () {
                      if (mounted) {
                        if (_timer.isActive) _timer.cancel();
                        _streamController.close();
                        PageRouter.gotoWidget(
                            TransferTimeoutScreen(
                              transferDetailModel: widget.transferDetailModel,
                              customerDetailModel: widget.customerDetailModel,
                              amountBreakdownModel:
                                  widget.amountBreakdownModel ??
                                      AmountBreakdownModel(
                                          total: detailModel?.amount ?? 0,
                                          subtotal: detailModel?.amount ?? 0,
                                          taxAndLevy: 0,
                                          taxBreak: []),
                              currencyType: widget.currencyType,
                              onRetry: () => widget.onRetry(),
                              onSwitchPayment: () {
                                PageRouter.goBack(context);
                                PageRouter.replacePage(
                                    context,
                                    PaystackScreen(
                                      customerDetailModel:
                                          widget.customerDetailModel,
                                      amount: amountBreakdownModel?.total ?? 0,
                                      currency: widget.currencyType,
                                    ));
                              },
                            ),
                            context);
                      }
                    },
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  CustomButtonWidget(
                    buttonText: 'Show account number',
                    buttonColor: Pallet.buttonColor,
                    fontSize: 12.sp,
                    height: 42.h,
                    width: 180.w,
                    onTap: () async {
                      PageRouter.goBack(context);
                    },
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () {
                      PageRouter.replacePage(
                          context,
                          PaystackScreen(
                            customerDetailModel: widget.customerDetailModel,
                            amount: amountBreakdownModel?.total ?? 0,
                            currency: widget.currencyType,
                          ));
                    },
                    child: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppAssets.changeOrange,
                            width: 16.w,
                            height: 16.h,
                            fit: BoxFit.fitWidth,
                          ),
                          SizedBox(width: 4.w),
                          TextView(
                            text: "Change payment methods",
                            textStyle: GoogleFonts.hankenGrotesk(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Pallet.buttonColor,
                              //decoration: TextDecoration.underline
                            ),
                          ),
                        ],
                      ),
                    ),
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
