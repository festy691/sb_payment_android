import 'package:sb_payment_sdk/core/network/network_service.dart';
import 'package:sb_payment_sdk/core/network/url_config.dart';
import 'package:sb_payment_sdk/models/api_response.dart';
import 'package:sb_payment_sdk/models/charge_model.dart';

class AuthService {
  NetworkService _networkService;
  AuthService({required NetworkService networkService})
      : _networkService = networkService;

  void updateNetworkService() =>
      _networkService = NetworkService(baseUrl: UrlConfig.coreBaseUrl);

  Future<APIResponse> initTransfer({required Payment payment}) async {
    try {
      var data = {
        "amount": payment.amount,
        "currency": payment.currencyType?.name ?? CurrencyType.NGN,
        "email": payment.email,
        "reference": payment.reference
      };
      final response = await _networkService.call(
          UrlConfig.coreBaseUrl + UrlConfig.initTransfer, RequestMethod.post,
          data: data);
      return APIResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<APIResponse> initPaystack({required Payment payment}) async {
    try {
      var data = {
        "amount": payment.amount,
        "currency": payment.currencyType?.name ?? CurrencyType.NGN,
        "email": payment.email,
        "paymentMethods": payment.paymentMethods,
        "partner": "Paystack",
        "redirectUrl": "https://sb.payment.com/success",
      };
      final response = await _networkService.call(
          UrlConfig.coreBaseUrl + UrlConfig.initPaystackPayment,
          RequestMethod.post,
          data: data);
      return APIResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<APIResponse> initMomoPayment({required Payment payment}) async {
    try {
      var data = {
        "amount": payment.amount,
        "currency": payment.currencyType?.name ?? CurrencyType.NGN,
        "email": payment.email,
        "provider": payment.provider,
        "phone": payment.phoneNumber
      };
      final response = await _networkService.call(
          UrlConfig.coreBaseUrl + UrlConfig.initMomoPayment, RequestMethod.post,
          data: data);
      return APIResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<APIResponse> verifyMomoOTP(
      {required String customerName,
      required String reference,
      required String otp}) async {
    try {
      var data = {
        "reference": reference,
        "customerName": customerName,
        "otp": otp,
      };
      final response = await _networkService.call(
          UrlConfig.coreBaseUrl + UrlConfig.verifyMomoOTP, RequestMethod.post,
          data: data);
      return APIResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<APIResponse> manualVerification({required String paymentCode}) async {
    try {
      final response = await _networkService.call(
          "${UrlConfig.coreBaseUrl}${UrlConfig.manualVerify}/$paymentCode",
          RequestMethod.post,
          data: {});
      return APIResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<APIResponse> decodePaystackToken({required String token}) async {
    try {
      final response = await _networkService.call(
          "${UrlConfig.coreBaseUrl}${UrlConfig.decodePaystackPaymentDetails}/$token",
          RequestMethod.get);
      return APIResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<APIResponse> getTaxBreakdown(
      {required String merchantId,
      required String currency,
      required String transactionType,
      required num amount}) async {
    try {
      final response = await _networkService.call(
          "${UrlConfig.coreBaseUrl}${UrlConfig.getTaxBreakDown(merchantId: merchantId, currency: currency, transactionType: transactionType, amount: amount)}",
          RequestMethod.get);
      return APIResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<APIResponse> getServiceProviders({
    required String transactionCode,
  }) async {
    try {
      final response = await _networkService.call(
          "${UrlConfig.coreBaseUrl}${UrlConfig.serviceProvider(transactionCode)}",
          RequestMethod.get);
      return APIResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
