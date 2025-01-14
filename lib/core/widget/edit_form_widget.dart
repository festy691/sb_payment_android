import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';
import 'package:sb_payment_sdk/core/widget/text_views.dart';

class EditFormField extends StatelessWidget {
  EditFormField({
    this.label = '',
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixWidget,
    this.prefixWidget,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.controller,
    this.onPasswordToggle,
    this.onTapInfo,
    this.initialValue,
    this.autoValidate = false,
    this.autocorrect = true,
    this.readOnly = false,
    this.ignore = false,
    this.obscureText = false,
    this.shakeKey,
    this.isborderDecoration = true,
    this.onTapped,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.focusedColorBorder = Colors.white,
    this.labelStyle,
    this.hintStyle,
    this.textStyle,
    this.decoration,
    this.iconColor,
    this.textCapitalization = TextCapitalization.none,
    this.key,
    this.showInfo = false,
    this.focusNode,
    this.floatingLabelBehavior = FloatingLabelBehavior.never,
  });

  TextCapitalization textCapitalization;
  String label;
  String? hint;
  IconData? prefixIcon;
  IconData? suffixIcon;
  Color? iconColor;

  Widget? prefixWidget;
  Widget? suffixWidget;

  final FormFieldSetter<String>? onSaved;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
  VoidCallback? onPasswordToggle;
  final AutovalidateMode? autoValidateMode;

  String? initialValue;
  TextEditingController? controller;
  FocusNode? focusNode;

  bool autocorrect;
  bool autoValidate;
  bool readOnly;
  bool showInfo;
  bool ignore;
  bool obscureText;
  bool isborderDecoration;

  // bool clickable;
  Function()? onTapped;

  // bool clickable;
  Function()? onTapInfo;

  TextInputType? keyboardType;
  int maxLines;
  int minLines;
  int? maxLength;
  var inputFormatters;
  Color focusedColorBorder;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  InputDecoration? decoration;
  FloatingLabelBehavior floatingLabelBehavior;
  Key? key;
  final shakeKey;

