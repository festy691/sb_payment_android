import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sb_payment_sdk/core/provider/payment_provider.dart';
import 'package:sb_payment_sdk/core/utils/app_assets.dart';
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
import 'package:sb_payment_sdk/models/charge_model.dart';
import 'package:sb_payment_sdk/models/customer_detail_model.dart';
import 'package:sb_payment_sdk/models/paystack_detail_model.dart';
import 'package:sb_payment_sdk/models/transfer_detail_model.dart';

typedef OnRetry = Function();
typedef OnSwitchPayment = Function();

class TransferTimeoutScreen extends StatefulWidget {
  static String routeName = "payment-timeout-screen";
  TransferDetailModel transferDetailModel;
  CustomerDetailModel customerDetailModel;
  AmountBreakdownModel amountBreakdownModel;
  CurrencyType currencyType;
  OnRetry onRetry;
  OnSwitchPayment onSwitchPayment;
  TransferTimeoutScreen({
    super.key,
    required this.transferDetailModel,
    required this.customerDetailModel,
    required this.amountBreakdownModel,
    required this.currencyType,
    required this.onRetry,
    required this.onSwitchPayment,
  });

  @override
  State<TransferTimeoutScreen> createState() => _TransferTimeoutScreenState();
}

class _TransferTimeoutScreenState extends State<TransferTimeoutScreen> {
  int countDownMinutes = 0;
  PaymentDetailModel? detailModel;
  AmountBreakdownModel? amountBreakdownModel;

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
                    amountBreakdownModel: widget.amountBreakdownModel,
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
                    seconds: 0,
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
                    text: "Timeout!",
                    textAlign: TextAlign.center,
                    textStyle: GoogleFonts.hankenGrotesk(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Pallet.textColorLight,
                      //decoration: TextDecoration.underline
                    ),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  CustomOutlinedButtonWidget(
                    buttonText: 'Change payment methods',
                    buttonColor: Pallet.buttonColor,
                    borderColor: Pallet.buttonColor,
                    buttonTextColor: Pallet.buttonColor,
                    radius: 4.r,
                    fontSize: 12.sp,
                    height: 42.h,
                    width: 230.w,
                    onTap: () async {
                      widget.onSwitchPayment();
                    },
                  ),
                  SizedBox(height: 16.h),
                  TextView(
                    text: "Retry payment",
                    textStyle: GoogleFonts.hankenGrotesk(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Pallet.textColorLight,
                      decoration: TextDecoration.underline,
                    ),
                    onTap: () => widget.onRetry(),
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
