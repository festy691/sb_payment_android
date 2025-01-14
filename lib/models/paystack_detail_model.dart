class PaystackDetailModel {
  final merchantEmail;
  final customerEmail;
  final amount;
  final partner;
  final publicKey;
  final transactionRef;
  final currency;
  final paymentPartnerId;
  final redirectLink;

  PaystackDetailModel(
      {this.merchantEmail,
      this.customerEmail,
      this.amount,
      this.partner,
      this.publicKey,
      this.transactionRef,
      this.currency,
      this.paymentPartnerId,
      this.redirectLink});

  factory PaystackDetailModel.fromJson(Map<String, dynamic> data){
    return PaystackDetailModel(
        merchantEmail: data["merchantEmail"],
        customerEmail: data["customerEmail"],
        amount: data["amount"],
        partner: data["partner"],
        publicKey: data["publicKey"],
        transactionRef: data["transactionRef"],
        currency: data["currency"],
        paymentPartnerId: data["paymentPartnerId"],
        redirectLink: data["redirectLink"],
    );
  }
}