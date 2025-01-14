class TransferDetailModel {
  String? accountNumber;
  String? reference;
  String? expiryTime;
  String? bankName;
  String? accountName;
  String? shortCode;

  TransferDetailModel(
      {this.accountNumber,
      this.reference,
      this.expiryTime,
      this.bankName,
      this.shortCode,
      this.accountName});

  factory TransferDetailModel.fromJson(Map<String, dynamic> data) {
    return TransferDetailModel(
      accountNumber: (data["accountNumber"] ?? "").toString(),
      reference: data["reference"],
      expiryTime: data["expiryTime"],
      bankName: data["bankName"],
      accountName: data["accountName"],
      shortCode: data["shortCode"],
    );
  }
}
