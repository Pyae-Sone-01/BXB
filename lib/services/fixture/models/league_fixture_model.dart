class LeagueFixturesModel {
  String? league;
  List<FixtureModel>? fixtures;

  LeagueFixturesModel({this.league, this.fixtures});

  LeagueFixturesModel.fromJson(Map<String, dynamic> json) {
    league = json['league'];
    if (json['fixtures'] != null) {
      fixtures = <FixtureModel>[];
      json['fixtures'].forEach((v) {
        fixtures!.add(FixtureModel.fromJson(v));
      });
    }
  }
}

// class FixtureModel {
//   int? id;
//   String? homeTeam;
//   String? awayTeam;
//   String? matchDateAndTime;
//   int? oddId;
//   int? bodyHandicap;
//   int? bodyHandicapPrice;
//   int? goalTotalHandicap;
//   int? goalTotalHandicapPrice;
//   bool? isHomeTeamUpper;
//   bool? isBigMatch;

//   FixtureModel({
//     this.id,
//     this.homeTeam,
//     this.awayTeam,
//     this.matchDateAndTime,
//     this.oddId,
//     this.bodyHandicap,
//     this.bodyHandicapPrice,
//     this.goalTotalHandicap,
//     this.goalTotalHandicapPrice,
//     this.isHomeTeamUpper,
//     this.isBigMatch,
//   });

//   FixtureModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     homeTeam = json['home_team'];
//     awayTeam = json['away_team'];
//     matchDateAndTime = json['match_date_and_time'];
//     oddId = json['odd_id'];
//     bodyHandicap = json['body_handicap'];
//     bodyHandicapPrice = json['body_handicap_price'];
//     goalTotalHandicap = json['goal_total_handicap'];
//     goalTotalHandicapPrice = json['goal_total_handicap_price'];
//     isHomeTeamUpper = json['is_home_team_upper'];
//     isBigMatch = json['is_big_match'];
//   }
// }
class FixtureModel {
  int? id;
  String? homeTeam;
  String? awayTeam;
  String? matchDateAndTime;
  int? oddId;
  int? bodyHandicap;
  int? bodyHandicapPrice;
  int? goalTotalHandicap;
  int? goalTotalHandicapPrice;
  bool? isHomeTeamUpper;
  bool? isBigMatch;

  // Extra fields for prediction response
  bool? isOddUpdate;
  String? predictionType;
  String? predictedSide;
  int? predictedCoin;
  int? estimatedWinningCoin;

  FixtureModel({
    this.id,
    this.homeTeam,
    this.awayTeam,
    this.matchDateAndTime,
    this.oddId,
    this.bodyHandicap,
    this.bodyHandicapPrice,
    this.goalTotalHandicap,
    this.goalTotalHandicapPrice,
    this.isHomeTeamUpper,
    this.isBigMatch,
    this.isOddUpdate,
    this.predictionType,
    this.predictedSide,
    this.predictedCoin,
    this.estimatedWinningCoin,
  });

  FixtureModel.fromJson(Map<String, dynamic> json) {
    // Handle fixtureId or id
    id = json['id'] ?? json['fixture_id'];

    homeTeam = json['home_team'];
    awayTeam = json['away_team'];
    matchDateAndTime = json['match_date_and_time'];

    // Handle oddId or handicapOddId
    oddId = json['odd_id'] ?? json['handicap_odd_id'];

    // Handle bodyHandicap from fixture or prediction
    bodyHandicap = json['body_handicap'] ?? json['handicap_value'];
    bodyHandicapPrice = json['body_handicap_price'] ?? json['handicap_price'];

    goalTotalHandicap = json['goal_total_handicap'];
    goalTotalHandicapPrice = json['goal_total_handicap_price'];

    isHomeTeamUpper = json['is_home_team_upper'];
    isBigMatch = json['is_big_match'];

    // Extra prediction fields
    isOddUpdate = json['is_odd_update'];
    predictionType = json['prediction_type'];
    predictedSide = json['predicted_side'];
    predictedCoin = json['predicted_coin'];
    estimatedWinningCoin = json['estimated_winning_coin'];
  }
}
