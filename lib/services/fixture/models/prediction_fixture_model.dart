class PredictionFixtureModel {
  final int fixtureId;
  final int handicapOddId;
  final String predictedSide;
  final String predictionType;

  PredictionFixtureModel({
    required this.fixtureId,
    required this.handicapOddId,
    required this.predictedSide,
  }) : predictionType = (predictedSide == 'home' || predictedSide == "away")
            ? "body"
            : "goal_total";
}
