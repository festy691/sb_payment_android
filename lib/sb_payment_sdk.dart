library sb_payment_sdk;

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sb_payment_sdk/card_payment_screen.dart';
import 'package:sb_payment_sdk/core/data/session_manager.dart';
import 'package:sb_payment_sdk/core/di/injection_container.dart';
import 'package:sb_payment_sdk/core/network/url_config.dart';
import 'package:sb_payment_sdk/core/provider/payment_provider.dart';
import 'package:sb_payment_sdk/core/utils/app_assets.dart';
import 'package:sb_payment_sdk/core/utils/app_flush_bar.dart';
import 'package:sb_payment_sdk/core/utils/app_theme.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';
import 'package:sb_payment_sdk/core/utils/utils.dart';
import 'package:sb_payment_sdk/core/utils/validators.dart';
import 'package:sb_payment_sdk/core/widget/custom_button.dart';
import 'package:sb_payment_sdk/core/widget/dialog.dart';
import 'package:sb_payment_sdk/core/widget/edit_form_widget.dart';
import 'package:sb_payment_sdk/core/widget/text_views.dart';
import 'package:sb_payment_sdk/models/api_response.dart';
import 'package:sb_payment_sdk/models/bank_account_model.dart';
import 'package:sb_payment_sdk/models/charge_model.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:sb_payment_sdk/models/paystack_detail_model.dart';
import 'package:sb_payment_sdk/models/transfer_detail_model.dart';

enum CurrencyType { NGN, USD, GHS, ZAR, KES }

typedef OnPaymentSuccessful = Function(String);
typedef OnPaymentFailed = Function(String);

class StartButtonPlugin {
  bool _sdkInitialized = false;
  String _publicKey = "";
  List<BankAccountModel> _bankList = [];

  /// Initialize the Payment object. It should be called as early as possible
  /// (preferably in initState() of the Widget.
  ///
  /// [publicKey] - your startbutton public key. This is mandatory

  initialize({required String publicKey, bool isLive = false}) async {
    //initialize singletons
    await init(
        environment:
            //kReleaseMode ? Environment.production : Environment.production);
            isLive ? Environment.production : Environment.staging);

    assert(() {
      if (publicKey.isEmpty) {
        throw APIResponse(
            error: true, message: 'publicKey cannot be null or empty');
      }
      return true;
    }());

    if (sdkInitialized) return;

    this._publicKey = publicKey;

    SessionManager.instance.authToken = publicKey;
    _sdkInitialized = true;
  }

  dispose() {
    _publicKey = "";
    _sdkInitialized = false;
  }

  bool get sdkInitialized => _sdkInitialized;

  String get publicKey {
    // Validate that the sdk has been initialized
    _validateSdkInitialized();
    return _publicKey;
  }

  APIResponse _performChecks() {
    //validate that sdk has been initialized
    String? error = _validateSdkInitialized();
    if (error != null) return APIResponse(error: true, message: error);
    //check for null value, and length and starts with sb_
    if (_publicKey.isEmpty || !_publicKey.startsWith("sb_")) {
      return APIResponse(
          error: true,
          message:
              "Invalid public key. You must use a valid public key. Ensure that you have set a public key.");
    }
    return APIResponse(error: false, message: "Check completed");
  }

  /// Make payment by charging the user's card
  ///
  /// [context] - the widgets BuildContext
  ///
  /// [charge] - the charge object.

