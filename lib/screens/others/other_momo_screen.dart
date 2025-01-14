import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sb_payment_sdk/core/provider/payment_provider.dart';
import 'package:sb_payment_sdk/core/provider/result_provider.dart';
import 'package:sb_payment_sdk/core/utils/app_assets.dart';
import 'package:sb_payment_sdk/core/utils/page_router.dart';
import 'package:sb_payment_sdk/core/utils/pallet.dart';
import 'package:sb_payment_sdk/core/utils/utils.dart';
import 'package:sb_payment_sdk/core/widget/background_widget.dart';
import 'package:sb_payment_sdk/core/widget/custom_button.dart';
import 'package:sb_payment_sdk/core/widget/custom_dropdown.dart';
import 'package:sb_payment_sdk/core/widget/dialogs.dart';
import 'package:sb_payment_sdk/core/widget/edit_form_widget.dart';
import 'package:sb_payment_sdk/core/widget/footer_widget.dart';
import 'package:sb_payment_sdk/core/widget/header_widget.dart';
import 'package:sb_payment_sdk/core/widget/image_loader.dart';
import 'package:sb_payment_sdk/core/widget/tax_break_down_widget.dart';
import 'package:sb_payment_sdk/core/widget/text_views.dart';
import 'package:sb_payment_sdk/models/amount_breakdown_model.dart';
import 'package:sb_payment_sdk/models/api_response.dart';
import 'package:sb_payment_sdk/models/charge_model.dart';
import 'package:sb_payment_sdk/models/customer_detail_model.dart';
import 'package:sb_payment_sdk/models/paystack_detail_model.dart';
import 'package:sb_payment_sdk/models/service_provider_model.dart';
import 'package:sb_payment_sdk/screens/cedis/dialogs/register_name_dialog.dart';
import 'package:sb_payment_sdk/screens/paystack_screen.dart';
import 'package:sb_payment_sdk/screens/pending_momo_payment_screen.dart';

class OtherMomoScreen extends StatefulWidget {
  final routeName = "other-payment-type";
  num amount;
  CustomerDetailModel customerDetailModel;
  CurrencyType currencyType;

  OtherMomoScreen({
    super.key,
    required this.amount,
    required this.customerDetailModel,
    required this.currencyType,
  });

  @override
  State<OtherMomoScreen> createState() => _OtherMomoScreenState();
}

class _OtherMomoScreenState extends State<OtherMomoScreen> {
  late AmountBreakdownModel amountBreakdownModel;
  PaymentDetailModel? detailModel;

  final resultController = Get.find<ResultController>();

  final TextEditingController _phoneNumberController = TextEditingController();
  String _countryCode = "";
  String _phoneNumber = "";

  ServiceProviderModel? _selectedProvider;

  bool _isLoading = false;

  bool isBank = true;
  bool disableBank = false;

