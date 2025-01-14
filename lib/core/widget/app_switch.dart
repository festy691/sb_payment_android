import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.selected,
    required this.onTap,
  });
  final bool selected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        alignment: selected ? Alignment.centerRight : Alignment.centerLeft,
        padding: const EdgeInsets.all(1),
        width: 38.w,
        height: 16.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: selected ? const Color(0xff0061F3) : Colors.white,
          border: Border.all(
            color: selected ? const Color(0xff0061F3) : const Color(0xffC5CCD6),
          ),
        ),
        child: Container(
          width: 14.w,
          height: 14.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? Colors.white : const Color(0xffC5CCD6),
          ),
        ),
      ),
    );
  }
}
