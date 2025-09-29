import 'package:bxb/services/fixture/models/fixture_for_score_model.dart';
import 'package:bxb/services/fixture/fixture_service.dart';
import 'package:bxb/services/fixture/providers/fixture_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'score_view_model.g.dart';

abstract class ScoreViewModel {
  void initializeData();
}

class ScoreState {
  final bool isLoading;
  final FixtureForScoreModel? scores;

  ScoreState({
    this.isLoading = false,
    this.scores,
  });

  ScoreState copyWith({
    bool? isLoading,
    FixtureForScoreModel? scores,
  }) {
    return ScoreState(
      isLoading: isLoading ?? this.isLoading,
      scores: scores ?? this.scores,
    );
  }
}

@riverpod
class ScoreViewModelImpl extends _$ScoreViewModelImpl
    implements ScoreViewModel {
  late final FixtureService _fixtureService;

  @override
  ScoreState build() {
    _fixtureService = ref.read(fixtureServiceProvider);
    return ScoreState();
  }

  @override
  void initializeData() {
    _getFixtureForScore();
  }

  Future<void> _getFixtureForScore() async {
    state = state.copyWith(isLoading: true);
    final res = await _fixtureService.getScoreForFixture();
    state = state.copyWith(isLoading: false);
    if (res.isSuccess && res.data != null) {
      state = state.copyWith(scores: res.data);
    }
  }
}
