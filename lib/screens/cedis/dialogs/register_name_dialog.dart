import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sb_payment_sdk/core/provider/payment_provider.dart';
import 'package:sb_payment_sdk/core/utils/page_router.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';
import 'package:sb_payment_sdk/core/widget/custom_button.dart';
import 'package:sb_payment_sdk/core/widget/dialogs.dart';
import 'package:sb_payment_sdk/core/widget/edit_form_widget.dart';
import 'package:sb_payment_sdk/core/widget/text_views.dart';
import 'package:sb_payment_sdk/models/customer_detail_model.dart';
import 'package:sb_payment_sdk/screens/cedis/dialogs/otp_verification_dialog.dart';

class RegisterNameDialog extends StatefulWidget {
  CustomerDetailModel customerDetailModel;
  num amount;
  RegisterNameDialog({
    super.key,
    required this.amount,
    required this.customerDetailModel,
  });

  @override
  State<RegisterNameDialog> createState() => _RegisterNameDialogState();
}

class _RegisterNameDialogState extends State<RegisterNameDialog> {
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
          TextView(
            text: "Registration",
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
                "This is a one-time registration to better enhance our service delivery to you.",
            textStyle: GoogleFonts.hankenGrotesk(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: Pallet.textColorLight),
          ),
          SizedBox(
            height: 20.h,
          ),
          EditFormField(
            hint: "First Last",
            label: "Full name",
            controller: _fullNameController,
            onChanged: (value) {},
          ),
          SizedBox(
            height: 32.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomOutlinedButtonWidget(
                buttonText: "Cancel",
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
              CustomOutlinedButtonWidget(
                buttonText: "Continue",
                width: 170.w,
                height: 48.h,
                borderColor: Pallet.buttonColor,
                buttonTextColor: Pallet.buttonColor,
                fontSize: 14.sp,
                onTap: () async {
                  PageRouter.goBack(context);
                  AppDialog.showCustomDialog(context,
                      widget: OTPVerificationDialog(
                        customerDetailModel: widget.customerDetailModel,
                        name: _fullNameController.text,
                        amount: widget.amount,
                      ),
                      isDismissible: false,
                      width: 340.w,
                      radius: 4.r);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
