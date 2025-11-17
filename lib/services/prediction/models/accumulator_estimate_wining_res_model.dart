class AccumulatorEstimateWinningResModel {
  List<AccumulatorEstimateFixtureItem>? items;
  num? predictedCoin;
  num? estimatedWinningCoin;

  AccumulatorEstimateWinningResModel(
      {this.items, this.predictedCoin, this.estimatedWinningCoin});

  AccumulatorEstimateWinningResModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <AccumulatorEstimateFixtureItem>[];
      json['items'].forEach((v) {
        items!.add(new AccumulatorEstimateFixtureItem.fromJson(v));
      });
    }
    predictedCoin = json['predicted_coin'];
    estimatedWinningCoin = json['estimated_winning_coin'];
  }
}

class AccumulatorEstimateFixtureItem {
  bool? isOddUpdate;
  int? fixtureId;
  String? matchDateAndTime;
  int? handicapOddId;
  int? handicapValue;
  int? handicapPrice;
  String? predictionType;
  String? predictedSide;
  bool? isHomeTeamUpper;
  String? homeTeam;
  String? awayTeam;

  AccumulatorEstimateFixtureItem(
      {this.isOddUpdate,
      this.fixtureId,
      this.matchDateAndTime,
      this.handicapOddId,
      this.handicapValue,
      this.handicapPrice,
      this.predictionType,
      this.predictedSide,
      this.isHomeTeamUpper,
      this.homeTeam,
      this.awayTeam});

  AccumulatorEstimateFixtureItem.fromJson(Map<String, dynamic> json) {
    isOddUpdate = json['is_odd_update'];
    fixtureId = json['fixture_id'];
    matchDateAndTime = json['match_date_and_time'];
    handicapOddId = json['handicap_odd_id'];
    handicapValue = json['handicap_value'];
    handicapPrice = json['handicap_price'];
    predictionType = json['prediction_type'];
    predictedSide = json['predicted_side'];
    isHomeTeamUpper = json['is_home_team_upper'];
    homeTeam = json['home_team'];
    awayTeam = json['away_team'];
  }
}
