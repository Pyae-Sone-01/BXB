class HistoryModel {
  int? id;
  String? orderNumber;
  String? type;
  String? status;
  num? predictedCoin;
  num? returnedCoin;
  String? transactionDate;
  num? orderItemsCount;

  HistoryModel(
      {this.id,
      this.orderNumber,
      this.type,
      this.status,
      this.predictedCoin,
      this.returnedCoin,
      this.transactionDate,
      this.orderItemsCount});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    type = json['type'];
    status = json['status'];
    predictedCoin = json['predicted_coin'];
    returnedCoin = json['returned_coin'];
    transactionDate = json['transaction_date'];
    orderItemsCount = json['order_items_count'];
  }
}
