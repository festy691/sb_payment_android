import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sb_payment_sdk/core/utils/app_theme.dart';
import 'package:sb_payment_sdk/core/utils/constants.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';
import 'package:sb_payment_sdk/core/widget/text_views.dart';

import '../data/session_manager.dart';
import '../utils/app_value.dart';

class EditFormField extends StatefulWidget {
  EditFormField({
    this.label,
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
    this.isborderDecoration = true,
    this.onTapped,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines = 1,
    this.isFilled = false,
    this.maxLength,
    this.inputFormatters,
    //this.focusedColorBorder = Colors.white,
    this.labelStyle,
    this.fillColor,
    this.hasShadow = false,
    this.hintStyle,
    this.textStyle,
    this.decoration,
    this.iconColor,
    this.isRequired = false,
    this.isHeader = false,
    this.isPassword = false,
    this.textCapitalization = TextCapitalization.none,
    this.key,
    this.focusedColorBorder,
    this.showInfo = false,
    FocusNode? focusNode,
    this.floatingLabelBehavior = FloatingLabelBehavior.never,
    this.horizontalpadding,
    this.verticalpadding,
  });

  TextCapitalization textCapitalization;
  String? label;
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
  final double? horizontalpadding;
  final double? verticalpadding;
  bool autocorrect;
  bool autoValidate;
  bool readOnly;
  bool isFilled;
  bool showInfo;
  bool ignore;
  bool obscureText;
  bool isborderDecoration;
  final bool? isRequired;
  final bool? isHeader;
  final bool? isPassword;
  final Color? fillColor;
  final bool hasShadow;
  // bool clickable;
  Function()? onTapped;

  // bool clickable;
  Function()? onTapInfo;

  TextInputType? keyboardType;
  int maxLines;
  int minLines;
  int? maxLength;
  var inputFormatters;
  final Color? focusedColorBorder;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  InputDecoration? decoration;
  FloatingLabelBehavior floatingLabelBehavior;
  Key? key;

  @override
  State<EditFormField> createState() => _EditFormFieldState();
}

class _EditFormFieldState extends State<EditFormField> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widget.focusNode ??= FocusNode();
  }

  bool obscureText = true;
  void showPassword() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  Color focusBgColor = Colors.transparent;
  Color focusBorderColor = Pallet.grey.shade50;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.isRequired! || widget.isHeader!
            ? Row(
          children: [
            widget.isRequired!
                ? TextView(
              text: "*",
              textStyle: captionStyle.copyWith(
                  fontSize: 16, color: Pallet.error),
            )
                : SizedBox(),
            TextView(
              text: widget.label ?? "",
              textAlign: TextAlign.center,
              textStyle: captionStyle.copyWith(
                color: Pallet.black,
              ),
            ),
          ],
        )
            : SizedBox(),
        SizedBox(
          height: 6.h,
        ),
        InkWell(
          onTap: widget.onTapped ?? () {},
          child: IgnorePointer(
            ignoring: widget.ignore,
            child: Theme(
              data: Theme.of(context)
                  .copyWith(splashColor: Colors.transparent),
              child: Container(
                decoration: BoxDecoration(
                    color: widget.isFilled
                        ? widget.fillColor ?? Color(0xFFEFEFEF)
                        : focusBgColor,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        width: 1.w,
                        color: widget.focusedColorBorder ??
                            focusBorderColor)),
                child: Row(
                  children: [
                    widget.prefixWidget == null
                        ? SizedBox()
                        : widget.prefixWidget!,
                    Expanded(
                      child: TextFormField(
                        key: widget.key,
                        keyboardType: widget.keyboardType,
                        maxLines: widget.maxLines,
                        minLines: widget.minLines,
                        readOnly: widget.readOnly,
                        focusNode: widget.focusNode,
                        textCapitalization: widget.textCapitalization,
                        onSaved: widget.onSaved,
                        autocorrect: widget.autocorrect,
                        initialValue: widget.initialValue,
                        onChanged: (text) {
                          if (widget.onChanged != null) {
                            widget.onChanged!(text);
                          }
                          if (text.isNotEmpty) {
                            focusBgColor = Pallet.grey.shade500;
                            focusBorderColor = Pallet.grey.shade100;
                            if (mounted) {
                              setState(() {});
                            }
                          } else {
                            focusBgColor = Colors.transparent;
                            focusBorderColor = Pallet.grey.shade50;
                            if (mounted) {
                              setState(() {});
                            }
                          }
                        },
                        style: widget.textStyle ??
                            titleStyle.copyWith(
                              color: Pallet.black,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                            ),
                        controller: widget.controller,
                        inputFormatters: widget.inputFormatters ??
                            [
                              LengthLimitingTextInputFormatter(
                                  widget.maxLength ?? 100),
                            ],
                        obscureText:
                        widget.isPassword! ? obscureText : false,
                        decoration: widget.decoration ??
                            InputDecoration(
                              filled: false,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal:
                                  widget.horizontalpadding ??
                                      setWidth(20),
                                  vertical: widget.verticalpadding ??
                                      setHeight(14)),
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              errorBorder: InputBorder.none,
                              suffixIconConstraints:
                              const BoxConstraints(minHeight: 1),
                              hintText: widget.hint,
                              hintStyle:
                              widget.hintStyle ?? captionStyle,
                              labelText:
                              widget.isRequired! || widget.isHeader!
                                  ? null
                                  : widget.label,
                              isDense: true,
                              labelStyle:
                              widget.labelStyle ?? captionStyle,
                              prefixIcon: widget.prefixIcon != null
                                  ? IconButton(
                                  onPressed:
                                  widget.onPasswordToggle,
                                  icon: Icon(
                                    widget.prefixIcon,
                                    color: widget.iconColor ??
                                        Pallet.grey
                                            .withOpacity(0.7),
                                  ))
                                  : null,
                              errorStyle: const TextStyle(
                                  fontSize: 0, height: 0.0),
                              suffixIcon: widget.isPassword!
                                  ? Padding(
                                padding: const EdgeInsets.only(
                                    right: 20),
                                child: InkWell(
                                    onTap: showPassword,
                                    child: obscureText
                                        ? const Icon(Icons.visibility_off)
                                        : const Icon(Icons.visibility)),
                              )
                                  : widget.suffixWidget,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}
