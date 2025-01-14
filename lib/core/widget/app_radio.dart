import 'package:flutter/material.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';

class AppRadio extends StatelessWidget {
  const AppRadio({
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
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? const Color(0xff0061F3) : Pallet.white,
          border: Border.all(
            color: selected ? Colors.transparent : const Color(0xffC5CCD6),
          ),
        ),
        child: Container(
          height: 5,
          width: 5,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Pallet.white,
          ),
        ),
      ),
    );
  }
}
