import 'package:bxb/services/coin/coin_service.dart';
import 'package:bxb/services/coin/providers/coin_service_provider.dart';
import 'package:bxb/services/fixture/fixture_service.dart';
import 'package:bxb/services/fixture/models/league_fixture_model.dart';
import 'package:bxb/services/fixture/models/league_model.dart';
import 'package:bxb/services/fixture/models/prediction_fixture_model.dart';
import 'package:bxb/services/fixture/providers/fixture_service_provider.dart';
import 'package:bxb/services/prediction/prediction_service.dart';
import 'package:bxb/services/prediction/providers/prediction_service_provider.dart';
import 'package:bxb/utils/common/dialog_manager/dialog_manager.dart';
import 'package:bxb/utils/extension/string_extension.dart';
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
  void showPreviewPrediction(BuildContext context);
}

class HandicapState {
  final bool isLoading;
  final bool isEmpty;
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
    this.isEmpty = false,
    this.remainingBalance = 0,
    this.prediction,
  });

  HandicapState copyWith(
      {bool? isLoading,
      List<List<LeagueFixturesModel>>? fixtures,
      List<LeagueModel>? leauges,
      List<num>? leagueIds,
      num? remainingBalance,
      PredictionFixtureModel? prediction,
      bool setPredictionNull = false,
      bool? isEmpty}) {
    return HandicapState(
      isLoading: isLoading ?? this.isLoading,
      fixtures: fixtures ?? this.fixtures,
      leauges: leauges ?? this.leauges,
      leagueIds: leagueIds ?? this.leagueIds,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      prediction: setPredictionNull ? null : prediction ?? this.prediction,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }
}

@riverpod
class HandicapViewModelImpl extends _$HandicapViewModelImpl
    implements HandicapViewModel {
  late final FixtureService _fixtureService;
  late final CoinService _coinService;
  late final PollingTimer _pollingTimer;
  late final PredictionService _predictionService =
      ref.read(predictionServiceProvider);
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

  testing() {}

  void dispose() {
    _timer?.cancel();
  }

  Future<void> _getFixtures() async {
    if (state.fixtures.isEmpty && !state.isEmpty) {
      state = state.copyWith(isLoading: true);
    }
    final res = await _fixtureService
        .getHandicapFixture({"league_ids": state.leagueIds.join(",")});
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
  void selectPrediction({required PredictionFixtureModel prediction}) {
    // final targetFixture = state.fixtures
    //     .expand((leagueFixturesList) => leagueFixturesList)
    //     .expand((leagueFixturesModel) =>
    //         leagueFixturesModel.fixtures ?? <FixtureModel>[])
    //     .where((fixture) => fixture.id == state.prediction!.fixtureId)
    //     .firstOrNull;
    // if (targetFixture != null) {
    //   prediction.oddId = targetFixture.oddId!;
    // }
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
      _getEstimateWining(context, predictedCoin: predictedCoin);
    }
  }

  _updateOddId() async {
    if (state.prediction != null) {
      final targetFixture = state.fixtures
          .expand((leagueFixturesList) => leagueFixturesList)
          .expand((leagueFixturesModel) =>
              leagueFixturesModel.fixtures ?? <FixtureModel>[])
          .where((fixture) => fixture.id == state.prediction!.fixtureId)
          .firstOrNull;

      if (targetFixture?.oddId != null) {
        final updatedPrediction = state.prediction!;
        updatedPrediction.oddId = targetFixture!.oddId!;
        state = state.copyWith(prediction: updatedPrediction);
      }
    }
  }

  _getEstimateWining(BuildContext context, {required num predictedCoin}) async {
    final prediction = state.prediction;
    DialogManger.showLoading(context);
    final res = await _predictionService.getHandicapEstimateWining({
      "fixture_id": prediction?.fixtureId,
      "handicap_odd_id": prediction?.oddId,
      "prediction_type": prediction?.predictionType,
      "predicted_side": prediction?.predictedSide,
      "predicted_coin": predictedCoin
    });
    DialogManger.closeDialog(context);
    if (res.isSuccess) {
      DialogManger.showHandicapEstimateWiningCoin(context, onConfirm: () {
        _confirmPrediction(
          context,
          predictedCoin: predictedCoin,
        );
      }, onClose: () async {
        await _getFixtures();
        _updateOddId();
      },
          data: res.data!,
          predictedCoin: predictedCoin,
          prediction: prediction!);
    } else {
      DialogManger.showAutoCloseResultDialog(context,
          isSuccess: res.isSuccess,
          description: res.isSuccess ? res.msg ?? "" : res.error ?? "");
    }
  }

  _confirmPrediction(BuildContext context, {required num predictedCoin}) async {
    final hasMatchExpire = state.prediction?.matchDateAndTime?.isExpired();

    if (hasMatchExpire ?? false) {
      DialogManger.showExpireMatchAlertDialog(
        context,
        expireMatchCount: 1,
        onClearCallback: () {
          state = state.copyWith(setPredictionNull: true);
          _getEstimateWining(context, predictedCoin: predictedCoin);
        },
        onCancelCallback: () {
          _getEstimateWining(context, predictedCoin: predictedCoin);
        },
      );
      return;
    }

    state = state.copyWith(isLoading: true);

    final res = await _predictionService.handicapPrediction({
      "fixture_id": state.prediction?.fixtureId,
      "handicap_odd_id": state.prediction?.oddId,
      "prediction_type": state.prediction?.predictionType,
      "predicted_side": state.prediction?.predictedSide,
      "predicted_coin": predictedCoin
    });
    state = HandicapState(
      fixtures: state.fixtures,
      leagueIds: state.leagueIds,
      leauges: state.leauges,
      isLoading: false,
    );

    DialogManger.showAutoCloseResultDialog(context,
        isSuccess: res.isSuccess,
        description: res.isSuccess ? res.msg ?? "" : res.error ?? "");
  }

  @override
  void showPreviewPrediction(BuildContext context) {
    if (state.prediction == null) {
      DialogManger.showAutoCloseResultDialog(context,
          isSuccess: false, description: "ပွဲတစ်ပွဲကို အရင်ရွေးချယ်ပါ");
      return;
    }
    final selectedFixture = state.fixtures
        .expand((leagueFixturesList) => leagueFixturesList)
        .expand((leagueFixturesModel) =>
            leagueFixturesModel.fixtures ?? <FixtureModel>[])
        .firstWhere(
          (fixture) => fixture.id == state.prediction?.fixtureId,
          orElse: () =>
              FixtureModel(), // Provide a default instance or handle differently
        );

    DialogManger.showPredictionPreviewDialog(
      context,
      onConfirm: () {},
      items: [selectedFixture],
      prediction: [state.prediction!],
      predictedCoin: null,
      estimateWinningCoin: null,
      onDeletePrediction: (id) {},
    );
  }
}
