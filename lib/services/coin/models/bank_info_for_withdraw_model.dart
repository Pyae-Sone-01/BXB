class BankInfoForWithdrawModel {
  int? id;
  String? name;

  BankInfoForWithdrawModel({this.id, this.name});

  BankInfoForWithdrawModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
