import 'package:bxb/services/fixture/models/prediction_fixture_model.dart';
import 'package:bxb/utils/extension/num_extension.dart';
import 'package:bxb/utils/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../services/fixture/models/league_fixture_model.dart';
import '../../themes/app_resources.dart';

class FixtureGroupItemWidget extends StatelessWidget {
  final Function({
    required PredictionFixtureModel data,
  }) onPrediction;
  final LeagueFixturesModel fixture;
  final List<PredictionFixtureModel> predictions;

  const FixtureGroupItemWidget({
    super.key,
    required this.fixture,
    required this.onPrediction,
    required this.predictions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          listTileTheme: const ListTileThemeData(
            dense: true,
            minVerticalPadding: 0,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity(vertical: -2),
          ),
        ),
        child: ExpansionTile(
          dense: true,
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          collapsedBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            fixture.league ?? "",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppResources.colors.neutral800,
              fontSize: 14,
            ),
          ),
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppResources.colors.blue200,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(10)),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  ...?fixture.fixtures?.map((e) => FixtureRow(
                        key: ValueKey(e.id),
                        data: e,
                        onPrediction: onPrediction,
                        prediction: predictions,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FixtureRow extends StatelessWidget {
  final FixtureModel data;

  final List<PredictionFixtureModel> prediction;
  final Function({
    required PredictionFixtureModel data,
  }) onPrediction;
  const FixtureRow({
    super.key,
    required this.data,
    required this.onPrediction,
    required this.prediction,
  });

  @override
  Widget build(BuildContext context) {
    final matchedPrediction = prediction.firstWhere(
      (p) => p.fixtureId == data.id && p.handicapOddId == data.oddId,
      orElse: () => PredictionFixtureModel(
        fixtureId: data.id ?? 0,
        handicapOddId: data.oddId ?? 0,
        predictedSide: "",
      ),
    );
    final selectedPredictedSide = matchedPrediction.predictedSide;

    final isSelectedFixture = selectedPredictedSide.isNotEmpty;

    final isHomeSelected =
        (isSelectedFixture && selectedPredictedSide == "home");
    final isAwaySelected =
        (isSelectedFixture && selectedPredictedSide == "away");
    final isUnderSelected =
        (isSelectedFixture && selectedPredictedSide == "under");
    final isOverSelected =
        (isSelectedFixture && selectedPredictedSide == "over");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Match Time : ${data.matchDateAndTime?.toReadableDateTime() ?? ''}",
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        ),
        const Gap(10),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: _buildDecorator(
                  onTap: () {
                    onPrediction(
                      data: PredictionFixtureModel(
                          fixtureId: data.id ?? 0,
                          handicapOddId: data.oddId ?? 0,
                          predictedSide: "home"),
                    );
                  },
                  backgroundColor: isHomeSelected
                      ? AppResources.colors.blue700
                      : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: (data.isHomeTeamUpper ?? false)
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            data.homeTeam ?? "",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 1.1,
                              color: isHomeSelected
                                  ? Colors.white
                                  : (data.isHomeTeamUpper ?? false)
                                      ? AppResources.colors.red600
                                      : AppResources.colors.blue600,
                            ),
                          ),
                        ),
                        if (data.isHomeTeamUpper ?? false) ...[
                          const Gap(5),
                          Text(
                            " (${data.bodyHandicap?.withSignPrefix(withoutPlusSign: true, withoutSpace: true)}${data.bodyHandicapPrice?.withSignPrefix(withoutSpace: true)})",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 1.1,
                              color: isHomeSelected
                                  ? Colors.white
                                  : AppResources.colors.blue600,
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(5),
              Expanded(
                child: _buildDecorator(
                  onTap: () {
                    onPrediction(
                      data: PredictionFixtureModel(
                          fixtureId: data.id ?? 0,
                          handicapOddId: data.oddId ?? 0,
                          predictedSide: "away"),
                    );
                  },
                  backgroundColor: isAwaySelected
                      ? AppResources.colors.blue700
                      : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: !(data.isHomeTeamUpper ?? false)
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Text(
                          data.awayTeam ?? "",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.1,
                            color: isAwaySelected
                                ? Colors.white
                                : !(data.isHomeTeamUpper ?? false)
                                    ? AppResources.colors.red600
                                    : AppResources.colors.blue600,
                          ),
                        )),
                        if (!(data.isHomeTeamUpper ?? false)) ...[
                          const Gap(5),
                          Text(
                            "(${data.bodyHandicap?.withSignPrefix(withoutPlusSign: true, withoutSpace: true)}${data.bodyHandicapPrice?.withSignPrefix(withoutSpace: true)})",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 1.1,
                              color: isAwaySelected
                                  ? Colors.white
                                  : AppResources.colors.blue600,
                            ), // smaller text
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(5),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildDecorator(
                onTap: () {
                  onPrediction(
                    data: PredictionFixtureModel(
                        fixtureId: data.id ?? 0,
                        handicapOddId: data.oddId ?? 0,
                        predictedSide: "over"),
                  );
                },
                backgroundColor:
                    isOverSelected ? AppResources.colors.blue700 : Colors.white,
                child: Text(
                  "G - Over",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isOverSelected
                          ? Colors.white
                          : AppResources.colors.neutral800),
                ),
              ),
            ),
            const Gap(5),
            Expanded(
              flex: 1,
              child: _buildDecorator(
                onTap: () {},
                backgroundColor: AppResources.colors.blue600,
                child: Text(
                  "${data.goalTotalHandicap?.withSignPrefix(withoutPlusSign: true)}${data.goalTotalHandicapPrice?.withSignPrefix()}",
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
            const Gap(5),
            Expanded(
              flex: 2,
              child: _buildDecorator(
                onTap: () {
                  onPrediction(
                    data: PredictionFixtureModel(
                        fixtureId: data.id ?? 0,
                        handicapOddId: data.oddId ?? 0,
                        predictedSide: "under"),
                  );
                },
                backgroundColor: isUnderSelected
                    ? AppResources.colors.blue700
                    : Colors.white,
                child: Text(
                  "G - Under",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isUnderSelected
                          ? Colors.white
                          : AppResources.colors.neutral800),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildDecorator(
      {required VoidCallback onTap,
      required Widget child,
      required Color backgroundColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(5)),
        child: child,
      ),
    );
  }
}
