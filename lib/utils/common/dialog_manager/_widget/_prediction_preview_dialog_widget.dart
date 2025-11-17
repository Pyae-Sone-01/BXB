part of '../dialog_manager.dart';

class _PredicitonPreviewDialogWidget extends StatefulWidget {
  final List<FixtureModel> items;
  final List<PredictionFixtureModel> prediction;
  final Function(int id) onDeletePrediction;
  final VoidCallback onClose;

  const _PredicitonPreviewDialogWidget({
    required this.items,
    required this.prediction,
    required this.onClose,
    required this.onDeletePrediction,
  });

  @override
  State<_PredicitonPreviewDialogWidget> createState() =>
      _PredicitonPreviewDialogWidgetState();
}

class _PredicitonPreviewDialogWidgetState
    extends State<_PredicitonPreviewDialogWidget> {
  late List<FixtureModel> currentItems;
  late List<PredictionFixtureModel> currentPredictions;

  @override
  void initState() {
    super.initState();
    currentItems = List.from(widget.items);
    currentPredictions = List.from(widget.prediction);
  }

  void _onDeletePrediction(int id) {
    setState(() {
      currentPredictions =
          currentPredictions.where((p) => p.fixtureId != id).toList();
      currentItems = currentItems.where((item) => item.id != id).toList();
    });
    widget.onDeletePrediction(id);

    // Close dialog if no predictions left
    if (currentPredictions.isEmpty) {
      widget.onClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(12),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        height: currentItems.length > 1 ? 600 : 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "ရွေးချယ်ထားသောပွဲများ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Gap(10),
            currentItems.length > 1
                ? Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: currentItems.length,
                      separatorBuilder: (context, index) => Gap(15),
                      itemBuilder: (context, index) {
                        return _FixtureRow(
                          data: currentItems[index],
                          prediction: currentPredictions,
                          onDeletePrediction: _onDeletePrediction,
                        );
                      },
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: currentItems.length,
                    separatorBuilder: (context, index) => Gap(15),
                    itemBuilder: (context, index) {
                      return _FixtureRow(
                        data: currentItems[index],
                        prediction: currentPredictions,
                        onDeletePrediction: _onDeletePrediction,
                      );
                    },
                  ),
            currentItems.length > 1 ? const Gap(15) : const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: widget.onClose,
              child: const Text('ပိတ်မည်'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FixtureRow extends StatelessWidget {
  final FixtureModel data;

  final List<PredictionFixtureModel> prediction;
  final Function(int id) onDeletePrediction;
  const _FixtureRow({
    required this.data,
    required this.prediction,
    required this.onDeletePrediction,
  });

  @override
  Widget build(BuildContext context) {
    final matchedPrediction = prediction.firstWhere(
      (p) => p.fixtureId == data.id,
      orElse: () => PredictionFixtureModel(
          fixtureId: data.id ?? 0,
          oddId: data.oddId ?? 0,
          predictedSide: "",
          matchDateAndTime: data.matchDateAndTime),
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
              GestureDetector(
                  onTap: () {
                    onDeletePrediction(data.id ?? 0);
                  },
                  child: Icon(Icons.close))
            ],
          ),
          const Gap(10),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: _buildDecorator(
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
                          if (matchedPrediction.predictionType == "body" &&
                              (data.isHomeTeamUpper ?? false)) ...[
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
                          if (matchedPrediction.predictionType == "body" &&
                              !(data.isHomeTeamUpper ?? false)) ...[
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
              if (matchedPrediction.predictionType == "goal_total") ...[
                Expanded(
                  flex: 1,
                  child: _buildDecorator(
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
              ],
              const Gap(5),
              Expanded(
                flex: 2,
                child: _buildDecorator(
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
      {required Widget child, required Color backgroundColor}) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(5)),
      child: child,
    );
  }
}
