class CustomerDetailModel {
  final String customerEmail;
  final String customerName;
  String? reference;

  CustomerDetailModel({
    required this.customerEmail,
    required this.customerName,
    this.reference,
  });
}
