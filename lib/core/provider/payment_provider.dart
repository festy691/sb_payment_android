import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:sb_payment_sdk/core/di/injection_container.dart';
import 'package:sb_payment_sdk/core/services/auth_service.dart';
import 'package:sb_payment_sdk/models/api_response.dart';
import 'package:sb_payment_sdk/models/charge_model.dart';
import 'package:sb_payment_sdk/models/manual_verification_model.dart';
import 'package:sb_payment_sdk/models/paystack_detail_model.dart';
import 'package:sb_payment_sdk/models/transfer_detail_model.dart';

class PaymentProvider {

  PaymentProvider._internal();

  static PaymentProvider _instance = PaymentProvider._internal();

  factory PaymentProvider() => _instance;

  static PaymentProvider get instance => _instance;

  TransferDetailModel? transferDetailModel;
  PaystackDetailModel? paystackDetailModel;
  ManualVerificationModel? manualVerificationModel;
  String? token;
  String? url;

  bool initializing = false;
  bool loading = false;

  Future<APIResponse> initTransfer ({required Payment payment}) async {
    try {
      initializing = true;
      AuthService _authService = sl();
      APIResponse _response = await _authService.initTransfer(payment: payment);
      if(_response.error) return APIResponse(error: true, message: 'Transfer initialization failed');
      print(_response.data);
      transferDetailModel = TransferDetailModel.fromJson(_response.data);
      initializing = false;
      return _response;
    } catch (e){
      initializing = false;
      return APIResponse(error: true, message: e.toString());
    }
  }

  Future<APIResponse> manualConfirmation ({required String paymentCode}) async {
    try {
      loading = true;
      AuthService _authService = sl();
      APIResponse _response = await _authService.manualVerification(paymentCode: paymentCode);
      if(_response.error) return APIResponse(error: true, message: 'Confirm payment failed');
      manualVerificationModel = ManualVerificationModel.fromJson(_response.data);
      loading = false;
      return _response;
    } catch (e){
      loading = false;
      return APIResponse(error: true, message: e.toString());
    }
  }

  Future<APIResponse> decodePaystack ({required String token}) async {
    try {
      initializing = true;
      AuthService _authService = sl();
      APIResponse _response = await _authService.decodePaystackToken(token: token);
      if(_response.error) return APIResponse(error: true, message: 'Token decode failed');
      paystackDetailModel = PaystackDetailModel.fromJson(_response.data);
      initializing = false;
      return _response;
    } catch (e){
      initializing = false;
      return APIResponse(error: true, message: e.toString());
    }
  }

  Future<APIResponse> initPaystack ({required Payment payment}) async {
    try {
      initializing = true;
      AuthService _authService = sl();
      APIResponse _response = await _authService.initPaystack(payment: payment);
      if(_response.error) return APIResponse(error: true, message: 'Transfer initialization failed');
      token = _response.data.toString().split("#/").last;
      url = _response.data.toString();
      initializing = false;
      return _response;
    } catch (e){
      initializing = false;
      return APIResponse(error: true, message: e.toString());
    }
  }


  PaymentCard cardInfo({
    required String cardnumber,
    required String cvv,
    required int expiryMonth,
    required int expiryYear,
    //required String cardname,
  }) {
    return PaymentCard(
        number: cardnumber,
        cvc: cvv,
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
        //name: cardname
    );
  }
}