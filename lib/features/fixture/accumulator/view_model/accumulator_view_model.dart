import 'package:bxb/services/coin/coin_service.dart';
import 'package:bxb/services/coin/providers/coin_service_provider.dart';
import 'package:bxb/services/fixture/fixture_service.dart';
import 'package:bxb/services/fixture/models/league_fixture_model.dart';
import 'package:bxb/services/fixture/models/league_model.dart';
import 'package:bxb/services/fixture/providers/fixture_service_provider.dart';

import 'package:bxb/services/prediction/prediction_service.dart';
import 'package:bxb/services/prediction/providers/prediction_service_provider.dart';
import 'package:bxb/utils/extension/string_extension.dart';
import 'package:bxb/utils/helpers/functions.dart';
import 'package:bxb/utils/helpers/polling_timer.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';

import '../../../../services/fixture/models/prediction_fixture_model.dart';
import '../../../../utils/common/dialog_manager/dialog_manager.dart';
part 'accumulator_view_model.g.dart';

abstract class AccumulatorViewModel {
  void initializedData();
  void leagueFilterApply(List<num> leagues);
  void selectPrediction(BuildContext context,
      {required PredictionFixtureModel prediction});
  void onPrediction(BuildContext context, {required num predictedCoin});
  void showPreviewPrediction(BuildContext context);
}

class AccumulatorState {
  final bool isLoading;
  final List<List<LeagueFixturesModel>> fixtures;
  final List<LeagueModel> leauges;
  final List<num> leagueIds;
  final num remainingBalance;
  final num? predictedCoin;
  final List<PredictionFixtureModel> predictions;
  final bool isEmpty;

  AccumulatorState(
      {this.fixtures = const [],
      this.leauges = const [],
      this.leagueIds = const [],
      this.isLoading = true,
      this.remainingBalance = 0,
      this.predictedCoin,
      this.predictions = const [],
      this.isEmpty = false});

