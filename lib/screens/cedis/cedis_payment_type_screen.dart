import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sb_payment_sdk/core/provider/payment_provider.dart';
import 'package:sb_payment_sdk/core/provider/result_provider.dart';
import 'package:sb_payment_sdk/core/utils/app_assets.dart';
import 'package:sb_payment_sdk/core/utils/page_router.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';
import 'package:sb_payment_sdk/core/utils/utils.dart';
import 'package:sb_payment_sdk/core/widget/background_widget.dart';
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
import 'package:sb_payment_sdk/screens/cedis/bank_transfer_view.dart';
import 'package:sb_payment_sdk/screens/cedis/ghs_momo_screen.dart';

class CedisPaymentTypeScreen extends StatefulWidget {
  static String routeName = "ghs-payment-type";
  num amount;
  CustomerDetailModel customerDetailModel;

  CedisPaymentTypeScreen({
    super.key,
    required this.amount,
    required this.customerDetailModel,
  });

  @override
  State<CedisPaymentTypeScreen> createState() => _CedisPaymentTypeScreenState();
}

class _CedisPaymentTypeScreenState extends State<CedisPaymentTypeScreen> {
  late AmountBreakdownModel amountBreakdownModel;
  PaymentDetailModel? detailModel;
  final resultController = Get.find<ResultController>();
  int countDownMinutes = 5;
  int countDownSeconds = 0;
  int _selectedIndex = 0;

  bool isBank = true;
  bool disableBank = false;

  Key _widgetKey = UniqueKey();

  void _startTimer() {
    // Create a countdown timer that runs every second

    DateTime _expireDate = DateTime.parse(
            PaymentProvider.instance.transferDetailModel?.expiryTime ?? "")
        .toLocal();
    int _secondsBetween = secondsBetween(DateTime.now(), _expireDate);

    countDownMinutes = _secondsBetween ~/ 60;
    countDownSeconds = _secondsBetween % 60;
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
            currencyType: CurrencyType.GHS,
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
    var serviceResult = await PaymentProvider.instance.getServiceProviders(
        transactionCode: transferDetailModel?.shortCode ?? "");
    if (serviceResult.error) {
      _showLoader = false;
      if (mounted) setState(() {});
      resultController.setResult(serviceResult);
      PageRouter.goBack(context);
      return;
    }
    var decodedResult = await PaymentProvider.instance
        .loadTransactionDetails(token: transferDetailModel?.shortCode ?? "");
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
          currency: CurrencyType.GHS.name,
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

  int selectedIndex = 0;

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                          currency: CurrencyType.GHS.name,
                          amountBreakdownModel: amountBreakdownModel,
                          showTax: detailModel?.isTaxed ?? false,
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        _tabView(_selectedIndex, onSelected: (index) {
                          if (_selectedIndex == index) return;
                          if (index == 0) {
                            _widgetKey = UniqueKey();
                            _startTimer();
                          }
                          _selectedIndex = index;
                          if (mounted) {
                            setState(() {});
                          }
                        }),
                        if (_selectedIndex == 0) ...[
                          GHSBankTransferView(
                            amount: widget.amount,
                            key: _widgetKey,
                            customerDetailModel: widget.customerDetailModel,
                            countDownMinutes: countDownMinutes,
                            countDownSeconds: countDownSeconds,
                            onRetry: () {
                              PageRouter.goBack(context);
                              String paymentReference =
                                  "SB-${DateTime.now().millisecondsSinceEpoch.toString()}";
                              _loadAccountInfo(paymentRef: paymentReference);
                            },
                          ),
                        ],
                        if (_selectedIndex == 1) ...[
                          GhsMomoScreen(
                            amount: widget.amount,
                            customerDetailModel: widget.customerDetailModel,
                            countDownMinutes: countDownMinutes,
                            onRetry: () {
                              PageRouter.goBack(context);
                              String paymentReference =
                                  "SB-${DateTime.now().millisecondsSinceEpoch.toString()}";
                              _loadAccountInfo(paymentRef: paymentReference);
                            },
                          ),
                        ],
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

  Widget _tabView(int index, {required OnSelected onSelected}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {
            onSelected(0);
          },
          child: Column(
            children: [
              TextView(
                text: "Bank Transfer",
                textStyle: GoogleFonts.hankenGrotesk(
                  color: index == 0 ? Pallet.dark : const Color(0xff959DB6),
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Container(
                  height: index == 0 ? 2.h : 0.5.h,
                  width: 140.w,
                  color: index == 0 ? Pallet.dark : Pallet.hintColor),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            onSelected(1);
          },
          child: Column(
            children: [
              TextView(
                text: "Mobile Money (MoMo)",
                textStyle: GoogleFonts.hankenGrotesk(
                  color: index == 1 ? Pallet.dark : const Color(0xff959DB6),
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Container(
                  height: index == 1 ? 2.h : 0.5.h,
                  width: 140.w,
                  color: index == 1 ? Pallet.dark : Pallet.hintColor),
            ],
          ),
        ),
      ],
    );
  }
}

typedef OnSelected = Function(int);
