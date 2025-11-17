import 'package:bxb/services/result_model.dart';
import 'package:bxb/services/user/models/user_model.dart';
import 'package:bxb/services/user/user_repository.dart';

abstract class UserService {
  Future<ResultModel<UserModel>> me();
  Future<ResultModel> updateAgentCode(Map<String, dynamic> payload);
  Future<ResultModel> updateWidthdrawPin(Map<String, dynamic> payload);
  Future<ResultModel> setUpWidthdrawPin(Map<String, dynamic> payload);
}

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;

  UserServiceImpl(this._userRepository);

  @override
  Future<ResultModel<UserModel>> me() async {
    try {
      final res = await _userRepository.me();
      if (res.success && res.data != null) {
        return ResultModel.success(res.data, msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel> updateAgentCode(Map<String, dynamic> payload) async {
    try {
      final res = await _userRepository.updateAgent(payload);
      if (res.success) {
        return ResultModel.success("", msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel> updateWidthdrawPin(Map<String, dynamic> payload) async {
    try {
      final res = await _userRepository.updateWithdrawPin(payload);
      if (res.success) {
        return ResultModel.success("", msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel> setUpWidthdrawPin(Map<String, dynamic> payload) async {
    try {
      final res = await _userRepository.setupWithdrawPin(payload);
      if (res.success) {
        return ResultModel.success("", msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }
}
