import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

int secondsBetween(DateTime from, DateTime to) {
  from = DateTime(
      from.year, from.month, from.day, from.hour, from.minute, from.second);
  to = DateTime(to.year, to.month, to.day, to.hour, to.minute, to.second);
  return (to.difference(from).inSeconds).round();
}

void launchURL(Uri url) async {
  try {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  } catch (e) {
    log(e.toString());
  }
}

String maskValue(String value) {
  if (value.length < 12) {
    return value; // Return as-is if the number is too short
  }
  int visibleDigits = 6; // Number of visible digits at the start and end
  String start = value.substring(0, visibleDigits);
  String end = value.substring(value.length - visibleDigits);
  String masked = '*' * (value.length - visibleDigits * 2);
  return '$start$masked$end';
}

String formatMoney(dynamic amount, {int? decimalDigits, String name = "₵"}) {
  return NumberFormat.simpleCurrency(
          locale: 'en',
          name: name == "GHS" ? "₵" : name,
          decimalDigits: decimalDigits)
      .format(amount);
}

num formatStringAmount(String amount) {
  if (amount.isEmpty) return 0;
  return num.parse(amount.replaceAll(",", ""));
}

String formatNumber(int number) {
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(0)}M';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(0)}k';
  } else {
    return number.toString();
  }
}

String formNum(String inputString) {
  if (inputString.isEmpty) {
    return inputString;
  }
  String text1 = inputString;
  if (text1.split(".").length > 2) {
    text1 = customReplace(text1, ".", 2, "");
    return text1;
  } else if (text1.split(".").length == 2) {
    num n1 = num.parse(text1.split(".").first.replaceAll(",", ""));
    String decimalPlace = text1.split(".").skip(1).first;
    if (decimalPlace.split("").length > 2) {
      decimalPlace = decimalPlace.split("").elementAt(0) +
          decimalPlace.split("").elementAt(1);
    }
    String text2 =
        NumberFormat.decimalPattern().format(n1) + "." + decimalPlace;
    return text2;
  }
  String text3 = inputString.replaceAll(',', '');
  text1 = text3;
  return NumberFormat.decimalPattern().format(
    num.parse(text1),
  );
}

String customReplace(
    String text, String searchText, int replaceOn, String replaceText) {
  String data = text.split(".").first + "." + text.split(".").skip(1).first;
  return data;
}

String formatDate(String date, {String? format, Duration? duration}) {
  DateTime dateTime = DateTime.parse(date);
  date = dateTime.toIso8601String();
  if (!date.contains("-")) {
    return formatDate(
        DateTime.fromMillisecondsSinceEpoch(int.parse(date)).toIso8601String());
  } else if (date.contains("T")) {
    var dateTime = DateTime.parse(date);
    if (duration != null) {
      dateTime = dateTime.add(duration);
    }
    return DateFormat(format ?? 'MMM dd, yyyy HH:mm').format(dateTime);
  } else {
    return date;
  }
}

copyText(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));
  showToast("Copied!!!");
}

showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      fontSize: 16.sp);
}

String getFirstName(String name) {
  if (name.split(" ").isNotEmpty) {
    String text = name.split(" ").first;
    return text;
  }
  return "";
}

String getLastName(String name) {
  if (name.split(" ").skip(1).isNotEmpty) {
    String text = name.split(" ").skip(1).first;
    return text;
  }
  return "";
}

String getMiddleName(String name) {
  if (name.split(" ").skip(2).isNotEmpty) {
    String text = name.split(" ").skip(2).first;
    return text;
  }
  return "";
}
