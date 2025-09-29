import 'package:bxb/services/fixture/fixture_service.dart';

import 'package:bxb/services/user/user_service.dart';

import 'user_repository_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_service_provider.g.dart';

@riverpod
UserService userService(Ref ref) {
  return UserServiceImpl(ref.watch(userRepositoryProvider));
}