  @override
  Widget build(BuildContext context) {
    focusedColorBorder = Theme.of(context).brightness == Brightness.dark
        ? Pallet.white
        : Pallet.grey;
    return InkWell(
      onTap: onTapped,
      child: IgnorePointer(
        ignoring: ignore,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextView(
                    text: label,
                    textAlign: TextAlign.center,
                    textStyle: GoogleFonts.hankenGrotesk(
                      fontSize: 14.sp,
                      color: Pallet.textColorLight,
                      height: 1.43,
                    ),
                  ),
                  if (showInfo)
                    GestureDetector(
                      onTap: onTapInfo,
                      child: Icon(Icons.info_outline, size: 16.w),
                    ),
                ],
              ),
            if (label.isNotEmpty)
              SizedBox(
                height: 8.h,
              ),
            Theme(
              data: Theme.of(context).copyWith(splashColor: Colors.transparent),
              child: Container(
                decoration: ShapeDecoration(
                  color: Pallet.lightGrayAccent.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: TextFormField(
                  key: key,
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  minLines: minLines,
                  //enabled: enabled,
                  readOnly: readOnly,
                  textCapitalization: textCapitalization,
                  onSaved: onSaved,
                  validator: validator,
                  autocorrect: autocorrect,
                  initialValue: initialValue,
                  obscureText: obscureText,
                  onChanged: onChanged,
                  style: textStyle ??
                      GoogleFonts.hankenGrotesk(
                        color: Pallet.gray,
                        fontSize: 16.sp,
                        height: 1.57,
                      ),
                  controller: controller,
                  autovalidateMode: autoValidateMode,
                  inputFormatters: inputFormatters ??
                      [
                        LengthLimitingTextInputFormatter(maxLength ?? 100),
                      ],
                  decoration: decoration ??
                      InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 16.h),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        // floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: hint,
                        hintStyle: hintStyle ??
                            GoogleFonts.hankenGrotesk(
                              color: Pallet.grayAccent,
                              fontSize: 16.sp,
                              height: 0,
                            ),
                        // labelText: "", //label,
                        isDense: true,
                        labelStyle: labelStyle ??
                            GoogleFonts.hankenGrotesk(
                              fontSize: 16.sp,
                              height: 1.43,
                              color: Pallet.white,
                            ),
                        prefixIcon: prefixIcon != null
                            ? IconButton(
                                onPressed: onPasswordToggle,
                                icon: Icon(
                                  prefixIcon,
                                  color:
                                      iconColor ?? Pallet.grey.withOpacity(0.7),
                                ))
                            : null,
                        suffixIcon: suffixIcon != null
                            ? IconButton(
                                onPressed: onPasswordToggle,
                                icon: Icon(
                                  suffixIcon,
                                  color:
                                      iconColor ?? Pallet.grey.withOpacity(0.7),
                                ))
                            : suffixWidget,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneNumberField extends StatelessWidget {
  PhoneNumberField({
    this.label = '',
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixWidget,
    this.prefixWidget,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.controller,
    this.onPasswordToggle,
    this.onTapInfo,
    this.initialValue = "GH",
    this.autoValidate = false,
    this.autocorrect = true,
    this.readOnly = false,
    this.ignore = false,
    this.shakeKey,
    this.isborderDecoration = true,
    this.onTapped,
    this.maxLength,
    this.inputFormatters,
    this.focusedColorBorder = Colors.white,
    this.labelStyle,
    this.hintStyle,
    this.textStyle,
    this.decoration,
    this.iconColor,
    this.textCapitalization = TextCapitalization.none,
    this.key,
    this.showInfo = false,
    this.focusNode,
    this.floatingLabelBehavior = FloatingLabelBehavior.never,
  });

  TextCapitalization textCapitalization;
  String label;
  String? hint;
  IconData? prefixIcon;
  IconData? suffixIcon;
  Color? iconColor;

  Widget? prefixWidget;
  Widget? suffixWidget;

  final FormFieldSetter<String>? onSaved;
  final Function(PhoneNumber)? onChanged;
  final FormFieldValidator<String>? validator;
  VoidCallback? onPasswordToggle;
  final AutovalidateMode? autoValidateMode;

  String initialValue;
  TextEditingController? controller;
  FocusNode? focusNode;

  bool autocorrect;
  bool autoValidate;
  bool readOnly;
  bool showInfo;
  bool ignore;
  bool isborderDecoration;

  // bool clickable;
  Function()? onTapped;

  // bool clickable;
  Function()? onTapInfo;

  int? maxLength;
  var inputFormatters;
  Color focusedColorBorder;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  InputDecoration? decoration;
  FloatingLabelBehavior floatingLabelBehavior;
  Key? key;
  final shakeKey;

  @override
  Widget build(BuildContext context) {
    focusedColorBorder = Theme.of(context).brightness == Brightness.dark
        ? Pallet.white
        : Pallet.grey;
    return InkWell(
      onTap: onTapped,
      child: IgnorePointer(
        ignoring: ignore,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextView(
                    text: label,
                    textAlign: TextAlign.center,
                    textStyle: GoogleFonts.hankenGrotesk(
                      fontSize: 14.sp,
                      color: Pallet.textColorLight,
                      height: 1.43,
                    ),
                  ),
                  if (showInfo)
                    GestureDetector(
                      onTap: onTapInfo,
                      child: Icon(Icons.info_outline, size: 16.w),
                    ),
                ],
              ),
            if (label.isNotEmpty)
              SizedBox(
                height: 8.h,
              ),
            Theme(
              data: Theme.of(context).copyWith(splashColor: Colors.transparent),
              child: Container(
                decoration: ShapeDecoration(
                  color: Pallet.lightGrayAccent.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: IntlPhoneField(
                  key: key,
                  readOnly: readOnly,
                  initialCountryCode: initialValue,
                  onChanged: onChanged,
                  style: textStyle ??
                      GoogleFonts.hankenGrotesk(
                        color: Pallet.gray,
                        fontSize: 16.sp,
                        height: 1.57,
                      ),
                  controller: controller,
                  autovalidateMode: autoValidateMode,
                  decoration: decoration ??
                      InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 16.h),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        // floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: hint,
                        hintStyle: hintStyle ??
                            GoogleFonts.hankenGrotesk(
                              color: Pallet.grayAccent,
                              fontSize: 16.sp,
                              height: 0,
                            ),
                        // labelText: "", //label,
                        isDense: true,
                        labelStyle: labelStyle ??
                            GoogleFonts.hankenGrotesk(
                              fontSize: 16.sp,
                              height: 1.43,
                              color: Pallet.white,
                            ),
                        prefixIcon: prefixIcon != null
                            ? IconButton(
                                onPressed: onPasswordToggle,
                                icon: Icon(
                                  prefixIcon,
                                  color:
                                      iconColor ?? Pallet.grey.withOpacity(0.7),
                                ))
                            : null,
                        suffixIcon: suffixIcon != null
                            ? IconButton(
                                onPressed: onPasswordToggle,
                                icon: Icon(
                                  suffixIcon,
                                  color:
                                      iconColor ?? Pallet.grey.withOpacity(0.7),
                                ))
                            : suffixWidget,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
