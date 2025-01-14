import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sb_payment_sdk/core/provider/payment_provider.dart';
import 'package:sb_payment_sdk/core/utils/app_assets.dart';
import 'package:sb_payment_sdk/core/utils/page_router.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';
import 'package:sb_payment_sdk/core/utils/utils.dart';
import 'package:sb_payment_sdk/core/widget/countdown_timer.dart';
import 'package:sb_payment_sdk/core/widget/custom_button.dart';
import 'package:sb_payment_sdk/core/widget/text_views.dart';
import 'package:sb_payment_sdk/models/charge_model.dart';
import 'package:sb_payment_sdk/models/customer_detail_model.dart';
import 'package:sb_payment_sdk/screens/confirm_sent_transfer_screen.dart';
import 'package:sb_payment_sdk/screens/paystack_screen.dart';
import 'package:sb_payment_sdk/screens/transfer_timeout_screen.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class GHSBankTransferView extends StatefulWidget {
  CustomerDetailModel customerDetailModel;
  num amount;
  int countDownMinutes;
  int countDownSeconds;
  OnRetry onRetry;
  GHSBankTransferView(
      {super.key,
      required this.amount,
      required this.customerDetailModel,
      required this.countDownMinutes,
      required this.countDownSeconds,
      required this.onRetry});

  @override
  State<GHSBankTransferView> createState() => _GHSBankTransferViewState();
}

class _GHSBankTransferViewState extends State<GHSBankTransferView>
    with RouteAware {
  Key _widgetKey = UniqueKey();
  bool _isActive = false;

  void _rebuildWidget() {
    setState(() {
      _widgetKey = UniqueKey(); // Change the key to force recreation
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    // The screen became active
    _isActive = true;
  }

  @override
  void didPopNext() {
    // Returned to this screen from a child screen
    _isActive = true;
  }

  @override
  void didPop() {
    // The screen is being popped
    _isActive = false;
  }

  @override
  void didPushNext() {
    // Navigated to a child screen
    _isActive = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16.h,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            border: Border.all(width: 0.5.w, color: Pallet.hintColor),
            color: Pallet.taxWidgetColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextView(
                text: "PAY WITH YOUR BANKING APP",
                textStyle: GoogleFonts.hankenGrotesk(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Pallet.dark),
              ),
              SizedBox(
                height: 8.h,
              ),
              _rowItems(context,
                  mainText: "Open the ",
                  boldText: "transfer section ",
                  trailing: "on your banking app."),
              _rowItems(context,
                  mainText: "Select ",
                  boldText:
                      "${PaymentProvider.instance.transferDetailModel?.bankName} ",
                  trailing: "as the recipient bank."),
              _rowItems(context,
                  mainText: "Enter this account number: ",
                  boldText:
                      "${PaymentProvider.instance.transferDetailModel?.accountNumber}",
                  hasCopy: true),
              _rowItems(context,
                  mainText: "Confirm recipient as: ",
                  boldText:
                      "${PaymentProvider.instance.transferDetailModel?.accountName}"),
              _rowItems(context,
                  mainText: "Enter amount: ",
                  boldText:
                      "${formatMoney((PaymentProvider.instance.paystackDetailModel?.amount ?? 1) / 100, name: CurrencyType.GHS.name)} ",
                  trailing: "and make the transfer"),
              _rowItems(context,
                  mainText: "Click: ",
                  boldText: '"I`ve made the transfer" ',
                  trailing: "beneath after the transfer is successful!"),
            ],
          ),
        ),
        SizedBox(
          height: 12.h,
        ),
        CountdownTimer(
          minutes: widget.countDownMinutes,
          seconds: widget.countDownSeconds,
          key: _widgetKey,
          onResendOtp: () async {
            if (mounted) setState(() {});
          },
          onTimerEnd: () {
            if (mounted && _isActive) {
              PageRouter.gotoWidget(
                  TransferTimeoutScreen(
                    transferDetailModel:
                        PaymentProvider.instance.transferDetailModel!,
                    customerDetailModel: widget.customerDetailModel,
                    amountBreakdownModel:
                        PaymentProvider.instance.amountBreakdownModel!,
                    currencyType: CurrencyType.GHS,
                    onRetry: () {
                      widget.onRetry();
                      _rebuildWidget();
                    },
                    onSwitchPayment: () {
                      PageRouter.goBack(context);
                      PageRouter.replacePage(
                          context,
                          PaystackScreen(
                            customerDetailModel: widget.customerDetailModel,
                            amount: PaymentProvider
                                    .instance.amountBreakdownModel?.total ??
                                0,
                            currency: CurrencyType.GHS,
                          ));
                    },
                  ),
                  context);
            }
          },
        ),
        SizedBox(
          height: 16.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomButtonWidget(
            buttonText: 'I’ve made the transfer',
            buttonColor: Pallet.buttonColor,
            fontSize: 12.sp,
            height: 42.h,
            width: 1.sw,
            onTap: () async {
              PageRouter.gotoWidget(
                  ConfirmSentTransferScreen(
                    transferDetailModel:
                        PaymentProvider.instance.transferDetailModel!,
                    customerDetailModel: widget.customerDetailModel,
                    amountBreakdownModel:
                        PaymentProvider.instance.amountBreakdownModel,
                    currencyType: CurrencyType.GHS,
                    onRetry: () {
                      widget.onRetry();
                      _rebuildWidget();
                    },
                  ),
                  context);
            },
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        GestureDetector(
          onTap: () {
            PageRouter.replacePage(
                context,
                PaystackScreen(
                  customerDetailModel: widget.customerDetailModel,
                  amount: widget.amount,
                  currency: CurrencyType.GHS,
                ));
          },
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppAssets.changeOrange,
                  width: 16.w,
                  height: 16.h,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(width: 4.w),
                TextView(
                  text: "More payment methods",
                  textStyle: GoogleFonts.hankenGrotesk(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Pallet.buttonColor,
                    //decoration: TextDecoration.underline
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _rowItems(BuildContext context,
      {required String mainText,
      String? boldText,
      String? trailing,
      bool hasCopy = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(
                height: 8.h,
              ),
              Container(
                width: 4.w,
                height: 4.w,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Pallet.dark),
              ),
            ],
          ),
          SizedBox(
            width: 16.w,
          ),
          Expanded(
            child: Wrap(
              children: [
                TextView(
                  text: mainText,
                  textStyle: GoogleFonts.hankenGrotesk(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Pallet.textColorLight),
                ),
                if (boldText != null) ...[
                  TextView(
                    text: boldText,
                    textStyle: GoogleFonts.hankenGrotesk(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: Pallet.dark),
                  ),
                ],
                if (hasCopy) ...[
                  SizedBox(
                    width: 4.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      copyText(context, boldText ?? "");
                    },
                    child: Icon(
                      Icons.copy,
                      size: 18.w,
                      color: Pallet.hintColorLight,
                    ),
                  ),
                ],
                if (trailing != null) ...[
                  TextView(
                    text: trailing,
                    textStyle: GoogleFonts.hankenGrotesk(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Pallet.textColorLight),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
