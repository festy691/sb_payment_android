class APIResponse<T>{
  var data;
  bool error;
  var message;

  APIResponse({this.data, this.error=false, this.message});

  factory APIResponse.fromJson(Map<String, dynamic> data){
    return APIResponse(
        error: data['status'] != null ? !data['status'] : data['error'] ?? false,
        message: data['message'],
        data: data['data']
    );
  }
}