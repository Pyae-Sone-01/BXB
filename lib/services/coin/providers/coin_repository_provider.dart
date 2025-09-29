import 'package:bxb/services/coin/coin_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../datasources/services/remote/providers/api_service_provider.dart';

part 'coin_repository_provider.g.dart';

@riverpod
CoinRepository coinRepository(Ref ref) {
  return CoinRepositoryImpl(ref.watch(apiServiceProvider));
}
