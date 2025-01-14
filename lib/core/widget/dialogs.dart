import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sb_payment_sdk/core/widget/flutter_custom_dialog.dart';

class AppDialog {
  AppDialog._();

  defaultDialog(String title, Widget content,
      {bool isDismissible = false, Widget? confirm, Widget? cancel}) {
    return Get.defaultDialog(
      title: title,
      content: content,
      cancel: cancel ?? null,
      confirm: confirm ?? null,
      barrierDismissible: isDismissible,
      radius: 10,
    );
  }

  customisedDialog(
    Widget widget, {
    bool isDismissible = false,
  }) {
    return Get.dialog(widget, barrierDismissible: isDismissible);
  }

  static YYDialog showCustomDialog(BuildContext context,
      {required Widget widget,
      double width = 450,
      double radius = 16,
      bool isDismissible = true}) {
    return YYDialog().build(context)
      ..width = width
      //..height = setHeight(448)
      ..borderRadius = radius
      ..barrierDismissible = isDismissible
      ..widget(
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return widget;
        }),
      )
      ..show();
  }
}
