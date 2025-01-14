import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sb_payment_sdk/core/provider/result_provider.dart';
import 'package:sb_payment_sdk/core/utils/app_assets.dart';
import 'package:sb_payment_sdk/core/utils/page_router.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';
import 'package:sb_payment_sdk/core/widget/background_widget.dart';
import 'package:sb_payment_sdk/core/widget/countdown_timer.dart';
import 'package:sb_payment_sdk/core/widget/custom_button.dart';
import 'package:sb_payment_sdk/core/widget/footer_widget.dart';
import 'package:sb_payment_sdk/core/widget/image_loader.dart';
import 'package:sb_payment_sdk/core/widget/text_views.dart';
import 'package:sb_payment_sdk/models/api_response.dart';
import 'package:sb_payment_sdk/screens/confirm_sent_transfer_screen.dart';

class TransactionCompletedScreen extends StatelessWidget {
  static String routeName = "transaction-completed-screen";
  String paymentReference;
  APIResponse response;
  TransactionCompletedScreen(
      {super.key, required this.paymentReference, required this.response});

  @override
  Widget build(BuildContext context) {
    final ResultController resultController = Get.find();
    return BackgroundWidget(
      hasPadding: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: const SizedBox(),
        actions: const [
          /*IconButton(
            onPressed: () {
              resultController.setResult(response);
              PageRouter.goBack(context);
              PageRouter.goBack(context);
            },
            icon: Icon(
              Icons.close,
              color: Pallet.iconColorLight,
              size: 24.w,
            ),
          ),*/
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          children: [
            SizedBox(
              height: 32.h,
            ),
            ImageLoader(
              path: AppAssets.transactionSuccess,
              width: 81.w,
              height: 81.w,
            ),
            SizedBox(
              height: 64.h,
            ),
            TextView(
              text: "Transaction completed!",
              textAlign: TextAlign.center,
              textStyle: GoogleFonts.hankenGrotesk(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Pallet.textColorLight,
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            CountdownTimer(
              minutes: 0,
              seconds: 5,
              message: "Redirecting in ",
              onResendOtp: () async {},
              onTimerEnd: () {
                resultController.setResult(response);
                PageRouter.goBack(context);
                PageRouter.goBack(context);
              },
            ),
            /*TextView(
              text: "You may now exit this page",
              textAlign: TextAlign.center,
              textStyle: GoogleFonts.hankenGrotesk(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Pallet.hintColorLight,
              ),
            ),*/
            SizedBox(
              height: 24.h,
            ),
            Divider(
              thickness: 0.5.w,
              color: Pallet.hintColor,
            ),
            SizedBox(
              height: 24.h,
            ),
            TextView(
              text:
                  "Startbutton empowers you to sell your awesome products and services in more African countries.",
              textAlign: TextAlign.center,
              textStyle: GoogleFonts.hankenGrotesk(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Pallet.textColorLight,
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            SizedBox(
              child: Center(
                child: CustomIconButton(
                  title: 'Contact sales',
                  icon: AppAssets.contact,
                  buttonColor: Pallet.buttonColor,
                  textColor: Pallet.white,
                  isText: true,
                  fontSize: 14.sp,
                  height: 42.h,
                  width: 140.w,
                  onTap: () {},
                ),
              ),
            ),
            SizedBox(height: 32.h),
            ImageLoader(
              path: AppAssets.successBg,
              width: 1.sw,
              height: 160.h,
            ),
            SizedBox(height: 32.h),
            const FooterWidget(
              showAuthorized: false,
            )
          ],
        ),
      ),
    );
  }
}
