part of '../dialog_manager.dart';

class _HandicapEstimateWiningDialogWidget extends StatelessWidget {
  final EstimateWiningFixtureItemModel data;
  final VoidCallback onClose;
  final VoidCallback onConfirm;

  const _HandicapEstimateWiningDialogWidget(
      {required this.data, required this.onClose, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(12),
      child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "ရွေးချယ်ထားသောပွဲများ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Gap(10),
              _HandicapEstimateFixtureRow(data: data),
              const Gap(10),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "လောင်းငွေ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        data.predictedCoin?.toPricing ?? "0 Ks",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "ခန့်မှန်းနိုင်ငွေ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        data.estimatedWinningCoin?.toPricing ?? "0 Ks",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const Gap(10),
                  Row(
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
                          onPressed: onConfirm,
                          child: const Text(
                            'လောင်းမည်',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          )),
    );
  }
}

class _HandicapEstimateFixtureRow extends StatefulWidget {
  final EstimateWiningFixtureItemModel data;

  const _HandicapEstimateFixtureRow({
    required this.data,
  });

  @override
  State<_HandicapEstimateFixtureRow> createState() =>
      _HandicapEstimateFixtureRowState();
}

class _HandicapEstimateFixtureRowState
    extends State<_HandicapEstimateFixtureRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: AppResources.colors.yellow100,
      end: AppResources.colors.yellow500,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Only start animation if isOddUpdate is true
    if (widget.data.isOddUpdate == true) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isHomeSelected = (widget.data.predictedSide == "home");
    final isAwaySelected = (widget.data.predictedSide == "away");
    final isUnderSelected = (widget.data.predictedSide == "under");
    final isOverSelected = (widget.data.predictedSide == "over");

    // Use animation color if isOddUpdate is true, otherwise use static blue200
    final containerColor = widget.data.isOddUpdate == true
        ? _colorAnimation.value
        : AppResources.colors.blue200;

    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          color: containerColor,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data.matchDateAndTime?.toReadableDateTime() ?? '',
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
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
                            mainAxisAlignment:
                                (widget.data.isHomeTeamUpper ?? false)
                                    ? MainAxisAlignment.spaceBetween
                                    : MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.data.homeTeam ?? "",
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    height: 1.1,
                                    color: isHomeSelected
                                        ? Colors.white
                                        : (widget.data.isHomeTeamUpper ?? false)
                                            ? AppResources.colors.red600
                                            : AppResources.colors.blue600,
                                  ),
                                ),
                              ),
                              if (widget.data.predictionType == "body" &&
                                  (widget.data.isHomeTeamUpper ?? false)) ...[
                                const Gap(5),
                                Text(
                                  // data.handicapValue
                                  " (${widget.data.handicapValue?.withSignPrefix(withoutPlusSign: true, withoutSpace: true)}${widget.data.handicapPrice?.withSignPrefix(withoutSpace: true)})",
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
                            mainAxisAlignment:
                                !(widget.data.isHomeTeamUpper ?? false)
                                    ? MainAxisAlignment.spaceBetween
                                    : MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Text(
                                widget.data.awayTeam ?? "",
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  height: 1.1,
                                  color: isAwaySelected
                                      ? Colors.white
                                      : !(widget.data.isHomeTeamUpper ?? false)
                                          ? AppResources.colors.red600
                                          : AppResources.colors.blue600,
                                ),
                              )),
                              if (widget.data.predictionType == "body" &&
                                  !(widget.data.isHomeTeamUpper ?? false)) ...[
                                const Gap(5),
                                Text(
                                  //"",
                                  "(${widget.data.handicapValue?.withSignPrefix(withoutPlusSign: true, withoutSpace: true)}${widget.data.handicapPrice?.withSignPrefix(withoutSpace: true)})",
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
                  if (widget.data.predictionType == "goal_total")
                    Expanded(
                      flex: 1,
                      child: _buildDecorator(
                        backgroundColor: AppResources.colors.blue600,
                        child: Text(
                          "${widget.data.handicapValue?.withSignPrefix(withoutPlusSign: true)}${widget.data.handicapPrice?.withSignPrefix()}",
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
      },
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
