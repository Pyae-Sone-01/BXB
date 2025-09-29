import 'package:bxb/services/prediction/models/history_detail_model.dart';
import 'package:bxb/services/prediction/prediction_service.dart';
import 'package:bxb/services/prediction/providers/prediction_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'history_detail_view_model.g.dart';

class HistoryDetailState {
  final bool isLoading;
  final HistoryDetailModel? detail;

  HistoryDetailState({
    this.isLoading = false,
    this.detail,
  });

  HistoryDetailState copyWith({
    bool? isLoading,
    HistoryDetailModel? detail,
  }) {
    return HistoryDetailState(
      isLoading: isLoading ?? this.isLoading,
      detail: detail ?? this.detail,
    );
  }
}

@riverpod
class HistoryDetailViewModel extends _$HistoryDetailViewModel {
  late final PredictionService _predictionService;

  @override
  HistoryDetailState build() {
    _predictionService = ref.read(predictionServiceProvider);
    return HistoryDetailState();
  }

  void initializeData(int id) {
    _getDetail(id);
  }

  Future<void> _getDetail(int id) async {
    state = state.copyWith(isLoading: true);
    final res = await _predictionService.getHistoryDetail(id: id);
    state = state.copyWith(isLoading: false);
    if (res.isSuccess) {
      state = state.copyWith(detail: res.data);
    }
  }
}
