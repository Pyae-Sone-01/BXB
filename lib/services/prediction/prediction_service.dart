import 'package:bxb/services/prediction/models/estimate_fixture_item_model.dart';

import 'package:bxb/services/prediction/prediction_repository.dart';
import 'package:bxb/services/result_model.dart';

import 'models/history_detail_model.dart';
import 'models/history_model.dart';

abstract class PredictionService {
  Future<ResultModel<List<HistoryModel>>> getOnGoingHistories(
      Map<String, dynamic> payload);
  Future<ResultModel<List<HistoryModel>>> getFinishedHistories(
      Map<String, dynamic> payload);
  Future<ResultModel<HistoryDetailModel>> getHistoryDetail({required int id});
  Future<ResultModel<EstimateWiningFixtureItemModel>> getHandicapEstimateWining(
      Map<String, dynamic> payload);
  Future<ResultModel> handicapPrediction(Map<String, dynamic> payload);
}

class PredictionServiceImpl implements PredictionService {
  final PredictionRepository _predictionRepository;

  PredictionServiceImpl(this._predictionRepository);

  @override
  Future<ResultModel<List<HistoryModel>>> getFinishedHistories(
      Map<String, dynamic> payload) async {
    try {
      final res = await _predictionRepository.getFinishedHistories(payload);
      if (res.success && res.data != null && res.data!.isNotEmpty) {
        return ResultModel.success(res.data, msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel<HistoryDetailModel>> getHistoryDetail(
      {required int id}) async {
    try {
      final res = await _predictionRepository.getHistoryDetail(id: id);
      if (res.success && res.data != null) {
        return ResultModel.success(res.data, msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel<List<HistoryModel>>> getOnGoingHistories(
      Map<String, dynamic> payload) async {
    try {
      final res = await _predictionRepository.getOnGoingHistories(payload);
      if (res.success && res.data != null && res.data!.isNotEmpty) {
        return ResultModel.success(res.data, msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel<EstimateWiningFixtureItemModel>> getHandicapEstimateWining(
      Map<String, dynamic> payload) async {
    try {
      final res =
          await _predictionRepository.getHandicapEstimateWining(payload);
      if (res.success && res.data != null) {
        return ResultModel.success(res.data, msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel> handicapPrediction(Map<String, dynamic> payload) async {
    try {
      final res = await _predictionRepository.handicapPrediction(payload);

      if (res.success && res.data == true) {
        return ResultModel.success(res.data, msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }
}
