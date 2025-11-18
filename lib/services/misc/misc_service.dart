import 'package:bxb/services/misc/misc_repository.dart';
import 'package:bxb/services/misc/models/notification_model.dart';
import 'package:bxb/services/result_model.dart';

import 'package:package_info_plus/package_info_plus.dart';

import 'models/force_update_response_model.dart';

abstract class MiscService {
  Future<ResultModel<List<NotificationModel>>> getNotification(
      Map<String, dynamic> payload);
  Future<ResultModel<ForceUpdateResponseModel>> checkForUpdate();
  Future<ResultModel<bool>> checkBffIntegrationStatus();
}

class MiscServiceImpl implements MiscService {
  final MiscRepository _miscRepository;

  MiscServiceImpl(this._miscRepository);

  @override
  Future<ResultModel<List<NotificationModel>>> getNotification(
      Map<String, dynamic> payload) async {
    try {
      final res = await _miscRepository.getNotification(payload);
      if (res.success) {
        return ResultModel.success(res.data, msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel<ForceUpdateResponseModel>> checkForUpdate() async {
    // requires: add `import 'package:package_info_plus/package_info_plus.dart';` at the top of the file
    int versionCode;
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      versionCode = int.tryParse(packageInfo.buildNumber) ?? 1;
    } catch (_) {
      versionCode = 1;
    }
    try {
      final res =
          await _miscRepository.checkForUpdate({"version": versionCode});
      if (res.success && res.data != null) {
        return ResultModel.success(res.data, msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel<bool>> checkBffIntegrationStatus() async {
    try {
      final res = await _miscRepository.checkBffIntegrationStatus();
      if (res.success && res.data != null) {
        return ResultModel.success(res.data, msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }
}
