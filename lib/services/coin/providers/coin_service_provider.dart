import 'package:bxb/services/coin/coin_service.dart';

import 'coin_repository_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coin_service_provider.g.dart';

@riverpod
CoinService coinService(Ref ref) {
  return CoinServiceImpl(ref.watch(coinRepositoryProvider));
}
