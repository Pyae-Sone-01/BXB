import 'package:bxb/services/coin/coin_repository.dart';
import 'package:bxb/services/coin/models/bank_info_for_deposit_model.dart';
import 'package:bxb/services/coin/models/bank_info_for_withdraw_model.dart';
import 'package:bxb/services/coin/models/bff_coin_model.dart';
import 'package:bxb/services/coin/models/coin_history_model.dart';
import 'package:bxb/services/result_model.dart';

abstract class CoinService {
  Future<ResultModel<num>> myCoin();
  Future<ResultModel<BffCoinModel>> getBffCoin();
  Future<ResultModel<List<BankInfoForDepositModel>>> bankInfoForDeposit();
  Future<ResultModel<List<BankInfoForWithdrawModel>>> bankInfoForWithdraw();
  Future<ResultModel<List<CoinHistoryModel>>> getCoinHistores(
      {bool? isGetFromCache, required Map<String, dynamic> payload});
  Future<ResultModel> depositCoin(Map<String, dynamic> payload);
  Future<ResultModel> withdraw(Map<String, dynamic> payload);
  Future<ResultModel> depositBffCoin(Map<String, dynamic> payload);
}

class CoinServiceImpl implements CoinService {
  final CoinRepository _coinRepository;

  CoinServiceImpl(this._coinRepository);

  @override
  Future<ResultModel<List<BankInfoForDepositModel>>>
      bankInfoForDeposit() async {
    try {
      final res = await _coinRepository.bankInfoForDeposit();
      if (res.success && (res.data != null && res.data!.isNotEmpty)) {
        return ResultModel.success(res.data, msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel<List<BankInfoForWithdrawModel>>>
      bankInfoForWithdraw() async {
    try {
      final res = await _coinRepository.bankInfoForWithdraw();
      if (res.success && (res.data != null && res.data!.isNotEmpty)) {
        return ResultModel.success(res.data, msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel<BffCoinModel>> getBffCoin() async {
    try {
      final res = await _coinRepository.getBffCoin();
      if (res.success && res.data != null) {
        return ResultModel.success(res.data, msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel<num>> myCoin() async {
    try {
      final res = await _coinRepository.myCoin();
      if (res.success && res.data != null) {
        return ResultModel.success(res.data, msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel<List<CoinHistoryModel>>> getCoinHistores(
      {bool? isGetFromCache, required Map<String, dynamic> payload}) async {
    try {
      final res = await _coinRepository.getCoinHistores(
          payload: payload, isGetFromCache: isGetFromCache ?? false);
      if (res.success && (res.data != null && res.data!.isNotEmpty)) {
        return ResultModel.success(res.data, msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel> depositCoin(Map<String, dynamic> payload) async {
    try {
      final res = await _coinRepository.depositCoin(payload);

      if (res.success) {
        return ResultModel.success("", msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel> withdraw(Map<String, dynamic> payload) async {
    try {
      final res = await _coinRepository.widthdraw(payload);

      if (res.success) {
        return ResultModel.success("", msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }

  @override
  Future<ResultModel> depositBffCoin(Map<String, dynamic> payload) async {
    try {
      final res = await _coinRepository.depositBffCoin(payload);

      if (res.success) {
        return ResultModel.success("", msg: res.msg);
      }
      throw res.msg;
    } catch (e) {
      return ResultModel.failure(e.toString());
    }
  }
}
