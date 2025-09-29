import 'package:bxb/datasources/models/base_response.dart';
import 'package:bxb/datasources/services/local/network_cache_manager.dart';
import 'package:bxb/datasources/services/remote/api_route.dart' show ApiRoute;
import 'package:bxb/datasources/services/remote/api_service.dart';
import 'package:bxb/services/coin/models/bank_info_for_deposit_model.dart';
import 'package:bxb/services/coin/models/bank_info_for_withdraw_model.dart';
import 'package:bxb/services/coin/models/bff_coin_model.dart';
import 'package:bxb/services/coin/models/coin_history_model.dart';

abstract class CoinRepository {
  Future<BaseResponse<num>> myCoin();
  Future<BaseResponse<BffCoinModel>> getBffCoin();
  Future<BaseResponse<List<BankInfoForDepositModel>>> bankInfoForDeposit();
  Future<BaseResponse<List<BankInfoForWithdrawModel>>> bankInfoForWithdraw();
  Future<BaseResponse<List<CoinHistoryModel>>> getCoinHistores(
      {required bool isGetFromCache});
  Future<BaseResponse> depositCoin(Map<String, dynamic> payload);
  Future<BaseResponse> widthdraw(Map<String, dynamic> payload);
}

class CoinRepositoryImpl implements CoinRepository {
  final ApiService _apiService;

  CoinRepositoryImpl(this._apiService);
  @override
  Future<BaseResponse<num>> myCoin() async {
    return _apiService.get(
      ApiRoute.coin.myCoin,
      fromJson: (data) => data,
    );
  }

  @override
  Future<BaseResponse<List<BankInfoForDepositModel>>> bankInfoForDeposit() {
    return _apiService.get(
      ApiRoute.coin.bankInfoForDeposit,
      fromJson: (data) => (data as List)
          .map((e) =>
              BankInfoForDepositModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<BaseResponse<List<BankInfoForWithdrawModel>>>
      bankInfoForWithdraw() async {
    return _apiService.get(
      ApiRoute.coin.bankInfoForWithdraw,
      fromJson: (data) => (data as List)
          .map((e) =>
              BankInfoForWithdrawModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<BaseResponse<BffCoinModel>> getBffCoin() {
    return _apiService.get(
      ApiRoute.coin.bffCoin,
      fromJson: (data) => BffCoinModel.fromJson(data),
    );
  }

  @override
  Future<BaseResponse<List<CoinHistoryModel>>> getCoinHistores(
      {required bool isGetFromCache}) async {
    apiCall() {
      return _apiService.get(
        ApiRoute.coin.coinHistories,
        rawJson: (json) {
          NetworkCacheManager.saveJson(
            jsonData: json,
            key: ApiRoute.coin.coinHistories,
          );
        },
        fromJson: (data) {
          return (data as List)
              .map((e) => CoinHistoryModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );
    }

    if (isGetFromCache) {
      final json = await NetworkCacheManager.getJson(
        key: ApiRoute.coin.coinHistories,
      );

      if (json != null) {
        return BaseResponse.fromJson(
            json,
            (data) => (data as List)
                .map(
                    (e) => CoinHistoryModel.fromJson(e as Map<String, dynamic>))
                .toList());
      } else {
        return apiCall();
      }
    }
    return apiCall();
  }

  @override
  Future<BaseResponse> depositCoin(Map<String, dynamic> payload) {
    return _apiService.post(ApiRoute.coin.depositCoin,
        body: payload, fromJson: (data) {});
  }

  @override
  Future<BaseResponse> widthdraw(Map<String, dynamic> payload) {
    return _apiService.post(ApiRoute.coin.withdraw,
        body: payload, fromJson: (data) {});
  }
}
