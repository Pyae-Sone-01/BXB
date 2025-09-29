import 'package:bxb/services/coin/coin_service.dart';

import 'package:bxb/services/coin/providers/coin_service_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../services/coin/models/bank_info_for_withdraw_model.dart';
import '../../../../utils/common/dialog_manager/dialog_manager.dart';
part 'coin_out_view_model.g.dart';

abstract class CoinOutViewModel {
  void initializeData();
  void selectPayment(int index);

  void onSubmit(BuildContext context,
      {required String amount,
      required String name,
      required String phone,
      required String pin});
}

class CoinInState {
  final bool isLoading;
  final int selectedPayment;

  final List<BankInfoForWithdrawModel> bankInfos;
  final num myCoins;

  CoinInState({
    this.isLoading = false,
    this.selectedPayment = -1,
    this.bankInfos = const [],
    this.myCoins = 0,
  });

  CoinInState copyWith({
    bool? isLoading,
    int? selectedPayment,
    List<BankInfoForWithdrawModel>? bankInfos,
    num? myCoins,
  }) {
    return CoinInState(
      isLoading: isLoading ?? this.isLoading,
      selectedPayment: selectedPayment ?? this.selectedPayment,
      bankInfos: bankInfos ?? this.bankInfos,
      myCoins: myCoins ?? this.myCoins,
    );
  }
}

@riverpod
class CoinOutViewModelImpl extends _$CoinOutViewModelImpl
    implements CoinOutViewModel {
  late final CoinService _coinService;

  @override
  CoinInState build() {
    _coinService = ref.read(coinServiceProvider);
    return CoinInState();
  }

  @override
  void initializeData() async {
    state = state.copyWith(isLoading: true);
    final results = await Future.wait([
      _coinService.myCoin(),
      _coinService.bankInfoForWithdraw(),
    ]);
    final myCoinResult = results[0];
    final bankInfoResult = results[1];

    state = state.copyWith(
      isLoading: false,
      myCoins: myCoinResult.isSuccess ? myCoinResult.data as num? : null,
      bankInfos: bankInfoResult.isSuccess
          ? bankInfoResult.data as List<BankInfoForWithdrawModel>?
          : null,
    );
  }

  @override
  void selectPayment(int index) {
    state = state.copyWith(selectedPayment: index);
  }

  @override
  void onSubmit(BuildContext context,
      {required String amount,
      required String name,
      required String phone,
      required String pin}) async {
    final payload = {
      "payment_method_id": state.bankInfos[state.selectedPayment].id,
      "name": name,
      "account_number": phone,
      "amount": amount,
      "pin": pin
    };
    DialogManger.showLoading(context);
    final res = await _coinService.withdraw(payload);
    DialogManger.closeDialog(context);
    if (res.isSuccess) {
      DialogManger.showResultDialog(context,
          isSuccess: true,
          title: "ငွေထုတ်ရန်တောင်းဆိုခြင်း",
          description:
              "သင်၏ငွေထုတ်ခြင်း အောင်မြင်ပါသည်။ အချက်အလက်များမှန်ကန်ပါက ၅ မိနစ်အတွင်း ငွေလွှဲပေးသွားပါမည်",
          confirmCallback: () {
        context.pop();
      });
    } else {
      DialogManger.showResultDialog(context,
          isSuccess: false,
          title: "ငွေထုတ်ရန်တောင်းဆိုခြင်း",
          description: res.error ??
              "သင်၏ငွေထုတ်ရန်တောင်းဆိုခြင်း မအောင်မြင်ပါသည်။ ထပ်မံ ကြိုးစားပါ။",
          confirmCallback: () {});
    }
  }
}
