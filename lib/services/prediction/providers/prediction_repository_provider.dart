import 'package:bxb/services/fixture/fixture_repository.dart';
import 'package:bxb/services/prediction/prediction_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../datasources/services/remote/providers/api_service_provider.dart';

part 'prediction_repository_provider.g.dart';

@riverpod
PredictionRepository predictionRepository(Ref ref) {
  return PredictionRepositoryImpl(ref.watch(apiServiceProvider));
}
