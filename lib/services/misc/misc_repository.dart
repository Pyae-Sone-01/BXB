import 'package:bxb/datasources/models/base_response.dart';
import 'package:bxb/datasources/services/remote/api_route.dart';
import 'package:bxb/datasources/services/remote/api_service.dart';
import 'package:bxb/services/misc/models/force_update_response_model.dart';
import 'package:bxb/services/misc/models/notification_model.dart';

import 'package:bxb/services/user/models/user_model.dart';

abstract class MiscRepository {
  Future<BaseResponse<List<NotificationModel>>> getNotification(
      Map<String, dynamic> payload);
  Future<BaseResponse<ForceUpdateResponseModel?>> checkForUpdate(
      Map<String, dynamic> payload);
  Future<BaseResponse<bool>> checkBffIntegrationStatus();
}

class MiscRepositoryImpl implements MiscRepository {
  final ApiService _apiService;
  MiscRepositoryImpl(this._apiService);

  @override
  Future<BaseResponse<List<NotificationModel>>> getNotification(
      Map<String, dynamic> payload) {
    return _apiService.get(ApiRoute.misc.notification,
        queryParameters: payload,
        fromJson: (data) => data.containsKey("data")
            ? (data['data'] as List)
                .map((item) =>
                    NotificationModel.fromJson(item as Map<String, dynamic>))
                .toList()
            : <NotificationModel>[]);
  }

  @override
  Future<BaseResponse<ForceUpdateResponseModel?>> checkForUpdate(
      Map<String, dynamic> payload) async {
    return _apiService.post(ApiRoute.misc.checkForUpdate,
        queryParameters: payload,
        fromJson: (data) => ForceUpdateResponseModel.fromJson(data));
  }

  @override
  Future<BaseResponse<bool>> checkBffIntegrationStatus() {
    return _apiService.get(ApiRoute.misc.bffIntegrationStatus,
        fromJson: (data) => data as bool);
  }
}
