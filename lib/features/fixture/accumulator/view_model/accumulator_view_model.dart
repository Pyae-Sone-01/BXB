import 'package:bxb/services/coin/coin_service.dart';
import 'package:bxb/services/coin/providers/coin_service_provider.dart';
import 'package:bxb/services/fixture/fixture_service.dart';
import 'package:bxb/services/fixture/models/league_fixture_model.dart';
import 'package:bxb/services/fixture/models/league_model.dart';
import 'package:bxb/services/fixture/providers/fixture_service_provider.dart';
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
  void selectPrediction({required PredictionFixtureModel prediction});
  void onPrediction(BuildContext context, {required num predictedCoin});
}

class HandicapState {
  final bool isLoading;
  final List<List<LeagueFixturesModel>> fixtures;
  final List<LeagueModel> leauges;
  final List<num> leagueIds;
  final num remainingBalance;
  final num? predictedCoin;
  final List<PredictionFixtureModel> predictions;

  HandicapState({
    this.fixtures = const [],
    this.leauges = const [],
    this.leagueIds = const [],
    this.isLoading = true,
    this.remainingBalance = 0,
    this.predictedCoin,
    this.predictions = const [],
  });

  HandicapState copyWith({
    bool? isLoading,
    List<List<LeagueFixturesModel>>? fixtures,
    List<LeagueModel>? leauges,
    List<num>? leagueIds,
    num? remainingBalance,
    num? predictedCoin,
    List<PredictionFixtureModel>? predictions,
  }) {
    return HandicapState(
      isLoading: isLoading ?? this.isLoading,
      fixtures: fixtures ?? this.fixtures,
      leauges: leauges ?? this.leauges,
      leagueIds: leagueIds ?? this.leagueIds,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      predictedCoin: predictedCoin ?? this.predictedCoin,
      predictions: predictions ?? this.predictions,
    );
  }
}

@riverpod
class AccumulatorViewModelImpl extends _$AccumulatorViewModelImpl
    implements AccumulatorViewModel {
  late final FixtureService _fixtureService;
  late final CoinService _coinService;
  late final PollingTimer _pollingTimer;
  @override
  HandicapState build() {
    _fixtureService = ref.read(fixtureServiceProvider);
    _coinService = ref.read(coinServiceProvider);
    ref.onDispose(() {
      _pollingTimer.stop();
    });
    return HandicapState();
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
    if (state.fixtures.isEmpty) {
      state = state.copyWith(isLoading: true);
    }
    final res = await _fixtureService
        .getAccumulatorFixture({"league_ids": state.leagueIds.join(",")});
    state = state.copyWith(isLoading: false);
    if (res.isSuccess) {
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
  void selectPrediction({required PredictionFixtureModel prediction}) {
    final existingIndex = state.predictions.indexWhere(
      (p) => p.handicapOddId == prediction.handicapOddId,
    );
    final isSame = state.predictions.any(
      (p) =>
          p.handicapOddId == prediction.handicapOddId &&
          p.predictedSide == prediction.predictedSide,
    );

    if (isSame) {
      // Remove the prediction
      final updatedPredictions =
          List<PredictionFixtureModel>.from(state.predictions)
            ..removeWhere(
              (p) =>
                  p.handicapOddId == prediction.handicapOddId &&
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
      // final selectedFixture = state.fixtures
      //     .expand((leagueFixturesList) => leagueFixturesList)
      //     .expand((leagueFixturesModel) =>
      //         leagueFixturesModel.fixtures ?? <FixtureModel>[])
      //     .firstWhere(
      //       (fixture) =>
      //           fixture.id == state.prediction?.fixtureId &&
      //           fixture.oddId == state.prediction?.handicapOddId,
      //       orElse: () =>
      //           FixtureModel(), // Provide a default instance or handle differently
      //     );

      // Use the selectedFixture if needed, or just show the dialog
      // DialogManger.showSelectedPredictionDialog(
      //   context,
      //   onConfirm: () {},
      //   items: [selectedFixture],
      //   prediction: [state.prediction!],
      //   predictedCoin: 0,
      //   estimateWinningCoin: 0,
      // );

      // DialogManger.showSelectedPredictionDialog(
      //   context,
      //   onConfirm: () {},
      //   items: [selectedFixture],
      //   prediction: [state.prediction!],
      //   predictedCoin: 0,
      //   estimateWinningCoin: 0,
      // );
    }
  }
}
