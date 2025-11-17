import 'package:bxb/services/prediction/models/share_handicap_response_model.dart';
import 'package:bxb/services/prediction/prediction_service.dart';
import 'package:bxb/services/prediction/providers/prediction_service_provider.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'share_handicap_view_model.g.dart';

final shareHandicapVM = Provider<ShareHandicapViewModel>((ref) {
  return ref.read(_shareHandicapViewModelProvider.notifier);
});

final shareHandicapState = Provider<ShareHandicapState>((ref) {
  return ref.watch(_shareHandicapViewModelProvider);
});

abstract class ShareHandicapViewModel {
  void initializedData({required int id});
}

class ShareHandicapState {
  final bool isLoading;
  final ShareHandicapResponseModel? data;

  ShareHandicapState({this.isLoading = true, this.data});

  ShareHandicapState copyWith({
    bool? isLoading,
    ShareHandicapResponseModel? data,
  }) {
    return ShareHandicapState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
    );
  }
}

@riverpod
class _ShareHandicapViewModel extends _$ShareHandicapViewModel
    implements ShareHandicapViewModel {
  late final PredictionService _predictionService =
      ref.read(predictionServiceProvider);
  @override
  ShareHandicapState build() {
    return ShareHandicapState();
  }

  @override
  void initializedData({required int id}) {
    _getShareData(id: id);
  }

  _getShareData({required int id}) async {
    state = state.copyWith(isLoading: true);
    final res = await _predictionService
        .getShareData(isAccumulator: false, payload: {"id": id});
    state = state.copyWith(isLoading: false);
    if (res.isSuccess) {
      final data = res.data as ShareHandicapResponseModel;
      print(data.title);
      state = state.copyWith(data: data);
    } else {}
  }
}
