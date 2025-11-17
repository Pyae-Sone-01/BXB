import 'package:firebase_messaging/firebase_messaging.dart';

import '../result_model.dart';
import 'auth_repository.dart';

abstract class AuthService {
  Future<ResultModel> getOtp(Map<String, dynamic> payload);
  Future<ResultModel> verifyOtp(Map<String, dynamic> payload);
  Future<ResultModel> register(Map<String, dynamic> payload);
  Future<ResultModel<bool>> checkAtomPhone(Map<String, dynamic> payload);
  Future<ResultModel> registerWithAtom(Map<String, dynamic> payload);
  Future<ResultModel> loginWithAtom(Map<String, dynamic> payload);
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
      String? apnsToken = await FirebaseMessaging.instance.getToken();
      final res = await _authRepository
          .register({'device_token': apnsToken, ...payload});
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
      String? apnsToken = await FirebaseMessaging.instance.getToken();

      final res = await _authRepository
          .verifyOtp({'device_token': apnsToken, ...payload});
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

  @override
  Future<ResultModel<bool>> checkAtomPhone(Map<String, dynamic> payload) async {
    try {
      final res = await _authRepository.checkAtomPhone(payload);
      if (res.success) {
        return ResultModel.success(res.data, msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel> registerWithAtom(Map<String, dynamic> payload) async {
    try {
      final res = await _authRepository.registerWithAtom(payload);
      if (res.success) {
        return ResultModel.success("", msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel> loginWithAtom(Map<String, dynamic> payload) async {
    try {
      String? apnsToken = await FirebaseMessaging.instance.getToken();
      final res = await _authRepository
          .loginWithAtom({'device_token': apnsToken, ...payload});
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
