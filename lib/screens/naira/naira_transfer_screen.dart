import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:sb_payment_sdk/screens/confirm_sent_transfer_screen.dart';
import 'package:sb_payment_sdk/screens/paystack_screen.dart';
import 'package:sb_payment_sdk/screens/transfer_timeout_screen.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class NairaTransferScreen extends StatefulWidget {
  num amount;
  CustomerDetailModel customerDetailModel;

  NairaTransferScreen({
    super.key,
    required this.amount,
    required this.customerDetailModel,
  });

  @override
  State<NairaTransferScreen> createState() => _NairaTransferScreenState();
}

class _NairaTransferScreenState extends State<NairaTransferScreen>
    with RouteAware {
  late AmountBreakdownModel amountBreakdownModel;
  PaymentDetailModel? detailModel;
  int countDownMinutes = 5;
  final resultController = Get.find<ResultController>();

  bool isBank = true;
  bool disableBank = false;

  Key _widgetKey = UniqueKey();

  void _rebuildWidget() {
    setState(() {
      _widgetKey = UniqueKey(); // Change the key to force recreation
    });
  }

  void _startTimer() {
    // Create a countdown timer that runs every second
    DateTime _expireDate = DateTime.parse(
            PaymentProvider.instance.transferDetailModel?.expiryTime ?? "")
        .toLocal();
    int _secondsBetween = secondsBetween(DateTime.now(), _expireDate);

    countDownMinutes = _secondsBetween ~/ 60;
  }

  TransferDetailModel? transferDetailModel;
  bool _showLoader = false;
  bool _isActive = false;
  _loadAccountInfo({String? paymentRef}) async {
    _showLoader = true;
    if (mounted) setState(() {});
    var result = await PaymentProvider.instance.initTransfer(
        payment: Payment(
            amount: widget.amount,
            email: widget.customerDetailModel.customerEmail,
            reference: paymentRef ?? widget.customerDetailModel.reference,
            currencyType: CurrencyType.NGN,
            customerName: widget.customerDetailModel.customerName));
    if (result.error) {
      _showLoader = false;
      if (mounted) setState(() {});
      resultController.setResult(result);
      PageRouter.goBack(context);
      return;
    }
    // Start the countdown timer when the screen is initialized
    transferDetailModel = PaymentProvider.instance.transferDetailModel;

    var decodedResult = await PaymentProvider.instance
        .loadTransactionDetails(token: transferDetailModel!.shortCode!);
    if (decodedResult.error) {
      _showLoader = false;
      if (mounted) setState(() {});
      resultController.setResult(decodedResult);
      PageRouter.goBack(context);
      return;
    }
    detailModel = PaymentProvider.instance.paystackDetailModel!;
    if (detailModel!.isTaxed) {
      var taxResult = await PaymentProvider.instance.getTaxBreakDown(
          merchantId: detailModel?.merchantId ?? "",
          currency: CurrencyType.NGN.name,
          transactionType: "collection",
          amount: widget.amount);
      if (taxResult.error) {
        _showLoader = false;
        if (mounted) setState(() {});
        resultController.setResult(taxResult);
        PageRouter.goBack(context);
        return;
      }
      amountBreakdownModel = PaymentProvider.instance.amountBreakdownModel!;
    }
    _startTimer();
    _showLoader = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amountBreakdownModel = AmountBreakdownModel(
        total: widget.amount,
        subtotal: widget.amount,
        taxAndLevy: 0,
        taxBreak: []);
    _loadAccountInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    // The screen became active
    _isActive = true;
  }

  @override
  void didPopNext() {
    // Returned to this screen from a child screen
    _isActive = true;
  }

  @override
  void didPop() {
    // The screen is being popped
    _isActive = false;
  }

  @override
  void didPushNext() {
    // Navigated to a child screen
    _isActive = false;
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      hasPadding: true,
      shouldExit: true,
      onPopResult: (status, result) {
        if (resultController.resultCode.value == 0) {
          resultController.setResult(APIResponse(
              error: true, message: "The request was canceled!!!", data: null));
        }
      },
      body: SafeArea(
        child: _showLoader
            ? Center(
                child: ImageLoader(
                  path: AppAssets.sbLoaderGif,
                  width: 200.w,
                  height: 100.h,
                  fit: BoxFit.fitWidth,
                ),
              )
            : ListView(
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
                          currency: CurrencyType.NGN.name,
                          amountBreakdownModel: amountBreakdownModel,
                          showTax: detailModel?.isTaxed ?? false,
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Container(
                          width: 1.sw,
                          height: 38.h,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: Pallet.red.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(color: Pallet.red, width: 0.5.w),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning,
                                color: Pallet.red,
                                size: 16.h,
                              ),
                              SizedBox(
                                width: 12.w,
                              ),
                              TextView(
                                text: "Send exact Amount as displayed.",
                                textStyle: GoogleFonts.hankenGrotesk(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Pallet.red),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 16.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            color: Pallet.taxWidgetColor,
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _accountDetail(
                                        title: "BANK NAME",
                                        subtitle:
                                            transferDetailModel?.bankName ??
                                                ""),
                                  ),
                                  Expanded(
                                    child: _accountDetail(
                                      title: "ACCOUNT NUMBER",
                                      subtitle:
                                          transferDetailModel?.accountNumber ??
                                              "",
                                      rightAligned: true,
                                      showCopy: true,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: _accountDetail(
                                        title: "ACCOUNT NAME",
                                        subtitle:
                                            transferDetailModel?.accountName ??
                                                ""),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        CountdownTimer(
                          minutes: countDownMinutes,
                          seconds: 0,
                          key: _widgetKey,
                          onResendOtp: () async {
                            if (mounted) setState(() {});
                          },
                          onTimerEnd: () {
                            if (mounted && _isActive) {
                              PageRouter.gotoWidget(
                                  TransferTimeoutScreen(
                                    transferDetailModel: transferDetailModel!,
                                    customerDetailModel:
                                        widget.customerDetailModel,
                                    amountBreakdownModel: amountBreakdownModel,
                                    currencyType: CurrencyType.NGN,
                                    onRetry: () {
                                      PageRouter.goBack(context);
                                      String paymentReference =
                                          "SB-${DateTime.now().millisecondsSinceEpoch.toString()}";
                                      _loadAccountInfo(
                                          paymentRef: paymentReference);
                                      _rebuildWidget();
                                    },
                                    onSwitchPayment: () {
                                      PageRouter.goBack(context);
                                      PageRouter.replacePage(
                                          context,
                                          PaystackScreen(
                                            customerDetailModel:
                                                widget.customerDetailModel,
                                            amount:
                                                amountBreakdownModel?.total ??
                                                    0,
                                            currency: CurrencyType.NGN,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                PageRouter.replacePage(
                                    context,
                                    PaystackScreen(
                                      customerDetailModel:
                                          widget.customerDetailModel,
                                      amount: widget.amount,
                                      currency: CurrencyType.NGN,
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
                                      text: "More payment methods",
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
                            CustomButtonWidget(
                              buttonText: 'I’ve sent the money',
                              buttonColor: Pallet.buttonColor,
                              fontSize: 12.sp,
                              height: 42.h,
                              width: 166.w,
                              onTap: () async {
                                PageRouter.gotoWidget(
                                    ConfirmSentTransferScreen(
                                      transferDetailModel: PaymentProvider
                                          .instance.transferDetailModel!,
                                      customerDetailModel:
                                          widget.customerDetailModel,
                                      amountBreakdownModel:
                                          amountBreakdownModel,
                                      currencyType: CurrencyType.NGN,
                                      onRetry: () {
                                        PageRouter.goBack(context);
                                        PageRouter.goBack(context);
                                        String paymentReference =
                                            "SB-${DateTime.now().millisecondsSinceEpoch.toString()}";
                                        _loadAccountInfo(
                                            paymentRef: paymentReference);
                                        _rebuildWidget();
                                      },
                                    ),
                                    context);
                              },
                            ),
                          ],
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

  Widget _accountDetail(
      {required String title,
      required String subtitle,
      bool showCopy = false,
      bool rightAligned = false}) {
    return Column(
      crossAxisAlignment:
          rightAligned ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        TextView(
          text: title,
          textStyle: GoogleFonts.hankenGrotesk(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: Pallet.hintColorLight),
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment:
              rightAligned ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!rightAligned) ...[
              Expanded(
                child: TextView(
                  text: subtitle,
                  textStyle: GoogleFonts.hankenGrotesk(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Pallet.textColorLight),
                ),
              ),
            ],
            if (rightAligned) ...[
              TextView(
                text: subtitle,
                textStyle: GoogleFonts.hankenGrotesk(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Pallet.textColorLight),
              ),
            ],
            if (showCopy) ...[
              SizedBox(
                width: 4.w,
              ),
              GestureDetector(
                onTap: () {
                  copyText(context, subtitle);
                },
                child: Icon(
                  Icons.copy,
                  size: 18.w,
                  color: Pallet.hintColorLight,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
