class BankInfoForDepositModel {
  String? paymentMethod;
  List<BankInfo>? bankInfo;

  BankInfoForDepositModel({this.paymentMethod, this.bankInfo});

  BankInfoForDepositModel.fromJson(Map<String, dynamic> json) {
    paymentMethod = json['paymentMethod'];
    if (json['bankInfo'] != null) {
      bankInfo = <BankInfo>[];
      json['bankInfo'].forEach((v) {
        bankInfo!.add(BankInfo.fromJson(v));
      });
    }
  }
}

class BankInfo {
  int? id;
  String? name;
  String? accountNumber;
  String? paymentMethodName;

  BankInfo({this.id, this.name, this.accountNumber, this.paymentMethodName});

  BankInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    accountNumber = json['account_number'];
    paymentMethodName = json['payment_method_name'];
  }
}
