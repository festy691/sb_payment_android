
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sb_payment_sdk/core/utils/app_assets.dart';
import 'package:sb_payment_sdk/core/utils/app_theme.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';
import 'package:sb_payment_sdk/core/widget/custom_button.dart';
import 'package:sb_payment_sdk/core/widget/text_views.dart';

class AppDialog {
  AppDialog._();

  defaultDialog(String title, Widget content,
      {bool isDismissible = false, Widget? confirm, Widget? cancel}) {
    return Get.defaultDialog(
      title: title,
      content: content,
      cancel: cancel,
      confirm: confirm,
      barrierDismissible: isDismissible,
      radius: 10,
    );
  }

  customisedDialog(
      Widget widget, {
        bool isDismissible = false,
      }) {
    return Get.dialog(widget, barrierDismissible: isDismissible);
  }

  static showInfoDialog(BuildContext context,
      {required String message, required Function onContinue}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  16.r,
                ),
              ),
            ),
            contentPadding: EdgeInsets.all(
              20.w,
            ),
            title: Row(
              children: [
                Icon(
                  Icons.info,
                  color: Pallet.secondary,
                  size: 24.w,
                ),
                SizedBox(width: 14.w),
                TextView(
                  text: "Info",
                  textStyle: titleStyle,
                ),
              ],
            ),

            content: SizedBox(
              //height: setHeight(132),
              width: 332.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Divider(
                    height: 0.5,
                    color: Pallet.grey,
                  ),
                  SizedBox(height: 10.h),
                  TextView(
                    text: message,
                    textStyle: title3Style,
                  ),
                  SizedBox(height: 40.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomOutlinedButtonWidget(
                          buttonText: "Continue",
                          height: 40.h,
                          width: 114.w,
                          onTap: () {
                            onContinue();
                          }),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  static showSuccessDialog(BuildContext context, {required Function onContinue}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  16.r,
                ),
              ),
            ),
            contentPadding: EdgeInsets.all(
              20.w,
            ),

            title: Column(
              children: [
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

                    TextView(text: "Powered by", textStyle: titleStyle.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w600,),),

                    SizedBox(width: 12.w),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Pallet.warning.shade700.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(16.r)),
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

                          TextView(text: "Startbutton", textStyle: title3Style.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, letterSpacing: 0.8),),

                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 100.h,),
              ],
            ),

            content: SizedBox(
              //height: setHeight(132),
              width: 332.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    AppAssets.transactionSuccess,
                    width: 88.w,
                    height: 88.h,
                    fit: BoxFit.fitHeight,
                  ),

                  SizedBox(height: 24.h),

                  TextView(
                    text: "Transaction successful!",
                    textStyle: title3Style.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700),
                  ),

                  SizedBox(height: 12.h),

                  TextView(
                    text: "We have confirmed your transaction, and it is currently processing.",
                    textAlign: TextAlign.center,
                    textStyle: title3Style.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400),
                  ),

                  SizedBox(height: 40.h),

                  CustomButtonWidget(
                    buttonText: "Exit page",
                    height: 49.h,
                    width: 229.w,
                    buttonColor: Pallet.orangeDark,
                    onTap: () {
                      onContinue();
                    }
                  ),

                  SizedBox(height: 48.h),

                ],
              ),
            ),
          );
        });
  }

  static showAccountExpiredDialog(BuildContext context, {required Function onContinue}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  16.r,
                ),
              ),
            ),
            contentPadding: EdgeInsets.all(
              20.w,
            ),

            title: Column(
              children: [
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

                    TextView(text: "Powered by", textStyle: titleStyle.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w600,),),

                    SizedBox(width: 12.w),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Pallet.warning.shade700.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(16.r)),
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

                          TextView(text: "Startbutton", textStyle: title3Style.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, letterSpacing: 0.8),),

                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 64.h,),
              ],
            ),

            content: SizedBox(
              //height: setHeight(132),
              width: 332.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    AppAssets.warningOrange,
                    width: 88.w,
                    height: 88.h,
                    fit: BoxFit.fitHeight,
                  ),

                  SizedBox(height: 24.h),

                  TextView(
                    text: "Account expired",
                    textStyle: title3Style.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700),
                  ),

                  SizedBox(height: 12.h),

                  TextView(
                    text: "This account has expired, please use an alternative payment method.",
                    textAlign: TextAlign.center,
                    textStyle: title3Style.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400),
                  ),

                  SizedBox(height: 40.h),

                  CustomIconButtonWidget(
                    buttonText: "Change payment method",
                    fontSize: 14.sp,
                    iconPath: AppAssets.changeWhite,
                    height: 49.h,
                    width: 249.w,
                    buttonColor: Pallet.orangeDark,
                    onTap: () {
                      onContinue();
                    }
                  ),

                  SizedBox(height: 48.h),

                ],
              ),
            ),
          );
        });
  }

}