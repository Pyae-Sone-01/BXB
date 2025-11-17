class ShareAccumulatorResponseModel {
  String? title;
  String? body;
  String? winTeamsCount;
  num? returnedCoin;
  String? roi;
  String? accuracy;
  int? itemsCount;
  List<Predictions>? predictions;

  ShareAccumulatorResponseModel(
      {this.title,
      this.body,
      this.winTeamsCount,
      this.returnedCoin,
      this.roi,
      this.accuracy,
      this.itemsCount,
      this.predictions});

  ShareAccumulatorResponseModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    winTeamsCount = json['winTeamsCount'];
    returnedCoin = json['returnedCoin'];
    roi = json['roi'];
    accuracy = json['accuracy'];
    itemsCount = json['itemsCount'];
    if (json['predictions'] != null) {
      predictions = <Predictions>[];
      json['predictions'].forEach((v) {
        predictions!.add(new Predictions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    data['winTeamsCount'] = this.winTeamsCount;
    data['returnedCoin'] = this.returnedCoin;
    data['roi'] = this.roi;
    data['accuracy'] = this.accuracy;
    data['itemsCount'] = this.itemsCount;
    if (this.predictions != null) {
      data['predictions'] = this.predictions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Predictions {
  String? homeTeam;
  String? awayTeam;
  String? score;
  String? predictionType;
  String? predictionSide;
  int? handicapValue;
  int? handicapPrice;
  bool? isHomeTeamUpper;
  String? status;
  String? statusString;

  Predictions(
      {this.homeTeam,
      this.awayTeam,
      this.score,
      this.predictionType,
      this.predictionSide,
      this.handicapValue,
      this.handicapPrice,
      this.isHomeTeamUpper,
      this.status,
      this.statusString});

  Predictions.fromJson(Map<String, dynamic> json) {
    homeTeam = json['homeTeam'];
    awayTeam = json['awayTeam'];
    score = json['score'];
    predictionType = json['predictionType'];
    predictionSide = json['predictionSide'];
    handicapValue = json['handicapValue'];
    handicapPrice = json['handicapPrice'];
    isHomeTeamUpper = json['isHomeTeamUpper'];
    status = json['status'];
    statusString = json['statusString'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['homeTeam'] = this.homeTeam;
    data['awayTeam'] = this.awayTeam;
    data['score'] = this.score;
    data['predictionType'] = this.predictionType;
    data['predictionSide'] = this.predictionSide;
    data['handicapValue'] = this.handicapValue;
    data['handicapPrice'] = this.handicapPrice;
    data['isHomeTeamUpper'] = this.isHomeTeamUpper;
    data['status'] = this.status;
    data['statusString'] = this.statusString;
    return data;
  }
}
