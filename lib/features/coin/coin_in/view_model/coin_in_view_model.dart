import 'package:bxb/services/coin/coin_service.dart';
import 'package:bxb/services/coin/models/bank_info_for_deposit_model.dart';
import 'package:bxb/services/coin/providers/coin_service_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../utils/common/dialog_manager/dialog_manager.dart';
part 'coin_in_view_model.g.dart';

abstract class CoinInViewModel {
  void initializeData();
  void selectPayment(int index);

  void onSubmit(BuildContext context,
      {required String amount, required String transactionId});
}

class CoinInState {
  final bool isLoading;
  final int selectedPayment;

  final List<BankInfoForDepositModel> bankInfos;

  CoinInState({
    this.isLoading = false,
    this.selectedPayment = -1,
    this.bankInfos = const [],
  });

  CoinInState copyWith({
    bool? isLoading,
    int? selectedPayment,
    List<BankInfoForDepositModel>? bankInfos,
  }) {
    return CoinInState(
      isLoading: isLoading ?? this.isLoading,
      selectedPayment: selectedPayment ?? this.selectedPayment,
      bankInfos: bankInfos ?? this.bankInfos,
    );
  }
}

@riverpod
class CoinInViewModelImpl extends _$CoinInViewModelImpl
    implements CoinInViewModel {
  late final CoinService _coinService;

  @override
  CoinInState build() {
    _coinService = ref.read(coinServiceProvider);
    return CoinInState();
  }

  @override
  void initializeData() {
    _getBankInfo();
  }

  Future<void> _getBankInfo() async {
    state = state.copyWith(isLoading: true);
    final res = await _coinService.bankInfoForDeposit();
    state = state.copyWith(
      isLoading: false,
    );
    if (res.isSuccess && res.data != null) {
      state = state.copyWith(bankInfos: res.data!, selectedPayment: 0);
    }
  }

  @override
  void selectPayment(int index) {
    state = state.copyWith(selectedPayment: index);
  }

  @override
  void onSubmit(BuildContext context,
      {required String amount, required String transactionId}) async {
    final payload = {
      "bank_info_id": state.bankInfos[state.selectedPayment].bankInfo?.first.id,
      "amount": amount,
      "transaction_id": transactionId
    };
    DialogManger.showLoading(context);
    final res = await _coinService.depositCoin(payload);
    DialogManger.closeDialog(context);
    if (res.isSuccess) {
      DialogManger.showResultDialog(context,
          isSuccess: true,
          title: "ငွေသွင်းခြင်း",
          description:
              "သင်၏ငွေသွင်းခြင်း အောင်မြင်ပါသည်။ အချက်အလက်များမှန်ကန်ပါက ၅ မိနစ်အတွင်း ငွေဖြည့်ပေးသွားပါမည်",
          confirmCallback: () {
        context.pop();
      });
    } else {
      DialogManger.showResultDialog(context,
          isSuccess: false,
          title: "ငွေသွင်းခြင်း",
          description: res.error ??
              "သင်၏ငွေသွင်းခြင်း မအောင်မြင်ပါသည်။ ထပ်မံ ကြိုးစားပါ။",
          confirmCallback: () {});
    }
  }
}
