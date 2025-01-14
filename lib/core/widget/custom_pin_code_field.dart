import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';

class CustomPinCodeField extends StatefulWidget {
  final int pinLength;
  final BuildContext appContext;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  const CustomPinCodeField({
    Key? key,
    required this.pinLength,
    required this.appContext,
    this.controller,
    this.focusNode,
  }) : super(key: key);

  @override
  State<CustomPinCodeField> createState() => _CustomPinCodeFieldState();
}

class _CustomPinCodeFieldState extends State<CustomPinCodeField> {
  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      length: widget.pinLength,
      obscureText: false,
      controller: widget.controller,
      textStyle: GoogleFonts.hankenGrotesk(
        color: Pallet.black,
        fontSize: 22.sp,
      ),
      animationType: AnimationType.none,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
        fieldHeight: 60.h,
        fieldWidth: 50.w,
        activeFillColor: Pallet.taxWidgetColor,
        activeColor: Pallet.buttonColor,
        inactiveColor: Pallet.taxWidgetColor,
        borderWidth: 0,
        inactiveFillColor: Pallet.taxWidgetColor,
        selectedColor: Pallet.buttonColor,
        selectedFillColor: Pallet.taxWidgetColor,
      ),
      keyboardType: TextInputType.none,
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      cursorColor: Pallet.buttonColor.withOpacity(.8),
      focusNode: widget.focusNode,
      onCompleted: (v) {
        //otp = v;
        //validate();
      },
      onChanged: (v) {},
      beforeTextPaste: (text) {
        return true;
      },
      appContext: widget.appContext,
    );
  }
}
