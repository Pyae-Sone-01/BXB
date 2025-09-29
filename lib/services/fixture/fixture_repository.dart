import 'package:bxb/datasources/models/base_response.dart';
import 'package:bxb/datasources/services/remote/api_route.dart';
import 'package:bxb/datasources/services/remote/api_service.dart';
import 'package:bxb/services/fixture/models/fixture_for_score_model.dart';

import 'package:bxb/services/fixture/models/league_fixture_model.dart';
import 'package:bxb/services/fixture/models/league_model.dart';

abstract class FixtureRepository {
  Future<BaseResponse<List<LeagueModel>>> getAllLeagues();

  Future<BaseResponse<List<List<LeagueFixturesModel>>>> getHandicapFixture(
      Map<String, dynamic> payload);

  Future<BaseResponse<List<List<LeagueFixturesModel>>>> getAccumulatorFixture(
      Map<String, dynamic> payload);

  Future<BaseResponse<FixtureForScoreModel>> getScoreForFixture();
}

class FixtureRepositoryImpl implements FixtureRepository {
  final ApiService _apiService;

  FixtureRepositoryImpl(this._apiService);

  @override
  Future<BaseResponse<List<List<LeagueFixturesModel>>>> getAccumulatorFixture(
      Map<String, dynamic> payload) {
    return _apiService.get(
      ApiRoute.fixture.getHandicapFixture,
      queryParameters: payload,
      fromJson: (data) => (data as List)
          .map<List<LeagueFixturesModel>>(
            (e) => (e as List)
                .map((item) =>
                    LeagueFixturesModel.fromJson(item as Map<String, dynamic>))
                .toList(),
          )
          .toList(),
    );
  }

  @override
  Future<BaseResponse<List<LeagueModel>>> getAllLeagues() async {
    return _apiService.get(
      ApiRoute.fixture.getAllLeagues,
      fromJson: (data) => (data as List)
          .map((e) => LeagueModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<BaseResponse<List<List<LeagueFixturesModel>>>> getHandicapFixture(
      Map<String, dynamic> payload) {
    return _apiService.get(
      ApiRoute.fixture.getHandicapFixture,
      queryParameters: payload,
      fromJson: (data) => (data as List)
          .map<List<LeagueFixturesModel>>(
            (e) => (e as List)
                .map((item) =>
                    LeagueFixturesModel.fromJson(item as Map<String, dynamic>))
                .toList(),
          )
          .toList(),
    );
  }

  @override
  Future<BaseResponse<FixtureForScoreModel>> getScoreForFixture() async {
    return _apiService.get(
      ApiRoute.fixture.getScoreForFixture,
      fromJson: (data) => FixtureForScoreModel.fromJson(data),
    );
  }
}
