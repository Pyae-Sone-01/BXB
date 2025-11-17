import 'package:bxb/services/prediction/models/accumulator_estimate_wining_res_model.dart';

import 'package:bxb/services/prediction/prediction_service.dart';
import 'package:bxb/services/prediction/providers/prediction_service_provider.dart';
import 'package:bxb/services/fixture/models/prediction_fixture_model.dart';
import 'package:bxb/utils/helpers/polling_timer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accumulator_estimate_dialog_view_model.g.dart';

class AccumulatorEstimateDialogState {
  final AccumulatorEstimateWinningResModel? data;
  final bool isRefreshing;
  final String? error;
  final List<PredictionFixtureModel> predictions;
  final num predictedCoin;

  AccumulatorEstimateDialogState(
      {this.data,
      this.isRefreshing = false,
      this.error,
      this.predictions = const [],
      this.predictedCoin = 0});

  AccumulatorEstimateDialogState copyWith(
      {AccumulatorEstimateWinningResModel? data,
      bool? isRefreshing,
      String? error,
      List<PredictionFixtureModel>? predictions,
      num? predictedCoin}) {
    return AccumulatorEstimateDialogState(
      data: data ?? this.data,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error ?? this.error,
      predictions: predictions ?? this.predictions,
      predictedCoin: predictedCoin ?? this.predictedCoin,
    );
  }
}

@riverpod
class AccumulatorEstimateDialogViewModel
    extends _$AccumulatorEstimateDialogViewModel {
  late final PredictionService _predictionService =
      ref.read(predictionServiceProvider);

  PollingTimer? _pollingTimer;

  @override
  AccumulatorEstimateDialogState build() {
    ref.onDispose(() {
      _pollingTimer?.stop();
      _pollingTimer = null;
    });

    return AccumulatorEstimateDialogState();
  }

  void initializeWithData(
      {required AccumulatorEstimateWinningResModel data,
      required List<PredictionFixtureModel> predictions,
      required num predictedCoin}) {
    state = state.copyWith(
      data: data,
      error: null,
      predictedCoin: predictedCoin,
      predictions: predictions,
    );
    _pollingTimer = PollingTimer(
      onTick: () async {
        await _getEsitmateWinning();
      },
    )..start();
  }

  Future<void> refreshEstimate({
    required List<PredictionFixtureModel> predictions,
  }) async {
    state = state.copyWith(isRefreshing: true, error: null);
    _getEsitmateWinning(predictions: predictions);
    state = state.copyWith(
      isRefreshing: false,
    );
  }

  Future _getEsitmateWinning(
      {List<PredictionFixtureModel>? predictions}) async {
    if (predictions != null) {
      state = state.copyWith(predictions: predictions);
    }

    final res = await _predictionService.getAccumulatorEstimateWining({
      "items": state.predictions
          .map((p) => {
                "fixture_id": p.fixtureId,
                "handicap_odd_id": p.oddId,
                "prediction_type": p.predictionType,
                "predicted_side": p.predictedSide,
              })
          .toList(),
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