  Future<APIResponse> makePayment(BuildContext context,
      {required Payment charge}) async {
    APIResponse _checkResponse = _performChecks();
    if (_checkResponse.error) return _checkResponse;

    APIResponse _response = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => _StartButtonPayment(
              email: charge.email,
              amount: charge.amount / 100,
              currencyType: charge.currencyType,
              bankList: _bankList,
              reference: charge.reference ??
                  "SBC-${DateTime.now().microsecondsSinceEpoch}",
              onPaymentSuccessful: (String paymentRef) {
                return APIResponse(
                    error: false, message: "Payment processing", data: charge);
              },
              onPaymentFailed: (String message) {
                return APIResponse(error: true, message: message, data: charge);
              },
            )));

    return _response;
  }

  /// Make payment using StartButton's checkout form. The plugin will handle the whole
  /// processes involved.
  ///
  /// [context] - the widget's BuildContext
  ///
  /// [charge] - the charge object.
  ///
  /// Notes:
  ///
  /// [hideEmail] - Whether to hide the email from the user. When
  /// `false` and an email is passed to the [charge] object, the email
  /// will be displayed at the top right edge of the UI prompt. Defaults to
  /// `false`
  ///
  /// [hideAmount]  - Whether to hide the amount from the  payment prompt.
  /// When `false` the payment amount and currency is displayed at the
  /// top of payment prompt, just under the email. Also the payment
  /// call-to-action will display the amount, otherwise it will display
  /// "Continue". Defaults to `false`
  ///
  ///
  String? _validateSdkInitialized() {
    if (!sdkInitialized) {
      return 'StartButton SDK has not been initialized. The SDK has'
          ' to be initialized before use';
    }
    return null;
  }
}

class _StartButtonPayment extends StatefulWidget {
  CurrencyType? currencyType;
  num amount;
  String email;
  String reference;
  List<BankAccountModel> bankList;
  OnPaymentSuccessful onPaymentSuccessful;
  OnPaymentFailed onPaymentFailed;
  _StartButtonPayment(
      {Key? key,
      this.currencyType,
      required this.bankList,
      required this.reference,
      required this.amount,
      required this.email,
      required this.onPaymentSuccessful,
      required this.onPaymentFailed})
      : super(key: key);

  @override
  State<_StartButtonPayment> createState() => _StartButtonPaymentState();
}

class _StartButtonPaymentState extends State<_StartButtonPayment> {
  int _totalSeconds =
      1800; // Initial countdown time in seconds (90 seconds = 1 minute and 30 seconds)
  late Timer _timer = Timer(const Duration(seconds: 30), () {});
  List<BankAccountModel> _bankList = [];
  late String email;
  late num subTotal;
  late num tax;
  late num amount;
  late String currency;

  TextEditingController cardnumber = TextEditingController();
  TextEditingController expiryDate = TextEditingController();
  TextEditingController cvv = TextEditingController();

  bool isBank = true;
  bool disableBank = false;

  final plugin = PaystackPlugin();

  late StreamController<dynamic> _streamController;
  late Dio _dio;
  final CancelToken cancelToken = CancelToken();

  _initTransfer() async {
    if (mounted) setState(() {});
    var result = await PaymentProvider.instance.initTransfer(
        payment: Payment(
            amount: widget.amount,
            email: widget.email,
            reference: widget.reference,
            currencyType: widget.currencyType ?? CurrencyType.NGN));
    if (mounted) setState(() {});
    if (!result.error) {
      // Start the countdown timer when the screen is initialized
      _startTimer();

      await Future.delayed(const Duration(seconds: 5));
      _checkTransferStatus(
          transactionRef:
              PaymentProvider.instance.transferDetailModel?.reference);
    } else {
      Navigator.of(context)
          .pop(APIResponse(error: true, message: result.message));
    }
  }

  Future<APIResponse> _verifyTransfer() async {
    if (mounted) setState(() {});
    var result = await PaymentProvider.instance.manualConfirmation(
        paymentCode: PaymentProvider.instance.transferDetailModel?.reference);
    if (mounted) setState(() {});
    return result;
  }

