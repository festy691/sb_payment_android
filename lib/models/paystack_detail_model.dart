class PaymentDetailModel {
  String? merchantId;
  String? merchantEmail;
  String? merchantLogo;
  String? customerEmail;
  String? merchantName;
  num? amount;
  String? partner;
  String? publicKey;
  String? sbPublicKey;
  String? transactionRef;
  String? currency;
  String? paymentPartnerId;
  bool isVaCheckoutDisabled;
  String? redirectLink;
  List<String>? paymentMethods;
  String? narration;
  EnabledSBServiceModel? isSBCheckoutEnabled;
  bool isTaxed;
  num? taxAmount;
  num? initialAmount;

  PaymentDetailModel({
    this.merchantEmail,
    this.merchantId,
    this.merchantLogo,
    this.merchantName,
    this.customerEmail,
    this.amount,
    this.partner,
    this.publicKey,
    this.sbPublicKey,
    this.transactionRef,
    this.currency,
    this.paymentPartnerId,
    this.redirectLink,
    this.isVaCheckoutDisabled = false,
    this.paymentMethods,
    this.narration,
    this.isSBCheckoutEnabled,
    this.isTaxed = false,
    this.taxAmount,
    this.initialAmount,
  });

  factory PaymentDetailModel.fromJson(Map<String, dynamic> data) {
    return PaymentDetailModel(
      merchantId: data["merchantId"],
      merchantName: data["merchantName"],
      merchantEmail: data["merchantEmail"],
      merchantLogo: data["merchantLogo"],
      customerEmail: data["customerEmail"],
      amount: (data["amount"] ?? 0) * 100,
      partner: data["partner"],
      publicKey: data["publicKey"],
      sbPublicKey: data["sbPublicKey"],
      transactionRef: data["transactionRef"],
      currency: data["currency"],
      paymentPartnerId: data["paymentPartnerId"],
      isVaCheckoutDisabled: data["isVaCheckoutDisabled"],
      redirectLink: data["redirectLink"],
      paymentMethods: data["paymentMethods"] != null
          ? (data["paymentMethods"] as List)
              .map((met) => met.toString())
              .toList()
          : [],
      narration: data["narration"],
      isSBCheckoutEnabled: data["isSBCheckoutEnabled"] != null
          ? EnabledSBServiceModel.fromJson(data["isSBCheckoutEnabled"])
          : EnabledSBServiceModel(),
      isTaxed: data["isTaxed"] ?? false,
      taxAmount: (data["taxAmount"] ?? 0) * 100,
      initialAmount: (data["initialAmount"] ?? 0) * 100,
    );
  }
}

class EnabledSBServiceModel {
  bool bankTransfer;
  bool momo;

  EnabledSBServiceModel({this.bankTransfer = false, this.momo = false});

  factory EnabledSBServiceModel.fromJson(Map<String, dynamic> data) {
    return EnabledSBServiceModel(
      bankTransfer: data['bank_transfer'] ?? false,
      momo: data['mobile_money'] ?? false,
    );
  }
}
