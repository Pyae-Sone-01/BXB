import 'package:bxb/services/prediction/models/history_model.dart';
import 'package:bxb/services/prediction/prediction_service.dart';
import 'package:bxb/services/prediction/providers/prediction_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'finsished_history_view_model.g.dart';

class FinishedHistoryState {
  final bool isLoading;
  final bool isLoadmore;
  final bool hasMoreData;
  final int page;
  final List<HistoryModel> histories;
  final String? startDate;
  final String? endDate;

  FinishedHistoryState({
    this.isLoading = false,
    this.isLoadmore = false,
    this.hasMoreData = true,
    this.page = 1,
    this.histories = const [],
    this.startDate,
    this.endDate,
  });

  FinishedHistoryState copyWith({
    bool? isLoading,
    bool? isLoadmore,
    bool? hasMoreData,
    int? page,
    List<HistoryModel>? histories,
    String? startDate,
    String? endDate,
  }) {
    return FinishedHistoryState(
      isLoading: isLoading ?? this.isLoading,
      isLoadmore: isLoadmore ?? this.isLoadmore,
      page: page ?? this.page,
      histories: histories ?? this.histories,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

@riverpod
class FinishedHistoryViewModel extends _$FinishedHistoryViewModel {
  late final PredictionService _predictionService;

  @override
  FinishedHistoryState build() {
    _predictionService = ref.read(predictionServiceProvider);
    return FinishedHistoryState();
  }

  void initializeData() {
    _getHistories();
  }

  setDateFilter({required String startDate, required String endDate}) {
    state = state.copyWith(startDate: startDate, endDate: endDate);
    _getHistories();
  }

  void onRefresh() {
    state = state.copyWith(hasMoreData: true);
    _getHistories();
  }

  void loadmore() async {
    if (state.isLoadmore || !state.hasMoreData) return;
    state = state.copyWith(isLoadmore: true, page: state.page + 1);
    final res = await _predictionService.getFinishedHistories({
      'page': state.page,
      "startDate": state.startDate,
      "endDate": state.endDate
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
    final res = await _predictionService.getFinishedHistories(
        {'page': 1, "startDate": state.startDate, "endDate": state.endDate});
    state = state.copyWith(isLoading: false);
    if (res.isSuccess && res.data != null) {
      state = state.copyWith(
        histories: res.data!,
      );
    }
  }
}
