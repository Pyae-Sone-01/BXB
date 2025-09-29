import 'package:bxb/datasources/models/base_response.dart';
import 'package:bxb/datasources/services/remote/api_route.dart';
import 'package:bxb/datasources/services/remote/api_service.dart';

import 'package:bxb/services/user/models/user_model.dart';

abstract class UserRepository {
  Future<BaseResponse<UserModel>> me();
  Future<BaseResponse> setupWithdrawPin(Map<String, dynamic> payload);
  Future<BaseResponse> updateWithdrawPin(Map<String, dynamic> payload);
  Future<BaseResponse> updateAgent(Map<String, dynamic> payload);
}

class UserRepositoryImpl implements UserRepository {
  final ApiService _apiService;
  UserRepositoryImpl(this._apiService);

  @override
  Future<BaseResponse<UserModel>> me() async {
    return _apiService.get(
      ApiRoute.user.me,
      fromJson: (data) => UserModel.fromJson(data),
    );
  }

  @override
  Future<BaseResponse> setupWithdrawPin(Map<String, dynamic> payload) {
    // TODO: implement setupWithdrawPin
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse> updateAgent(Map<String, dynamic> payload) {
    // TODO: implement updateAgent
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse> updateWithdrawPin(Map<String, dynamic> payload) {
    // TODO: implement updateWithdrawPin
    throw UnimplementedError();
  }
}
