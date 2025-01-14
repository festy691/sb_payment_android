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
  static const String initPaystackPayment = "transaction/initialize";
  static const String decodePaystackPaymentDetails = "transaction/get-payment-details";
}
