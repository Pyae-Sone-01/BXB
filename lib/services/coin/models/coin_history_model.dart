class CoinHistoryModel {
  String? date;
  int? toBff;
  int? fromBff;
  int? predictionWin;
  int? predictionLose;
  int? predictionAmount;
  int? withdraw;
  int? deposit;

  CoinHistoryModel(
      {this.date,
      this.toBff,
      this.fromBff,
      this.predictionWin,
      this.predictionLose,
      this.predictionAmount,
      this.withdraw,
      this.deposit});

  CoinHistoryModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    toBff = json['to_bff'];
    fromBff = json['from_bff'];
    predictionWin = json['prediction_win'];
    predictionLose = json['prediction_lose'];
    predictionAmount = json['prediction_amount'];
    withdraw = json['withdraw'];
    deposit = json['deposit'];
  }
}
