import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sb_payment_sdk/core/utils/app_assets.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';
import 'package:sb_payment_sdk/core/widget/image_loader.dart';
import 'package:sb_payment_sdk/core/widget/text_views.dart';

class HeaderWidget extends StatelessWidget {
  String? logo;
  String businessName;
  String businessEmail;
  Widget child;
  HeaderWidget(
      {super.key,
      required this.logo,
      required this.businessEmail,
      required this.businessName,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Pallet.hintColor, width: 0.5.w),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: Row(
              children: [
                ImageLoader(
                  path: logo ?? AppAssets.icon,
                  width: 31.w,
                  height: 31.w,
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: TextView(
                    text: businessName,
                    textStyle: GoogleFonts.hankenGrotesk(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: Pallet.textColorLight),
                  ),
                ),
                TextView(
                  text: businessEmail,
                  textStyle: GoogleFonts.hankenGrotesk(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: Pallet.hintColor),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 0.4.w,
            color: Pallet.hintColor,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: child,
          ),
        ],
      ),
    );
  }
}
