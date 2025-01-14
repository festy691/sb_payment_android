import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDivider extends StatefulWidget {
  const AppDivider({super.key});

  @override
  State<AppDivider> createState() => _AppDividerState();
}

class _AppDividerState extends State<AppDivider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 0.5.h,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }
}