  _initPaystack() async {
    if (mounted) setState(() {});
    var result = await PaymentProvider.instance.initPaystack(
        payment: Payment(
            amount: widget.amount,
            email: widget.email,
            reference: widget.reference,
            currencyType: widget.currencyType ?? CurrencyType.NGN));
    if (mounted) setState(() {});
    if (result.error) {
      if (mounted) setState(() {});
      Navigator.of(context)
          .pop(APIResponse(error: true, message: result.message));
      return;
    }
    var response = await PaymentProvider.instance
        .decodePaystack(token: PaymentProvider().token!);
    if (mounted) setState(() {});
    if (response.error)
      Navigator.of(context)
          .pop(APIResponse(error: true, message: response.message));

    PaystackDetailModel paymentModel =
        PaymentProvider.instance.paystackDetailModel!;

    plugin.initialize(publicKey: paymentModel.publicKey);

    /*log("URL===================>>>>>>>>>>>>>>>>> ${PaymentProvider.instance.url}");
    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> CardPaymentScreen(paymentUrl: PaymentProvider.instance.url!, paymentModel: paymentModel,
      onPaymentSuccessful: (paymentRef){
        var data = {
          "reference": paymentModel.transactionRef,
          "amount": paymentModel.amount,
          "email": paymentModel.customerEmail,
          "currency": paymentModel.currency,
          "bankName": "",
          "accountName": "",
          "accountNumber": "",
          "paymentStatus": "successful",
          "paymentType": "Paystack",
          "paymentDate": DateTime.now().toIso8601String()
        };
        Navigator.of(context).pop(APIResponse(error: false, message: "Payment successful", data: data));
        widget.onPaymentSuccessful(paymentRef);
      },
      onPaymentFailed: (msg){
        Navigator.of(context).pop(APIResponse(error: true, message: result.message));
        return;
      }))
    );*/
  }

  _init() {
    if (isBank) {
      _initTransfer();
    } else {
      _initPaystack();
    }
  }

