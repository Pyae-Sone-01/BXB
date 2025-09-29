import 'package:bxb/datasources/services/local/local_storage_service.dart';
import 'package:bxb/services/auth/models/auth_response_model.dart';

import '../../datasources/services/remote/api_route.dart';
import '../../datasources/services/remote/api_service.dart';
import '../../datasources/models/base_response.dart';

abstract class AuthRepository {
  Future<BaseResponse<dynamic>> loginWithBff(Map<String, dynamic> payload);
  Future<BaseResponse> getOtp(Map<String, dynamic> payload);
  Future<BaseResponse<AuthResponseModel>> verifyOtp(
      Map<String, dynamic> payload);
  Future<BaseResponse<AuthResponseModel>> register(
      Map<String, dynamic> payload);

  void saveToken(String token);
  void removeToken();
  bool hasToken();
}

class AuthRepositoryImp implements AuthRepository {
  final ApiService _apiService;
  AuthRepositoryImp(this._apiService);

  @override
  Future<BaseResponse<dynamic>> loginWithBff(Map<String, dynamic> payload) {
    // {
    //     "authKey": "dNuVYI2KKbu_5ALCp0rkAWo0Vmt6b1hPdDVqdHg5bzFpbWg3QVRKbVNuanIrdzBnNHgxdWJVZUNCYUo0S0U1YzVMYVd6WTdMeUVLN1kxdHdQNGt6OUN0K25SSWcwS1pBby9XTUZhSERXcnZwb1BTN1B5RVcrc3N6ZEtVPQ=="
    // }
    return _apiService.post(
      ApiRoute.auth.loginWithBff,
      body: payload,
      fromJson: (data) => data,
    );
  }

  @override
  Future<BaseResponse> getOtp(Map<String, dynamic> payload) {
    // {
    //     "phoneOrEmail": "0997348343",
    //     "type": "email"
    // }
    return _apiService.post(
      ApiRoute.auth.getOtp,
      body: payload,
      fromJson: (data) {},
    );
  }

  @override
  Future<BaseResponse<AuthResponseModel>> verifyOtp(
      Map<String, dynamic> payload) {
    ///payload example
    //{
    //     "phoneOrEmail": "0997348343",
    //     "otp": "1234",
    //     "type": "phone"
    // }

    return _apiService.post(
      ApiRoute.auth.verifyOtp,
      body: payload,
      fromJson: (data) => AuthResponseModel.fromJson(data),
    );
  }

  @override
  Future<BaseResponse<AuthResponseModel>> register(
      Map<String, dynamic> payload) {
//     {
//     "name": "New user",
//     "phoneOrEmail": "0997348343",
//     "otp": "1234",
//     "type": "phone",
//     "agentCode": ""
// }

    return _apiService.post(
      ApiRoute.auth.register,
      body: payload,
      fromJson: (data) => AuthResponseModel.fromJson(data),
    );
  }

  @override
  void saveToken(String token) {
    LocalStorageServices.setData(LocalStorageKey.token, token);
  }

  @override
  void removeToken() {
    LocalStorageServices.deleteData(LocalStorageKey.token);
  }

  @override
  bool hasToken() {
    final token = LocalStorageServices.getData(LocalStorageKey.token);

    return token.isNotEmpty;
  }
}
