import 'package:bxb/services/prediction/models/accumulator_estimate_wining_res_model.dart';

import 'package:bxb/services/prediction/prediction_service.dart';
import 'package:bxb/services/prediction/providers/prediction_service_provider.dart';
import 'package:bxb/services/fixture/models/prediction_fixture_model.dart';
import 'package:bxb/utils/helpers/polling_timer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../services/prediction/models/estimate_fixture_item_model.dart';

part 'handicap_estimate_dialog_view_model.g.dart';

class HandicapEstimateDialogState {
  final EstimateWiningFixtureItemModel? data;

  final String? error;
  final PredictionFixtureModel? prediction;
  final num predictedCoin;

  HandicapEstimateDialogState(
      {this.data, this.error, this.prediction, this.predictedCoin = 0});

  HandicapEstimateDialogState copyWith(
      {EstimateWiningFixtureItemModel? data,
      String? error,
      PredictionFixtureModel? prediction,
      num? predictedCoin}) {
    return HandicapEstimateDialogState(
      data: data ?? this.data,
      error: error ?? this.error,
      prediction: prediction ?? this.prediction,
      predictedCoin: predictedCoin ?? this.predictedCoin,
    );
  }
}

@riverpod
class HandicapEstimateDialogViewModel
    extends _$HandicapEstimateDialogViewModel {
  late final PredictionService _predictionService =
      ref.read(predictionServiceProvider);

  PollingTimer? _pollingTimer;

  @override
  HandicapEstimateDialogState build() {
    ref.onDispose(() {
      _pollingTimer?.stop();
      _pollingTimer = null;
    });

    return HandicapEstimateDialogState();
  }

  void initializeWithData(
      {required EstimateWiningFixtureItemModel data,
      required PredictionFixtureModel prediction,
      required num predictedCoin}) {
    state = state.copyWith(
      data: data,
      error: null,
      predictedCoin: predictedCoin,
      prediction: prediction,
    );
    _pollingTimer = PollingTimer(
      onTick: () async {
        await _getEsitmateWinning(prediction: prediction);
      },
    )..start();
  }

  Future _getEsitmateWinning({
    required PredictionFixtureModel prediction,
  }) async {
    state = state.copyWith(prediction: prediction);

    final res = await _predictionService.getHandicapEstimateWining({
      "fixture_id": prediction.fixtureId,
      "handicap_odd_id": prediction.oddId,
      "prediction_type": prediction.predictionType,
      "predicted_side": prediction.predictedSide,
      "predicted_coin": state.predictedCoin
    });

    if (res.isSuccess && res.data != null) {
      state = state.copyWith(
        data: res.data,
      );
    } else {
      state = state.copyWith(
        error: res.error ?? "Failed to refresh estimate",
      );
    }
  }
}
