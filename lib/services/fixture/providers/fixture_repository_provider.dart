import 'package:bxb/services/fixture/fixture_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../datasources/services/remote/providers/api_service_provider.dart';

part 'fixture_repository_provider.g.dart';

@riverpod
FixtureRepository fixtureRepository(Ref ref) {
  return FixtureRepositoryImpl(ref.watch(apiServiceProvider));
}
