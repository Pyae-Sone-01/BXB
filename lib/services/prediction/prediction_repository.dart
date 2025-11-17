import 'package:bxb/datasources/models/base_response.dart';
import 'package:bxb/datasources/services/remote/api_route.dart';
import 'package:bxb/datasources/services/remote/api_service.dart';
import 'package:bxb/services/prediction/models/accumulator_estimate_wining_res_model.dart';
import 'package:bxb/services/prediction/models/estimate_fixture_item_model.dart';

import 'package:bxb/services/prediction/models/history_detail_model.dart';
import 'package:bxb/services/prediction/models/history_model.dart';
import 'package:bxb/services/prediction/models/share_accumulator_response_model.dart';
import 'package:bxb/services/prediction/models/share_handicap_response_model.dart';

abstract class PredictionRepository {
  Future<BaseResponse<List<HistoryModel>>> getOnGoingHistories(
      Map<String, dynamic> payload);
  Future<BaseResponse<List<HistoryModel>>> getFinishedHistories(
      Map<String, dynamic> payload);
  Future<BaseResponse<HistoryDetailModel>> getHistoryDetail({required int id});
  Future<BaseResponse<EstimateWiningFixtureItemModel>>
      getHandicapEstimateWining(Map<String, dynamic> payload);

  Future<BaseResponse<AccumulatorEstimateWinningResModel>>
      getAccumulatorEstimateWining(Map<String, dynamic> payload);
  Future<BaseResponse<bool>> handicapPrediction(Map<String, dynamic> payload);
  Future<BaseResponse<bool>> accumulatorPrediction(
      Map<String, dynamic> payload);
  Future<BaseResponse<dynamic>> getAccumulatorShareData(
      Map<String, dynamic> payload);
  Future<BaseResponse<dynamic>> getHandicapShareData(
      Map<String, dynamic> payload);
}

class PredictionRepositoryImpl implements PredictionRepository {
  final ApiService _apiService;

  PredictionRepositoryImpl(this._apiService);

  @override
  Future<BaseResponse<List<HistoryModel>>> getFinishedHistories(
      Map<String, dynamic> payload) {
    print(payload);
    return _apiService.get(
      ApiRoute.prediction.finishedHistory,
      queryParameters: payload,
      fromJson: (data) => (data["data"] as List)
          .map((e) => HistoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<BaseResponse<HistoryDetailModel>> getHistoryDetail({required int id}) {
    return _apiService.get(
      "${ApiRoute.prediction.historyDetail}/$id",
      fromJson: (data) => HistoryDetailModel.fromJson(data),
    );
  }

  @override
  Future<BaseResponse<List<HistoryModel>>> getOnGoingHistories(
      Map<String, dynamic> payload) {
    return _apiService.get(
      ApiRoute.prediction.onGoingHistory,
      queryParameters: payload,
      fromJson: (data) => (data["data"] as List)
          .map((e) => HistoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<BaseResponse<EstimateWiningFixtureItemModel>>
      getHandicapEstimateWining(Map<String, dynamic> payload) {
    return _apiService.post(
      ApiRoute.prediction.handicapEstimateWinning,
      body: payload,
      fromJson: (data) => EstimateWiningFixtureItemModel.fromJson(data),
    );
  }

  @override
  Future<BaseResponse<bool>> handicapPrediction(Map<String, dynamic> payload) {
    return _apiService.post(
      ApiRoute.prediction.handicapPrediction,
      body: payload,
      fromJson: (data) => data as bool,
    );
  }

  @override
  Future<BaseResponse<AccumulatorEstimateWinningResModel>>
      getAccumulatorEstimateWining(Map<String, dynamic> payload) {
    return _apiService.post(
      ApiRoute.prediction.accumulatorEstimateWinning,
      body: payload,
      fromJson: (data) => AccumulatorEstimateWinningResModel.fromJson(data),
    );
  }

  @override
  Future<BaseResponse<bool>> accumulatorPrediction(
      Map<String, dynamic> payload) {
    return _apiService.post(
      ApiRoute.prediction.accumulatorPrediction,
      body: payload,
      fromJson: (data) => data as bool,
    );
  }

  @override
  Future<BaseResponse<dynamic>> getAccumulatorShareData(
      Map<String, dynamic> payload) {
    return _apiService.get(
      "${ApiRoute.prediction.shareData}/${payload["id"]}",
      fromJson: (data) => ShareAccumulatorResponseModel.fromJson(data),
    );
  }

  @override
  Future<BaseResponse> getHandicapShareData(Map<String, dynamic> payload) {
    return _apiService.get(
      "${ApiRoute.prediction.shareData}/${payload["id"]}",
      fromJson: (data) => ShareHandicapResponseModel.fromJson(data),
    );
  }
}
