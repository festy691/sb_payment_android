import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextView extends StatelessWidget {
  final String text;
  final TextOverflow? textOverflow;
  final TextAlign? textAlign;
  final Function()? onTap;
  final int? maxLines;
  final double? textSize;
  final TextStyle? textStyle;
  final Color? textColor;

  TextView({
    required this.text,
    this.textOverflow = TextOverflow.clip,
    this.textAlign = TextAlign.left,
    this.onTap,
    this.textStyle,
    this.textColor,
    this.textSize,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: textStyle ??
            GoogleFonts.inter(
              fontSize: textSize ?? 14.sp,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
        textAlign: textAlign,
        overflow: textOverflow,
        maxLines: maxLines,
      ),
    );
  }
}
