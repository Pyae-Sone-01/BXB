import 'package:bxb/services/result_model.dart';
import 'package:bxb/services/user/models/user_model.dart';
import 'package:bxb/services/user/user_repository.dart';

abstract class UserService {
  Future<ResultModel<UserModel>> me();
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
}
