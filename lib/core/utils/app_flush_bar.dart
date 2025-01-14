import 'package:another_flushbar/flushbar.dart';

import 'package:flutter/material.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';

class AppFlushBar {
  static void showSuccess({
    required BuildContext context,
    required String message,
    FlushbarPosition position = FlushbarPosition.BOTTOM,
    String title = "Success!",
    int duration = 4,
  }) {
    Flushbar(
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeOut,
      title: title,
      flushbarPosition: position,
      duration: Duration(seconds: duration),
      isDismissible: true,
      backgroundColor: Pallet.success,
      message: message,
      boxShadows: [
        BoxShadow(
          color: Pallet.primary.shade50,
          offset: const Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
    ).show(context);
  }

  static void showError({
    required BuildContext context,
    required String message,
    String title = "Error",
    FlushbarPosition position = FlushbarPosition.BOTTOM,
    int duration = 4,
  }) {
    Flushbar(
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeOut,
      title: title,
      flushbarPosition: position,
      duration: Duration(seconds: duration),
      isDismissible: true,
      backgroundColor: Pallet.error,
      message: message,
      boxShadows: [
        BoxShadow(
          color: Pallet.error.shade50,
          offset: const Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
    ).show(context);
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    String title = "Info",
    FlushbarPosition position = FlushbarPosition.TOP,
    int duration = 4,
  }) {
    Flushbar(
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeOut,
      title: title,
      flushbarPosition: position,
      duration: Duration(seconds: duration),
      isDismissible: true,
      backgroundColor: Pallet.orange,
      message: message,
      boxShadows: [
        BoxShadow(
          color: Pallet.error.shade50,
          offset: const Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
    ).show(context);
  }
}

