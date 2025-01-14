import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:sb_payment_sdk/core/data/session_manager.dart';
import 'package:sb_payment_sdk/core/network/api_error.dart';
import 'package:sb_payment_sdk/core/network/app_interceptor.dart';
import 'package:sb_payment_sdk/core/network/url_config.dart';

/// description: A network provider class which manages network connections
/// between the app and external services. This is a wrapper around [Dio].
///
/// Using this class automatically handle, token management, logging, global

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => log(match.group(0) ?? ""));
}

/// A top level function to print dio logs
void printDioLogs(Object object) {
  printWrapped(object.toString());
}

class NetworkService {
  static const int CONNECT_TIME_OUT = 120000;
  static const int RECEIVE_TIME_OUT = 120000;
  Dio? dio;
  String? baseUrl, authToken;

  NetworkService({String? baseUrl, String? authToken}) {
    this.baseUrl = baseUrl;
    this.authToken = authToken;
    _initialiseDio();
  }

  /// Initialize essential class properties
  void _initialiseDio() {
    dio = Dio(BaseOptions(
      connectTimeout: CONNECT_TIME_OUT,
      receiveTimeout: RECEIVE_TIME_OUT,
      baseUrl: baseUrl ?? UrlConfig.coreBaseUrl,
    ));
    dio!.interceptors
      //..add(AppInterceptor(SessionManager.instance.authToken))
      ..add(LogInterceptor(requestBody: true, logPrint: printDioLogs));
  }

  addInterceptor() {}

  Future<Options> getOption({responseType, bool isJson = true}) async {
    //appCheckToken = await FirebaseAppCheck.instance.getToken();
    return isJson
        ? Options(responseType: responseType, headers: {
            "Authorization": SessionManager.instance.authToken.isNotEmpty
                ? "Bearer ${SessionManager.instance.authToken}"
                : '',
            "Content-Type": "application/json",
          })
        : Options(responseType: responseType, headers: {
            "Authorization": SessionManager.instance.authToken.isNotEmpty
                ? "bearer ${SessionManager.instance.authToken}"
                : '',
            "Content-Disposition": "form-data",
            "Content-Type": "multipart/form-data",
          });
  }

  Future<String?> fetchUrl(Uri uri, {Map<String, String>? headers}) async {
    _initialiseDio();
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (error, stackTrace) {
      log(error.toString());
      // var apiError = ApiError.fromDio(error);
      // if (apiError.errorType == 401) {
      //   //eventBus.fire(LogoutEvent());
      // }
      //return Future.error(apiError, stackTrace);
    }
    return null;
  }

  /// Factory constructor used mainly for injecting an instance of [Dio] mock
  NetworkService.test(this.dio);

  Future<Response> call(
    String path,
    RequestMethod method, {
    Map<String, dynamic>? queryParams,
    data,
    FormData? formData,
    ResponseType responseType = ResponseType.json,
    classTag = '',
  }) async {
    _initialiseDio();
    Response response;
    var params = queryParams ?? {};

    try {
      switch (method) {
        case RequestMethod.post:
          response = await dio!.post(path,
              queryParameters: params,
              data: data,
              options: await getOption(responseType: responseType));
          break;
        case RequestMethod.get:
          response = await dio!
              .get(path, queryParameters: params, options: await getOption());
          break;
        case RequestMethod.patch:
          response = await dio!.patch(path,
              queryParameters: params, data: data, options: await getOption());
          break;
        case RequestMethod.put:
          response = await dio!.put(path,
              queryParameters: params, data: data, options: await getOption());
          break;
        case RequestMethod.delete:
          response = await dio!.delete(path,
              queryParameters: params, data: data, options: await getOption());
          break;
        case RequestMethod.upload:
          response = await dio!.post(path,
              data: formData,
              queryParameters: params,
              options: await getOption(isJson: false),
              onSendProgress: (sent, total) {
            // eventBus
            //     .fire(
            //     FileUploadProgressEvent(FileUploadProgress(sent, total, tag: classTag)));
          });
          break;
      }
      return response;
    } catch (error, stackTrace) {
      var apiError = ApiError.fromDio(error);
      if (apiError.errorType == 401) {
        //eventBus.fire(LogoutEvent());
      }
      return Future.error(apiError, stackTrace);
    }
  }
}

enum RequestMethod { post, get, put, delete, upload, patch }
