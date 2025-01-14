class BankAccountModel {
  final id;
  final accountNumber;
  final accountName;
  final bankName;

  BankAccountModel({this.id, this.accountNumber, this.accountName, this.bankName});

  factory BankAccountModel.fromJson(Map<String, dynamic> data){
    return BankAccountModel(
      id: data["id"],
      accountName: data["accountName"],
      accountNumber: data["accountNumber"],
      bankName: data["bankName"],
    );
  }
}