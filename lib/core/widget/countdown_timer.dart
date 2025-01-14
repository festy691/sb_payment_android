import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';

class CountdownTimer extends StatefulWidget {
  final int minutes; // Countdown starting minutes
  final int seconds; // Countdown starting seconds
  final Function onResendOtp;
  final Function onTimerEnd;
  final String message;
  final double fontSize;

  const CountdownTimer(
      {Key? key,
      this.minutes = 1,
      this.seconds = 0,
      required this.onResendOtp,
      required this.onTimerEnd,
      this.message = "This account will expire in ",
      this.fontSize = 11})
      : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int totalSeconds; // Total seconds for the countdown
  late Timer _timer;

  String formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    totalSeconds = widget.minutes * 60 + widget.seconds;
    startCountdown();
  }

  void startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (totalSeconds > 0) {
        setState(() {
          totalSeconds--;
        });
      } else {
        timer.cancel(); // Stop the timer when it reaches zero
        widget.onTimerEnd();
      }
    });
  }

  void resetCountdown() {
    setState(() {
      totalSeconds =
          widget.minutes * 60 + widget.seconds; // Reset to initial value
    });
    startCountdown();
  }

  void stopCountdown() {
    if (_timer.isActive) _timer.cancel(); // Safely cancel the timer
  }

  @override
  void dispose() {
    stopCountdown(); // Ensure the timer is cancelled when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onResendOtp(),
      child: Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
          children: [
            TextSpan(
              text: widget.message,
              style: GoogleFonts.hankenGrotesk(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: Pallet.hintColorLight),
            ),
            TextSpan(
              text: formatTime(totalSeconds),
              style: GoogleFonts.hankenGrotesk(
                  fontSize: widget.fontSize.sp,
                  fontWeight: FontWeight.w600,
                  color:
                      totalSeconds > 60 ? Pallet.textColorLight : Pallet.red),
            ),
          ],
        ),
      ),
    );
  }
}