  Future<void> _checkTransferStatus({required String transactionRef}) async {
    final url =
        '${UrlConfig.coreBaseUrl}${UrlConfig.listenForStream}?txnRef=$transactionRef'; // Replace with your API endpoint
    try {
      //log("Listening to stream =================>>>>>>>>>> $url");
      final response = await _dio.get(
        url,
        cancelToken: cancelToken,
        options: Options(responseType: ResponseType.stream),
      );

      response.data!.stream.listen(
        (data) {
          // Assuming data is utf-8 encoded JSON string
          final decodedData = utf8.decode(data);
          final jsonData = json.decode(decodedData.split("data: ").last);
          if (jsonData["status"] == "successful" ||
              jsonData["status"] == "verified") {
            _streamController.close();
            if (_timer.isActive) _timer.cancel();
            cancelToken.cancel('successful');
            var data = {
              "reference":
                  PaymentProvider.instance.transferDetailModel?.reference,
              "amount": amount,
              "email": email,
              "currency": widget.currencyType?.name ?? CurrencyType.NGN.name,
              "bankName":
                  PaymentProvider.instance.transferDetailModel?.bankName,
              "accountName":
                  PaymentProvider.instance.transferDetailModel?.accountName,
              "accountNumber":
                  PaymentProvider.instance.transferDetailModel?.accountNumber,
              "paymentStatus": "successful",
              "paymentType": "Bank transfer",
              "paymentDate": DateTime.now().toIso8601String()
            };
            _streamController.close();
            AppDialog.showSuccessDialog(context, onContinue: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(APIResponse(
                  error: false, message: "Transaction processing", data: data));
              widget.onPaymentSuccessful(data["reference"]);
            });
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
    super.initState();

    if (widget.amount < 2500) {
      isBank = false;
      disableBank = true;
    }

    if (widget.currencyType?.name != CurrencyType.NGN.name) {
      disableBank = true;
      isBank = false;
    }

    _streamController = StreamController<dynamic>();
    _dio = Dio();

    _init();

    email = widget.email;
    subTotal = widget.amount;
    tax = 0; //widget.amount * 0.10;
    amount = subTotal + tax;
    currency = widget.currencyType != null
        ? widget.currencyType!.name
        : CurrencyType.NGN.name;
    _bankList = widget.bankList;
  }

  @override
  void dispose() {
    // Cancel the timer when the screen is disposed
    if (_timer.isActive) _timer.cancel();
    _streamController.close();
    super.dispose();
  }

  _switchPaymentMethod() {
    isBank = !isBank;
    if (mounted) {
      setState(() {});
    }
    if (isBank) {
      _totalSeconds = 1800;
      //_startTimer();
    } else {
      if (_timer.isActive) _timer.cancel();
    }
    _init();
  }

  void _startTimer() {
    // Create a countdown timer that runs every second

    log(PaymentProvider.instance.transferDetailModel?.expiryTime);
    DateTime _expireDate =
        DateTime.parse(PaymentProvider.instance.transferDetailModel?.expiryTime)
            .toLocal();
    int _secondsBetween = secondsBetween(DateTime.now(), _expireDate);

    _totalSeconds = _secondsBetween;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Update the remaining time
      if (_totalSeconds > 0) {
        _totalSeconds--;
      } else {
        // If the countdown reaches zero, cancel the timer
        _timer.cancel();
        AppDialog.showAccountExpiredDialog(context, onContinue: () {
          Navigator.of(context).pop();
          _switchPaymentMethod();
        });
      }
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _totalSeconds ~/ 60; // Calculate total minutes
    int seconds = _totalSeconds % 60; // Calculate remaining seconds

    TransferDetailModel? transferDetail =
        PaymentProvider.instance.transferDetailModel;
    PaystackDetailModel? paystackDetail =
        PaymentProvider.instance.paystackDetailModel;

    return ScreenUtilInit(
      designSize: const Size(414, 896),
      builder: (context, child) => Scaffold(
        body: SafeArea(
          child: PaymentProvider.instance.initializing
              ? Center(
                  child: CupertinoActivityIndicator(
                    radius: 18.r,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 20.h),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.r)),
                            border: Border.all(
                                color: Pallet.grey.withOpacity(0.5),
                                width: 0.5),
                          ),
                          child: ListView(
                            children: [
                              Row(
                                children: [
                                  TextView(
                                    text:
                                        isBank ? "Bank transfer" : "Debit card",
                                    textStyle: titleStyle.copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(width: 4.w),
                                  if (!disableBank)
                                    GestureDetector(
                                      onTap: () {
                                        _switchPaymentMethod();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 8.h),
                                        decoration: BoxDecoration(
                                          color: Pallet.dividerColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.r)),
                                        ),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              AppAssets.changeGrey,
                                              width: 16.w,
                                              height: 16.h,
                                              fit: BoxFit.fitWidth,
                                            ),
                                            SizedBox(width: 4.w),
                                            TextView(
                                              text: "Change",
                                              textStyle: titleStyle.copyWith(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  const Spacer(),
                                  IconButton(
                                    icon: Icon(
                                      CupertinoIcons.clear_circled,
                                      size: 24.w,
                                      color: Pallet.grey,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop(APIResponse(
                                          error: true,
                                          message: "Transaction canceled"));
                                      widget.onPaymentFailed(
                                          "Transaction canceled");
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextView(
                                    text: "FROM:",
                                    textStyle: titleStyle.copyWith(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  TextView(
                                    text: email,
                                    textStyle: titleStyle.copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.h),
                              Divider(
                                color: Pallet.grey.withOpacity(0.5),
                                height: 0.5,
                                thickness: 0.5,
                              ),
                              SizedBox(height: 26.h),
                              Center(
                                  child: TextView(
                                text: "TOTAL TO BE PAID",
                                textStyle: titleStyle.copyWith(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600),
                              )),
                              SizedBox(height: 8.h),
                              Center(
                                  child: TextView(
                                text: formatMoney(
                                    isBank ? amount : paystackDetail?.amount,
                                    decimalDigits: 2,
                                    name: currency),
                                textStyle: title3Style.copyWith(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "sans"),
                              )),
                              SizedBox(height: 32.h),
                              if (isBank) ...[
                                Container(
                                  width: 1.sw,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.r)),
                                    border: Border.all(color: Pallet.orange),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 8.w),
                                      Image.asset(
                                        AppAssets.warning,
                                        width: 28.w,
                                        height: 28.h,
                                        fit: BoxFit.fitWidth,
                                      ),
                                      SizedBox(width: 8.w),
                                      TextView(
                                        text:
                                            "Ensure you send the EXACT amount indicated!",
                                        textStyle: titleStyle.copyWith(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Pallet.orange),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Pallet.dividerColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.r)),
                                    border: Border.all(
                                        color: Pallet.grey.withOpacity(0.5),
                                        width: 0.5),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w, vertical: 20.h),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: TextView(
                                              text:
                                                  "Please transfer to the account provided below, make sure to use the Narration given below.",
                                              textStyle: titleStyle.copyWith(
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w400),
                                            )),

                                            //const Spacer(),

                                            /*TextView(text: "Change bank", textStyle: titleStyle.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w600, color: Pallet.orangeDark, decoration: TextDecoration.underline, letterSpacing: 0.8),),

                                      Image.asset(
                                        AppAssets.arrowDown,
                                        width: 14.w,
                                        height: 14.h,
                                        fit: BoxFit.fitHeight,
                                      ),*/
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: Pallet.grey.withOpacity(0.5),
                                        height: 0.5,
                                        thickness: 0.5,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w, vertical: 20.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextView(
                                                  text: "ACCOUNT NAME",
                                                  textStyle:
                                                      titleStyle.copyWith(
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                                SizedBox(height: 8.h),
                                                TextView(
                                                  text:
                                                      "${transferDetail?.accountName}",
                                                  textStyle:
                                                      titleStyle.copyWith(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextView(
                                                  text: "ACCOUNT NUMBER",
                                                  textStyle:
                                                      titleStyle.copyWith(
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                                SizedBox(height: 8.h),
                                                Row(
                                                  children: [
                                                    TextView(
                                                      text:
                                                          "${transferDetail?.accountNumber}",
                                                      textStyle:
                                                          titleStyle.copyWith(
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Clipboard.setData(
                                                            ClipboardData(
                                                                text:
                                                                    "${transferDetail?.accountNumber}"));
                                                        AppFlushBar.showInfo(
                                                            context: context,
                                                            message:
                                                                "Account number copied");
                                                      },
                                                      child: Image.asset(
                                                        AppAssets.copy,
                                                        width: 16.w,
                                                        height: 16.h,
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 20.w,
                                                  ),
                                                  child: TextView(
                                                    text: "BANK NAME",
                                                    textStyle:
                                                        titleStyle.copyWith(
                                                            fontSize: 10.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  ),
                                                ),
                                                SizedBox(height: 8.h),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 20.w,
                                                  ),
                                                  child: TextView(
                                                    text:
                                                        "${transferDetail?.bankName}",
                                                    textStyle:
                                                        titleStyle.copyWith(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 20.w,
                                                ),
                                                child: TextView(
                                                  text: "NARRATION",
                                                  textStyle:
                                                      titleStyle.copyWith(
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                              ),
                                              SizedBox(height: 8.h),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 20.w,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    TextView(
                                                      text:
                                                          "${PaymentProvider.instance.transferDetailModel?.reference}",
                                                      textStyle:
                                                          titleStyle.copyWith(
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Clipboard.setData(
                                                            ClipboardData(
                                                                text:
                                                                    "${PaymentProvider.instance.transferDetailModel?.reference}"));
                                                        AppFlushBar.showInfo(
                                                            context: context,
                                                            message:
                                                                "Transaction reference copied");
                                                      },
                                                      child: Image.asset(
                                                        AppAssets.copy,
                                                        width: 16.w,
                                                        height: 16.h,
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20.h),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Center(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                            text: 'This account will '),
                                        TextSpan(
                                          text: 'Expire',
                                          style: titleStyle.copyWith(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        const TextSpan(text: ' in'),
                                        TextSpan(
                                          text:
                                              " $minutes:${seconds.toString().padLeft(2, '0')}",
                                          style: titleStyle.copyWith(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w700,
                                              color: Pallet.orangeDark),
                                        ),
                                      ],
                                    ),
                                    style: titleStyle.copyWith(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                SizedBox(height: 32.h),
                                CustomButtonWidget(
                                  buttonText: 'I’ve sent the money',
                                  buttonColor: Pallet.orangeDark,
                                  fontSize: 18.sp,
                                  loading: PaymentProvider.instance.loading,
                                  onTap: () async {
                                    var result = await _verifyTransfer();
                                    if (result.error ||
                                        (result.data["status"] != "verified" &&
                                            result.data["status"] !=
                                                "successful"))
                                      return AppFlushBar.showError(
                                          context: context,
                                          message: result.message);
                                    var data = {
                                      "reference": PaymentProvider.instance
                                          .transferDetailModel?.reference,
                                      "amount": amount,
                                      "email": email,
                                      "currency": widget.currencyType?.name ??
                                          CurrencyType.NGN.name,
                                      "bankName": PaymentProvider.instance
                                          .transferDetailModel?.bankName,
                                      "accountName": PaymentProvider.instance
                                          .transferDetailModel?.accountName,
                                      "accountNumber": PaymentProvider.instance
                                          .transferDetailModel?.accountNumber,
                                      "paymentStatus": "successful",
                                      "paymentType": "Bank transfer",
                                      "paymentDate":
                                          DateTime.now().toIso8601String()
                                    };
                                    AppDialog.showSuccessDialog(context,
                                        onContinue: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop(APIResponse(
                                          error: false,
                                          message: "Payment successful",
                                          data: data));
                                      widget.onPaymentSuccessful(
                                          data["reference"]);
                                    });
                                  },
                                ),
                                SizedBox(height: 16.h),
                                GestureDetector(
                                  onTap: () {
                                    _switchPaymentMethod();
                                  },
                                  child: SizedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          AppAssets.changeOrange,
                                          width: 16.w,
                                          height: 16.h,
                                          fit: BoxFit.fitWidth,
                                        ),
                                        SizedBox(width: 4.w),
                                        TextView(
                                          text: "Change payment method",
                                          textStyle: titleStyle.copyWith(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Pallet.orangeDark,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              if (!isBank) ...[
                                EditFormField(
                                  isFilled: true,
                                  fillColor: Pallet.white,
                                  label: "Card Number",
                                  isHeader: true,
                                  hint: "1234 1234 1234 1234",
                                  maxLength: 30,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    String formattedString =
                                        formatCardnumber(value);
                                    if (value != formattedString) {
                                      cardnumber.value =
                                          cardnumber.value.copyWith(
                                        text: formattedString,
                                        selection: TextSelection.collapsed(
                                            offset: formattedString.length),
                                      );
                                    }
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  },
                                  controller: cardnumber,
                                  hasShadow: true,
                                ),
                                SizedBox(
                                  height: 18.h,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: EditFormField(
                                        isFilled: true,
                                        fillColor: Pallet.white,
                                        label: "Expiry",
                                        isHeader: true,
                                        hint: "MM/YY",
                                        maxLength: 5,
                                        controller: expiryDate,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          String formattedString =
                                              formatExpirydate(value);
                                          if (value != formattedString) {
                                            expiryDate.value = expiryDate.value
                                                .copyWith(
                                                    text: formattedString,
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset:
                                                                formattedString
                                                                    .length));
                                          }
                                          if (mounted) {
                                            setState(() {});
                                          }
                                        },
                                        hasShadow: true,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Expanded(
                                      child: EditFormField(
                                        isFilled: true,
                                        fillColor: Pallet.white,
                                        label: "CVV",
                                        isHeader: true,
                                        hint: "CVV",
                                        maxLength: 3,
                                        keyboardType: TextInputType.number,
                                        onChanged: (text) {
                                          if (mounted) {
                                            setState(() {});
                                          }
                                        },
                                        controller: cvv,
                                        hasShadow: true,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 32.h,
                                ),
                                CustomButtonWidget(
                                  buttonText: 'Pay with card',
                                  buttonColor: Pallet.orangeDark,
                                  fontSize: 18.sp,
                                  disabled: !validateCard(),
                                  onTap: () async {
                                    Charge charge = Charge();
                                    charge.card =
                                        PaymentProvider.instance.cardInfo(
                                      cardnumber: cardnumber.text
                                          .replaceAll(RegExp(r'\s'), ""),
                                      cvv: cvv.text,
                                      expiryMonth: int.tryParse(
                                        expiryDate.text.split("/")[0],
                                      )!,
                                      expiryYear: int.tryParse(
                                        expiryDate.text.split("/")[1],
                                      )!,
                                      //cardname: cardName.text
                                    );

                                    charge.amount =
                                        (paystackDetail?.amount * 100).ceil();
                                    charge.email = email;
                                    charge.currency = currency;
                                    charge.reference =
                                        paystackDetail?.transactionRef;
                                    final response = await plugin.checkout(
                                      context,
                                      method: CheckoutMethod
                                          .card, // Defaults to CheckoutMethod.selectable
                                      charge: charge,
                                      logo: Image.asset(
                                        AppAssets.icon,
                                        width: 24.w,
                                        height: 24.h,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    );
                                    if (!response.status) {
                                      Navigator.of(context).pop(APIResponse(
                                          error: true,
                                          message: response.message));
                                      return widget
                                          .onPaymentFailed(response.message);
                                    }

                                    final reference = response.reference!;

                                    var data = {
                                      "reference": reference,
                                      "amount": paystackDetail?.amount,
                                      "email": email,
                                      "currency": widget.currencyType?.name ??
                                          CurrencyType.NGN.name,
                                      "bankName": "",
                                      "accountName": "",
                                      "accountNumber": "",
                                      "paymentStatus": "successful",
                                      "paymentType": "Paystack",
                                      "paymentDate":
                                          DateTime.now().toIso8601String()
                                    };

                                    AppDialog.showSuccessDialog(context,
                                        onContinue: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop(APIResponse(
                                          error: false,
                                          message: "Payment successful",
                                          data: data));
                                      widget.onPaymentSuccessful(reference);
                                    });
                                  },
                                ),
                                SizedBox(height: 16.h),
                                if (!disableBank)
                                  GestureDetector(
                                    onTap: () {
                                      _switchPaymentMethod();
                                    },
                                    child: SizedBox(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            AppAssets.changeOrange,
                                            width: 16.w,
                                            height: 16.h,
                                            fit: BoxFit.fitWidth,
                                          ),
                                          SizedBox(width: 4.w),
                                          TextView(
                                            text: "Change payment method",
                                            textStyle: titleStyle.copyWith(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Pallet.orangeDark,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppAssets.lock,
                          width: 12.w,
                          height: 12.h,
                          fit: BoxFit.fitHeight,
                        ),
                        SizedBox(width: 4.w),
                        TextView(
                          text: "Powered by",
                          textStyle: titleStyle.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: Pallet.warning.shade700.withOpacity(0.2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.r)),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                AppAssets.icon,
                                width: 12.w,
                                height: 12.h,
                                fit: BoxFit.fitWidth,
                              ),
                              SizedBox(width: 4.w),
                              TextView(
                                text: "Startbutton",
                                textStyle: title3Style.copyWith(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.8),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
        ),
      ),
    );
  }

  bool validateCard() {
    //if(cardName.text.isEmpty) return false;
    if (cardnumber.text.isEmpty) return false;
    if (expiryDate.text.isEmpty) return false;
    if (cvv.text.isEmpty) return false;
    if (expiryDate.text.split("/").length < 2) return false;
    return PaymentProvider.instance
        .cardInfo(
          cardnumber: cardnumber.text.replaceAll(RegExp(r'\s'), ""),
          cvv: cvv.text,
          expiryMonth: int.tryParse(
            expiryDate.text.split("/")[0],
          )!,
          expiryYear: int.tryParse(
            expiryDate.text.split("/")[1],
          )!,
          //cardname: cardName.text
        )
        .isValid();
  }
}
