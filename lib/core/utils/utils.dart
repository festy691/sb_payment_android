import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

int secondsBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day, from.hour, from.minute, from.second);
  to = DateTime(to.year, to.month, to.day, to.hour, to.minute, to.second);
  return (to.difference(from).inSeconds).round();
}

String formatMoney(dynamic amount, {int? decimalDigits, String name = "NGN"}) {
  return NumberFormat.simpleCurrency(
          locale: Platform.localeName, name: name, decimalDigits: decimalDigits)
      .format(amount);
}

num convertStringAmountToNum(String amount){
  return num.parse(amount.replaceAll(",", ""));
}

String formatDate(String date, {String? format, Duration? duration}) {
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

String formatStringDate(String date) {
  String day = date.split("-").first;
  String month = date.split("-").skip(1).first;
  String year = date.split("-").skip(2).first;

  if (day.split("").length == 4) return date.split("T").first;

  return "${getYear(int.parse(year))}-${getMonth(month)}-$day";
}

String formatOnlyDate(DateTime date) {
  int day = date.day;
  int month = date.month;
  int year = date.year;

  return "$day/$month/$year";
}

String formatOnlyTime(TimeOfDay time) {
  int hour = time.hour;
  int minute = time.minute;
  String period = time.period.name;

  return "$hour:$minute $period";
}

String getMonth(String month) {
  switch (month.toLowerCase()) {
    case "dec":
      return "12";
    case "nov":
      return "11";
    case "oct":
      return "10";
    case "sep":
      return "9";
    case "aug":
      return "8";
    case "jul":
      return "7";
    case "jun":
      return "6";
    case "may":
      return "5";
    case "apr":
      return "4";
    case "mar":
      return "3";
    case "feb":
      return "2";
    case "jan":
      return "1";
    default:
      return month;
  }
}

int getYear(int year) {
  if (year > 23 && year < 1000) {
    return year + 1900;
  } else if (year < 23 && year < 1000) {
    return year + 2000;
  } else {
    return year;
  }
}

String getFirstName(String name) {
  if (name.split(" ").isNotEmpty) {
    String text = name.split(" ").first;
    print("Last name: $text");
    return text;
  }
  return "";
}

String getLastName(String name) {
  if (name.split(" ").skip(1).isNotEmpty) {
    String text = name.split(" ").skip(1).first;
    print("First name: $text");
    return text;
  }
  return "";
}

String getMiddleName(String name) {
  if (name.split(" ").skip(2).isNotEmpty) {
    String text = name.split(" ").skip(2).first;
    print("Middle name: $text");
    return text;
  }
  return "";
}

String customReplace(
    String text, String searchText, int replaceOn, String replaceText) {
  String data = text.split(".").first + "." + text.split(".").skip(1).first;
  return data;
}


String formatCardnumber(String input) {
  input = input.replaceAll(RegExp(r'\s'), ''); // Remove existing spaces
  RegExp fourDigits = RegExp(r".{1,4}");
  Iterable<RegExpMatch> matches = fourDigits.allMatches(input);
  List<String> groups = matches.map((match) => match.group(0)!).toList();
  String formattedString = groups.join(' ');
  return formattedString;
}

String formatExpirydate(String input) {
  input =
      input.replaceAll(RegExp(r'[^0-9]'), ''); // Remove non-numeric characters
  List<String> chunks = [];
  for (int i = 0; i < input.length; i += 2) {
    int end = i + 2;
    if (end > input.length) {
      end = input.length;
    }
    chunks.add(input.substring(i, end));
  }
  String formattedString = chunks.join('/');
  return formattedString;
}
