import 'package:bxb/services/fixture/fixture_service.dart';
import 'package:bxb/services/prediction/prediction_service.dart';

import 'prediction_repository_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'prediction_service_provider.g.dart';

@riverpod
PredictionService predictionService(Ref ref) {
  return PredictionServiceImpl(ref.watch(predictionRepositoryProvider));
}
