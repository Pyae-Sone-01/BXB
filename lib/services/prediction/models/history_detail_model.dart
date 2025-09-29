class HistoryDetailModel {
  int? id;
  String? orderNumber;
  String? type;
  String? status;
  num? predictedCoin;
  num? returnedCoin;
  num? winOrLoseCoin;
  String? transactionDate;
  int? orderItemsCount;
  List<OrderItems>? orderItems;

  HistoryDetailModel(
      {this.id,
      this.orderNumber,
      this.type,
      this.status,
      this.predictedCoin,
      this.returnedCoin,
      this.winOrLoseCoin,
      this.transactionDate,
      this.orderItemsCount,
      this.orderItems});

  HistoryDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    type = json['type'];
    status = json['status'];
    predictedCoin = json['predicted_coin'];
    returnedCoin = json['returned_coin'];
    winOrLoseCoin = json['win_or_lose_coin'];
    transactionDate = json['transaction_date'];
    orderItemsCount = json['order_items_count'];
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
  }
}

class OrderItems {
  String? homeTeam;
  String? awayTeam;
  int? homeTeamScore;
  int? awayTeamScore;
  String? fixtureDate;
  int? fixtureStatus;
  String? predictionType;
  String? predictedSide;
  int? handicapValue;
  int? handicapPrice;
  bool? isHomeTeamUpper;

  OrderItems(
      {this.homeTeam,
      this.awayTeam,
      this.homeTeamScore,
      this.awayTeamScore,
      this.fixtureDate,
      this.fixtureStatus,
      this.predictionType,
      this.predictedSide,
      this.handicapValue,
      this.handicapPrice,
      this.isHomeTeamUpper});

  OrderItems.fromJson(Map<String, dynamic> json) {
    homeTeam = json['home_team'];
    awayTeam = json['away_team'];
    homeTeamScore = json['home_team_score'];
    awayTeamScore = json['away_team_score'];
    fixtureDate = json['fixture_date'];
    fixtureStatus = json['fixture_status'];
    predictionType = json['prediction_type'];
    predictedSide = json['predicted_side'];
    handicapValue = json['handicap_value'];
    handicapPrice = json['handicap_price'];
    isHomeTeamUpper = json['is_home_team_upper'];
  }
}
