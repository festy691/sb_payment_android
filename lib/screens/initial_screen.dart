import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sb_payment_sdk/core/provider/result_provider.dart';
import 'package:sb_payment_sdk/core/utils/app_assets.dart';
import 'package:sb_payment_sdk/core/widget/background_widget.dart';
import 'package:sb_payment_sdk/core/widget/image_loader.dart';
import 'package:sb_payment_sdk/models/api_response.dart';
import 'package:sb_payment_sdk/models/charge_model.dart';
import 'package:sb_payment_sdk/models/customer_detail_model.dart';
import 'package:sb_payment_sdk/screens/cedis/cedis_payment_type_screen.dart';
import 'package:sb_payment_sdk/screens/naira/naira_transfer_screen.dart';
import 'package:sb_payment_sdk/screens/others/other_momo_screen.dart';
import 'package:sb_payment_sdk/screens/paystack_screen.dart';

typedef OnComplete = Function();

class InitialScreen extends StatefulWidget {
  num amount;
  CustomerDetailModel customerDetailModel;
  CurrencyType currencyType;
  InitialScreen(
      {super.key,
      required this.amount,
      required this.customerDetailModel,
      required this.currencyType});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  _loadScreen() async {
    await Future.delayed(const Duration(seconds: 0));
    if (widget.currencyType == CurrencyType.NGN) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NairaTransferScreen(
                amount: widget.amount,
                customerDetailModel: widget.customerDetailModel,
              )));
    } else if (widget.currencyType == CurrencyType.GHS) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CedisPaymentTypeScreen(
                amount: widget.amount,
                customerDetailModel: widget.customerDetailModel,
              )));
    } else if (widget.currencyType == CurrencyType.USD ||
        widget.currencyType == CurrencyType.ZAR) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaystackScreen(
                amount: widget.amount,
                customerDetailModel: widget.customerDetailModel,
                currency: widget.currencyType,
              )));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OtherMomoScreen(
                currencyType: widget.currencyType,
                amount: widget.amount,
                customerDetailModel: widget.customerDetailModel,
              )));
    }
  }

  APIResponse? response;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultController = Get.put(ResultController(), permanent: true);

    return ScreenUtilInit(
      designSize: const Size(414, 896),
      builder: (context, child) => BackgroundWidget(
        shouldExit: true,
        body: Obx(() {
          if (resultController.isFirsLoad.value) {
            resultController.isFirsLoad.value = false;
            _loadScreen();
          }
          if (resultController.resultCode.value > 0) {
            response = resultController.response;
            resultController.resetResult();
            Future.delayed(const Duration(milliseconds: 2000))
                .then((_) => Navigator.of(context).pop(response));
          }
          return Center(
            child: ImageLoader(
              path: AppAssets.sbLoaderGif,
              width: 200.w,
              height: 100.h,
              fit: BoxFit.fitWidth,
            ),
          );
        }),
      ),
    );
  }
}
