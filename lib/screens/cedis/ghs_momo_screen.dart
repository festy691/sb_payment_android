import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sb_payment_sdk/core/provider/payment_provider.dart';
import 'package:sb_payment_sdk/core/utils/app_assets.dart';
import 'package:sb_payment_sdk/core/utils/page_router.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';
import 'package:sb_payment_sdk/core/utils/utils.dart';
import 'package:sb_payment_sdk/core/widget/custom_button.dart';
import 'package:sb_payment_sdk/core/widget/custom_dropdown.dart';
import 'package:sb_payment_sdk/core/widget/dialogs.dart';
import 'package:sb_payment_sdk/core/widget/edit_form_widget.dart';
import 'package:sb_payment_sdk/core/widget/image_loader.dart';
import 'package:sb_payment_sdk/core/widget/text_views.dart';
import 'package:sb_payment_sdk/models/charge_model.dart';
import 'package:sb_payment_sdk/models/customer_detail_model.dart';
import 'package:sb_payment_sdk/models/service_provider_model.dart';
import 'package:sb_payment_sdk/screens/cedis/dialogs/register_name_dialog.dart';
import 'package:sb_payment_sdk/screens/confirm_sent_transfer_screen.dart';
import 'package:sb_payment_sdk/screens/paystack_screen.dart';
import 'package:sb_payment_sdk/screens/pending_momo_payment_screen.dart';
import 'package:sb_payment_sdk/screens/transfer_timeout_screen.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class GhsMomoScreen extends StatefulWidget {
  CustomerDetailModel customerDetailModel;
  num amount;
  int countDownMinutes;
  OnRetry onRetry;
  GhsMomoScreen(
      {super.key,
      required this.amount,
      required this.customerDetailModel,
      required this.countDownMinutes,
      required this.onRetry});

  @override
  State<GhsMomoScreen> createState() => _GhsMomoScreenState();
}

class _GhsMomoScreenState extends State<GhsMomoScreen> with RouteAware {
  Key _widgetKey = UniqueKey();
  bool _isActive = false;
  bool _isLoading = false;

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

  final TextEditingController _phoneNumberController = TextEditingController();
  String _countryCode = "";
  String _phoneNumber = "";

  ServiceProviderModel? _selectedProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 32.h,
        ),
        PhoneNumberField(
          hint: "8121234532",
          label: "Mobile number",
          initialValue: "GH",
          controller: _phoneNumberController,
          //suffixWidget: const Icon(Icons.phone),
          onChanged: (value) {
            _countryCode = value.countryCode;
            _phoneNumber = value.number;
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        LayoutBuilder(builder: (context, constraints) {
          double parentWidth = constraints.maxWidth;
          return CustomDropdownInput<ServiceProviderModel>(
            label: 'Select provider',
            suffixWidget: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Pallet.iconTint,
            ),
            options: PaymentProvider.instance.serviceProviders,
            value: _selectedProvider,
            width: parentWidth - 80.w,
            onChanged: (value) {
              _selectedProvider = value;
              if (mounted) {
                setState(() {});
              }
            },
            getLabel: (value) => value?.name ?? "",
          );
        }),
        SizedBox(
          height: 24.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
            CustomButtonWidget(
              buttonText: 'Initiate',
              buttonColor: Pallet.buttonColor,
              fontSize: 12.sp,
              height: 42.h,
              width: 160.w,
              disabled: _isLoading,
              onTap: () async {
                _isLoading = true;
                if (mounted) setState(() {});
                var result = await PaymentProvider.instance.initMomoPayment(
                    payment: Payment(
                        amount: widget.amount ~/ 100,
                        email: widget.customerDetailModel.customerEmail,
                        phoneNumber: _countryCode + _phoneNumber,
                        provider: _selectedProvider?.code,
                        currencyType: CurrencyType.GHS,
                        customerName: widget.customerDetailModel.customerName));
                _isLoading = false;
                if (mounted) setState(() {});
                if (result.error) return showToast(result.message);
                if (PaymentProvider.instance.momoResponseModel?.nextStep
                        ?.toLowerCase() ==
                    "otp") {
                  AppDialog.showCustomDialog(context,
                      widget: RegisterNameDialog(
                        customerDetailModel: widget.customerDetailModel,
                        amount: widget.amount,
                      ),
                      isDismissible: false,
                      width: 340.w,
                      radius: 4.r);
                } else {
                  PageRouter.gotoWidget(
                      PendingMomoPaymentScreen(
                        transferDetailModel:
                            PaymentProvider.instance.transferDetailModel!,
                        customerDetailModel: widget.customerDetailModel,
                        amount: widget.amount,
                        currencyType: CurrencyType.GHS,
                      ),
                      context);
                }
              },
            ),
          ],
        ),
        if (_isLoading) ...[
          SizedBox(
            height: 16.h,
          ),
          ImageLoader(
            path: AppAssets.loaderLottie,
            width: 100.w,
            height: 30.h,
          ),
        ],
      ],
    );
  }
}
