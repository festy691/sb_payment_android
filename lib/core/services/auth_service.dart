import 'dart:developer';

import 'package:sb_payment_sdk/core/network/network_service.dart';
import 'package:sb_payment_sdk/core/network/url_config.dart';
import 'package:sb_payment_sdk/models/api_response.dart';
import 'package:sb_payment_sdk/models/charge_model.dart';
import 'package:sb_payment_sdk/sb_payment_sdk.dart';

class AuthService {
  NetworkService _networkService;
  AuthService({required NetworkService networkService})
      : _networkService = networkService;

  void updateNetworkService() =>
      _networkService = NetworkService(baseUrl: UrlConfig.coreBaseUrl);

  Future<APIResponse> initTransfer({required Payment payment}) async {
    try {
      var data = {
        "amount": (payment.amount * 100).ceil(),
        "currency": payment.currencyType?.name ?? CurrencyType.NGN,
        "email": payment.email,
        "reference": payment.reference
      };
      final response = await _networkService.call(
          UrlConfig.coreBaseUrl + UrlConfig.initTransfer, RequestMethod.post, data: data);
      return APIResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<APIResponse> initPaystack({required Payment payment}) async {
    try {
      var data = {
        "amount": (payment.amount * 100).ceil(),
        "currency": payment.currencyType?.name ?? CurrencyType.NGN,
        "email": payment.email,
        "partner": "Paystack"
      };
      final response = await _networkService.call(
          UrlConfig.coreBaseUrl + UrlConfig.initPaystackPayment, RequestMethod.post, data: data);
      return APIResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<APIResponse> manualVerification({required String paymentCode}) async {
    try {
      final response = await _networkService.call(
          "${UrlConfig.coreBaseUrl}${UrlConfig.manualVerify}/$paymentCode", RequestMethod.post, data: {});
      return APIResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<APIResponse> decodePaystackToken({required String token}) async {
    try {
      final response = await _networkService.call(
          "${UrlConfig.coreBaseUrl}${UrlConfig.decodePaystackPaymentDetails}/$token", RequestMethod.get);
      return APIResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

}
