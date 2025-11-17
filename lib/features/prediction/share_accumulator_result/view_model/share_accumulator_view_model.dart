import 'package:bxb/services/prediction/models/share_accumulator_response_model.dart';
import 'package:bxb/services/prediction/prediction_service.dart';
import 'package:bxb/services/prediction/providers/prediction_service_provider.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'share_accumulator_view_model.g.dart';

final shareAccumulatorVM = Provider<ShareAccumulatorViewModel>((ref) {
  return ref.read(_shareAccumulatorViewModelProvider.notifier);
});

final shareAccumulatorState = Provider<ShareAccumulatorState>((ref) {
  return ref.watch(_shareAccumulatorViewModelProvider);
});

abstract class ShareAccumulatorViewModel {
  void initializedData({required int id});
}

class ShareAccumulatorState {
  final bool isLoading;
  final ShareAccumulatorResponseModel? data;

  ShareAccumulatorState({this.isLoading = true, this.data});

  ShareAccumulatorState copyWith({
    bool? isLoading,
    ShareAccumulatorResponseModel? data,
  }) {
    return ShareAccumulatorState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
    );
  }
}

@riverpod
class _ShareAccumulatorViewModel extends _$ShareAccumulatorViewModel
    implements ShareAccumulatorViewModel {
  late final PredictionService _predictionService =
      ref.read(predictionServiceProvider);
  @override
  ShareAccumulatorState build() {
    return ShareAccumulatorState();
  }

  @override
  void initializedData({required int id}) {
    _getShareData(id: id);
  }

  _getShareData({required int id}) async {
    state = state.copyWith(isLoading: true);
    final res = await _predictionService
        .getShareData(isAccumulator: true, payload: {"id": id});
    state = state.copyWith(isLoading: false);
    if (res.isSuccess) {
      final data = res.data as ShareAccumulatorResponseModel;

      state = state.copyWith(data: data);
    } else {}
  }
}
