import 'dart:convert';
import 'dart:developer';

class APIResponse<T> {
  var data;
  bool error;
  var message;

  APIResponse({this.data, this.error = false, this.message});

  factory APIResponse.fromJson(Map<String, dynamic> data) {
    log("Response======================>${json.encode(data)}");
    return APIResponse(
      error: data['success'] != null ? !data['success'] : true,
      message: data['message'] ?? "",
      data: data['data'],
    );
  }
}
