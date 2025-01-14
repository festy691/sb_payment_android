import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomSheets {
  static Future<T?> showSheet<T>(BuildContext context,
      {required Widget child, bool isDismissible = true}) {
    return showModalBottomSheet<T>(
        isDismissible: isDismissible,
        isScrollControlled: true,
        // backgroundColor: Colors.white.withOpacity(0.8),
        enableDrag: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        context: context,
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Icon(Icons.maximize),
              Flexible(child: child),
            ],
          );
        });
  }

  static PersistentBottomSheetController showPersistentSheet<T>(
      BuildContext context,
      {required Widget child}) {
    return showBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r), topRight: Radius.circular(12.r))),
        context: context,
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.maximize),
              Flexible(child: child),
            ],
          );
        });
  }
}
