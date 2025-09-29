import 'package:bxb/services/prediction/models/history_model.dart';
import 'package:bxb/services/prediction/prediction_service.dart';
import 'package:bxb/services/prediction/providers/prediction_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'on_going_history_view_model.g.dart';

class OnGoingHistoryState {
  final bool isLoading;
  final bool isLoadmore;
  final bool hasMoreData;
  final int page;
  final List<HistoryModel> histories;

  OnGoingHistoryState({
    this.isLoading = false,
    this.isLoadmore = false,
    this.hasMoreData = true,
    this.page = 1,
    this.histories = const [],
  });

  OnGoingHistoryState copyWith({
    bool? isLoading,
    bool? isLoadmore,
    bool? hasMoreData,
    int? page,
    List<HistoryModel>? histories,
  }) {
    return OnGoingHistoryState(
      isLoading: isLoading ?? this.isLoading,
      isLoadmore: isLoadmore ?? this.isLoadmore,
      page: page ?? this.page,
      histories: histories ?? this.histories,
      hasMoreData: hasMoreData ?? this.hasMoreData,
    );
  }
}

@riverpod
class OnGoingHistoryViewModel extends _$OnGoingHistoryViewModel {
  late final PredictionService _predictionService;

  @override
  OnGoingHistoryState build() {
    _predictionService = ref.read(predictionServiceProvider);
    return OnGoingHistoryState();
  }

  void initializeData() {
    _getHistories();
  }

  void onRefresh() {
    state = state.copyWith(hasMoreData: true);
    _getHistories();
  }

  void loadmore() async {
    if (state.isLoadmore || !state.hasMoreData) return;
    state = state.copyWith(isLoadmore: true, page: state.page + 1);
    final res = await _predictionService.getOnGoingHistories({
      'page': state.page,
    });
    state = state.copyWith(isLoadmore: false);
    if (res.isSuccess) {
      state = state.copyWith(histories: [...state.histories, ...res.data!]);
    } else {
      // If no more data, revert page increment
      state = state.copyWith(page: state.page - 1, hasMoreData: false);
    }
  }

  Future<void> _getHistories() async {
    state = state.copyWith(isLoading: true);
    final res = await _predictionService.getOnGoingHistories({
      'page': 1,
    });
    state = state.copyWith(isLoading: false);
    if (res.isSuccess && res.data != null) {
      state = state.copyWith(
        histories: res.data!,
      );
    }
  }
}
