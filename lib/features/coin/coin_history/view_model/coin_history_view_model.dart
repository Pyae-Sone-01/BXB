import 'package:bxb/services/coin/models/coin_history_model.dart';
import 'package:bxb/services/coin/coin_service.dart';
import 'package:bxb/services/coin/providers/coin_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'coin_history_view_model.g.dart';

class CoinHistoryState {
  final bool isLoading;
  final List<CoinHistoryModel> histories;

  CoinHistoryState({
    this.isLoading = false,
    this.histories = const [],
  });

  CoinHistoryState copyWith({
    bool? isLoading,
    List<CoinHistoryModel>? histories,
  }) {
    return CoinHistoryState(
      isLoading: isLoading ?? this.isLoading,
      histories: histories ?? this.histories,
    );
  }
}

@riverpod
class CoinHistoryViewModel extends _$CoinHistoryViewModel {
  late final CoinService _coinService;
  @override
  CoinHistoryState build() {
    _coinService = ref.read(coinServiceProvider);
    return CoinHistoryState();
  }

  void initializeData() async {
    await _getHistories(isGetFromCache: true);
    await _getHistories();
  }

  Future<void> _getHistories({bool? isGetFromCache}) async {
    if (isGetFromCache != true) {
      state = state.copyWith(isLoading: true);
    }
    final res =
        await _coinService.getCoinHistores(isGetFromCache: isGetFromCache);
    state = state.copyWith(isLoading: false);
    if (res.isSuccess && res.data != null) {
      state = state.copyWith(histories: res.data!);
    }
  }
}
