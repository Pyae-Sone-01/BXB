import 'package:bxb/services/auth/models/auth_response_model.dart';

import '../../datasources/services/local/local_storage_service.dart';
import '../result_model.dart';
import 'auth_repository.dart';

abstract class AuthService {
  Future<ResultModel> getOtp(Map<String, dynamic> payload);
  Future<ResultModel> verifyOtp(Map<String, dynamic> payload);
  Future<ResultModel> register(Map<String, dynamic> payload);
  bool hasAuth();
  Future<void> logout();
}

class AuthServiceImpl implements AuthService {
  final AuthRepository _authRepository;

  AuthServiceImpl(this._authRepository);

  @override
  Future<void> logout() async {
    _authRepository.removeToken();
  }

  @override
  bool hasAuth() {
    return _authRepository.hasToken();
  }

  @override
  Future<ResultModel> getOtp(Map<String, dynamic> payload) async {
    try {
      final res = await _authRepository.getOtp(payload);
      if (res.success) {
        return ResultModel.success("", msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel> register(Map<String, dynamic> payload) async {
    try {
      final res = await _authRepository.register(payload);
      if (res.success && res.data != null && res.data?.token != null) {
        _authRepository.saveToken(res.data!.token!);
        return ResultModel.success("", msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel> verifyOtp(Map<String, dynamic> payload) async {
    try {
      final res = await _authRepository.verifyOtp(payload);
      if (res.success && res.data != null) {
        if (res.data?.token != null) {
          _authRepository.saveToken(res.data!.token!);
          return ResultModel.success("", msg: res.msg);
        }

        return ResultModel.success(res.data, msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }
}
