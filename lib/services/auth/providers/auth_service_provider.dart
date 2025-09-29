import 'auth_repository_provider.dart';
import '../auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service_provider.g.dart';

@riverpod
AuthService authService(Ref ref) {
  return AuthServiceImpl(ref.watch(authRepositoryProvider));
}
