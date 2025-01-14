enum Environment { development, staging, qa, production }

class UrlConfig {
  static Environment environment = Environment.production;
  static String STAGING_URL = "https://api.startbutton.builditdigital.co/";
  static String PRODUCTION_URL = "https://api.startbutton.tech/";

  static final coreBaseUrl =
      environment == Environment.production ? PRODUCTION_URL : STAGING_URL;

  //Auth Endpoints
  static const String initTransfer = "transaction/initialize-s2s";
  static const String listenForStream = "streams/va";
  static const String manualVerify = "transaction/verify-va-collection";
  static serviceProvider(String transactionCode) =>
      "transaction/mobile-money/providers/$transactionCode";
  static const String initPaystackPayment = "transaction/initialize";
  static const String initMomoPayment =
      "transaction/initialize/s2s/mobile_money";
  static const String verifyMomoOTP =
      "transaction/initialize/s2s/mobile_money/otp-verify";
  static const String decodePaystackPaymentDetails =
      "transaction/get-payment-details";
  static String getTaxBreakDown(
          {required String merchantId,
          required String currency,
          required String transactionType,
          required num amount}) =>
      "tax-region/get-applicable-taxes-breakdown?merchantId=$merchantId&currency=$currency&transactionType=$transactionType&amount=$amount";
}
