import 'package:bxb/services/coin/coin_service.dart';
import 'package:bxb/services/coin/providers/coin_service_provider.dart';
import 'package:bxb/services/fixture/fixture_service.dart';
import 'package:bxb/services/fixture/models/league_fixture_model.dart';
import 'package:bxb/services/fixture/models/league_model.dart';
import 'package:bxb/services/fixture/models/prediction_fixture_model.dart';
import 'package:bxb/services/fixture/providers/fixture_service_provider.dart';
import 'package:bxb/utils/common/dialog_manager/dialog_manager.dart';
import 'package:bxb/utils/helpers/functions.dart';
import 'package:bxb/utils/helpers/polling_timer.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
part 'handicap_view_model.g.dart';

abstract class HandicapViewModel {
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

  final PredictionFixtureModel? prediction;

  HandicapState({
    this.fixtures = const [],
    this.leauges = const [],
    this.leagueIds = const [],
    this.isLoading = true,
    this.remainingBalance = 0,
    this.prediction,
  });

  HandicapState copyWith(
      {bool? isLoading,
      List<List<LeagueFixturesModel>>? fixtures,
      List<LeagueModel>? leauges,
      List<num>? leagueIds,
      num? remainingBalance,
      PredictionFixtureModel? prediction}) {
    return HandicapState(
      isLoading: isLoading ?? this.isLoading,
      fixtures: fixtures ?? this.fixtures,
      leauges: leauges ?? this.leauges,
      leagueIds: leagueIds ?? this.leagueIds,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      prediction: prediction ?? this.prediction,
    );
  }
}

@riverpod
class HandicapViewModelImpl extends _$HandicapViewModelImpl
    implements HandicapViewModel {
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
        .getHandicapFixture({"league_ids": state.leagueIds.join(",")});
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
    state = state.copyWith(prediction: prediction);
  }

  @override
  void onPrediction(BuildContext context, {required num predictedCoin}) {
    if (state.prediction == null) {
      DialogManger.showAutoCloseResultDialog(context,
          isSuccess: false, description: "ပွဲတစ်ပွဲကို အရင်ရွေးချယ်ပါ");
    } else if ((predictedCoin < 1000)) {
      DialogManger.showAutoCloseResultDialog(context,
          isSuccess: false,
          description: "အနည်းဆုံး ၁၀၀၀ ကျပ် လောင်းရန် လိုအပ်ပါသည်");
    } else {
      final selectedFixture = state.fixtures
          .expand((leagueFixturesList) => leagueFixturesList)
          .expand((leagueFixturesModel) =>
              leagueFixturesModel.fixtures ?? <FixtureModel>[])
          .firstWhere(
            (fixture) =>
                fixture.id == state.prediction?.fixtureId &&
                fixture.oddId == state.prediction?.handicapOddId,
            orElse: () =>
                FixtureModel(), // Provide a default instance or handle differently
          );

      // Use the selectedFixture if needed, or just show the dialog
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
