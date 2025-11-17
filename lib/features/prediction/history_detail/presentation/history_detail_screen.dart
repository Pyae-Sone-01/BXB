import 'package:bxb/features/prediction/history_detail/view_model/history_detail_view_model.dart';
import 'package:bxb/router/router.dart';
import 'package:bxb/services/prediction/models/history_detail_model.dart';
import 'package:bxb/utils/common/widgets/loading_widget.dart';
import 'package:bxb/utils/common/widgets/vistory_btn_widget.dart';
import 'package:bxb/utils/extension/num_extension.dart';
import 'package:bxb/utils/extension/string_extension.dart';
import 'package:bxb/utils/themes/app_resources.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class HistoryDetailScreen extends ConsumerStatefulWidget {
  final int id;
  const HistoryDetailScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends ConsumerState<HistoryDetailScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(historyDetailViewModelProvider.notifier)
          .initializeData(widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final detail =
        ref.watch(historyDetailViewModelProvider.select((s) => s.detail));
    final isLoading =
        ref.watch(historyDetailViewModelProvider.select((s) => s.isLoading));
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("အသေးစိတ်"),
      ),
      body: isLoading
          ? const LoadingWidget()
          : Column(
              children: [
                if (detail?.status != "pending")
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: VistoryBtnWidget(onTap: () {
                      if (detail?.type == "accumulator") {
                        context.pushNamed(
                            RouteNames.prediciton.shareAccumulatorResult,
                            queryParameters: {
                              "order_id": detail?.id.toString()
                            });
                      } else {
                        context.pushNamed(
                            RouteNames.prediciton.shareHandicapResult,
                            queryParameters: {
                              "order_id": detail?.id.toString()
                            });
                      }
                    }),
                  ),
                Expanded(
                    child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  itemCount: detail?.orderItems?.length ?? 0,
                  separatorBuilder: (context, index) => const Gap(15),
                  itemBuilder: (context, index) {
                    final data = detail!.orderItems![index];
                    return FixtureRow(
                      data: data,
                    );
                  },
                )),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  decoration: BoxDecoration(
                      color: AppResources.colors.blue700,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(25))),
                  child: Column(
                    children: [
                      _buildDataRow(
                          label: "အမျိုးအစား",
                          data: (detail?.type ?? "") == "accumulator"
                              ? "မောင်း (${detail?.orderItemsCount ?? 0})"
                              : "ဘော်ဒီ / ဂိုးပေါင်း"),
                      _buildDataRow(
                          label: "လောင်းငွေ",
                          data: detail?.predictedCoin?.toPricing ?? "0 Ks"),
                      _buildDataRow(
                          label: "နိုင်/ရူံး",
                          data: detail?.status ?? "",
                          textColor: Colors.orange),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Widget _buildDataRow(
      {required String label, required String data, Color? textColor}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.white),
            ),
            Text(
              data,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: textColor ?? Colors.white),
            )
          ],
        ),
        const Gap(5)
      ],
    );
  }
}

class FixtureRow extends StatelessWidget {
  final OrderItems data;
  const FixtureRow({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isHomeSelected = data.predictedSide == "home";
    final isAwaySelected = data.predictedSide == "away";
    final isUnderSelected = data.predictedSide == "under";
    final isOverSelected = data.predictedSide == "over";
    final isGoalTotal = data.predictionType == "goal_total";
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppResources.colors.blue200,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Match Time : ${data.fixtureDate?.toReadableDateTime()}",
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
          const Gap(10),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 3,
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
                          if (data.isHomeTeamUpper ?? false) ...[
                            const Gap(5),
                            Text(
                              " (${data.handicapValue?.withSignPrefix(withoutPlusSign: true, withoutSpace: true)}${data.handicapPrice?.withSignPrefix(withoutSpace: true)})",
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
                  flex: 1,
                  child: _buildDecorator(
                    backgroundColor: Colors.white,
                    child: Text(
                      "${data.homeTeamScore} - ${data.awayTeamScore}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Gap(5),
                Expanded(
                  flex: 3,
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
                          if (!(data.isHomeTeamUpper ?? false)) ...[
                            const Gap(5),
                            Text(
                              "(${data.handicapValue?.withSignPrefix(withoutPlusSign: true, withoutSpace: true)}${data.handicapPrice?.withSignPrefix(withoutSpace: true)})",

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
              if (isGoalTotal) ...[
                const Gap(5),
                Expanded(
                  flex: 1,
                  child: _buildDecorator(
                    backgroundColor: AppResources.colors.blue600,
                    child: Text(
                      "${data.handicapValue?.withSignPrefix(withoutPlusSign: true)}${data.handicapPrice?.withSignPrefix()}",
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
