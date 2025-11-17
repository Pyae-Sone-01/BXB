import 'package:bxb/services/misc/misc_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../datasources/services/remote/providers/api_service_provider.dart';

part 'misc_repository_provider.g.dart';

@riverpod
MiscRepository miscRepository(Ref ref) {
  return MiscRepositoryImpl(ref.watch(apiServiceProvider));
}
