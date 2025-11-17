class ShareHandicapResponseModel {
  String? title;
  String? body;
  String? homeTeam;
  String? awayTeam;
  String? score;
  String? predictionType;
  String? predictionSide;
  int? handicapValue;
  int? handicapPrice;
  bool? isHomeTeamUpper;
  int? predictedCoin;
  int? returnedCoin;
  int? winOrLoseCoin;
  String? status;
  String? roi;

  ShareHandicapResponseModel(
      {this.title,
      this.body,
      this.homeTeam,
      this.awayTeam,
      this.score,
      this.predictionType,
      this.predictionSide,
      this.handicapValue,
      this.handicapPrice,
      this.isHomeTeamUpper,
      this.predictedCoin,
      this.returnedCoin,
      this.winOrLoseCoin,
      this.status,
      this.roi});

  ShareHandicapResponseModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    homeTeam = json['homeTeam'];
    awayTeam = json['awayTeam'];
    score = json['score'];
    predictionType = json['predictionType'];
    predictionSide = json['predictionSide'];
    handicapValue = json['handicapValue'];
    handicapPrice = json['handicapPrice'];
    isHomeTeamUpper = json['isHomeTeamUpper'];
    predictedCoin = json['predictedCoin'];
    returnedCoin = json['returnedCoin'];
    winOrLoseCoin = json['winOrLoseCoin'];
    status = json['status'];
    roi = json['roi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    data['homeTeam'] = this.homeTeam;
    data['awayTeam'] = this.awayTeam;
    data['score'] = this.score;
    data['predictionType'] = this.predictionType;
    data['predictionSide'] = this.predictionSide;
    data['handicapValue'] = this.handicapValue;
    data['handicapPrice'] = this.handicapPrice;
    data['isHomeTeamUpper'] = this.isHomeTeamUpper;
    data['predictedCoin'] = this.predictedCoin;
    data['returnedCoin'] = this.returnedCoin;
    data['winOrLoseCoin'] = this.winOrLoseCoin;
    data['status'] = this.status;
    data['roi'] = this.roi;
    return data;
  }
}
