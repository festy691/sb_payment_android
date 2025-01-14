import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';
import 'package:sb_payment_sdk/core/widget/image_loader.dart';

import 'text_views.dart';

// ignore: must_be_immutable
class CustomButtonWidget extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final double height;
  final double radius;
  final String? font;
  final double fontSize;
  final Color? buttonTextColor;
  final TextStyle? buttonTextStyle;
  Color? buttonColor;
  Color? borderColor;
  final double width;
  bool disabled;

  CustomButtonWidget(
      {Key? key,
      required this.buttonText,
      required this.onTap,
      this.font,
      this.height = 56,
      this.radius = 8,
      this.width = 50,
      this.fontSize = 16,
      this.buttonTextColor,
      this.borderColor,
      this.buttonTextStyle,
      this.disabled = false,
      this.buttonColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: IgnorePointer(
        ignoring: disabled,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: disabled == true
                ? Pallet.colorPrimaryLight.withOpacity(0.2)
                : buttonColor ?? Pallet.colorPrimaryLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: TextView(
            text: buttonText,
            textAlign: TextAlign.center,
            textStyle: buttonTextStyle ??
                GoogleFonts.inter(
                    color: buttonTextColor ?? Pallet.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600),
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
  final TextStyle? buttonTextStyle;
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
      this.buttonTextStyle,
      this.borderColor,
      this.buttonColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
            //backgroundColor: borderColor ?? Pallet.colorPrimaryLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            side: BorderSide(color: borderColor ?? Pallet.colorPrimaryLight)),
        child: TextView(
          text: buttonText,
          textAlign: TextAlign.center,
          textStyle: buttonTextStyle ??
              GoogleFonts.inter(
                  color: buttonTextColor ??
                      borderColor ??
                      Pallet.colorPrimaryLight,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomOutlinedButton2Widget extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final double height;
  final double radius;
  final double fontSize;
  final String? font;
  final String? icon;
  final Color? buttonTextColor;
  Color? buttonColor;
  Color? borderColor;
  final double width;

  CustomOutlinedButton2Widget(
      {Key? key,
      required this.buttonText,
      required this.onTap,
      this.font,
      this.icon,
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
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            border: Border.all(color: borderColor ?? Pallet.black, width: 1),
            borderRadius: BorderRadius.circular(10.0)),
        child: Center(
          child: Row(
            children: [
              SizedBox(width: 54.w),
              ImageLoader(
                path: icon,
                width: 20.w,
                height: 20.w,
              ),
              Expanded(
                child: SizedBox(
                  child: TextView(
                    text: buttonText,
                    textAlign: TextAlign.center,
                    textStyle: GoogleFonts.hankenGrotesk(
                        fontSize: fontSize.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(width: 54.w),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomSmallButtonWidget extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final double height;
  final double radius;
  bool disabled;
  final String? font;
  final TextStyle? buttonTextStyle;
  final Color? buttonTextColor;
  Color? buttonColor;
  Color? borderColor;
  final double width;

  CustomSmallButtonWidget(
      {Key? key,
      required this.buttonText,
      required this.onTap,
      this.font,
      this.buttonTextStyle,
      this.height = 30,
      this.radius = 8,
      this.width = 60,
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
                ? Pallet.lightGrey.withOpacity(0.4)
                : buttonColor ?? Pallet.colorPrimaryDark,
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: TextView(
              text: buttonText,
              textAlign: TextAlign.center,
              textStyle: buttonTextStyle ??
                  GoogleFonts.hankenGrotesk(
                    fontSize: 12.sp,
                    color: buttonTextColor,
                  )
              // TextStyle(
              //   fontFamily: fontFamily,
              //   color: buttonTextColor,
              //   fontSize: setSp(12),
              //   fontWeight: FontWeight.w700,
              // ),
              ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    this.title,
    this.isSvg = false,
    this.isText = false,
    required this.icon,
    required this.onTap,
    this.buttonColor = Pallet.colorPrimaryDark,
    this.textColor = Pallet.black,
    this.borderRadius,
    this.width = 150,
    this.height = 40,
    this.fontSize = 12,
    this.iconWidth,
    this.iconHeight,
    this.isOutlined = false,
  }) : super(key: key);

  String? title;
  bool isSvg;
  bool isText;
  String icon;
  Function onTap;
  Color buttonColor;
  Color? textColor;
  double? borderRadius;
  num width;
  num height;
  double fontSize;
  num? iconWidth;
  num? iconHeight;
  bool isOutlined;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.w),
        width: width.w,
        height: height.h,
        decoration: isOutlined
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: buttonColor, width: 0.5))
            : BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(borderRadius ?? 4.r)),
        child: isText
            ?
            //           ? SizedBox()
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (title != null) ...[
                    TextView(
                        text: title!,
                        textAlign: TextAlign.start,
                        textStyle: GoogleFonts.hankenGrotesk(
                          fontSize: fontSize,
                          color: textColor,
                        )),
                    SizedBox(width: 8.w),
                  ],
                  ImageLoader(
                    path: icon,
                    width: 18.w,
                    height: 18.w,
                  ),
                ],
              )
            : isSvg
                ? SvgPicture.asset(icon)
                : ImageLoader(
                    path: icon,
                    width: 22.w,
                    height: 22.w,
                  ),
      ),
    );
  }
}
