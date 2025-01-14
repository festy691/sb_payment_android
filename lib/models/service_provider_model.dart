class ServiceProviderModel {
  String name;
  String code;
  int id;

  ServiceProviderModel(
      {required this.name, required this.code, required this.id});

  factory ServiceProviderModel.fromJson(Map<String, dynamic> data) {
    return ServiceProviderModel(
        name: data["name"], code: data["code"], id: data["id"]);
  }
}
