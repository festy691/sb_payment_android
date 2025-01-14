class MomoResponseModel {
  String? reference;
  String? nextStep;

  MomoResponseModel({this.reference, this.nextStep});

  factory MomoResponseModel.fromJson(Map<String, dynamic> data) {
    return MomoResponseModel(
        reference: data["reference"], nextStep: data["nextStep"]);
  }
}
