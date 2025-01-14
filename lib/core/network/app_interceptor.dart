import 'package:dio/dio.dart';
import 'package:sb_payment_sdk/core/network/url_config.dart';

/// [Interceptor] extension for setting token header
/// and other required properties for all requests
class AppInterceptor extends Interceptor {
  String authToken;
  String storeId;
  AppInterceptor(this.authToken, this.storeId);

  /// sets the auth token and App token
  /// App token is an identify for each app
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (authToken.isNotEmpty) {
      options.headers.addAll({
        "Bearer ": authToken,
        "x-environment":
            UrlConfig.environment == Environment.production ? "live" : "dev"
      });
    }
    return super.onRequest(options, handler);
  }

  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      response.statusCode = 200;
    } else if (response.statusCode == 401) {
      // eventBus.fire(LogoutEvent(""));
    }
    return super.onResponse(response, handler);
  }
}
