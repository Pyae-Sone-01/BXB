class PredictionFixtureModel {
  final int fixtureId;
  int oddId;
  final String predictedSide;
  final String predictionType;
  final String? matchDateAndTime;

  PredictionFixtureModel(
      {required this.fixtureId,
      required this.oddId,
      required this.predictedSide,
      required this.matchDateAndTime})
      : predictionType = (predictedSide == 'home' || predictedSide == "away")
            ? "body"
            : "goal_total";
}
