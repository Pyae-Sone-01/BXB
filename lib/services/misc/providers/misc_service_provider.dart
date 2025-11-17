import 'package:bxb/services/fixture/fixture_service.dart';
import 'package:bxb/services/misc/misc_service.dart';

import 'package:bxb/services/user/user_service.dart';

import 'misc_repository_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'misc_service_provider.g.dart';

@riverpod
MiscService miscService(Ref ref) {
  return MiscServiceImpl(ref.watch(miscRepositoryProvider));
}
