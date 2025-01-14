import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sb_payment_sdk/core/utils/app_assets.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';
import 'package:sb_payment_sdk/core/utils/utils.dart';
import 'package:sb_payment_sdk/core/widget/image_loader.dart';
import 'package:sb_payment_sdk/core/widget/text_views.dart';

class FooterWidget extends StatelessWidget {
  final String businessName;
  final bool showAuthorized;
  const FooterWidget(
      {super.key, this.businessName = "", this.showAuthorized = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageLoader(
              path: AppAssets.lock,
              width: 12.w,
              height: 12.h,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(width: 4.w),
            TextView(
              text: "Powered by",
              textStyle: GoogleFonts.hankenGrotesk(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Pallet.grey),
            ),
            SizedBox(width: 12.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Pallet.taxWidgetColor.withOpacity(0.9),
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
                  TextView(
                    text: "startbutton",
                    textStyle: GoogleFonts.hankenGrotesk(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: Pallet.grey),
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 16.h,
        ),
        if (showAuthorized) ...[
          TextView(
            text: "An Authorized reseller of $businessName",
            textStyle: GoogleFonts.hankenGrotesk(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          Divider(
            thickness: 0.5.w,
            color: Pallet.hintColor,
          ),
          SizedBox(
            height: 16.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextView(
                text: "Terms of service",
                textStyle: GoogleFonts.hankenGrotesk(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
                onTap: () {
                  launchURL(Uri.parse(
                      "https://difficult-pentagon-7f6.notion.site/Terms-of-Use-702fc49aa8554dcf8fa01500429a6dfc?pvs=4"));
                },
              ),
              SizedBox(
                width: 50.w,
              ),
              TextView(
                text: "Privacy notice",
                textStyle: GoogleFonts.hankenGrotesk(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
                onTap: () {
                  launchURL(Uri.parse(
                      "https://difficult-pentagon-7f6.notion.site/Privacy-Notice-18ac227f1b4145859f68ad1150d45f7e?pvs=4"));
                },
              ),
            ],
          ),
          SizedBox(
            height: 16.h,
          ),
        ],
      ],
    );
  }
}
