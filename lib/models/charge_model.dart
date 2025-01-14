import 'package:sb_payment_sdk/sb_payment_sdk.dart';

class Payment {
  num amount;
  String email;
  String? reference;
  CurrencyType? currencyType;

  Payment({required this.amount, required this.email, this.reference, this.currencyType});
}