  bool _showLoader = false;
  _loadAccountInfo({String? paymentRef}) async {
    _showLoader = true;
    if (mounted) setState(() {});
    detailModel = PaymentProvider.instance.paystackDetailModel;
    List<String> _suppoertedPayments = [];
    if (detailModel?.paymentMethods != null) {
      for (String p in detailModel!.paymentMethods!) {
        if (p != "bank_transfer" && p != "momo") {
          _suppoertedPayments.add(p);
        }
      }
    }
    var result = await PaymentProvider.instance.initPaystack(
        payment: Payment(
            amount: widget.amount,
            email: widget.customerDetailModel.customerEmail,
            reference: widget.customerDetailModel.reference,
            currencyType: widget.currencyType,
            paymentMethods: _suppoertedPayments,
            customerName: widget.customerDetailModel.customerName));
    if (result.error) {
      _showLoader = false;
      if (mounted) setState(() {});
      resultController.setResult(result);
      PageRouter.goBack(context);
      return;
    }
    var response = await PaymentProvider.instance
        .loadTransactionDetails(token: PaymentProvider().token!);
    if (response.error) {
      _showLoader = false;
      if (mounted) setState(() {});
      resultController.setResult(response);
      PageRouter.goBack(context);
      return;
    }
    detailModel = PaymentProvider.instance.paystackDetailModel!;
    var serviceResult = await PaymentProvider.instance
        .getServiceProviders(transactionCode: PaymentProvider().token ?? "");
    if (serviceResult.error) {
      _showLoader = false;
      if (mounted) setState(() {});
      resultController.setResult(serviceResult);
      PageRouter.goBack(context);
      return;
    }

    if (detailModel!.isTaxed) {
      var taxResult = await PaymentProvider.instance.getTaxBreakDown(
          merchantId: detailModel?.merchantId ?? "",
          currency: widget.currencyType.name,
          transactionType: "collection",
          amount: widget.amount);
      if (taxResult.error) {
        _showLoader = false;
        if (mounted) setState(() {});
        resultController.setResult(taxResult);
        PageRouter.goBack(context);
        return;
      }
      amountBreakdownModel = PaymentProvider.instance.amountBreakdownModel!;
    }
    _showLoader = false;
    if (mounted) setState(() {});
  }

  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amountBreakdownModel = AmountBreakdownModel(
        total: widget.amount,
        subtotal: widget.amount,
        taxAndLevy: 0,
        taxBreak: []);
    _loadAccountInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      hasPadding: true,
      shouldExit: true,
      onPopResult: (status, result) {
        if (resultController.resultCode.value == 0) {
          resultController.setResult(APIResponse(
              error: true, message: "The request was canceled!!!", data: null));
        }
      },
      body: SafeArea(
        child: _showLoader
            ? Center(
                child: ImageLoader(
                  path: AppAssets.sbLoaderGif,
                  width: 200.w,
                  height: 100.h,
                  fit: BoxFit.fitWidth,
                ),
              )
            : ListView(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                children: [
                  HeaderWidget(
                    logo: detailModel
                        ?.merchantLogo, //widget.customerDetailModel.businessLogo,
                    businessEmail: detailModel?.merchantEmail ??
                        "", //widget.customerDetailModel.businessEmail,
                    businessName: detailModel?.merchantName ??
                        "", //widget.customerDetailModel.businessName,
                    child: Column(
                      children: [
                        TaxBreakDownWidget(
                          currency: widget.currencyType.name,
                          amountBreakdownModel: amountBreakdownModel,
                          showTax: detailModel?.isTaxed ?? false,
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        SizedBox(
                          height: 32.h,
                        ),
                        PhoneNumberField(
                          hint: "8121234532",
                          label: "Mobile number",
                          initialValue:
                              widget.currencyType.name.split("").first +
                                  widget.currencyType.name.split("")[1],
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
                                      customerDetailModel:
                                          widget.customerDetailModel,
                                      amount: widget.amount,
                                      currency: widget.currencyType,
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
                                var result = await PaymentProvider.instance
                                    .initMomoPayment(
                                        payment: Payment(
                                            amount: widget.amount ~/ 100,
                                            email: widget.customerDetailModel
                                                .customerEmail,
                                            phoneNumber:
                                                _countryCode + _phoneNumber,
                                            provider: _selectedProvider?.code,
                                            currencyType: widget.currencyType,
                                            customerName: widget
                                                .customerDetailModel
                                                .customerName));
                                _isLoading = false;
                                if (mounted) setState(() {});
                                if (result.error) {
                                  return showToast(result.message);
                                }
                                if (PaymentProvider
                                        .instance.momoResponseModel?.nextStep
                                        ?.toLowerCase() ==
                                    "otp") {
                                  AppDialog.showCustomDialog(context,
                                      widget: RegisterNameDialog(
                                        customerDetailModel:
                                            widget.customerDetailModel,
                                        amount: widget.amount,
                                      ),
                                      isDismissible: false,
                                      width: 340.w,
                                      radius: 4.r);
                                } else {
                                  PageRouter.gotoWidget(
                                      PendingMomoPaymentScreen(
                                        transferDetailModel: PaymentProvider
                                            .instance.transferDetailModel!,
                                        customerDetailModel:
                                            widget.customerDetailModel,
                                        amount: widget.amount,
                                        currencyType: widget.currencyType,
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
                    ),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  FooterWidget(
                    businessName: detailModel?.merchantName ??
                        "", //widget.customerDetailModel.businessName,
                  )
                ],
              ),
      ),
    );
  }
}
