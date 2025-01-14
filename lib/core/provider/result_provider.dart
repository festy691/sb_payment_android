import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:sb_payment_sdk/models/api_response.dart';

class ResultController extends GetxController {
  var resultCode = 0.obs;
  var isFirsLoad = true.obs;

  var response = APIResponse();

  setResult(APIResponse result) {
    response = result;
    resultCode.value = result.error ? 1 : 2;
  }

  resetResult() {
    resultCode.value = 0;
    isFirsLoad.value = true;
    response = APIResponse();
  }

  @override
  void onClose() {
    super.onClose();
    // Clean up any resources here
    resetResult();
  }
}
