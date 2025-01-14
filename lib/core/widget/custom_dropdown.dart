import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';
import 'package:sb_payment_sdk/core/widget/text_views.dart';

class CustomDropdownInput<T> extends StatelessWidget {
  final String? hintText;
  final List<T> options;
  final T? value;
  final String Function(T?)? getLabel;
  final void Function(T?)? onChanged;
  String? label;
  String? hint;
  Widget? prefixWidget;
  Widget? suffixWidget;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  Color? focusedColorBorder;
  double? width;
  bool disabled;
  final shakeKey;

  CustomDropdownInput(
      {this.hintText = 'Please select an Option',
      this.options = const [],
      this.value,
      this.getLabel,
      this.onChanged,
      this.label,
      this.hint,
      this.disabled = false,
      this.prefixWidget,
      this.suffixWidget,
      this.labelStyle,
      this.hintStyle,
      this.textStyle,
      this.shakeKey,
      this.width,
      this.focusedColorBorder});

  @override
  Widget build(BuildContext context) {
    focusedColorBorder = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.grey;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          TextView(
            text: label ?? "",
            textAlign: TextAlign.center,
            textStyle: GoogleFonts.hankenGrotesk(
              fontSize: 14.sp,
              color: Pallet.textColorLight,
              height: 1.43,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
        ],
        Theme(
          data: Theme.of(context).copyWith(splashColor: Colors.transparent),
          child: IgnorePointer(
            ignoring: disabled,
            child: Container(
              decoration: ShapeDecoration(
                color: Pallet.lightGrayAccent.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: FormField<T>(
                builder: (FormFieldState<T> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
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
                            color: Pallet.textColorLight,
                            fontSize: 16.sp,
                            height: 0,
                          ),
                      // labelText: "", //label,
                      isDense: true,
                      labelStyle: labelStyle ??
                          GoogleFonts.hankenGrotesk(
                            fontSize: 16.sp,
                            height: 1.43,
                            color: Pallet.textColorLight,
                          ),
                    ),
                    isEmpty: value == null || value == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<T>(
                        icon: suffixWidget,
                        //dropdownColor: Pallet.colorPrimaryDark,
                        iconSize: 24.w,
                        iconEnabledColor: Pallet.hintColor,
                        value: value,
                        isDense: true,
                        items: options.map((T value) {
                          return DropdownMenuItem<T>(
                            value: value,
                            child: Container(
                              width: width != null ? width : 0.6.sw,
                              child: Text(
                                getLabel!(value),
                                style: textStyle ??
                                    GoogleFonts.hankenGrotesk(
                                      color: Pallet.textColorLight,
                                      fontSize: 16.sp,
                                      height: 1.57,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                // maxLines: 2,
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: onChanged,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StateDropdownInput<T> extends StatelessWidget {
  final String? hintText;
  final List<T> options;
  final T? value;
  final String Function(T?)? getLabel;
  final void Function(T?)? onChanged;
  String? label;
  String? hint;
  Widget? prefixWidget;
  Widget? suffixWidget;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  Color? focusedColorBorder;
  double? width;

  StateDropdownInput(
      {this.hintText = 'Please select an Option',
      this.options = const [],
      this.value,
      this.getLabel,
      this.onChanged,
      this.label,
      this.hint,
      this.prefixWidget,
      this.suffixWidget,
      this.labelStyle,
      this.hintStyle,
      this.textStyle,
      this.width,
      this.focusedColorBorder});

  @override
  Widget build(BuildContext context) {
    focusedColorBorder = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.grey;
    return Container(
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Pallet.grey.withOpacity(.5), width: 1.5)),
      child: FormField<T>(
        builder: (FormFieldState<T> state) {
          return InputDecorator(
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              errorStyle: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              border: InputBorder.none,
              hintStyle: hintStyle,
              labelText: label,
              labelStyle:
                  labelStyle ?? TextStyle(color: Pallet.black.withOpacity(.8)),
            ),
            isEmpty: value == null || value == '',
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                icon: suffixWidget,
                iconSize: ScreenUtil().setHeight(25),
                iconEnabledColor: Pallet.grey,
                value: value,
                isDense: true,
                items: options.map((T value) {
                  return DropdownMenuItem<T>(
                    value: value,
                    child: SizedBox(
                      width:
                          width != null ? width : ScreenUtil().screenWidth * .7,
                      child: Text(
                        getLabel!(value),
                        style: TextStyle(color: Pallet.black),
                        // maxLines: 2,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomDropdownButton<T> extends StatelessWidget {
  final String? hintText;
  final List<T> options;
  final T? value;
  final String Function(T?)? getLabel;
  final void Function(T?)? onChanged;
  String? label;
  String? hint;
  String? text;
  Widget? prefixWidget;
  Widget? suffixWidget;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  Color? focusedColorBorder;
  double width;
  bool disabled;

  CustomDropdownButton(
      {this.hintText = 'Please select an Option',
      this.options = const [],
      this.value,
      this.getLabel,
      this.onChanged,
      this.label,
      this.hint,
      this.text = 'Select Item',
      this.disabled = false,
      this.prefixWidget,
      this.suffixWidget,
      this.labelStyle,
      this.hintStyle,
      this.textStyle,
      this.width = 200,
      this.focusedColorBorder});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        hint: TextView(
          text: label ?? 'Select Item',
          textStyle: Theme.of(context)
              .primaryTextTheme
              .bodySmall
              ?.copyWith(fontSize: 12.sp),
          textOverflow: TextOverflow.ellipsis,
        ),
        items: options
            .map((T item) => DropdownMenuItem<T>(
                  value: item,
                  child: TextView(
                    text: getLabel!(item),
                    textStyle: Theme.of(context)
                        .primaryTextTheme
                        .bodySmall
                        ?.copyWith(fontSize: 14.sp),
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: value,
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
            width: 160.w,
            height: 32.h,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r), color: Pallet.white)),
        iconStyleData: IconStyleData(
          icon: suffixWidget ??
              Icon(
                Icons.arrow_drop_down,
                size: 18.w,
                color: Pallet.iconTint,
              ),
          iconSize: 18.w,
          iconEnabledColor: Pallet.titleTextLight,
          iconDisabledColor: Pallet.iconTint,
        ),
        dropdownStyleData: DropdownStyleData(
          elevation: 6,
          padding: EdgeInsets.all(5.r),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
        ),
      ),
    );
  }
}
