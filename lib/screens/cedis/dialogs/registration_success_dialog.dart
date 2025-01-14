import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sb_payment_sdk/core/provider/payment_provider.dart';
import 'package:sb_payment_sdk/core/utils/app_assets.dart';
import 'package:sb_payment_sdk/core/utils/page_router.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';
import 'package:sb_payment_sdk/core/widget/countdown_timer.dart';
import 'package:sb_payment_sdk/core/widget/image_loader.dart';
import 'package:sb_payment_sdk/core/widget/text_views.dart';
import 'package:sb_payment_sdk/models/charge_model.dart';
import 'package:sb_payment_sdk/models/customer_detail_model.dart';
import 'package:sb_payment_sdk/screens/pending_momo_payment_screen.dart';

class RegisterSuccessDialog extends StatefulWidget {
  CustomerDetailModel customerDetailModel;
  num amount;
  RegisterSuccessDialog({
    super.key,
    required this.amount,
    required this.customerDetailModel,
  });

  @override
  State<RegisterSuccessDialog> createState() => _RegisterSuccessDialogState();
}

class _RegisterSuccessDialogState extends State<RegisterSuccessDialog> {
  final TextEditingController _fullNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      color: Pallet.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageLoader(
            path: AppAssets.transactionSuccess,
            width: 20.w,
            height: 20.w,
          ),
          SizedBox(
            height: 16.h,
          ),
          TextView(
            text: "Registration successful",
            textStyle: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Pallet.textColorLight),
          ),
          SizedBox(
            height: 16.h,
          ),
          TextView(
            text:
                "Please stay on this page, you will be redirected to continue your payment shortly.",
            textStyle: GoogleFonts.hankenGrotesk(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: Pallet.textColorLight),
          ),
          SizedBox(
            height: 24.h,
          ),
          CountdownTimer(
            minutes: 0,
            seconds: 5,
            message: "Redirecting in ",
            onResendOtp: () async {
              if (mounted) setState(() {});
            },
            onTimerEnd: () {
              PageRouter.goBack(context);
              PageRouter.gotoWidget(
                  PendingMomoPaymentScreen(
                    transferDetailModel:
                        PaymentProvider.instance.transferDetailModel!,
                    customerDetailModel: widget.customerDetailModel,
                    amount: widget.amount,
                    currencyType: CurrencyType.GHS,
                  ),
                  context);
            },
          ),
          SizedBox(
            height: 16.h,
          ),
        ],
      ),
    );
  }
}
