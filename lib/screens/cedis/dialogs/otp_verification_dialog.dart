import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sb_payment_sdk/core/provider/payment_provider.dart';
import 'package:sb_payment_sdk/core/utils/app_assets.dart';
import 'package:sb_payment_sdk/core/utils/page_router.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';
import 'package:sb_payment_sdk/core/utils/utils.dart';
import 'package:sb_payment_sdk/core/widget/countdown_timer.dart';
import 'package:sb_payment_sdk/core/widget/custom_button.dart';
import 'package:sb_payment_sdk/core/widget/custom_pin_code_field.dart';
import 'package:sb_payment_sdk/core/widget/dialogs.dart';
import 'package:sb_payment_sdk/core/widget/image_loader.dart';
import 'package:sb_payment_sdk/core/widget/text_views.dart';
import 'package:sb_payment_sdk/models/charge_model.dart';
import 'package:sb_payment_sdk/models/customer_detail_model.dart';
import 'package:sb_payment_sdk/screens/cedis/dialogs/registration_success_dialog.dart';
import 'package:sb_payment_sdk/screens/paystack_screen.dart';
import 'package:sb_payment_sdk/screens/transfer_timeout_screen.dart';

class OTPVerificationDialog extends StatefulWidget {
  CustomerDetailModel customerDetailModel;
  num amount;
  String name;
  OTPVerificationDialog({
    super.key,
    required this.amount,
    required this.name,
    required this.customerDetailModel,
  });

  @override
  State<OTPVerificationDialog> createState() => _OTPVerificationDialogState();
}

class _OTPVerificationDialogState extends State<OTPVerificationDialog> {
  final TextEditingController _otpController = TextEditingController();
  Key _widgetKey = UniqueKey();
  bool _isLoading = false;

  _requestOtp() async {
    _startTimer();
    _rebuildWidget();
  }

  void _rebuildWidget() {
    setState(() {
      _widgetKey = UniqueKey(); // Change the key to force recreation
    });
  }

  int countDownMinutes = 3;
  int countDownSeconds = 0;

  void _startTimer() {
    // Create a countdown timer that runs every second

    DateTime _expireDate = DateTime.parse(
            PaymentProvider.instance.transferDetailModel?.expiryTime ?? "")
        .toLocal();
    int _secondsBetween = secondsBetween(DateTime.now(), _expireDate);

    countDownMinutes = _secondsBetween ~/ 60;
    countDownSeconds = _secondsBetween % 60;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      color: Pallet.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextView(
            text: "OTP Verification",
            textStyle: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Pallet.textColorLight),
          ),
          SizedBox(
            height: 16.h,
          ),
          TextView(
            text: "Kindly enter the pin below to complete this process.",
            textStyle: GoogleFonts.hankenGrotesk(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: Pallet.textColorLight),
          ),
          SizedBox(
            height: 20.h,
          ),
          CustomPinCodeField(
            pinLength: 4,
            appContext: context,
            controller: _otpController,
          ),
          SizedBox(
            height: 12.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CountdownTimer(
                minutes: countDownMinutes,
                seconds: countDownSeconds,
                key: _widgetKey,
                message: "Expires in ",
                onResendOtp: () async {
                  if (mounted) setState(() {});
                },
                onTimerEnd: () {
                  // PageRouter.goBack(context);
                  PageRouter.gotoWidget(
                      TransferTimeoutScreen(
                        transferDetailModel:
                            PaymentProvider.instance.transferDetailModel!,
                        customerDetailModel: widget.customerDetailModel,
                        amountBreakdownModel:
                            PaymentProvider.instance.amountBreakdownModel!,
                        currencyType: CurrencyType.GHS,
                        onRetry: () {
                          PageRouter.goBack(context);
                          PageRouter.goBack(context);
                        },
                        onSwitchPayment: () {
                          PageRouter.goBack(context);
                          PageRouter.replacePage(
                              context,
                              PaystackScreen(
                                customerDetailModel: widget.customerDetailModel,
                                amount: PaymentProvider
                                        .instance.amountBreakdownModel?.total ??
                                    0,
                                currency: CurrencyType.GHS,
                              ));
                        },
                      ),
                      context);
                },
              ),
              if (_isLoading) ...[
                ImageLoader(
                  path: AppAssets.loaderLottie,
                  width: 70.w,
                  height: 20.h,
                ),
              ],
            ],
          ),
          SizedBox(
            height: 16.h,
          ),
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              children: [
                TextSpan(
                  text: "I didn't receive the code! ",
                  style: GoogleFonts.hankenGrotesk(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Pallet.hintColorLight),
                ),
                TextSpan(
                  text: "Resend OTP",
                  style: GoogleFonts.hankenGrotesk(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Pallet.buttonColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _requestOtp();
                    },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 32.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomOutlinedButtonWidget(
                buttonText: "Back",
                width: 120.w,
                height: 48.h,
                buttonColor: Pallet.white,
                borderColor: Pallet.white,
                buttonTextColor: Pallet.textColorLight,
                fontSize: 14.sp,
                onTap: () {
                  PageRouter.goBack(context);
                },
              ),
              IgnorePointer(
                ignoring: _isLoading,
                child: CustomOutlinedButtonWidget(
                  buttonText: "Verify",
                  width: 170.w,
                  height: 48.h,
                  borderColor: Pallet.buttonColor,
                  buttonTextColor: Pallet.buttonColor,
                  fontSize: 14.sp,
                  onTap: () async {
                    _isLoading = true;
                    if (mounted) {
                      setState(() {});
                    }
                    var result = await PaymentProvider.instance.verifyMomoOTP(
                        otp: _otpController.text,
                        customerName: widget.name,
                        reference: PaymentProvider
                                .instance.momoResponseModel?.reference ??
                            "");
                    _isLoading = false;
                    if (mounted) {
                      setState(() {});
                    }
                    if (result.error) return showToast(result.message);
                    PageRouter.goBack(context);
                    AppDialog.showCustomDialog(context,
                        widget: RegisterSuccessDialog(
                          customerDetailModel: widget.customerDetailModel,
                          amount: widget.amount,
                        ),
                        isDismissible: false,
                        width: 340.w,
                        radius: 4.r);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
