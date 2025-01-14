import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';
import 'package:sb_payment_sdk/core/utils/utils.dart';
import 'package:sb_payment_sdk/core/widget/text_views.dart';
import 'package:sb_payment_sdk/models/amount_breakdown_model.dart';

class TaxBreakDownWidget extends StatefulWidget {
  bool showTax;
  String currency;
  AmountBreakdownModel amountBreakdownModel;
  TaxBreakDownWidget(
      {super.key,
      this.showTax = true,
      required this.currency,
      required this.amountBreakdownModel});

  @override
  State<TaxBreakDownWidget> createState() => _TaxBreakDownWidgetState();
}

class _TaxBreakDownWidgetState extends State<TaxBreakDownWidget> {
  bool _showMore = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: widget.showTax
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: [
          if (widget.showTax) ...[
            _taxWidget(model: widget.amountBreakdownModel),
          ],
          Column(
            crossAxisAlignment: widget.showTax
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.center,
            children: [
              TextView(
                text: "TOTAL TO BE PAID",
                textStyle: GoogleFonts.hankenGrotesk(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Pallet.textColorLight),
              ),
              TextView(
                text: formatMoney(widget.amountBreakdownModel.total / 100,
                    name: widget.currency),
                textStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Pallet.textColorLight),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _taxWidget({required AmountBreakdownModel model}) {
    return Container(
      width: 171.w,
      decoration: BoxDecoration(
        color: Pallet.taxWidgetColor,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: Pallet.hintColor, width: 0.5.w),
      ),
      child: Column(
        children: [
          _listTile(
            title: "Subtotal",
            value: model.subtotal,
          ),
          Divider(color: Pallet.hintColor, thickness: 0.5.w),
          _listTile(
            title: "Tax & Levy",
            value: model.subtotal,
          ),
          if (_showMore) ...[
            for (TaxBreak tx in model.taxBreak) ...[
              Divider(color: Pallet.hintColor, thickness: 0.5.w),
              _listTile(
                title: tx.name,
                value: tx.amount,
              ),
            ],
          ],
          if (model.taxBreak.isNotEmpty) ...[
            SizedBox(
              height: 16.h,
              child: GestureDetector(
                onTap: () {
                  _showMore = !_showMore;
                  if (mounted) {
                    setState(() {});
                  }
                },
                child: Icon(
                  _showMore
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Pallet.hintColor,
                  size: 16.w,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _listTile(
      {required String title, required num value, double fontSize = 9}) {
    return Container(
      width: 171.w,
      height: 20.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextView(
            text: title,
            textStyle: GoogleFonts.hankenGrotesk(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: Pallet.textColorLight),
          ),
          TextView(
            text: formatMoney(value / 100, name: widget.currency),
            textStyle: GoogleFonts.hankenGrotesk(
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                color: Pallet.hintColorLight),
          ),
        ],
      ),
    );
  }
}
