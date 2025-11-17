import 'package:bxb/services/fixture/fixture_repository.dart';
import 'package:bxb/services/fixture/models/league_fixture_model.dart';
import 'package:bxb/services/result_model.dart';

import 'models/fixture_for_score_model.dart';
import 'models/league_model.dart';

abstract class FixtureService {
  Future<ResultModel<List<LeagueModel>>> getAllLeagues();

  Future<ResultModel<List<List<LeagueFixturesModel>>>> getHandicapFixture(
      Map<String, dynamic> payload);

  Future<ResultModel<List<List<LeagueFixturesModel>>>> getAccumulatorFixture(
      Map<String, dynamic> payload);

  Future<ResultModel<FixtureForScoreModel>> getScoreForFixture();
}

class FixtureServiceImpl implements FixtureService {
  final FixtureRepository _fixtureRepository;

  FixtureServiceImpl(this._fixtureRepository);

  @override
  Future<ResultModel<List<List<LeagueFixturesModel>>>> getAccumulatorFixture(
      Map<String, dynamic> payload) async {
    try {
      final res = await _fixtureRepository.getAccumulatorFixture(payload);
      if (res.success && res.data != null) {
        return ResultModel.success(res.data, msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel<List<LeagueModel>>> getAllLeagues() async {
    try {
      final res = await _fixtureRepository.getAllLeagues();
      if (res.success && res.data != null && res.data!.isNotEmpty) {
        return ResultModel.success(res.data, msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel<List<List<LeagueFixturesModel>>>> getHandicapFixture(
      Map<String, dynamic> payload) async {
    try {
      final res = await _fixtureRepository.getHandicapFixture(payload);
      if (res.success && res.data != null) {
        return ResultModel.success(res.data, msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel<FixtureForScoreModel>> getScoreForFixture() async {
    try {
      final res = await _fixtureRepository.getScoreForFixture();
      if (res.success && res.data != null) {
        return ResultModel.success(res.data, msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }
}
