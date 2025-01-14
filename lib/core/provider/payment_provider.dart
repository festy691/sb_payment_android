import 'package:sb_payment_sdk/core/di/injection_container.dart';
import 'package:sb_payment_sdk/core/services/auth_service.dart';
import 'package:sb_payment_sdk/models/amount_breakdown_model.dart';
import 'package:sb_payment_sdk/models/api_response.dart';
import 'package:sb_payment_sdk/models/charge_model.dart';
import 'package:sb_payment_sdk/models/manual_verification_model.dart';
import 'package:sb_payment_sdk/models/momo_response_model.dart';
import 'package:sb_payment_sdk/models/paystack_detail_model.dart';
import 'package:sb_payment_sdk/models/service_provider_model.dart';
import 'package:sb_payment_sdk/models/transfer_detail_model.dart';

class PaymentProvider {
  PaymentProvider._internal();

  static PaymentProvider _instance = PaymentProvider._internal();

  factory PaymentProvider() => _instance;

  static PaymentProvider get instance => _instance;

  TransferDetailModel? transferDetailModel;
  PaymentDetailModel? paystackDetailModel;
  ManualVerificationModel? manualVerificationModel;
  AmountBreakdownModel? amountBreakdownModel;
  MomoResponseModel? momoResponseModel;
  String? token;
  String? url;

  List<ServiceProviderModel> serviceProviders = [];

  bool initializing = false;
  bool loading = false;

  Future<APIResponse> initTransfer({required Payment payment}) async {
    try {
      initializing = true;
      AuthService _authService = sl();
      APIResponse _response = await _authService.initTransfer(payment: payment);

      if (!_response.error) {
        transferDetailModel = TransferDetailModel.fromJson(_response.data);
        initializing = false;
      }
      return _response;
    } catch (e) {
      initializing = false;
      return APIResponse(error: true, message: e.toString());
    }
  }

  Future<APIResponse> manualConfirmation({required String paymentCode}) async {
    try {
      loading = true;
      AuthService _authService = sl();
      APIResponse _response =
          await _authService.manualVerification(paymentCode: paymentCode);
      if (!_response.error) {
        manualVerificationModel =
            ManualVerificationModel.fromJson(_response.data);
        loading = false;
      }
      return _response;
    } catch (e) {
      loading = false;
      return APIResponse(error: true, message: e.toString());
    }
  }

  Future<APIResponse> getTaxBreakDown(
      {required String merchantId,
      required String currency,
      required String transactionType,
      required num amount}) async {
    try {
      initializing = true;
      AuthService _authService = sl();
      APIResponse _response = await _authService.getTaxBreakdown(
          merchantId: merchantId,
          currency: currency,
          transactionType: transactionType,
          amount: amount);
      if (!_response.error) {
        amountBreakdownModel = AmountBreakdownModel.fromJson(_response.data);
        initializing = false;
      }
      return _response;
    } catch (e) {
      initializing = false;
      return APIResponse(error: true, message: e.toString());
    }
  }

  Future<APIResponse> loadTransactionDetails({required String token}) async {
    try {
      initializing = true;
      AuthService _authService = sl();
      APIResponse _response =
          await _authService.decodePaystackToken(token: token);
      if (!_response.error) {
        paystackDetailModel = PaymentDetailModel.fromJson(_response.data);
        initializing = false;
      }
      return _response;
    } catch (e) {
      initializing = false;
      return APIResponse(error: true, message: e.toString());
    }
  }

  Future<APIResponse> initPaystack({required Payment payment}) async {
    try {
      initializing = true;
      AuthService _authService = sl();
      APIResponse _response = await _authService.initPaystack(payment: payment);
      if (!_response.error) {
        token = _response.data.toString().split("#/").last;
        url = _response.data.toString();
        initializing = false;
      }
      return _response;
    } catch (e) {
      initializing = false;
      return APIResponse(error: true, message: e.toString());
    }
  }

  Future<APIResponse> initMomoPayment({required Payment payment}) async {
    try {
      AuthService _authService = sl();
      APIResponse _response =
          await _authService.initMomoPayment(payment: payment);
      if (!_response.error) {
        momoResponseModel = MomoResponseModel.fromJson(_response.data);
      }
      return _response;
    } catch (e) {
      return APIResponse(error: true, message: e.toString());
    }
  }

  Future<APIResponse> verifyMomoOTP(
      {required String customerName,
      required String reference,
      required String otp}) async {
    try {
      AuthService _authService = sl();
      APIResponse _response = await _authService.verifyMomoOTP(
          customerName: customerName, reference: reference, otp: otp);
      return _response;
    } catch (e) {
      return APIResponse(error: true, message: e.toString());
    }
  }

  Future<APIResponse> getServiceProviders(
      {required String transactionCode}) async {
    try {
      AuthService _authService = sl();
      APIResponse _response = await _authService.getServiceProviders(
          transactionCode: transactionCode);
      if (!_response.error) {
        List<ServiceProviderModel> list = [];
        for (var serviceProvider in _response.data) {
          list.add(ServiceProviderModel.fromJson(serviceProvider));
        }
        serviceProviders = list;
      }
      return _response;
    } catch (e) {
      return APIResponse(error: true, message: e.toString());
    }
  }
}
