part of '../dialog_manager.dart';

class _SelectedPredicitonDialogWidget extends StatelessWidget {
  final List<FixtureModel> items;
  final List<PredictionFixtureModel> prediction;
  final num? predictedCoin;
  final num? estimateWinningCoin;
  const _SelectedPredicitonDialogWidget(
      {super.key,
      required this.items,
      required this.prediction,
      required this.predictedCoin,
      required this.estimateWinningCoin});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(12),
      child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          height: 330,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "ရွေးချယ်ထားသောပွဲများ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Gap(10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _FixtureRow(
                      data: item,
                      onPrediction: ({required data}) {},
                      prediction: prediction);
                },
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "လောင်းငွေ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    "လောင်းငွေ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ခန့်မှန်းနိုင်ငွေ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    "လောင်းငွေ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Gap(10),
              (estimateWinningCoin != null && predictedCoin != null)
                  ? Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF484C54)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              'ပြင်မည်',
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {},
                            child: const Text(
                              'လောင်းမည်',
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container()
            ],
          )),
    );
  }
}

class _FixtureRow extends StatelessWidget {
  final FixtureModel data;

  final List<PredictionFixtureModel> prediction;
  final Function({
    required PredictionFixtureModel data,
  }) onPrediction;
  const _FixtureRow({
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
    return Container(
      color: AppResources.colors.blue200,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.matchDateAndTime?.toReadableDateTime() ?? '',
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
              Icon(Icons.close)
            ],
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
                  backgroundColor: isOverSelected
                      ? AppResources.colors.blue700
                      : Colors.white,
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
      ),
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
