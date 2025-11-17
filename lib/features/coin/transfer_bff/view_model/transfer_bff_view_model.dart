import 'package:bxb/utils/common/dialog_manager/dialog_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bxb/services/coin/coin_service.dart';
import 'package:bxb/services/coin/models/bff_coin_model.dart';
import 'package:bxb/services/coin/providers/coin_service_provider.dart';
part 'transfer_bff_view_model.g.dart';

abstract class TransferBffViewModel {
  void initializeData();
  void depositBffCoin(
    BuildContext context,
    num amt,
  );
}

class TransferBffState {
  final bool isLoading;
  final BffCoinModel? bffCoin;

  TransferBffState({
    this.isLoading = false,
    this.bffCoin,
  });

  TransferBffState copyWith({
    bool? isLoading,
    BffCoinModel? bffCoin,
  }) {
    return TransferBffState(
      isLoading: isLoading ?? this.isLoading,
      bffCoin: bffCoin ?? this.bffCoin,
    );
  }
}

@riverpod
class TransferBffViewModelImpl extends _$TransferBffViewModelImpl
    implements TransferBffViewModel {
  late final CoinService _coinService;

  @override
  TransferBffState build() {
    _coinService = ref.read(coinServiceProvider);
    return TransferBffState();
  }

  @override
  void initializeData() {
    _getBffCoin();
  }

  Future<void> _getBffCoin() async {
    state = state.copyWith(isLoading: true);
    final res = await _coinService.getBffCoin();
    state = state.copyWith(isLoading: false);
    if (res.isSuccess && res.data != null) {
      state = state.copyWith(bffCoin: res.data!);
    }
  }

  @override
  void depositBffCoin(BuildContext context, num amt) async {
    DialogManger.showLoading(context);
    final res = await _coinService.depositBffCoin({"amount": amt});

    DialogManger.closeDialog(context);

    if (res.isSuccess) {
      _getBffCoin();
      DialogManger.showAutoCloseResultDialog(context,
          isSuccess: true,
          description: "BFF Coins ဖြည့်သွင်းခြင်း အောင်မြင်ပါသည်");
    } else {
      DialogManger.showResultDialog(context,
          isSuccess: false,
          title: "BFF Coins ဖြည့်သွင်းခြင်း မအောင်မြင်ပါ",
          description:
              "BFF မှ Coin ဖြည့်သွင်းခြင်း မအောင်မြင်ပါ။ ကျေးဇူးပြု၍ ထပ်မံကြိုးစားပါ။",
          confirmCallback: () {});
    }
  }
}
