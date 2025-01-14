import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sb_payment_sdk/core/utils/app_theme.dart';
import 'package:sb_payment_sdk/core/utils/constants.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';

import 'text_views.dart';

// ignore: must_be_immutable
class CustomButtonWidget extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final double height;
  final double radius;
  final String? font;
  final num fontSize;
  final Color? buttonTextColor;
  Color? buttonColor;
  Color? borderColor;
  final double width;
  bool disabled;
  bool loading;

  CustomButtonWidget(
      {Key? key,
      required this.buttonText,
      required this.onTap,
      this.font,
      this.height = 50,
      this.radius = 8,
      this.width = 50,
      this.fontSize = 16,
      this.buttonTextColor,
      this.borderColor,
      this.disabled = false,
      this.loading = false,
      this.buttonColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: IgnorePointer(
        ignoring: disabled,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: disabled == true
                ? (buttonColor ?? Pallet.primary).withOpacity(0.5)
                //Pallet.primary.withOpacity(0.17)
                : buttonColor ?? Pallet.primary,
            foregroundColor: disabled == true
                ? (buttonColor ?? Pallet.primary).withOpacity(0.5)
                //Pallet.primary.withOpacity(0.17)
                : buttonColor ?? Pallet.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          child: loading ?
              const CircularProgressIndicator(strokeWidth: 5, valueColor: AlwaysStoppedAnimation<Color>(Pallet.white),) :
          TextView(
              text: buttonText,
              textAlign: TextAlign.center,
              textStyle: body2Style.copyWith(
                  color: disabled ? Pallet.white : Pallet.white)),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomIconButtonWidget extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final double height;
  final double radius;
  final String? font;
  final double fontSize;
  final Color? buttonTextColor;
  Color? buttonColor;
  Color? borderColor;
  final double width;
  bool disabled;
  String iconPath;

  CustomIconButtonWidget(
      {Key? key,
      required this.buttonText,
      required this.iconPath,
      required this.onTap,
      this.font,
      this.height = 50,
      this.radius = 8,
      this.width = 50,
      this.fontSize = 16,
      this.buttonTextColor,
      this.borderColor,
      this.disabled = false,
      this.buttonColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: IgnorePointer(
        ignoring: disabled,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: disabled == true
                ? const Color(0x2B039754)
                //Pallet.primary.withOpacity(0.17)
                : buttonColor ?? Pallet.primary,
            foregroundColor: disabled == true
                ? const Color(0x2B039754)
                //Pallet.primary.withOpacity(0.17)
                : buttonColor ?? Pallet.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          child: Center(
            child: Row(
              children: [
                Image.asset(
                  iconPath,
                  width: 24.w,
                  height: 24.h,
                  fit: BoxFit.fitWidth,
                ),

                SizedBox(width: 4.w),

                TextView(
                    text: buttonText,
                    textAlign: TextAlign.center,
                    textStyle: body2Style.copyWith(
                        color: disabled ? Pallet.grey.shade700 : Pallet.white, fontSize: fontSize ?? 14.sp)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomOutlinedButtonWidget extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final double height;
  final double radius;
  final double fontSize;
  final String? font;
  final Color? buttonTextColor;
  Color? buttonColor;
  Color? borderColor;
  final double width;

  CustomOutlinedButtonWidget(
      {Key? key,
      required this.buttonText,
      required this.onTap,
      this.font,
      this.height = 50,
      this.radius = 8,
      this.width = 50,
      this.fontSize = 16,
      this.buttonTextColor,
      this.borderColor,
      this.buttonColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
            foregroundColor: borderColor ?? Pallet.black, shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            side: BorderSide(color: borderColor ?? Pallet.primary)),
        child: TextView(
          text: buttonText,
          textAlign: TextAlign.center,
          textStyle: TextStyle(
              fontFamily: fontFamily,
              fontSize: ScreenUtil().setSp(fontSize),
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}