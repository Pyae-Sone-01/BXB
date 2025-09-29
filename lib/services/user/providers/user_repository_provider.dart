import 'package:bxb/services/fixture/fixture_repository.dart';
import 'package:bxb/services/user/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../datasources/services/remote/providers/api_service_provider.dart';

part 'user_repository_provider.g.dart';

@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepositoryImpl(ref.watch(apiServiceProvider));
}
