class ManualVerificationModel {
  final id;
  final toAccountNumber;
  final type;
  final customerName;
  final amount;
  final status;
  final transactionReference;
  final createdAt;
  final reference;
  final updatedAt;
  final transactionId;
  final isFee;
  final partnerId;
  final businessName;
  final merchantId;
  final transType;
  final customerId;
  final otherFeeCollected;


  ManualVerificationModel(
      {this.id,
      this.toAccountNumber,
      this.type,
      this.customerName,
      this.amount,
      this.status,
      this.transactionReference,
      this.createdAt,
      this.reference,
      this.updatedAt,
      this.transactionId,
      this.isFee,
      this.partnerId,
      this.businessName,
      this.merchantId,
      this.transType,
      this.customerId,
      this.otherFeeCollected});

  factory ManualVerificationModel.fromJson(Map<String, dynamic> data){
    return ManualVerificationModel(
        id: data["id"],
        toAccountNumber: data["toAccountNumber"],
        type: data["type"],
        customerName: data["customerName"],
        amount: data["amount"],
        status: data["status"],
        transactionReference: data["transactionReference"],
        createdAt: data["createdAt"],
        reference: data["reference"],
        updatedAt: data["updatedAt"],
        transactionId: data["transactionId"],
        isFee: data["isFee"],
        partnerId: data["partnerId"],
        businessName: data["businessName"],
        merchantId: data["merchantId"],
        transType: data["transType"],
        customerId: data["customerId"],
        otherFeeCollected: data["otherFeeCollected"],
    );
  }
}