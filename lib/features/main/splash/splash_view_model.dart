import 'package:bxb/router/router.dart';
import 'package:bxb/services/auth/auth_service.dart';
import 'package:bxb/services/auth/providers/auth_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'splash_view_model.g.dart';

abstract class SplashViewModel {
  void navigateToNextScreen(BuildContext context);
}

@riverpod
class SplashViewModelImpl extends _$SplashViewModelImpl
    implements SplashViewModel {
  late final AuthService _authService;
  @override
  void build() {
    _authService = ref.read(authServiceProvider);
  }

  @override
  void navigateToNextScreen(BuildContext context) {
    if (_authService.hasAuth()) {
      context.goNamed(RouteNames.main.home);
    } else {
      context.goNamed(RouteNames.auth.login);
    }
  }
}
