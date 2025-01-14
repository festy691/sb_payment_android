class Payment {
  num amount;
  String email;
  String customerName;
  String? reference;
  String? phoneNumber;
  String? provider;
  CurrencyType? currencyType;
  List<String>? paymentMethods;

  Payment(
      {required this.amount,
      required this.email,
      required this.customerName,
      this.phoneNumber,
      this.provider,
      this.reference,
      this.paymentMethods,
      this.currencyType});
}

enum CurrencyType { USD, NGN, GHS, ZAR, KES, TZS, UGX, RWF, XOF }
