class TransferDetailModel {
  final accountNumber;
  final reference;
  final expiryTime;
  final bankName;
  final accountName;

  TransferDetailModel(
      {this.accountNumber,
      this.reference,
      this.expiryTime,
      this.bankName,
      this.accountName});

  factory TransferDetailModel.fromJson(Map<String, dynamic> data){
    return TransferDetailModel(
        accountNumber: data["accountNumber"],
        reference: data["reference"],
        expiryTime: data["expiryTime"],
        bankName: data["bankName"],
        accountName: data["accountName"],
    );
  }
}