  AccumulatorState copyWith(
      {bool? isLoading,
      List<List<LeagueFixturesModel>>? fixtures,
      List<LeagueModel>? leauges,
      List<num>? leagueIds,
      num? remainingBalance,
      num? predictedCoin,
      List<PredictionFixtureModel>? predictions,
      bool? isEmpty}) {
    return AccumulatorState(
      isLoading: isLoading ?? this.isLoading,
      fixtures: fixtures ?? this.fixtures,
      leauges: leauges ?? this.leauges,
      leagueIds: leagueIds ?? this.leagueIds,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      predictedCoin: predictedCoin ?? this.predictedCoin,
      predictions: predictions ?? this.predictions,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }
}

@riverpod
class AccumulatorViewModelImpl extends _$AccumulatorViewModelImpl
    implements AccumulatorViewModel {
  late final FixtureService _fixtureService = ref.read(fixtureServiceProvider);
  late final CoinService _coinService = ref.read(coinServiceProvider);

  late final PredictionService _predictionService =
      ref.read(predictionServiceProvider);
  late final PollingTimer _pollingTimer;
  @override
  AccumulatorState build() {
    ref.onDispose(() {
      _pollingTimer.stop();
    });
    return AccumulatorState();
  }

  Timer? _timer;

  @override
  void initializedData() {
    _getLeagues();
    _pollingTimer = PollingTimer(
      onTick: () async {
        await _getFixtures();
        await _getUserRemainingBalance();
      },
    );
    _pollingTimer.start();
  }

  void dispose() {
    _timer?.cancel();
  }

  Future<void> _getFixtures() async {
    if (state.fixtures.isEmpty && !state.isEmpty) {
      state = state.copyWith(isLoading: true);
    }
    final res = await _fixtureService
        .getAccumulatorFixture({"league_ids": state.leagueIds.join(",")});
    state = state.copyWith(isLoading: false);
    if (res.isSuccess) {
      state = state.copyWith(isEmpty: res.data?.isEmpty ?? false);
      if (!listEquals(state.fixtures, res.data ?? [])) {
        state = state.copyWith(fixtures: res.data);
      }
    }
  }

  Future<void> _getUserRemainingBalance() async {
    final res = await _coinService.myCoin();
    if (res.isSuccess) {
      if (state.remainingBalance != res.data) {
        state = state.copyWith(remainingBalance: res.data);
      }
    }
  }

  Future<void> _getLeagues() async {
    final res = await _fixtureService.getAllLeagues();
    if (res.isSuccess) {
      state = state.copyWith(leauges: res.data);
    }
  }

  @override
  void leagueFilterApply(List<num> leagues) {
    state = state.copyWith(leagueIds: leagues);
    _getFixtures();
  }

  @override
  void selectPrediction(BuildContext context,
      {required PredictionFixtureModel prediction}) {
    final targetFixture = state.fixtures
        .expand((leagueFixturesList) => leagueFixturesList)
        .expand((leagueFixturesModel) =>
            leagueFixturesModel.fixtures ?? <FixtureModel>[])
        .where((fixture) => fixture.id == prediction.fixtureId)
        .firstOrNull;

    if (targetFixture != null) {
      prediction.oddId = targetFixture.oddId!;
    }
    final existingIndex = state.predictions.indexWhere(
      (p) => p.fixtureId == prediction.fixtureId,
    );

    final isSame = state.predictions.any(
      (p) =>
          p.oddId == prediction.oddId &&
          p.predictedSide == prediction.predictedSide,
    );

    if (isSame) {
      // Remove the prediction
      final updatedPredictions =
          List<PredictionFixtureModel>.from(state.predictions)
            ..removeWhere(
              (p) =>
                  p.oddId == prediction.oddId &&
                  p.predictedSide == prediction.predictedSide,
            );
      state = state.copyWith(predictions: updatedPredictions);
    } else if (existingIndex != -1) {
      // Update the existing prediction
      final updatedPredictions =
          List<PredictionFixtureModel>.from(state.predictions);
      updatedPredictions[existingIndex] = prediction;
      state = state.copyWith(predictions: updatedPredictions);
    } else if (state.predictions.length < 11) {
      // Add new prediction
      state = state.copyWith(predictions: [
        ...state.predictions,
        prediction,
      ]);
    } else if (state.predictions.length >= 11) {
      DialogManger.showAutoCloseResultDialog(context,
          isSuccess: false,
          description: "အများဆုံး ၁၁ ပွဲသာ ရွေးချယ်နိုင်ပါသည်");
    }
  }

  @override
  void onPrediction(BuildContext context, {required num predictedCoin}) {
    if (state.predictions.length < 2) {
      DialogManger.showAutoCloseResultDialog(context,
          isSuccess: false,
          description: "အနည်းဆုံး ၂ ပွဲ ရွေးချယ်ရန် လိုအပ်ပါသည်");
    } else if ((predictedCoin < 500)) {
      DialogManger.showAutoCloseResultDialog(context,
          isSuccess: false,
          description: "အနည်းဆုံး 500 ကျပ် လောင်းရန် လိုအပ်ပါသည်");
    } else {
      _getEstimateWining(context, predictedCoin: predictedCoin);
    }
  }

  _getEstimateWining(BuildContext context, {required num predictedCoin}) async {
    _pollingTimer.stop();
    DialogManger.showLoading(context);
    final res = await _predictionService.getAccumulatorEstimateWining({
      "items": state.predictions
          .map((p) => {
                "fixture_id": p.fixtureId,
                "handicap_odd_id": p.oddId,
                "prediction_type": p.predictionType,
                "predicted_side": p.predictedSide,
              })
          .toList(),
      "predicted_coin": predictedCoin
    });
    DialogManger.closeDialog(context);

    if (res.isSuccess) {
      await DialogManger.showAccumulatorEstimateWiningCoin(
        context,
        data: res.data!,
        predictions: state.predictions,
        predictedCoin: predictedCoin,
        onDeletePrediction: (id) {
          if (state.predictions.length > 2) {
            state = state.copyWith(
              predictions:
                  state.predictions.where((p) => p.fixtureId != id).toList(),
            );
          } else {
            DialogManger.showAutoCloseResultDialog(context,
                isSuccess: false,
                description: "အနည်းဆုံး ၂ ပွဲ ရွေးချယ်ရန် လိုအပ်ပါသည်");
          }
        },
        onConfirm: () {
          _confirmPrediction(context, predictedCoin: predictedCoin);
        },
        onClose: () {
          _updateOddIds();
        },
      );
    } else {
      DialogManger.showAutoCloseResultDialog(context,
          isSuccess: res.isSuccess,
          description: res.isSuccess ? res.msg ?? "" : res.error ?? "");
    }
    _pollingTimer.start();
  }

  _updateOddIds() async {
    await _getFixtures();
    final updatedPredictions = state.predictions.map((prediction) {
      final targetFixture = state.fixtures
          .expand((leagueFixturesList) => leagueFixturesList)
          .expand((leagueFixturesModel) =>
              leagueFixturesModel.fixtures ?? <FixtureModel>[])
          .where((fixture) => fixture.id == prediction.fixtureId)
          .firstOrNull;

      if (targetFixture?.oddId != null) {
        prediction.oddId = targetFixture!.oddId!;
      }
      return prediction;
    }).toList();

    state = state.copyWith(predictions: updatedPredictions);
    print(
        "All prediction oddIds: ${state.predictions.map((p) => p.oddId).toList()}");
  }

  _confirmPrediction(BuildContext context, {required num predictedCoin}) async {
    final expireMatchCount = state.predictions
        .where((e) => e.matchDateAndTime?.isExpired() ?? false)
        .length;

    if (expireMatchCount > 0) {
      DialogManger.showExpireMatchAlertDialog(
        context,
        expireMatchCount: expireMatchCount,
        onClearCallback: () {
          final updatedPredictions = state.predictions
              .where((e) => !(e.matchDateAndTime?.isExpired() ?? false))
              .toList();
          state = state.copyWith(predictions: updatedPredictions);
          _getEstimateWining(context, predictedCoin: predictedCoin);
        },
        onCancelCallback: () {
          _getEstimateWining(context, predictedCoin: predictedCoin);
        },
      );
      return;
    }

    if (state.predictions.length < 2) {
      DialogManger.showAutoCloseResultDialog(context,
          isSuccess: false,
          description: "အနည်းဆုံး ၂ ပွဲ ရွေးချယ်ရန် လိုအပ်ပါသည်");
      return;
    }

    state = state.copyWith(isLoading: true);

    final res = await _predictionService.accumulatorPrediction({
      "items": state.predictions
          .map((p) => {
                "fixture_id": p.fixtureId,
                "handicap_odd_id": p.oddId,
                "prediction_type": p.predictionType,
                "predicted_side": p.predictedSide,
              })
          .toList(),
      "predicted_coin": predictedCoin
    });
    if (res.isSuccess) {
      state = AccumulatorState(
        fixtures: state.fixtures,
        leagueIds: state.leagueIds,
        leauges: state.leauges,
        isLoading: false,
      );
    }

    DialogManger.showAutoCloseResultDialog(context,
        isSuccess: res.isSuccess,
        description: res.isSuccess ? res.msg ?? "" : res.error ?? "");
  }

  @override
  void showPreviewPrediction(BuildContext context) {
    if (state.predictions.length < 2) {
      DialogManger.showAutoCloseResultDialog(context,
          isSuccess: false,
          description: "အနည်းဆုံး ၂ ပွဲ ရွေးချယ်ရန် လိုအပ်ပါသည်");
      return;
    }
    final selectedFixtures = state.fixtures
        .expand((leagueFixturesList) => leagueFixturesList)
        .expand((leagueFixturesModel) =>
            leagueFixturesModel.fixtures ?? <FixtureModel>[])
        .where((fixture) => state.predictions
            .any((prediction) => fixture.id == prediction.fixtureId))
        .toList();

    DialogManger.showPredictionPreviewDialog(
      context,
      onConfirm: () {},
      items: selectedFixtures,
      prediction: state.predictions,
      predictedCoin: null,
      estimateWinningCoin: null,
      onDeletePrediction: (id) {
        state = state.copyWith(
          predictions:
              state.predictions.where((p) => p.fixtureId != id).toList(),
        );
      },
    );
  }
}
