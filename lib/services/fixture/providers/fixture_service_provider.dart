import 'package:bxb/services/fixture/fixture_service.dart';

import 'fixture_repository_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fixture_service_provider.g.dart';

@riverpod
FixtureService fixtureService(Ref ref) {
  return FixtureServiceImpl(ref.watch(fixtureRepositoryProvider));
}
