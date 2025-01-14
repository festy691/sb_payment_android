library sb_payment_sdk;

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sb_payment_sdk/core/data/session_manager.dart';
import 'package:sb_payment_sdk/core/di/injection_container.dart';
import 'package:sb_payment_sdk/core/network/url_config.dart';
import 'package:sb_payment_sdk/models/api_response.dart';
import 'package:sb_payment_sdk/models/bank_account_model.dart';
import 'package:sb_payment_sdk/models/charge_model.dart';
import 'package:sb_payment_sdk/models/customer_detail_model.dart';
import 'package:sb_payment_sdk/screens/initial_screen.dart';

class StartButtonPlugin {
  bool _sdkInitialized = false;
  String _publicKey = "";
  List<BankAccountModel> _bankList = [];

  /// Initialize the Payment object. It should be called as early as possible
  /// (preferably in initState() of the Widget.
  ///
  /// [publicKey] - your startbutton public key. This is mandatory

  initialize({required String publicKey, bool isLive = false}) async {
    //initialize singletons
    await init(
        environment:
            //kReleaseMode ? Environment.production : Environment.production);
            isLive ? Environment.production : Environment.staging);

    assert(() {
      if (publicKey.isEmpty) {
        throw APIResponse(
            error: true, message: 'publicKey cannot be null or empty');
      }
      return true;
    }());

    if (sdkInitialized) return;

    this._publicKey = publicKey;

    SessionManager.instance.authToken = publicKey;
    _sdkInitialized = true;
  }

  dispose() {
    _publicKey = "";
    _sdkInitialized = false;
  }

  bool get sdkInitialized => _sdkInitialized;

  String get publicKey {
    // Validate that the sdk has been initialized
    _validateSdkInitialized();
    return _publicKey;
  }

  APIResponse _performChecks() {
    //validate that sdk has been initialized
    String? error = _validateSdkInitialized();
    if (error != null) return APIResponse(error: true, message: error);
    //check for null value, and length and starts with sb_
    if (_publicKey.isEmpty || !_publicKey.startsWith("sb_")) {
      return APIResponse(
          error: true,
          message:
              "Invalid public key. You must use a valid public key. Ensure that you have set a public key.");
    }
    return APIResponse(error: false, message: "Check completed");
  }

  /// Make payment by charging the user's card
  ///
  /// [context] - the widgets BuildContext
  ///
  /// [charge] - the charge object.

  Future<APIResponse> makePayment(BuildContext context,
      {required Payment charge}) async {
    APIResponse _checkResponse = _performChecks();
    if (_checkResponse.error) return _checkResponse;
    APIResponse? _response;
    String paymentReference =
        "SB-${DateTime.now().millisecondsSinceEpoch.toString()}";
    CustomerDetailModel customerDetailModel = CustomerDetailModel(
      customerEmail: charge.email,
      customerName: charge.customerName,
      reference: charge.reference ?? paymentReference,
    );

    _response = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => InitialScreen(
              customerDetailModel: customerDetailModel,
              amount: charge.amount,
              currencyType: charge.currencyType ?? CurrencyType.NGN,
            )));
    return _response ?? APIResponse(error: true, message: "Unknown error!!!");
  }

  /// Make payment using StartButton's checkout form. The plugin will handle the whole
  /// processes involved.
  ///
  /// [context] - the widget's BuildContext
  ///
  /// [charge] - the charge object.
  ///
  /// Notes:
  ///
  /// [hideEmail] - Whether to hide the email from the user. When
  /// `false` and an email is passed to the [charge] object, the email
  /// will be displayed at the top right edge of the UI prompt. Defaults to
  /// `false`
  ///
  /// [hideAmount]  - Whether to hide the amount from the  payment prompt.
  /// When `false` the payment amount and currency is displayed at the
  /// top of payment prompt, just under the email. Also the payment
  /// call-to-action will display the amount, otherwise it will display
  /// "Continue". Defaults to `false`
  ///
  ///
  String? _validateSdkInitialized() {
    if (!sdkInitialized) {
      return 'StartButton SDK has not been initialized. The SDK has'
          ' to be initialized before use';
    }
    return null;
  }
}
